package org.interguild.gui {

	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;

	/**
	 class BtnRecSolid = Rectangular Button with Solid Fill
	 
	 NOTE: x and y are at the top-center point of the button.
	 If you want to set its coordinates based on the top-left point,
	 use public function moveTo2(int x, int y);
	 */
	public class BtnRecSolid extends Btn {

		private var canvas:Sprite; // where the gradient is drawn
		private var canvas2:Sprite; // where the border is drawn
		private var lblText:TextField;
		
		private static const LABEL_FONT:String = "Verdana";
		private static const FONT_SIZE:Number = 12;
		private static const FONT_COLOR:uint = 0xFFFFFF;
		
		private static const BUFFER:Number = 40; //the button's width is the label's width plus BUFFER
		private static const HEIGHT:Number = 20; //the button's height
		
		private static const BG_COLOR:uint = 0x990000;
		private static const BG_COLOR_ONCLICK:uint = 0x660000;

		public function BtnRecSolid(txtlbl:String):void {
			//initialize variables:
			canvas = new Sprite();
			canvas2 = new Sprite();
			
			//set this certain Sprite properties:
			buttonMode = true;
			mouseChildren = false;
			
			initTextLabel(txtlbl);
			
			//a little optimization:
			var btnWidth:Number = lblText.width + BUFFER;
			var left:Number = -btnWidth / 2;
			
			//draw on-click fill:
			with (canvas2.graphics) {
				beginFill(BG_COLOR_ONCLICK);
				drawRect(left, 0, btnWidth, HEIGHT);
				endFill();
			}
			canvas2.visible = false;
			
			//draw normal fill:
			with (canvas.graphics) {
				beginFill(BG_COLOR);
				drawRect(left, 0, btnWidth, HEIGHT);
				endFill();
			}
			
			//add drawings:
			addChild(canvas2);
			addChild(canvas);
			addChild(lblText);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
		}

		private function initTextLabel(txtlbl:String):void{
			// make text label:
			lblText = new TextField();
			var lblFormat:TextFormat = new TextFormat(LABEL_FONT, FONT_SIZE, FONT_COLOR);
			lblFormat.align = TextFormatAlign.CENTER;
			lblText.text = txtlbl;
			lblText.autoSize = TextFieldAutoSize.CENTER;
			lblText.setTextFormat(lblFormat);
			// center the label
			lblText.x = -(lblText.width / 2);
		}

		private function onDown(evt:MouseEvent):void {
			//show alternate color:
			canvas.visible = false;
			canvas2.visible = true;
			
			addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onUp, false, 0, true);
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private function onUp(evt:MouseEvent):void {
			//show normal color:
			canvas2.visible = false;
			canvas.visible = true;
			
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
			removeEventListener(MouseEvent.MOUSE_OUT, onUp);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
		}
		
		/**
		 * Sets the button label and resizes the button accordingly.
		 */
		public override function set text(txt:String):void {
			removeChild(lblText);
			initTextLabel(txt);
			addChild(lblText);
			
			var btnWidth:Number = lblText.width + BUFFER;
			var left:Number = -btnWidth / 2;
			
			//draw on-click fill:
			canvas2.graphics.clear();
			with (canvas2.graphics) {
				beginFill(BG_COLOR_ONCLICK);
				drawRect(left, 0, btnWidth, HEIGHT);
				endFill();
			}
			
			//draw normal fill:
			canvas.graphics.clear();
			with (canvas.graphics) {
				beginFill(BG_COLOR);
				drawRect(left, 0, btnWidth, HEIGHT);
				endFill();
			}
		}
	}
}