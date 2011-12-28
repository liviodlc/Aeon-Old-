package org.interguild.levellist {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.xml.XMLNode;

	import flashx.textLayout.formats.TextAlign;

	import org.interguild.Aeon;
	import org.interguild.pages.GamePage;
	import org.interguild.pages.HomePage;
	import org.interguild.pages.Page;

	/**
	 * The purpose of this class is to manage the list of levels and handle loading in level data from the database.
	 * Its size and location are handled by the LevelsPage class.
	 */
	public class LevelLister extends Sprite {

		private var loader:BulkLoader;
		private var loadingText:TextField;
		private var scrollpane:ScrollPane;
		private var container:Sprite;

		private var pagination:Sprite;
		private var pageBox:TextField;
		private var pageLimit:TextField;
		private var num_results:TextField;
		private var no_results:TextField;

		private var curSearch:String = "";
		private var curPage:uint;
		private var lastPage:uint;


		public function LevelLister() {

			//initialize scrollpane and container
			container = new Sprite();
			scrollpane = new ScrollPane();
			scrollpane.horizontalScrollPolicy = ScrollPolicy.OFF;
			scrollpane.verticalScrollPolicy = ScrollPolicy.AUTO;
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0x222222);
			mc.graphics.drawRect(0, 0, 10, 10);
			mc.graphics.endFill();
			scrollpane.setStyle("upSkin", mc);
			scrollpane.source = container;


			//initialize pagination
			pagination = new Sprite();

			var pageText:TextField = new TextField();
			pageText.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF, true);
			pageText.autoSize = TextFieldAutoSize.LEFT;
			pageText.text = "Page:";

			pageBox = new TextField();
			pageBox.defaultTextFormat = new TextFormat("Verdana", 13, 0, null, null, null, null, null, TextFormatAlign.CENTER);
			pageBox.type = TextFieldType.INPUT;
			pageBox.border = true;
			pageBox.backgroundColor = 0xFFFFFF;
			pageBox.background = true;
			pageBox.x = pageText.width + 4;
			pageBox.width = 24;
			pageBox.height = 20;
			pageBox.addEventListener(KeyboardEvent.KEY_DOWN, onPageBoxKey, false, 0, true);

			pageLimit = new TextField();
			pageLimit.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF, true);
			pageLimit.autoSize = TextFieldAutoSize.LEFT;
			pageLimit.text = "of 1";
			pageLimit.x = pageBox.x + pageBox.width + 4;


			//initialize results count
			num_results = new TextField();
			num_results.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF);
			num_results.autoSize = TextFieldAutoSize.LEFT;
			num_results.text = "Results: 0";
			num_results.x = 10;

			//initialize no-results text
			no_results = new TextField();
			no_results.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF);
			no_results.autoSize = TextFieldAutoSize.LEFT;
			no_results.text = "Your search returned zero results.";
			no_results.visible = false;

			//initialize loading text
			loadingText = new TextField();
			var loadingFormat:TextFormat = new TextFormat("Arial", 15, 0xFFFFFF);
			loadingFormat.align = TextFormatAlign.LEFT;
			loadingText.defaultTextFormat = loadingFormat;
			loadingText.autoSize = TextFieldAutoSize.LEFT;
			loadingText.x = 10;
			loadingText.text = "Loading...";
			loadingText.visible = false;

			//add children
			addChild(scrollpane);
			pagination.addChild(pageText);
			pagination.addChild(pageBox);
			pagination.addChild(pageLimit);
			addChild(pagination);
			addChild(num_results);
			addChild(no_results);
			addChild(loadingText);

			loader = new BulkLoader("level_list");
		}


		private function onPageBoxKey(evt:KeyboardEvent):void {
			if (evt.keyCode == Keyboard.ENTER) {
				if (isNaN(Number(pageBox.text))) {
					pageBox.text = String(curPage);
				} else {
					loadList("?search=" + curSearch + "&page_number=" + pageBox.text);
				}
			}
		}


		public override function set width(newWidth:Number):void {
			scrollpane.width = newWidth;
			pagination.x = newWidth - pagination.width - 10;
			no_results.x = newWidth / 2 - no_results.width / 2;
			var num:int = container.numChildren;
			for (var i:int = 0; i < num; i++) {
				container.getChildAt(i).width = newWidth;
			}
		}


		public override function set height(newHeight:Number):void {
			scrollpane.height = newHeight - 26;
			scrollpane.y = 26;
			loadingText.y = newHeight + 10;
			no_results.y = newHeight / 2;
		}


		public function searchFor(txt:String):void {
			no_results.visible = false;
			loadList("?search=" + txt);
			curSearch = txt;
			curPage = 1;
			pageBox.text = String(1);
		}


		private function loadList(txt:String = ""):void {
			var downloadPath:String = "http://www.interguild.org/levels/xml.php" + txt;
			loader.add(downloadPath, {id: "xml", preventCache: true});
			loader.addEventListener(BulkProgressEvent.COMPLETE, onDownloadComplete, false, 0, true);
			loader.addEventListener(BulkLoader.ERROR, onDownloadError, false, 0, true);

			loadingText.text = "Loading...";
			loadingText.visible = true;

			loader.start();
		}


		private function onDownloadComplete(evt:BulkProgressEvent):void {
			clearList();
			loader.removeEventListener(BulkProgressEvent.COMPLETE, onDownloadComplete);
			loader.removeEventListener(BulkLoader.ERROR, onDownloadError);

			var xml:XML = XML(loader.getText("xml", true));
			loader.removeAll();
			loadingText.visible = false;

			for each (var item:XML in xml.elements()) {
				addLevel(new LevelListItem(item));
			}
			
			lastPage = uint(xml.@lastpage);
			pageLimit.text = "of " + xml.@lastpage;
			curPage = uint(xml.@curpage);
			pageBox.text = String(curPage);
			
			var num:int = int(xml.@results);
			num_results.text = "Results: " + num;
			if (num == 0)
				no_results.visible = true;
		}


		private function onDownloadError(evt:ErrorEvent):void {
			loader.removeEventListener(BulkProgressEvent.COMPLETE, onDownloadComplete);
			loader.removeEventListener(BulkLoader.ERROR, onDownloadError);
			loader.removeAll();
			loadingText.text = "Error: URL failed to load.";
		}


		private function addLevel(level:LevelListItem):void {
			level.addEventListener(MouseEvent.CLICK, onLevelClick, false, 0, true);
			level.y = level.height * container.numChildren;
			container.addChild(level);
			scrollpane.source = container;
		}


		private function onLevelClick(evt:MouseEvent):void {
			var theID:uint = LevelListItem(evt.currentTarget).id;
			loader.add("http://www.interguild.org/levels/xml.php?id=" + theID, {id: "lvl", preventCache: true});
			loader.addEventListener(BulkProgressEvent.COMPLETE, levelLoadComplete, false, 0, true);
			loader.addEventListener(BulkLoader.ERROR, noLevelError, false, 0, true);
			loadingText.text = "Loading level ID #" + theID + "...";
			loadingText.visible = true;
			loader.start();
		}


		private function levelLoadComplete(event:BulkProgressEvent):void {
			loader.removeEventListener(BulkProgressEvent.COMPLETE, levelLoadComplete);
			loader.removeEventListener(BulkLoader.ERROR, noLevelError);
			loadingText.visible = false;

			var levelCode:String = loader.getText("lvl", true);
			loader.removeAll();
			GamePage.instance.loadAndPlay(levelCode);
		}


		private function noLevelError(evt:ErrorEvent):void {
			loader.removeEventListener(BulkProgressEvent.COMPLETE, levelLoadComplete);
			loader.removeEventListener(BulkLoader.ERROR, noLevelError);
			loader.removeAll();
			loadingText.text = "Error: Level failed to load.";
		}


		/**
		 * This is called whenever the LevelPage's open() method is called.
		 * It resets the list of levels to the default display.
		 */
		public function reset():void {
			clearList();
			no_results.visible = false;
			loadingText.visible = false;
			loadList();
		}


		/**
		 * Empties the list of all levels.
		 */
		public function clearList():void {
			container = new Sprite();
			scrollpane.source = container;
		}


		public function stop():void {
			loader.removeAll();
		}
	}
}
