package org.interguild.pages {
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import org.interguild.Aeon;
	import org.interguild.gui.Btn;
	import org.interguild.gui.BtnRecSolid;
	import org.interguild.list.LevelListItem;
	import org.interguild.list.LevelLister;

	/**
	 * This page allows users to browse through levels in the level database.
	 *
	 * The responsibilities of this class are to provide the basic visual elements for the page.
	 * The actual loading of the level data is handled by the LevelLister class.
	 */
	public class LevelsPage extends Page {

		private var title:TextField;

		private var desc:TextField;
		private static const DESC_PADDING:int = 10;
		
		private var search:Sprite;
		private var searchBox:TextField
		private var levels:LevelLister;
		private var exit:Btn

		private var theStage:Stage;


		public function LevelsPage() {
			theStage = Aeon.instance.stage;

			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;

			//initialize title text
			title = new TextField();
			var titleForm:TextFormat = new TextFormat("Arial", 30, 0xFFFFFF, true);
			titleForm.align = TextFormatAlign.CENTER;
			title.defaultTextFormat = titleForm;
			title.autoSize = TextFieldAutoSize.CENTER;
			title.text = "User Level Database";
			title.x = sw / 2 - title.width / 2;
			title.y = 10;
			addChild(title);

			//initialize description text
			desc = new TextField();
			desc.defaultTextFormat = new TextFormat("Verdana", 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			desc.autoSize = TextFieldAutoSize.CENTER;
			desc.width = sw - DESC_PADDING * 2;
			desc.multiline = true;
			desc.wordWrap = true;
			desc.htmlText = "Visit <a href=\"http://www.interguild.org\" target=\"_blank\">interguild.org</a> to rate and comment on your favorite levels!";
			desc.x = DESC_PADDING;
			desc.y = 60;
			addChild(desc);


			//initialize search area
			search = new Sprite();

			var searchText:TextField = new TextField();
			searchText.defaultTextFormat = new TextFormat("Arial", 14, 0xFFFFFF, true);
			searchText.autoSize = TextFieldAutoSize.LEFT;
			searchText.text = "Search:";
			search.addChild(searchText);

			searchBox = new TextField();
			searchBox.defaultTextFormat = new TextFormat("Verdana", 13, 0);
			searchBox.type = TextFieldType.INPUT;
			searchBox.border = true;
			searchBox.backgroundColor = 0xFFFFFF;
			searchBox.background = true;
			searchBox.width = 200;
			searchBox.height = 20;
			searchBox.x = searchText.width + 10;
			searchBox.addEventListener(KeyboardEvent.KEY_DOWN, onSearchKey, false, 0, true);
			search.addChild(searchBox);

			search.x = sw / 2 - search.width / 2;
			search.y = desc.y + desc.height + 10;
			addChild(search);


			//initialize level list:
			levels = new LevelLister();
			levels.y = search.y + search.height + 10;
			levels.width = sw;
			levels.height = sh - levels.y - 50;
			addChild(levels);


			//initialize exit button
			exit = new BtnRecSolid("Back to Home");
			exit.moveTo(sw / 2, sh - exit.height - 10);
			exit.addEventListener(MouseEvent.CLICK, onExitClick, false, 0, true);
			addChild(exit);
		}


		private function onStageResize(evt:Event):void {
			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;

			title.x = sw / 2 - title.width / 2;
			desc.width = sw - DESC_PADDING * 2;
			search.x = sw / 2 - search.width / 2;
			search.y = desc.y + desc.height + 10;

			levels.y = search.y + search.height + 10;
			levels.width = sw;
			levels.height = sh - levels.y - 50;

			exit.moveTo(sw / 2, sh - exit.height - 10);
		}


		private function onSearchKey(evt:KeyboardEvent):void {
			if (evt.keyCode == Keyboard.ENTER) {
				levels.searchFor(searchBox.text);
			}
		}


		private function onExitClick(evt:Event):void {
			Aeon.instance.gotoHomePage();
		}


		/**
		 * Should hide the page and remove event listeners
		 */
		public override function close():void {
			visible = false;
			levels.stop();
			theStage.removeEventListener(Event.RESIZE, onStageResize);
		}


		/**
		 * Should make the page visible and activate event listeners
		 */
		public override function open():void {
			onStageResize(null);
			visible = true;
			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			searchBox.text = "";
			levels.reset();
		}
	}
}
