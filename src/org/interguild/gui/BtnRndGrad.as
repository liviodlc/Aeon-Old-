package org.interguild.gui {

	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.*;

	/**
	 class BtnRndGrad = Round Button with Gradient Fill
	 
	 NOTE: x and y are at the top-center point of the button.
	 If you want to set its coordinates based on the top-left point,
	 use public function moveTo2(int x, int y);
	 */
	public class BtnRndGrad extends Btn {

		private var canvas:Sprite; // where the gradient is drawn
		private var canvas2:Sprite; // where the border is drawn

		private static const LABEL_FONT:String = "Verdana";
		private static const FONT_SIZE:Number = 15;
		private static const FONT_COLOR:uint = 0xFF0000;

		private static const ROUNDING:Number = 20; //the amount of rounding on the rounded rectangle
		private static const BUFFER:Number = 20; //the button's width is the label's width plus BUFFER
		private static const HEIGHT:Number = 25; //the button's height

		private static const BORDER_WIDTH:Number = 1;
		private static const BORDER_COLOR:uint = 0x000000;

		private static const GRADIENT_COLOR_TOP:uint = 0x494949; //the first color in the gradient, appears on top
		private static const GRADIENT_COLOR_BOT:uint = 0x000000; //the second color in the gradient, appears on bottom

		public function BtnRndGrad(txtlbl:String):void {
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
			lblFormat.bold = true;
			lblText.text = txtlbl;
			lblText.autoSize = TextFieldAutoSize.CENTER;
			lblText.setTextFormat(lblFormat);
			// center the label
			lblText.x = -(lblText.width / 2);

			//a little optimization:
			var btnWidth:Number = lblText.width + BUFFER;
			var left:Number = -btnWidth / 2;

			//draw the border:
			with (canvas2.graphics) {
				beginFill(0x000000);
				drawRoundRect(left - BORDER_WIDTH, -BORDER_WIDTH, btnWidth + 2 * BORDER_WIDTH, HEIGHT + 2 * BORDER_WIDTH,
							  ROUNDING);
				endFill();
			}

			//this Matrix is used to draw the gradient:
			var btnMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
			btnMatrix.createGradientBox(btnWidth, HEIGHT, Math.PI / 2);

			//draw the button's fill:
			with (canvas.graphics) {
				beginGradientFill(GradientType.LINEAR, [GRADIENT_COLOR_TOP, GRADIENT_COLOR_BOT], [1, 1], [0, 255],
								  btnMatrix);
				drawRoundRect(left, 0, btnWidth, HEIGHT, ROUNDING);
				endFill();
			}

			//add the drawings:
			addChild(canvas2);
			addChild(canvas);
			addChild(lblText);

			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
		}

		private function onDown(evt:MouseEvent):void {
			//flip the gradient up-side down:
			canvas.rotation = 180;
			canvas.y += canvas.height;

			addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onUp, false, 0, true);
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private function onUp(evt:MouseEvent):void {
			//flip the gradient right side up:
			canvas.rotation = 0;
			canvas.y -= canvas.height;

			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
			removeEventListener(MouseEvent.MOUSE_OUT, onUp);
		}
	}
}