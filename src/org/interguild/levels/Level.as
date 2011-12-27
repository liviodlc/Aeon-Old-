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
	import org.interguild.levels.objects.styles.PseudoClassTriggers;
	import org.interguild.log.LoadingBox;
	import org.interguild.pages.GamePage;

	public class Level extends Sprite {

		private static var untitledCount:uint = 1;

		private var inEditor:Boolean = false;
		private var _state:PseudoClassTriggers;

		private var gamepage:GamePage;
		private var hud:LevelHUD;
		private var lvl:LevelArea;

		private var _levelCode:String;

		private var _assets:AssetMan;
		private var _keys:KeyMan;

		private var finishedLoading:Boolean;
		private var _errorLog:String;

		private var _title:String;

		private var timer:Timer;
		private var _frameRate:Number;

		public var loadDefaultSettings:Boolean = true;


		/**
		 * Leave parameters blank for empty, untitled level in Editor mode
		 */
		public function Level(inEditor:Boolean = true, code:String = null) {
			gamepage = GamePage.instance;
			_levelCode = code;
			_errorLog = "";

			this.inEditor = inEditor;
			_state = new PseudoClassTriggers();
			_state.setLoading();
			if (!inEditor)
				_state.setPreview();
		}


		public function get state():PseudoClassTriggers {
			return _state;
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
			if (lvl == null) {
				lvl = la;
				lvl.visible = false;
				addChildAt(lvl,0);
			} else {
				new Error("The LevelArea for level '" + this.title + "' has already been initialized.");
			}
		}
		
		public function get levelArea():LevelArea{
			return lvl;
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
			if (inEditor) {
				//TODO convert everything from level edit to level start state
			} else {
				_state.update();
				_state.setLoading(false);
				lvl.initStyles();
				lvl.visible = true;

				//testing assets:
//				var img:BitmapData = assets.getImage("circleWithSquare");
//				var b1:Bitmap = new Bitmap(img);
//				var b2:Bitmap = new Bitmap(img);
//				b2.x = b2.y = 200;
//				addChild(b1);
//				addChild(b2);

				// if there are errors, show them.
//				if (_errorLog.length > 2) {
//					// this is temporary code. Ideally, the Pause Menu would load the error log
//					trace("//ERROR LOG");
//					trace(_errorLog);
//					trace("//END ERROR LOG");
//				}

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
			updateState();

			lvl.onGameLoop();
			hud.onGameLoop();
			_keys.onGameLoop();

			_state.update();
		}


		private function updateState():void {
			// if on jump-to-start screen and player jumps, then start level
			if (_state.getPreview() && _keys.isActionDown(KeyMan.JUMP, true))
				_state.setPreview(false);

			// if on any screen, the player presses pause, open pause menu
//			if(_keys.isActionDown(KeyMan.PAUSE,true)
//				open pasue menu

			// if on any screen, the player presses quit, quit the level
			if (_keys.isActionDown(KeyMan.QUIT, true))
				gamepage.closeLevel(this);

			// if while playing or after winning, player wants to restart, restart level
			if (!_state.getPreview() && _keys.isActionDown(KeyMan.RESTART, true))
				lvl.restart();

			//tests:
			if (_keys.isActionDown(KeyMan.JUMP, true)) {
				trace("gameloop: " + timer.currentCount);
				trace("LevelArea x: " + lvl.x + " y: " + lvl.y + " w: " + lvl.width + " h: " + lvl.height);
			}
		}
	}
}
