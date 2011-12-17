package org.interguild.levels {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import org.interguild.levels.assets.AssetMan;
	import org.interguild.levels.keys.KeyMan;
	import org.interguild.log.LoadingBox;
	import org.interguild.pages.GamePage;

	public class Level extends Sprite {

		private static var untitledCount:uint = 1;

		private static const LEVEL_EDIT:uint = 1;
		private static const LEVEL_START:uint = 2;
		private static const LEVEL_PLAY:uint = 3;
		private static const LEVEL_END:uint = 4;

		private var gamepage:GamePage;
		private var hud:LevelHUD;
		private var lvl:LevelArea;

		private var state:uint;
		private var _levelCode:String;

		private var _assets:AssetMan;
		private var _keys:KeyMan;

		private var finishedLoading:Boolean;
		private var _errorLog:String;

		private var _title:String;

		private var timer:Timer;
		private var _frameRate:Number;


		/**
		 * Leave parameters blank for empty, untitled level in Editor mode
		 */
		public function Level(inEditor:Boolean = true, code:String = null) {
			gamepage = GamePage.instance;
			_levelCode = code;
			_errorLog = "";

			if (inEditor)
				state = LEVEL_EDIT;
			else
				state = LEVEL_START;
		}


		/**
		 * Creates a LevelBuilder that will interpret the level code an build this level.
		 */
		public function startLoading():void {
			finishedLoading = false;

			if (_levelCode == null) {
				//set default title:
				title = null;
				finishedLoading = true;
			} else {
				var result:Boolean = gamepage.loadLock();
				if (result == false) {
					addError("Programmer's Error: You shouldn't be able to load two levels at once. Please report this at interguild.org");
				} else {
					new LevelBuilder(this);
				}
			}
		}


		/**
		 * Accepts a number between 0.01 and 1000.
		 */
		public function set frameRate(num:Number):void {
			if (num < 0.01 || num > 1000) {
				throw new Error("All level framerates must be between 0.01 and 1000.");
			}
			_frameRate = num;
			var period:Number = 1000 / _frameRate;
			if (timer == null) {
				timer = new Timer(period);
			} else {
				timer.delay = period;
			}
		}


		public function get frameRate():Number {
			return _frameRate;
		}


		public function get title():String {
			return _title;
		}


		public function set title(txt:String):void {
			if (txt == null) {
				_title = "Untitled-" + untitledCount;
				untitledCount++;
			} else {
				_title = txt;
			}
		}


		public function get errorLog():String {
			return _errorLog;
		}


		public function get levelCode():String {
			return _levelCode;
		}


		public function get assets():AssetMan {
			return _assets;
		}


		public function set assets(a:AssetMan):void {
			if (_assets != null) {
				throw new Error("Assets have already been initialized by LevelBuilder");
			} else {
				_assets = a;
			}
		}


		public function get keys():KeyMan {
			return _keys;
		}


		public function set keys(k:KeyMan):void {
			if (_keys != null) {
				throw new Error("KeyMan has already been initialized by LevelBuilder");
			} else {
				_keys = k;
			}
		}


		/**
		 * Allows you to set the LevelArea for this level, but only if the LevelArea for this level hasn't been defined yet.
		 */
		public function set levelArea(la:LevelArea):void {
			if (lvl == null)
				lvl = la;
			else
				new Error("The LevelArea for level '" + this.title + "' has already been initialized.");
		}


		/**
		 * If there's an error while loading the level, use this function to add it to this level's Error Log.
		 */
		public function addError(txt:String):void {
			_errorLog += txt + "\n\n";
		}


		/**
		 * allows outside classes to check if the level has finished loading yet.
		 */
		public function get hasFinishedLoading():Boolean {
			return finishedLoading;
		}


		public function setHUD(_hud:LevelHUD):void {
			hud = _hud;
			addChild(hud);
		}


		/**
		 * Fires up the game loop and puts the level into LEVEL_START state.
		 *
		 * If the level was opened to be played, then this function is called by LevelBuilder when it
		 * finishes building the level.
		 *
		 * If the level was opened to be edited (or if it's currently being edited), then this function
		 * is called by the Level Editor when it's time to test the level.
		 */
		public function playLevel():void {
			if (state == LEVEL_EDIT) {
				//TODO convert everything from level edit to level start state
			} else {
				hud.onLoadComplete();

				// if there are errors, show them.
				if (_errorLog.length > 2) {
					// this is temporary code. Ideally, the Pause Menu would load the error log
					trace("//ERROR LOG");
					trace(_errorLog);
					trace("//END ERROR LOG");
				}

				timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);
				_keys.activate();
				timer.start();
			}
		}


		/**
		 * ITS TEH GAME LOOP!!!
		 *
		 * Notice how it runs in the Level class, and then it just updates the LevelHUD and the LevelArea.
		 * But it also runs other checks:
		 *	--If the player presses Esc, pause the game
		 *	--Manage events such as LEVEL_RESET, LEVEL_WIN, etc.
		 */
		private function onGameLoop(evt:TimerEvent):void {
			lvl.onGameLoop();
			hud.onGameLoop();

			//testing KeyMan
			if (_keys.isActionDown(KeyMan.JUMP, true))
				trace("A	" + Math.round(flash.utils.getTimer()));
//			if(_keys.isKeyDown(32,true))
//				trace("K	"+Math.round(flash.utils.getTimer()/1000));
		}
	}
}
