package org.interguild.levels {

	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	import org.interguild.Aeon;
	import org.interguild.levels.assets.AnimationBuilder;
	import org.interguild.levels.assets.AnimationFrame;
	import org.interguild.levels.assets.AssetMan;
	import org.interguild.levels.assets.DrawingBuilder;
	import org.interguild.levels.hud.DefaultHUD;
	import org.interguild.levels.keys.KeyMan;
	import org.interguild.levels.objects.GameObject;
	import org.interguild.levels.objects.styles.GameObjectDefinition;
	import org.interguild.levels.objects.styles.StyleMap;
	import org.interguild.pages.GamePage;
	import org.interguild.resize.WindowResizer;
	import org.interguild.utils.LinkedList;

	/**
	 * LevelBuilder is in charge of taking the level code, interpreting it, and then building the level.
	 */
	public class LevelBuilder {

		private static const CHARS_TO_READ_PER_TICK:uint = 50;
		private static const TILE_WIDTH:uint = 32;
		private static const TAB_WIDTH:uint = 128; // 4 * 32;

		private static const DEFAULT_LEVEL_WIDTH:uint = 10;
		private static const DEFAULT_LEVEL_HEIGHT:uint = 10;
		private static const DEFAULT_FRAME_RATE:uint = 30;
		private static const MAX_SCREEN_WIDTH:uint = 2000;
		private static const MAX_SCREEN_HEIGHT:uint = 1500;

		private var gamepage:GamePage;
		private var level:Level;
		private var loadDefaults:Boolean;
		private var lvlWidth:uint;
		private var lvlHeight:uint;

		private var loader:BulkLoader;
		private var assets:AssetMan;

		private var xml:XML;
		private var stylesMap:StyleMap;

		private var builder:Timer;
		private var code:String;
		private var i:uint;
		private var n:uint;
		private var markerX:Number;
		private var markerY:Number;
		private var lastID:String;
		private var lastGO:GameObject;


		public function LevelBuilder(myLvl:Level) {
			gamepage = GamePage.instance;
			loader = BulkLoader.getLoader("gamepage");
			level = myLvl;
//			trace(level.levelCode);
			try {
				xml = new XML(level.levelCode);
			} catch (error:TypeError) {
				gamepage.loadingText = "Could not parse level code. Malformed XML.";
			}
			if (xml != null) {
				if (xml.@demo != "4.0")
					level.addError("Unrecognized version number. Please start your level code with: '<level demo=\"4.0\">'");

				if (xml.level.@loadDefaultSettings == "true")
					loadDefaults = true;
				else
					loadDefaults = false;

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
			if (loadDefaults)
				isAny = parseAssets($default_assets.assets);
			isAny = isAny || parseAssets(xml.assets);
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
//					assetURL = "../proxy.php?url=" + assetURL; // IMPORTANT: this line must be in final release.
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
		 * Iterates through all tags under <content>, creates the appropriate builder,
		 * and gives it to AssetMan for storage.
		 */
		private function loadCustomContent():void {
			include "assets/DefaultContent.as";
			if (loadDefaults)
				parseContentXML($default_content.content);
			parseContentXML(xml.content);

			loadCustomAnimation();
		}


		private function parseContentXML(xmlContent:XMLList):void {
			for each (var el:XML in xmlContent.elements()) {
				var type:String = String(el.name());
				var id:String = el.@id;
				if (assets.addID(id)) {
					switch (type) {
						case "drawing":
							var draw:DrawingBuilder = new DrawingBuilder(el, level);
							assets.setAsset(id, draw.getBitmapData());
							break;
						default:
							level.addError("Invalid <content> type: <" + type + ">");
							break;
					}
				}
			}
		}


		private function loadCustomAnimation():void {
			include "assets/DefaultAnimation.as";
			if (loadDefaults)
				parseAnimationXML($default_animation.animation);
			parseAnimationXML(xml.animation);

			buildHUD();
		}


		private function parseAnimationXML(xmlFrames:XMLList):void {
			for each (var el:XML in xmlFrames.elements()) {
				var type:String = String(el.name());
				var id:String = el.@id;
				if (assets.addID(id)) {
					if (type == "frame") {
						var frame:AnimationBuilder = new AnimationBuilder(el, level);
						assets.setAsset(id, frame.getFrame());
					} else {
						level.addError("Invalid <animation> tag type: <" + type + ">. Only <frame> tags are valid.");
					}
				}
			}
		}


		private function buildHUD():void {
			gamepage.loadingText = "Building HUD"
			gamepage.loadingButton.text = "Cancel & Quit";
			gamepage.loadingButton.addEventListener(MouseEvent.CLICK, stopBuildingLevel, false, 0, true);

			initTitle(String(xml.title));

			//TODO check xml for hud settings
			level.setHUD(new DefaultHUD(level.state, level.title));

			buildLevel();
		}


		/**
		 * Starts building the level.
		 */
		private function buildLevel():void {
			gamepage.loadingText = "Parsing Level Code...";

			initLevel(xml.level);
			initKeys();
			initStylesMap();
			level.levelArea.behaviors = stylesMap.behaviors;
			level.levelArea.setCamera(stylesMap.camera);

			builder = new Timer(0);
			builder.addEventListener(TimerEvent.TIMER, onLevelBuild);
			code = String(xml.levelcode);
			n = code.length;
			markerX = 0;
			markerY = 0;
			builder.start();
		}


		private function initTitle(s:String):void {
			level.title = s;
		}


		private function initLevel(xml:XMLList):void {
			var size:Array = checkLevelSize(xml.@size);
			initLevelArea(size[0], size[1]);

			initBackground(String(xml.@background));

			size = checkWindowSize(xml.@windowSize);
			initWindowSize(size[0], size[1]);
			var stage:Stage = Aeon.instance.stage;
			if (size[0] == 0)
				size[0] = stage.stageWidth;
			if (size[1] == 0)
				size[1] = stage.stageHeight;
			level.initPause(size[0], size[1]);

			initFrameRate(String(xml.@framerate));
		}


		/**
		 * Returns an array of exactly two, valid, unsigned Integers for dimensions.
		 *  a[0] = width
		 *  a[1] = height
		 */
		private function checkLevelSize(s:String):Array {
			var a:Array = s.split(" ", 2);

			a[0] = uint(a[0]);
			if (isNaN(a[0]) || a[0] == 0) {
				a[0] = DEFAULT_LEVEL_WIDTH;
			}

			if (a.length < 2) {
				a.push(a[0]);
			} else {
				a[1] = uint(a[1]);
				if (isNaN(a[1]) || a[1] == 0) {
					a[1] = DEFAULT_LEVEL_HEIGHT;
				}
			}

			return a;
		}


		/**
		 * Returns an array of exactly two, valid, unsigned Integers for dimensions.
		 *  a[0] = width
		 *  a[1] = height
		 */
		private function checkWindowSize(s:String):Array {
			var a:Array = s.split(" ", 2);

			a[0] = uint(a[0]);
			if (isNaN(a[0]) || a[0] > MAX_SCREEN_WIDTH) {
				a[0] = 0;
			}

			if (a.length < 2) {
				a.push(a[0]);
			} else {
				a[1] = uint(a[1]);
				if (isNaN(a[1]) || a[1] > MAX_SCREEN_HEIGHT) {
					a[1] = 0;
				}
			}

			return a;
		}


		/**
		 * Gets keys info from XML and gives them to KeyMan.
		 */
		private function initKeys():void {
			var keys:KeyMan = new KeyMan(level, xml.keys, loadDefaults);
			level.keys = keys;
		}


		private function initFrameRate(s:String):void {
			var num:Number = Number(s);

			if (isNaN(num))
				num = DEFAULT_FRAME_RATE;

			if (num < 0.01 || num > 1000)
				num = DEFAULT_FRAME_RATE;

			level.frameRate = num;
		}


		private function initWindowSize(width:uint, height:uint):void {
			if (width > 0 || height > 0) {
				var resizer:WindowResizer = new WindowResizer();
				if (width == 0)
					width = resizer.getCurrentWidth();
				else if (height == 0)
					height = resizer.getCurrentHeight();
				resizer.resize(height, width);
			}
		}


		private function initLevelArea(width:uint, height:uint):void {
			lvlWidth = width;
			lvlHeight = height;
			level.levelArea = new LevelArea(width, height, level.state);
		}


		private function initBackground(id:String):void {
			var data:BitmapData = assets.getImage(id);
			if (data != null) {
				var bg:Sprite = new Sprite();
				bg.graphics.beginBitmapFill(data);
				bg.graphics.drawRect(0, 0, level.levelArea.levelWidth, level.levelArea.levelHeight);
				bg.graphics.endFill();
				level.addChildAt(bg, 0);
			}
			level.addChildAt(new Background(), 0);
		}


		private function initStylesMap():void {
			stylesMap = new StyleMap(xml.objects, String(xml.styles), level, loadDefaults);
		}


		/**
		 * On every timer tick, this function parses the next few characters
		 * from the level code, and instantiates objects. The number of chars
		 * to parse is determined by CHARS_TO_READ_PER_TICK.
		 */
		private function onLevelBuild(evt:TimerEvent):void {
			if (i >= n) {
				finishLoading();
				return;
			}
			var percent:uint = Number(i / n) * 100;
			gamepage.loadingText = "Building Level: " + percent + "%";
			var j:uint = i + CHARS_TO_READ_PER_TICK;
			while (i < n && i < j) {
				var id:String = code.charAt(i);
				if (id == "=") {
					var newI:uint = code.indexOf(";", i);
					var len:Number = Number(code.substring(i + 1, newI));
					if (isNaN(len) || len < 0)
						len = 1;
					len--; // we already placed the first one, last iteration.
					while (len > 0) {
						parseChar(lastID);
						len--;
					}
					i = newI; //will get +1 later.
				} else {
					if (id == "$" || id == ".") {
						i++;
						id += code.charAt(i);
					}
					parseChar(id);
				}
				lastID = id;
				i++;
			}
			if (i >= n) {
				gamepage.loadingText = "Initializing Level...";
			}
		}


		/**
		 * Takes the current character (or double-character ID) and figures out
		 * what to do with it.
		 */
		private function parseChar(s:String):void {
			if (s == " ") {
				addSpace();
			} else if (s == "	") {
				addSpace(TAB_WIDTH);
			} else if (s == "\r" || (s == "\n" && lastID != "\r")) {
				addNewLine();
			} else if (s == "\n") {
				lastID = "/r";
			} else {
				var def:GameObjectDefinition = stylesMap.get(s);
				if (def == null) {
					level.addError("Unrecognized symbol in level code: '" + s + "'");
					addSpace();
				} else if (s.charAt(0) == ".") {
					lastGO.addStyleClass(def);
				} else {
					if (markerX < 0 || markerX >= level.levelArea.levelWidth || markerY < 0 || markerY >= level.levelArea.levelHeight)
						level.addError("Warning: You're placing objects outside the level grid, at (" + (markerX / 32 + 1) + "," + (markerY / 32 + 1) + ") on a " + lvlWidth + "x" + lvlHeight + " grid. Objects placed outside the grid will not have their collisions detected.");
					lastGO = new GameObject(def, markerX, markerY, assets)
					level.levelArea.add(lastGO);
					addSpace();
				}
			}
		}


		private function addSpace(d:Number = TILE_WIDTH):void {
			markerX += d;
		}


		private function addNewLine():void {
			markerY += TILE_WIDTH;
			markerX = 0;
		}


		private function finishLoading():void {
			builder.stop();
			builder.removeEventListener(TimerEvent.TIMER, onLevelBuild);
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
