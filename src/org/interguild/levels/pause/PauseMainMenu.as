package org.interguild.levels.pause {

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import org.interguild.Aeon;
	import org.interguild.gui.BtnRecText;
	import org.interguild.levels.Level;

	/**
	 * This PauseMenu comes up when the user presses Esc, or any other pause key, such as Shift of P.
	 * This menu allows the user to quit a level, restart it, review the keys, and change options.
	 * It may also allow the user to load the level editor and edit the level.
	 * The pause menu also allows one to change between multiple levels that are open at the same time.
	 */
	public class PauseMainMenu extends Sprite {

		private var ps:Pause;
		private var level:Level;
		private var theStage:Stage;

		private var btn_resume:BtnRecText;
		private var btn_restart:BtnRecText;
		private var btn_quit:BtnRecText;
		private var btn_edit:BtnRecText;
		private var btn_debug:BtnRecText;
		private var btn_log:BtnRecText;
		private var btn_hide:BtnRecText;

		//These variables define the colors used in the gradient background.
		private static const BG_COLOR1:uint = 0x770000;
		private static const BG_COLOR2:uint = 0x220000;

		private const WIDTH:uint = 200;
		private const HEIGHT:uint = 260;


		public function PauseMainMenu(ps:Pause, lvl:Level) {
			this.ps = ps;
			level = lvl;
			theStage = Aeon.instance.stage;
			visible = false;

			var SW:int = theStage.stageWidth;
			var SH:int = theStage.stageHeight;

			x = SW / 2;
			y = SH / 2;

			// rounded rectangle bg:
			var bg:Sprite = new Sprite();
			var myMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
			myMatrix.createGradientBox(WIDTH, HEIGHT, Math.PI / 2);
			with (bg.graphics) {
				lineStyle(2);
				beginGradientFill(GradientType.LINEAR, [BG_COLOR1, BG_COLOR2], [.7, .7], [0, 255], myMatrix);
				drawRoundRect(0, 0, WIDTH, HEIGHT, 30, 30);
				endFill();
			}
			bg.y = -HEIGHT / 2;
			bg.x = -WIDTH / 2;

//			// rounded rectangle bg's border:
//			var bgb:Sprite = new Sprite();
//			with (bgb.graphics) {
//				beginFill(0);
//				drawRoundRect(-3, -3, WIDTH + 6, HEIGHT + 6, 36, 36);
//				endFill();
//			}
//			bgb.y = -HEIGHT / 2;
//			bgb.x = -WIDTH / 2;

			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);

			// "Pause Menu" text:
			var title:TextField = new TextField();
			title.defaultTextFormat = new TextFormat("Arial", 28, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER);
			title.autoSize = TextFieldAutoSize.CENTER;
			title.selectable = false;
			title.text = "Pause Menu";
			title.y = -22 - HEIGHT / 2;
			title.x = -title.width / 2;
			title.filters = [new GlowFilter(0, 1, 7, 7, 10, 1)];

			//resume button:
			btn_resume = new BtnRecText("Resume (Esc)", true);
			btn_resume.y = 20 - HEIGHT / 2;
			btn_resume.addEventListener(MouseEvent.CLICK, onResumeClick, false, 0, true);

			//restart button:
			btn_restart = new BtnRecText("Restart", true);
			btn_restart.y = 60 - HEIGHT / 2;
			btn_restart.addEventListener(MouseEvent.CLICK, onRestartClick, false, 0, true);

			//quit button:
			btn_quit = new BtnRecText("Quit", true);
			btn_quit.y = 90 - HEIGHT / 2;
			btn_quit.addEventListener(MouseEvent.CLICK, onQuitClick, false, 0, true);

			//edit button:
			btn_edit = new BtnRecText("Edit Level Code", true);
			btn_edit.y = 140 - HEIGHT / 2;
			btn_edit.addEventListener(MouseEvent.CLICK, onEditClick, false, 0, true);

			//debug button:
//			btn_debug = new BtnRecText("Debug", true);
//			btn_debug.y = 170 - HEIGHT / 2;
//			btn_debug.addEventListener(MouseEvent.CLICK, onDebugClick, false, 0, true);

			//error log button:
			btn_log = new BtnRecText("Error Log", true);
			btn_log.y = 170 - HEIGHT / 2;
			btn_log.addEventListener(MouseEvent.CLICK, onLogClick, false, 0, true);

			//hide menu button:
			btn_hide = new BtnRecText("Hide Menu (H)", true);
			btn_hide.y = 220 - HEIGHT / 2;
			btn_hide.addEventListener(MouseEvent.MOUSE_DOWN, onHideDown, false, 0, true);

			//add children:
//			addChild(bgb);
			addChild(bg);
			addChild(title);
			addChild(btn_resume);
			addChild(btn_restart);
			addChild(btn_quit);
			addChild(btn_edit);
//			addChild(btn_debug);
			addChild(btn_log);
			addChild(btn_hide);
		}


		private function onStageResize(evt:Event):void {
			var SW:int = theStage.stageWidth;
			var SH:int = theStage.stageHeight;

			var newScaleX:Number = 1;
			var newScaleY:Number = 1;

			var HEIGHT:int = this.HEIGHT + 30;
			var WIDTH:int = this.WIDTH + 20;

			if (SH < HEIGHT || SW < WIDTH) {
				newScaleX = SW / WIDTH;
				newScaleY = SH / HEIGHT;
			}
			if (newScaleX < newScaleY)
				scaleX = scaleY = newScaleX;
			else if (newScaleY <= newScaleX)
				scaleX = scaleY = newScaleY;

			x = SW / 2;
			y = SH / 2;
		}


		private function onResumeClick(evt:MouseEvent):void {
			level.pause();
		}


		private function onRestartClick(evt:MouseEvent):void {
			ps.unpause();
			level.restart();
		}


		private function onQuitClick(evt:MouseEvent):void {
			level.quit();
		}


		private function onEditClick(evt:MouseEvent):void {
			ps.show("code");
		}


//		private function onDebugClick(evt:MouseEvent):void {
//			//TODO
//		}


		private function onLogClick(evt:MouseEvent):void {
			ps.show("errors");
		}


		private function onHideDown(evt:MouseEvent):void {
			btn_hide.removeEventListener(MouseEvent.MOUSE_DOWN, onHideDown);
			theStage.addEventListener(MouseEvent.MOUSE_UP, onHideUp, false, 0, true);
			ps.visible = false;
		}
		
		private function onHideUp(evt:MouseEvent):void{
			theStage.removeEventListener(MouseEvent.MOUSE_UP, onHideUp);
			btn_hide.addEventListener(MouseEvent.MOUSE_DOWN, onHideDown, false, 0, true);
			ps.visible = true;
		}


		private function onKeyDown(evt:KeyboardEvent):void {
			if (evt.keyCode == 72)
				ps.visible = false;
		}


		private function onKeyUp(evt:KeyboardEvent):void {
			if (evt.keyCode == 72)
				ps.visible = true;
		}


		public override function set visible(value:Boolean):void {
			super.visible = value;
			if (value) {
				theStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
				theStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			} else {
				theStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				theStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
		}
	}
}
