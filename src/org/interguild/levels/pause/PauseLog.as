package org.interguild.levels.pause {

	import fl.controls.TextArea;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.interguild.gui.BtnRecSolid;
	import org.interguild.pages.FakeEditorPage;

	public class PauseLog extends Sprite {

		private var title:TextField;
		protected var log:TextArea;

		private var quit:BtnRecSolid;
		private var back:BtnRecSolid;
		private var mid:BtnRecSolid;
		private var sub:BtnRecSolid;

		protected var pause:Pause;


		public function PauseLog(w:Number, h:Number, ps:Pause, pageTitle:String, submitButton:Boolean) {
			pause = ps;

			title = new TextField();
			title.defaultTextFormat = new TextFormat("Arial", 28, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER);
			title.autoSize = TextFieldAutoSize.CENTER;
			title.selectable = false;
			title.text = pageTitle;
			title.y = 50;
			title.x = w / 2 - title.width / 2;
			title.filters = [new GlowFilter(0, 1, 7, 7, 10, 1)];

			log = new TextArea();
			log.x = log.y = 80;
			log.width = w - 160;
			log.height = h - 160;
			if (!submitButton)
				log.editable = false;

			var yPos:Number = h - 70;

			if (submitButton)
				mid = new BtnRecSolid("Check Error Log");
			else
				mid = new BtnRecSolid("Edit Level Code");
			mid.moveTo(w / 2, yPos);
			mid.addEventListener(MouseEvent.CLICK, onMid, false, 0, true);

			quit = new BtnRecSolid("<< Back to Level");
			quit.x = mid.x - 10 - quit.width;
			quit.y = yPos;
			quit.addEventListener(MouseEvent.CLICK, onQuit, false, 0, true);

			back = new BtnRecSolid("Pause Menu >>");
			back.x = mid.x + mid.width + 10;
			back.y = yPos;
			back.addEventListener(MouseEvent.CLICK, onBack, false, 0, true);

			this.filters = [new DropShadowFilter(4, 45, 0, 1, 8, 8, 1)];

			if (submitButton) {
				sub = new BtnRecSolid("Test Changes");
				sub.moveTo(w / 2, yPos + 30);
				sub.addEventListener(MouseEvent.CLICK, onSubmit, false, 0, true);
				addChild(sub);
			}

			addChild(mid);
			addChild(log);
			addChild(quit);
			addChild(back);
			addChild(title);
		}


		public override function set width(w:Number):void {
			title.x = w / 2 - title.width / 2;
			log.width = w - 160;
			mid.moveTo(w / 2, mid.y);
			if (sub != null)
				sub.moveTo(w / 2, sub.y);
			quit.x = mid.x - 10 - quit.width;
			back.x = mid.x + mid.width + 10;
		}


		public override function set height(h:Number):void {
			log.height = h - 160;
			quit.y = back.y = mid.y = h - 70;
			if (sub != null)
				sub.y = h - 40;
		}


		private function onQuit(evt:MouseEvent):void {
			pause.unpause();
		}


		private function onBack(evt:MouseEvent):void {
			pause.show();
		}


		protected function onMid(evt:MouseEvent):void {
			//to be overriden
		}


		private function onSubmit(evt:MouseEvent):void {
			FakeEditorPage.s = log.text;
			pause.loadNewLevelCode(log.text);
		}
	}
}
