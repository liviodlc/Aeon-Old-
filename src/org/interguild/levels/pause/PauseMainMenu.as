package org.interguild.levels.pause{

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.interguild.gui.BtnRecText;
	
	import org.interguild.log.ErrorLog;
	
	import org.interguild.pages.LevelPage;

	/**
	 * This PauseMenu comes up when the user presses Esc, or any other pause key, such as Shift of P.
	 * This menu allows the user to quit a level, restart it, review the keys, and change options.
	 * It may also allow the user to load the level editor and edit the level.
	 * The pause menu also allows one to change between multiple levels that are open at the same time.
	 */
	public class PauseMainMenu extends Sprite{
		
		private var ps:Pause;
		private var levelPage:LevelPage;
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
		private const HEIGHT:uint = 280;
		
		public function PauseMainMenu(ps:Pause,lvlPage:LevelPage, stage:Stage){
			visible = false;
			
			this.ps = ps;
			levelPage = lvlPage;
			theStage = stage;
			
			var SW:int = stage.stageWidth;
			var SH:int = stage.stageHeight;
			
			x = SW/2;
			y = SH/2;
			
			// rounded rectangle bg:
			var bg:Sprite = new Sprite();
			var myMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
			myMatrix.createGradientBox(WIDTH, HEIGHT, Math.PI / 2);
			with (bg.graphics) {
				beginGradientFill(GradientType.LINEAR, [BG_COLOR1, BG_COLOR2], [1, 1], [0, 255],
					myMatrix);
				drawRoundRect(0,0,WIDTH,HEIGHT,30,30);
				endFill();
			}
			bg.y = - HEIGHT/2;
			bg.x = - WIDTH/2;
			
			// rounded rectangle bg's border:
			var bgb:Sprite = new Sprite();
			with (bgb.graphics) {
				beginFill(0);
				drawRoundRect(-3,-3,WIDTH+6,HEIGHT+6,36,36);
				endFill();
			}
			bgb.y = - HEIGHT/2;
			bgb.x = - WIDTH/2;
			
			theStage.addEventListener(Event.RESIZE,onStageResize,false,0,true);
			
			// "Pause Menu" text:
			var title:TextField = new TextField();
			title.defaultTextFormat = new TextFormat("Arial",28,0xFFFFFF,true,null,null,null,null,TextFormatAlign.CENTER);
			title.autoSize = TextFieldAutoSize.CENTER;
			title.selectable=false;
			title.text = "Pause Menu";
			title.y = - 22 - HEIGHT/2;
			title.x = - title.width/2;
			title.filters = [new GlowFilter(0,1,7,7,10,1)];
			
			//resume button:
			btn_resume = new BtnRecText("Resume");
			btn_resume.y = 20 - HEIGHT/2;
			btn_resume.addEventListener(MouseEvent.CLICK,onResumeClick,false,0,true);
			
			//restart button:
			btn_restart = new BtnRecText("Restart");
			btn_restart.y = 60 - HEIGHT/2;
			btn_restart.addEventListener(MouseEvent.CLICK,onRestartClick,false,0,true);
			
			//quit button:
			btn_quit = new BtnRecText("Quit");
			btn_quit.y = 90 - HEIGHT/2;
			btn_quit.addEventListener(MouseEvent.CLICK,onQuitClick,false,0,true);
			
			//edit button:
			btn_edit = new BtnRecText("Edit Level");
			btn_edit.y = 140 - HEIGHT/2;
			btn_edit.addEventListener(MouseEvent.CLICK,onEditClick,false,0,true);
			
			//debug button:
			btn_debug = new BtnRecText("Debug");
			btn_debug.y = 170 - HEIGHT/2;
			btn_debug.addEventListener(MouseEvent.CLICK,onDebugClick,false,0,true);
			
			//error log button:
			btn_log = new BtnRecText("Error Log");
			btn_log.y = 200 - HEIGHT/2;
			btn_log.addEventListener(MouseEvent.CLICK,onLogClick,false,0,true);
			
			//hide menu button:
			btn_hide = new BtnRecText("Hide Menu");
			btn_hide.y = 250 - HEIGHT/2;
			btn_hide.addEventListener(MouseEvent.ROLL_OVER,onHideOver,false,0,true);
			
			//add children:
			addChild(bgb);
			addChild(bg);
			addChild(title);
			addChild(btn_resume);
			addChild(btn_restart);
			addChild(btn_quit);
			addChild(btn_edit);
			addChild(btn_debug);
			addChild(btn_log);
			addChild(btn_hide);
		}
		
		public function show():void {
			visible = true;
		}
		
		public function hide():void {
			visible = false;
		}

		private function onStageResize(evt:Event):void{
			var SW:int = theStage.stageWidth;
			var SH:int = theStage.stageHeight;

			var newScaleX:Number = 1;
			var newScaleY:Number = 1;

			var HEIGHT:int = this.HEIGHT + 30;
			var WIDTH:int = this.WIDTH + 20;

			if(SH < HEIGHT || SW < WIDTH){
				newScaleX = SW / WIDTH;
				newScaleY = SH / HEIGHT;
			}
			if(newScaleX < newScaleY)
				scaleX = scaleY = newScaleX;
			else if(newScaleY <= newScaleX)
				scaleX = scaleY = newScaleY;

			x = SW/2;
			y = SH/2;
		}

		private function onResumeClick(evt:MouseEvent):void{
			levelPage.pauseToggle();
		}
		
		private function onRestartClick(evt:MouseEvent):void{
			//TODO
		}
		
		private function onQuitClick(evt:MouseEvent):void{
			levelPage.quit();
		}
		
		private function onEditClick(evt:MouseEvent):void{
			//TODO
		}
		
		private function onDebugClick(evt:MouseEvent):void{
			//TODO
		}
		
		private function onLogClick(evt:MouseEvent):void{
			ps.fromMenuToLog();
		}
		
		private function onHideOver(evt:MouseEvent):void{
			//TODO
		}
	}
}