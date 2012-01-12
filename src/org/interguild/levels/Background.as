package org.interguild.levels {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	import org.interguild.Aeon;

	public class Background extends Sprite {

		private var theStage:Stage;


		public function Background() {
			theStage = Aeon.instance.stage;
			graphics.clear();
			graphics.beginFill(0xefefef);
			graphics.drawRect(0, 0, 10, 10);
			graphics.endFill();
			onStageResize();
			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
//			paint(theStage.stageWidth, theStage.stageHeight);
		}


//		private function paint(w:int, h:int):void {
//			graphics.clear();
//			graphics.beginBitmapFill(data);
//			graphics.drawRect(0, 0, w, h);
//			graphics.endFill();
//		}


		private function onStageResize(evt:Event = null):void {
			width = theStage.stageWidth;
			height = theStage.stageHeight;
		}
	}
}
