package org.interguild.log {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.interguild.Aeon;
	import org.interguild.gui.*;

	/**
	 * This class is used to show loading progress anywhere in the game.
	 *
	 * How to use:
	 * 	-when initializing, you can set the initial text to display in the constructor
	 * 	-to show progress, simply set the text property of this object
	 * 	-to listen for events on the cancel button, you can get a reference to it through this object's
	 * 	 cancelButton property.
	 * 	-you can use the deconstruct() function to remove the resize listener so that it won't waste resources
	 * 	 as it waits to be garbaged collected.
	 */
	public class LoadingBox extends Sprite {

		private static const FADE_WIDTH:int = 260;
		private static const FADE_HEIGHT:int = 100;

		private var loadingText:TextField;
		private var cancelBtn:Btn;
		private var theStage:Stage;


		public function LoadingBox(showCancelButton:Boolean, initLoadText:String = "Loading Level Data...") {
			theStage = Aeon.instance.stage;

			//determines vertical position of loadingText
			var offset:int = 12;
			if (showCancelButton)
				offset = 30;

			//create background: ellipse with gradient fill.
			var bgFade:Sprite = new Sprite();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(FADE_WIDTH, FADE_HEIGHT);
			with (bgFade.graphics) {
				beginGradientFill("radial", [0, 0], [1, 0], [100, 255], matrix);
				drawEllipse(0, 0, FADE_WIDTH, FADE_HEIGHT);
				endFill();
			}
			bgFade.x = -FADE_WIDTH / 2;
			bgFade.y = -FADE_HEIGHT / 2;

			//initialize loading/error text:
			loadingText = new TextField();
			var loadingFormat:TextFormat = new TextFormat("Arial", 15, 0xFFFFFF);
			loadingFormat.align = TextFormatAlign.CENTER;
			loadingText.defaultTextFormat = loadingFormat;
			loadingText.autoSize = TextFieldAutoSize.CENTER;
			loadingText.selectable = true;
			loadingText.multiline = true;
			loadingText.wordWrap = false;
			loadingText.background = true;
			loadingText.backgroundColor = 0x333333;
			loadingText.border = true;
			loadingText.borderColor = 0;
			loadingText.x = 0;
			loadingText.y = -offset;
			loadingText.text = initLoadText;

			//create a cancel button:
			if (showCancelButton) {
				cancelBtn = new BtnRecSolid("Cancel");
				cancelBtn.moveTo(0, loadingText.y + loadingText.height + 14);
				addChild(cancelBtn);
			}

			addChildAt(bgFade, 0);
			addChildAt(loadingText, 1);

			this.x = theStage.stageWidth / 2;
			this.y = theStage.stageHeight / 2;

			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
		}


		private function onStageResize(evt:Event):void {
			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;
			x = sw / 2;
			y = sh / 2;
		}


		public function set text(t:String):void {
			loadingText.text = t;
		}


		public function get cancelButton():Btn {
			return cancelBtn;
		}


		public function deconstruct():void {
			theStage.removeEventListener(Event.RESIZE, onStageResize);
		}
	}
}
