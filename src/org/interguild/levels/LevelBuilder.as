package org.interguild.levels {

	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	import org.interguild.Aeon;
	import org.interguild.levels.assets.AssetMan;
	import org.interguild.levels.assets.ContentFactory;
	import org.interguild.levels.assets.DrawingFactory;
	import org.interguild.levels.hud.DefaultHUD;
	import org.interguild.levels.keys.KeyMan;
	import org.interguild.levels.styles.StyleMap;
	import org.interguild.pages.GamePage;
	import org.interguild.resize.WindowResizer;

	/**
	 * LevelBuilder is in charge of taking the level code, interpreting it, and then building the level.
	 */
	public class LevelBuilder {

		private static const DEFAULT_LEVEL_WIDTH:uint = 10;
		private static const DEFAULT_LEVEL_HEIGHT:uint = 10;
		private static const DEFAULT_FRAME_RATE:uint = 30;

		private var gamepage:GamePage;
		private var level:Level;
		private var loader:BulkLoader;
		private var styleMap:StyleMap;

		private var xml:XML;

		private var assets:AssetMan;


		public function LevelBuilder(myLvl:Level) {
			gamepage = GamePage.instance;
			loader = BulkLoader.getLoader("gamepage");
			level = myLvl;
//			trace(level.levelCode);
			try {
				xml = new XML(level.levelCode);
			} catch (error:TypeError) {
				level.addError("Could not parse level code. Malformed XML.");
//				trace("malformed xml");
			}
			if (xml != null) {
				gamepage.loadingText = "Loading Assets: 0%";
				gamepage.loadingButton.text = "Skip";

				initAssets();
			}
		}


		/**
		 * Handles the initializationa and loading of all external assets.
		 * When done, it moves on to building the HUD.
		 */
		private function initAssets():void {
			assets = new AssetMan(level);
			level.assets = assets;

			include "assets/DefaultAssets.as";
			var isAny:Boolean;
			isAny = parseAssets($default_assets.assets);
			isAny = parseAssets(xml.assets);
			if (isAny) {
				loadAssets();
			} else {
				loadCustomContent();
			}
		}


		/**
		 * Parses the XML, registers the asset ID's with AssetMan, and adds them to BulkLoader's queue.
		 *
		 * Returns true if any assets were added to be loaded.
		 */
		private function parseAssets(xmlAssets:XMLList):Boolean {
			if (xmlAssets == null) {
				return false;
			}

			var isAny:Boolean = false;
			//add all assets to appropriate lists:
			for each (var asset:XML in xmlAssets.elements()) {
				var assetName:String = asset.name().toString();
				var assetID:String = asset.@id.toString();
				var assetURL:String = asset.@src.toString();
				if (assetID == null || assetID == "") {
					level.addError("You've declared an asset without giving it an ID.");
				}
				if (assetURL == null || assetURL == "") {
					level.addError("You've declared an asset without giving it a src URL");
				} else {
					if (assetName == "image") {
						if (assets.addID(assetID)) {
							loader.add(assetURL, {id: assetID, type: BulkLoader.TYPE_IMAGE, preventCache: false});
							isAny = true;
						}
					} else if (assetName == "sound") {
						if (assets.addID(assetID)) {
							loader.add(assetURL, {id: assetID, type: BulkLoader.TYPE_SOUND, preventCache: false});
							isAny = true;
						}
					}
				}
			}
			return isAny;
		}


		/**
		 * Sets up event listeners and tells BulkLoader to start loading.
		 */
		private function loadAssets():void {
			gamepage.loadingButton.addEventListener(MouseEvent.CLICK, stopLoadingAssets, false, 0, true);
			loader.addEventListener(BulkProgressEvent.COMPLETE, assetsLoadComplete, false);
			loader.addEventListener(BulkProgressEvent.PROGRESS, assetsLoadProgress, false);
			loader.addEventListener(BulkLoader.ERROR, assetsError, false);
			loader.start();
		}


		/**
		 * Called when the users presses the "Skip" button when loading Assets.
		 * The game will dumb all external assets and proceed to load the level without them.
		 */
		private function stopLoadingAssets(evt:MouseEvent):void {
			loader.removeEventListener(BulkProgressEvent.COMPLETE, assetsLoadComplete);
			loader.removeEventListener(BulkProgressEvent.PROGRESS, assetsLoadProgress);
			loader.removeEventListener(BulkLoader.ERROR, assetsError);
			gamepage.loadingButton.removeEventListener(MouseEvent.CLICK, stopLoadingAssets);

			assets = null;
			loader.removeAll();
			loadCustomContent();
		}


		/**
		 * Every time BulkLoader makes progress, update LoadingBox with the current percent loaded.
		 */
		private function assetsLoadProgress(evt:BulkProgressEvent):void {
			gamepage.loadingText = "Loading Assets: " + Math.round(evt.ratioLoaded * 100) + "%";
		}


		/**
		 * Every time an asset fails to load, add it to the error log and remove it from the queue so that it may continue.
		 */
		private function assetsError(evt:ErrorEvent):void {
			var fails:Array = loader.getFailedItems();
			for each (var fail:LoadingItem in fails) {
				level.addError(fail.type + " asset failed to load.\n ID: '" + fail.id + "' URL: '" + fail.url.url + "'");
			}
			loader.removeFailedItems();
		}


		/**
		 * When BulkLoader has finished its work, extract the assets and give them to AssetMan. Then start loading the level.
		 */
		private function assetsLoadComplete(evt:BulkProgressEvent):void {
			loader.removeEventListener(BulkProgressEvent.COMPLETE, assetsLoadComplete);
			loader.removeEventListener(BulkProgressEvent.PROGRESS, assetsLoadProgress);
			loader.removeEventListener(BulkLoader.ERROR, assetsError);
			gamepage.loadingButton.removeEventListener(MouseEvent.CLICK, stopLoadingAssets);
			for each (var item:LoadingItem in loader.items) {
				if (item.type == "image") {
					assets.setAsset(item.id, loader.getBitmapData(item.id, true));
				} else if (item.type == "sound") {
					assets.setAsset(item.id, loader.getSound(item.id, true));
				}
			}
			loader.removeAll();
			loadCustomContent();
		}


		/**
		 * Iterates through all tags under <content>, creates the appropriate factory,
		 * and gives it to AssetMan for storage.
		 */
		private function loadCustomContent():void {
			include "assets/DefaultContent.as";
			parseContentXML($default_content.content);
			parseContentXML(xml.content);

			buildHUD();
		}


		private function parseContentXML(xmlContent:XMLList):void {
			for each (var el:XML in xmlContent.elements()) {
				var factory:ContentFactory;
				var type:String = String(el.name());
				var id:String = el.@id;
				if (assets.addID(id)) {
					switch (type) {
						case "drawing":
							factory = new DrawingFactory(el, level);
							assets.setAsset(id, factory);
							break;
						default:
							level.addError("Invalid <content> type: <" + type + ">");
							break;
					}
				}
			}
		}


		private function buildHUD():void {
			gamepage.loadingText = "Building HUD"
			gamepage.loadingButton.text = "Cancel & Quit";
			gamepage.loadingButton.addEventListener(MouseEvent.CLICK, stopBuildingLevel, false, 0, true);

			level.title = xml.title;

			//TODO check xml for hud settings
			level.setHUD(new DefaultHUD(level));

			buildLevel();
		}


		/**
		 * Starts building the level.
		 */
		private function buildLevel():void {
			gamepage.loadingText = "Building Level: 1%"

			initKeys();
			initFrameRate();
			initWindowSize();
			initLevelSize();
			initStylesMap();

			finishLoading();
		}


		/**
		 * Gets keys info from XML and gives them to KeyMan.
		 */
		private function initKeys():void {
			var keys:KeyMan = new KeyMan(level, xml.keys);
			level.keys = keys;
		}


		private function initFrameRate():void {
			level.frameRate = DEFAULT_FRAME_RATE;
		}


		private function initWindowSize():void {
			var width:uint, height:uint;
			if (xml.windowSize != null) {
				width = uint(xml.windowSize.@width);
				height = uint(xml.windowSize.@height);
				if (width > 0 || height > 0) {
					var resizer:WindowResizer = new WindowResizer();
					if (width <= 0)
						width = resizer.getCurrentWidth();
					else if (height <= 0)
						height = resizer.getCurrentHeight();
					resizer.resize(height, width);
				}
			}
		}


		private function initLevelSize():void {
			var width:uint, height:uint;
			if (xml.size != null) {
				width = uint(xml.size.@width);
				height = uint(xml.size.@height);
				if (width == 0)
					width = DEFAULT_LEVEL_WIDTH;
				if (height == 0)
					height = DEFAULT_LEVEL_HEIGHT;
			} else {
				width = DEFAULT_LEVEL_WIDTH;
				height = DEFAULT_LEVEL_HEIGHT;
			}
			initLevelArea(width, height);
		}


		private function initStylesMap():void {

		}


		private function initLevelArea(width:uint, height:uint):void {
			level.levelArea = new LevelArea(width, height);
		}


		private function finishLoading():void {
			gamepage.loadingButton.removeEventListener(MouseEvent.CLICK, stopBuildingLevel);
			gamepage.loadUnlock();
			level.playLevel();
		}


		/**
		 * Cancels the loading of this level and returns you to the level select page.
		 */
		private function stopBuildingLevel(evt:MouseEvent):void {
			gamepage.loadingButton.removeEventListener(MouseEvent.CLICK, stopBuildingLevel);
			gamepage.loadUnlock();
			gamepage.closeLevel(level);
			Aeon.instance.gotoHomePage();
		}

	}
}
