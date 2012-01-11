package org.interguild.pages {
	import fl.controls.TextArea;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.interguild.Aeon;
	import org.interguild.gui.BtnRecSolid;

	public class FakeEditorPage extends Page {

		public static var s:String = "";

		private var title:TextField;
		private var box:TextArea;
		private var load:BtnRecSolid;
		private var back:BtnRecSolid;
		private var submit:BtnRecSolid;
		private var theStage:Stage;
		private var file:FileReference;


		public function FakeEditorPage() {
			theStage = Aeon.instance.stage;
			var w:int = theStage.stageWidth;
			var h:int = theStage.stageHeight;

			title = new TextField();
			title.defaultTextFormat = new TextFormat("Arial", 16, 0xFFFFFF, false, null, null, null, null, TextFormatAlign.CENTER);
			title.autoSize = TextFieldAutoSize.CENTER;
			title.width = w - 175;
			title.selectable = false;
			title.multiline = true;
			title.htmlText = "<b>For more info on how to edit level code, visit the following page:</b><br /><a href=\"http://www.interguild.org/aeon/\" target=\"_blank\"><u>http://www.interguild.org/aeon/</u></a>";
			title.y = 40 - title.height / 2;
			title.x = w / 2 - title.width / 2;

			box = new TextArea();
			box.x = box.y = 80;
			box.width = w - 160;
			box.height = h - 160;
			include "../levels/editor/DefaultLevelCode.as";

			var yPos:Number = h - 70;

			submit = new BtnRecSolid("Test Level Code");
			submit.moveTo(w / 2, yPos);
			submit.addEventListener(MouseEvent.CLICK, onSubmit, false, 0, true);

			load = new BtnRecSolid("Load from File");
			load.moveTo2(submit.x - submit.width / 2 - 10 - load.width, yPos);
			load.addEventListener(MouseEvent.CLICK, onLoad, false, 0, true);

			back = new BtnRecSolid("Back to Home");
			back.moveTo2(submit.x + submit.width / 2 + 10, yPos);
			back.addEventListener(MouseEvent.CLICK, onBack, false, 0, true);

			addChild(submit);
			addChild(box);
			addChild(load);
			addChild(back);
			addChild(title);

			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
		}


		public override function open():void {
			super.open();
			if (s != "") {
				box.text = s;
			}
		}


		private function onStageResize(evt:Event):void {
			var w:int = theStage.stageWidth;
			var h:int = theStage.stageHeight;
			var yPos:Number = h - 70;

			submit.moveTo(w / 2, yPos);
			title.x = w / 2 - title.width / 2;
			load.moveTo2(submit.x - submit.width / 2 - 10 - load.width, yPos);
			back.moveTo2(submit.x + submit.width / 2 + 10, yPos);
			box.width = w - 160;
			box.height = h - 160;
		}


		private function onSubmit(evt:MouseEvent):void {
			GamePage.instance.loadAndPlay(box.text);
		}


		private function onLoad(evt:MouseEvent):void {
			file = new FileReference();

			var imageFileTypes:FileFilter = new FileFilter("Text (*.txt)", "*.txt");

			file.browse([imageFileTypes]);
			file.addEventListener(Event.SELECT, selectFile);
		}


		private function selectFile(evt:Event):void {
			file.addEventListener(Event.COMPLETE, playLevel);
			file.load();
		}


		private function playLevel(evt:Event):void {
			box.text = file.data.readUTFBytes(file.data.length).split("\r\n").join("\r");
		}


		private function onBack(evt:MouseEvent):void {
			Aeon.instance.gotoHomePage();
		}
	}
}
