package org.interguild.gui {

	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.*;
	import flash.ui.Mouse;

	/**
	 class BtnRecText = Rectangular Button without fill but upon rollover, alpha gradient
	 
	 NOTE: x and y are at the top-center point of the button.
	 If you want to set its coordinates based on the top-left point,
	 use public function moveTo2(int x, int y);
	 */
	public class BtnRecText extends Btn {

		private var canvas:Sprite; // where the gradient is drawn
		private var canvas2:Sprite; // where the border is drawn

		private static const LABEL_FONT:String = "Verdana";
		private static const FONT_SIZE:Number = 18;
		private static const FONT_COLOR:uint = 0xFFFFFF;

		private static const BUFFER:Number = 50; //the button's width is the label's width plus BUFFER
		private static const HEIGHT:Number = 28; //the button's height

		private static const BG_COLOR:uint = 0x000000; //0 is black
		private static const BG_COLOR_ONCLICK:uint = 0x990000;

		public function BtnRecText(txtlbl:String, dropShadow:Boolean = false):void {
			//initialize variables:
			canvas = new Sprite();
			canvas2 = new Sprite();

			//set this certain Sprite properties:
			buttonMode = true;
			mouseChildren = false;

			// make text label:
			var lblText:TextField = new TextField();
			var lblFormat:TextFormat = new TextFormat(LABEL_FONT, FONT_SIZE, FONT_COLOR);
			lblFormat.align = TextFormatAlign.CENTER;
			lblText.text = txtlbl;
			lblText.autoSize = TextFieldAutoSize.CENTER;
			lblText.setTextFormat(lblFormat);
			// center the label
			lblText.x = -(lblText.width / 2);
			
			if(dropShadow)
				lblText.filters = [new DropShadowFilter()];

			//a little optimization:
			var btnWidth:Number = lblText.width + BUFFER;
			var left:Number = -btnWidth / 2;

			//Matrix used for rollover and on-click gradients
			var myMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
			myMatrix.createGradientBox(btnWidth, HEIGHT, 0);

			//draw on-click fill:
			with (canvas2.graphics) {
				beginGradientFill(GradientType.LINEAR, [BG_COLOR_ONCLICK, BG_COLOR_ONCLICK], [1, 0],
								  [0, 150], myMatrix, "reflect");
				drawRect(left, 0, btnWidth, HEIGHT);
				endFill();
			}
			canvas2.visible = false;

			//draw rollover fill:
			with (canvas.graphics) {
				beginGradientFill(GradientType.LINEAR, [BG_COLOR, BG_COLOR], [1, 0],
								  [0, 150], myMatrix, "reflect");
				drawRect(left, 0, btnWidth, HEIGHT);
				endFill();
			}
			canvas.visible = false;

			//add drawings:
			addChild(canvas2);
			addChild(canvas);
			addChild(lblText);

			addEventListener(MouseEvent.MOUSE_OVER, onRollOver, false, 0, true);
		}

		private function onRollOver(evt:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onUp, false, 0, true);
			removeEventListener(MouseEvent.MOUSE_OVER, onUp);
			canvas.visible = true;
		}

		private function onDown(evt:MouseEvent):void {
			//show alternate color:
			canvas.visible = false;
			canvas2.visible = true;

			addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private function onUp(evt:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver, false, 0, true);
			removeEventListener(MouseEvent.MOUSE_DOWN, onUp);
			removeEventListener(MouseEvent.MOUSE_OUT, onUp);
			canvas.visible = false;
			canvas2.visible = false;
		}
	}
}