package org.interguild.levels.pause{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.interguild.log.ErrorLog;
	
	import org.interguild.pages.LevelPage;
	
	/**
	 * The Pause class handles the various pages that can exist within the pause screen,
	 * such as the PauseMenu and the ErrorLog. It's also responsible for making a semi-transparent,
	 * black overlay above the rest of the screen.
	 */
	public class Pause extends Sprite{
		
		private var levelPage:LevelPage;
		private var theStage:Stage;
		
		private var bg:Sprite;
		private var menu:PauseMainMenu;
		private var log:ErrorLog;
		
		public function Pause(lvlPage:LevelPage, stage:Stage){
			visible = false;

			levelPage = lvlPage;
			theStage = stage;
			
			var SW:int = stage.stageWidth;
			var SH:int = stage.stageHeight;

			// 50% black overlay above everything else
			bg = new Sprite();
			bg.graphics.beginFill(0, 0.5);
			bg.graphics.drawRect(0, 0, SW, SH);
			bg.graphics.endFill();

			//set up error log:
			log = new ErrorLog(levelPage, this, theStage);
			menu = new PauseMainMenu(this, levelPage, theStage);
			
			theStage.addEventListener(Event.RESIZE,onStageResize,false,0,true);

			addChild(bg);
			addChild(log);
			addChild(menu);
		}
		
		private function onStageResize(evt:Event):void{
			bg.width = theStage.stageWidth;
			bg.height = theStage.stageHeight;
		}
		
		/**
		 * This function is only to be used for when wanting to display the Pause screen after it's already hidden.
		 * It makes the Pause screen visible, along with a specific page, depending on what the page parameter says.
		 * 
		 * @param page:String=null tells the pause menu which page it should open to.
		 * The only valid value so far is "errors". Otherwise, the pause screen will
		 * by default open with the PauseMenu.
		 */
		public function show(page:String=null):void{
			if(page=="errors"){
				log.visible=true;
			}else{
				menu.visible=true;
			}
			visible=true;
		}
		
		/**
		 * Hides the entire Pause screen. All pages are also made hidden in order to make it easier for show(page=null)
		 * to open any page.
		 */
		public function hide():void{
			log.visible=false;
			menu.visible=false;
			visible=false;
		}
		
		/**
		 * Use this function if the PauseMenu is currently visible and you want to switch to the ErrorLog page.
		 */
		public function fromMenuToLog():void{
			menu.visible=false;
			log.visible=true;
		}
		
		/**
		 * Use this function if the ErrorLog is currently visible and you want to switch to the PauseMenu page.
		 */
		public function fromLogToMenu():void{
			log.visible=false;
			menu.visible=true;
		}
	}
}