package org.interguild {

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	
	import org.interguild.log.LoadingBox;
	import org.interguild.pages.*;
	
	import tests.TestUtils;

	[SWF(width = "640", height = "480", frameRate = "30", backgroundColor = "#222222")]

	/** AEON CLASS
	 *	This is the document class, the program's point of entry.
	 *  It is not meant to be instantiated by any code in the game.
	 *  It mainly manages the different pages within the game.
	 */
	public class Aeon extends Sprite {

		private static var HOME_PAGE:uint = 0x1;
		private static var CREDITS_PAGE:uint = 0x2;
		private static var LEVELS_PAGE:uint = 0x3;
		private static var GAME_PAGE:uint = 0x4;
		private var curPage:uint;

		private static var thisInstance:Aeon = null;


		public static function get instance():Aeon {
			return thisInstance;
		}

		private var loading:LoadingBox;

		private var home:Page;
		private var credits:Page;
		private var levels:Page;
		private var game:Page;


		public function Aeon() {
			var test:TestUtils;
			test = new TestUtils();
			
			thisInstance = this;
			allowStageResize();
			allowYouTube();
			initLoadingText();
			initPages();
			finishLoading();
		}


		private function allowStageResize():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		private function allowYouTube():void{
			Security.allowDomain("www.youtube.com");
		}


		private function initLoadingText():void {
			loading = new LoadingBox(false, "...Initializing Menus...");
			addChild(loading);
		}


		private function initPages():void {
			home = new HomePage();
			credits = new CreditsPage();
			levels = new LevelsPage();
			game = new GamePage();

			addChild(home);
			addChild(credits);
			addChild(game);
			addChild(levels);
		}


		private function finishLoading():void {
			removeChild(loading);
			loading.deconstruct();
			loading = null;

			curPage = HOME_PAGE;
			home.open();
		}


		/**
		 * Hides the current page and displays the homepage
		 */
		public function gotoHomePage():void {
			if (curPage != HOME_PAGE) {
				switch (curPage) {
					case CREDITS_PAGE:
						credits.close();
						break;
					case LEVELS_PAGE:
						levels.close();
						break;
					case GAME_PAGE:
						game.close();
						break;
				}
				curPage = HOME_PAGE;
				home.open();
			}
		}


		/**
		 * Hides the current page and displays the credits page
		 */
		public function gotoCreditsPage():void {
			if (curPage != CREDITS_PAGE) {
				switch (curPage) {
					case HOME_PAGE:
						home.close();
						break;
					case LEVELS_PAGE:
						levels.close();
						break;
					case GAME_PAGE:
						game.close();
						break;
				}
				curPage = CREDITS_PAGE;
				credits.open();
			}
		}


		/**
		 * Hides the current page and displays the user-levels page
		 */
		public function gotoLevelsPage():void {
			if (curPage != LEVELS_PAGE) {
				switch (curPage) {
					case HOME_PAGE:
						home.close();
						break;
					case CREDITS_PAGE:
						credits.close();
						break;
					case GAME_PAGE:
						game.close();
						break;
				}
				curPage = LEVELS_PAGE;
				levels.open();
			}
		}


		/**
		 * Hides the current page and displays the game page
		 */
		public function gotoGamePage():void {
			if (curPage != GAME_PAGE) {
				switch (curPage) {
					case HOME_PAGE:
						home.close();
						break;
					case CREDITS_PAGE:
						credits.close();
						break;
					case LEVELS_PAGE:
						levels.close();
						break;
				}
				curPage = GAME_PAGE;
				game.open();
			}
		}
	}
}
