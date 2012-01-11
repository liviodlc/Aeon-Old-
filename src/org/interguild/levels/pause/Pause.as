package org.interguild.levels.pause {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	import org.interguild.Aeon;
	import org.interguild.gui.ResizeIcon;
	import org.interguild.levels.Level;
	import org.interguild.pages.GamePage;

	/**
	 * The Pause class handles the various pages that can exist within the pause screen,
	 * such as the PauseMenu and the ErrorLog. It's also responsible for making a semi-transparent,
	 * black overlay above the rest of the screen.
	 */
	public class Pause extends Sprite {

		private var theStage:Stage;

		private var bg:Sprite;
		private var menu:PauseMainMenu;
		private var log:ErrorLog;
		private var code:CodeLog;

		private var level:Level;


		public function Pause(lvl:Level, w:Number, h:Number) {
			visible = false;
			level = lvl;

			theStage = Aeon.instance.stage;

			var SW:int = theStage.stageWidth;
			var SH:int = theStage.stageHeight;

			// 75% black overlay above everything else
			bg = new Sprite();
			bg.graphics.beginFill(0, 0.75);
			bg.graphics.drawRect(0, 0, SW, SH);
			bg.graphics.endFill();

			//set up error log:
			log = new ErrorLog(SW, SH, this);
			code = new CodeLog(SW, SH, this, level.levelCode);
			menu = new PauseMainMenu(this, level);

			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);

			addChild(bg);
			addChild(log);
			addChild(code);
			addChild(menu);
			addChild(new ResizeIcon(w, h));
		}


		private function onStageResize(evt:Event):void {
			bg.width = log.width = code.width = theStage.stageWidth;
			bg.height = log.height = code.height = theStage.stageHeight;
		}


		internal function loadNewLevelCode(s:String):void {
			var g:GamePage = GamePage.instance;
			level.quit();
			g.loadAndPlay(s);
		}


		/**
		 * This function is only to be used for when wanting to display the Pause screen after it's already hidden.
		 * It makes the Pause screen visible, along with a specific page, depending on what the page parameter says.
		 *
		 * @param page:String=null tells the pause menu which page it should open to.
		 * The only valid value so far is "errors". Otherwise, the pause screen will
		 * by default open with the PauseMenu.
		 */
		public function show(page:String = null):void {
			if (page == "errors") {
				menu.visible = false;
				code.visible = false;
				log.visible = true;
			} else if (page == "code") {
				menu.visible = false;
				log.visible = false;
				code.visible = true;
			} else {
				log.visible = false;
				code.visible = false;
				menu.visible = true;
			}
			visible = true;
		}


		public function showError(s:String):void {
			log.errors = s;
			show("errors");
		}


		/**
		 * Hides the entire Pause screen. All pages are also made hidden in order to make it easier for show(page=null)
		 * to open any page.
		 */
		public function hide():void {
			visible = false;
		}


		internal function unpause():void {
			level.pause();
		}


		public function canUnpauseOnKey():Boolean {
			return (log.visible == false && code.visible == false);
		}
	}
}
