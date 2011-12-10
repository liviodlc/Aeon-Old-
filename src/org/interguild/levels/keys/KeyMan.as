package org.interguild.levels.keys {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	import org.interguild.Aeon;
	import org.interguild.levels.Level;

	/**
	 * Key Man appears! His specialty is... to manage keyboard presses!

	 @@@@                      @@@@@@@@@    @@@@@@@@@@@@@@@@@              @@@@@@@@
	 @@@@                      @@@@@@@@@    @@@@@@@@@@@@@@@@@              @@@@@@@@
	 @@@@                      @@@@@@@@@    @@@@@@@@@@@@@@@@@              @@@@@@@@
	 @@@@                      @@@@@@@@@    @@@@@@@@@@@@@@@@@              @@@@@@@@
	 @@@@                      @@@@@@@@@    @@@@@@@@@@@@@@@@@              @@@@@@@@
	 @@@@;;;;@@@@@             @@@@         @@@@;;;;;;;;;;;;;;;;;@@@@@    @@@@@::::@@@@
	 @@@@;;;;@@@@@             @@@@         @@@@;;;;;;;;;;;;;;;;;@@@@@    @@@@@::::@@@@
	 @@@@;;;;@@@@@             @@@@         @@@@;;;;;;;;;;;;;;;;;@@@@@    @@@@@::::@@@@
	 @@@@;;;;@@@@@             @@@@         @@@@;;;;;;;;;;;;;;;;;@@@@@    @@@@@::::@@@@
	 @@@@;;;;@@@@@@@@@    @@@@@                 @@@@;;;;;;;;;;;;;;;;;;@@@@@@@@@::::@@@@
	 @@@@;;;;@@@@@@@@@    @@@@@                 @@@@;;;;;;;;;;;;;;;;;;@@@@@@@@@::::@@@@
	 @@@@;;;;@@@@@@@@@    @@@@@                 @@@@;;;;;;;;;;;;;;;;;;@@@@@@@@@::::@@@@
	 @@@@;;;;@@@@@@@@@    @@@@@                 @@@@;;;;;;;;;;;;;;;;;;@@@@@@@@@::::@@@@
	 @@@@;;;;;;;;;;;;;@@@@@@@@@    @@@@         @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@::::@@@@
	 @@@@;;;;;;;;;;;;;@@@@@@@@@    @@@@         @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@::::@@@@
	 @@@@;;;;;;;;;;;;;@@@@@@@@@    @@@@         @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@::::@@@@
	 @@@@;;;;;;;;;;;;;@@@@@@@@@    @@@@         @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@::::@@@@
	 @@@@;;;;;;;;;;;;;@@@@@@@@@    @@@@         @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;@@@@@                 @@@@;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;@@@@@                 @@@@;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;@@@@@                 @@@@;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;@@@@@                 @@@@;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@@;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@         @@@@;;;;@@@@@        ;;;;;:::::::::@@@@
	 @@@@@;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@         @@@@;;;;@@@@@        ;;;;;:::::::::@@@@
	 @@@@@;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@         @@@@;;;;@@@@@        ;;;;;:::::::::@@@@
	 @@@@@;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@         @@@@;;;;@@@@@        ;;;;;:::::::::@@@@
	 @@@@@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@;;;;@@@@@@@@@        ;;;;;:::::::::@@@@
	 @@@@@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@;;;;@@@@@@@@@        ;;;;;:::::::::@@@@
	 @@@@@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@;;;;@@@@@@@@@        ;;;;;:::::::::@@@@
	 @@@@@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@;;;;@@@@@@@@@        ;;;;;:::::::::@@@@
	 @@@@@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@;;;;@@@@@@@@@        ;;;;;:::::::::@@@@
	 @@@@@;;;;::::@@@@@::::@@@@.....    @@@@@@@@@    ....;;;;;;;;;:::::@@@@
	 @@@@@;;;;::::@@@@@::::@@@@.....    @@@@@@@@@    ....;;;;;;;;;:::::@@@@
	 @@@@@;;;;::::@@@@@::::@@@@.....    @@@@@@@@@    ....;;;;;;;;;:::::@@@@
	 @@@@@;;;;::::@@@@@::::@@@@.....    @@@@@@@@@    ....;;;;;;;;;:::::@@@@
	 @@@@:::::::::@@@@;;;;;;;;;....         ....;;;;;;;;;@@@@@@@@@
	 @@@@:::::::::@@@@;;;;;;;;;....         ....;;;;;;;;;@@@@@@@@@
	 @@@@:::::::::@@@@;;;;;;;;;....         ....;;;;;;;;;@@@@@@@@@
	 @@@@:::::::::@@@@;;;;;;;;;....         ....;;;;;;;;;@@@@@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@@@@@@@@@@
	 @@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@@@@@@@@@@
	 @@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@@@@@@@@@@
	 @@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@@@@@@@@@@
	 @@@@@;;;;@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@;;;;;@@@@@@@@@@@@@@@@@
	 @@@@@;;;;@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@;;;;;@@@@@@@@@@@@@@@@@
	 @@@@@;;;;@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@;;;;;@@@@@@@@@@@@@@@@@
	 @@@@@;;;;@@@@;;;;;;;;;;;;;@@@@@@@@@@@@@;;;;;@@@@@@@@@@@@@@@@@
	 @@@@@;;;;@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;;;;;:::::::::@@@@@@@@@;;;;;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;;;;;:::::::::@@@@@@@@@;;;;;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;;;;;:::::::::@@@@@@@@@;;;;;;;;@@@@@:::::::::@@@@@@@@
	 @@@@@;;;;;;;;:::::::::@@@@@@@@@;;;;;;;;@@@@@:::::::::@@@@@@@@
	 @@@@;;;;:::::::::;;;;;;;;;;;;;@@@@::::::::::::::@@@@
	 @@@@;;;;:::::::::;;;;;;;;;;;;;@@@@::::::::::::::@@@@
	 @@@@;;;;:::::::::;;;;;;;;;;;;;@@@@::::::::::::::@@@@
	 @@@@;;;;:::::::::;;;;;;;;;;;;;@@@@::::::::::::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@;;;;;;;;;:::::@@@@
	 @@@@@@@@@@@@@;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;@@@@@
	 @@@@@@@@@@@@@;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@
	 @@@@;;;;;;;;;@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@
	 @@@@;;;;;;;;;@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@
	 @@@@;;;;;;;;;@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@
	 @@@@;;;;;;;;;@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@;;;;@@@@
	 @@@@::::;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;@@@@@@@@@:::::::::@@@@
	 @@@@::::;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;@@@@@@@@@:::::::::@@@@
	 @@@@::::;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;@@@@@@@@@:::::::::@@@@
	 @@@@::::;;;;;;;;;@@@@@@@@@@@@@;;;;;;;;;;;;;;;;;@@@@@@@@@:::::::::@@@@
	 @@@@@@@@@:::::::::::::::::@@@@         @@@@;;;;;;;;;@@@@@@@@@:::::::::::::@@@@
	 @@@@@@@@@:::::::::::::::::@@@@         @@@@;;;;;;;;;@@@@@@@@@:::::::::::::@@@@
	 @@@@@@@@@:::::::::::::::::@@@@         @@@@;;;;;;;;;@@@@@@@@@:::::::::::::@@@@
	 @@@@@@@@@:::::::::::::::::@@@@         @@@@;;;;;;;;;@@@@@@@@@:::::::::::::@@@@
	 @@@@@@@@@:::::::::::::::::@@@@         @@@@;;;;;;;;;@@@@@@@@@:::::::::::::@@@@
	 @@@@::::::::::::::::::::::@@@@                 @@@@@@@@@    @@@@@:::::::::::::::::@@@@@@@@@
	 @@@@::::::::::::::::::::::@@@@                 @@@@@@@@@    @@@@@:::::::::::::::::@@@@@@@@@
	 @@@@::::::::::::::::::::::@@@@                 @@@@@@@@@    @@@@@:::::::::::::::::@@@@@@@@@
	 @@@@::::::::::::::::::::::@@@@                 @@@@@@@@@    @@@@@:::::::::::::::::@@@@@@@@@
	 @@@@@::::::::::::::::::::::::::::::@@@@                      @@@@:::::::::::::::::::::::::::::::@@@@
	 @@@@@::::::::::::::::::::::::::::::@@@@                      @@@@:::::::::::::::::::::::::::::::@@@@
	 @@@@@::::::::::::::::::::::::::::::@@@@                      @@@@:::::::::::::::::::::::::::::::@@@@
	 @@@@@::::::::::::::::::::::::::::::@@@@                      @@@@:::::::::::::::::::::::::::::::@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	 * Rather than wasting time checking to see if we need a key or not,
	 * KeyMan logs all possible button presess. All you need is the keycode
	 * for the key you want and KeyMan can tell you whether that key is up or down.
	 *
	 * KeyMan can also map several keys to one of 10 actions.
	 */
	public class KeyMan {

		private static const SMALLEST_KEYCODE:uint = 8;
		private static const LARGEST_KEYCODE:uint = 222;
		private static const ARRAY_SIZE:uint = LARGEST_KEYCODE - SMALLEST_KEYCODE + 1;

		//we don't use zero, because that's the default value in the array
		public static const LEFT:uint = 1;
		public static const RIGHT:uint = 2;
		public static const UP:uint = 3;
		public static const DOWN:uint = 4;
		public static const JUMP:uint = 5;
		public static const PAUSE:uint = 6;
		public static const QUIT:uint = 7;
		public static const RESTART:uint = 8;
		//if you add another action, remember to increment ACTIONS_NUM!!

		private static const ACTIONS_NUM:uint = 8;
		private static const KEY_UP:uint = 0; //because it's the default value
		private static const KEY_DOWN:uint = ACTIONS_NUM + 1;
		private static const KEY_HOLD_DOWN:uint = ACTIONS_NUM + 2;

		/**
		 * An array of a little over 200 elements, keeping track of all possible keypresses.
		 * If a key's value is less than ACTIONS_NUM and greater than zero, that means that it's
		 * pointing to a slot in the actions array, so every time the key does something, the
		 * changes go to the actions array instead.
		 */
		private var keys:Array = new Array(ARRAY_SIZE);
		/**
		 * Because we check these actions on every frame, it's more efficient to have this actions array
		 * and have the keys array update it than it is to have separate arrays for each action and have
		 * to look up each key on every frame.
		 */
		private var actions:Array = new Array(ACTIONS_NUM);
		private var theStage:Stage;
		private var level:Level;


		/**
		 * To use KeyMan, you must activate() him.
		 *
		 * @param xml:XMLList the XMLList for <keys>...</keys>
		 */
		public function KeyMan(lvl:Level, xml:XMLList) {
			theStage = Aeon.instance.stage;
			level = lvl;

			var esc:uint = 27;
			keys[esc - SMALLEST_KEYCODE] = PAUSE;

			include "DefaultKeys.as";
			parseXML(dKeys);
			parseXML(xml);
		}


		private function parseXML(xml:XMLList):void {
			for each (var node:XML in xml.elements()) {
				var action:uint;
				var key:uint;
				action = uint(node.toString());
				key = uint(node.@key);
				if (key == 27) {
					level.addError("The Esc key is reserved. You cannot map an action to it.");
				} else if (key < SMALLEST_KEYCODE || key > LARGEST_KEYCODE) {
					level.addError("Key id " + key + " is not a valid KeyCode.");
				} else if (action <= 0 || action > ACTIONS_NUM) {
					level.addError("Key Action id " + action + " is not a valid KeyAction.");
				} else {
					keys[key - SMALLEST_KEYCODE] = action;
				}
			}
		}


		/**
		 * Starts listening to keybaord events.
		 */
		public function activate():void {
			theStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			theStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}


		/**
		 * Removes event listeners. KeyMan won't work until you activate() him again.
		 */
		public function deactivate():void {
			theStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			theStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}


		private function onKeyDown(evt:KeyboardEvent):void {
			var pos:uint = evt.keyCode - SMALLEST_KEYCODE;
			var point:uint = keys[pos];
			if (point <= ACTIONS_NUM && point > 0) {
				point--;
				if (actions[point] == KEY_DOWN || actions[point] == KEY_HOLD_DOWN){
					actions[point] = KEY_HOLD_DOWN;
				}else{
					actions[point] = KEY_DOWN;
				}
			} else {
				if (keys[pos] == KEY_DOWN || keys[pos] == KEY_HOLD_DOWN){
					keys[pos] = KEY_HOLD_DOWN;
				}else{
					keys[pos] = KEY_DOWN;
				}
			}
		}


		private function onKeyUp(evt:KeyboardEvent):void {
			var pos:uint = evt.keyCode - SMALLEST_KEYCODE;
			var point:uint = keys[pos];
			if (point <= ACTIONS_NUM && point > 0) {
				point--;
				actions[point] = KEY_UP;
			} else {
				keys[pos] = KEY_UP;
			}
		}


		/**
		 * Returns true if the action (representing a group of keys) is down.
		 *
		 * @param actionCode See this class's public static constants for the action codes.
		 * @param strict Will only return true if the key has only recently been pressed down,
		 * but returns false if the key has been held down for multiple frames.
		 */
		public function isActionDown(actionCode:uint, isStrict:Boolean = false):Boolean {
			actionCode--;
			if (isStrict)
				return (actions[actionCode] == KEY_DOWN);
			else
				return (actions[actionCode] == KEY_DOWN || actions[actionCode] == KEY_HOLD_DOWN);
		}


		/**
		 * Returns true if the action (representing a group of keys) is up.
		 *
		 * @param actionCode See this class's public static constants for the action codes.
		 */
		public function isActionUp(actionCode:uint):Boolean {
			actionCode--;
			return (actions[actionCode] == KEY_UP);
		}


		/**
		 * Returns true if the requested keycode is being pressed.
		 *
		 * @param keyCode The code Flash uses to represent the keyboard key.
		 *
		 * @param strict Will only return true if the key has only recently been pressed down,
		 * but returns false if the key has been held down for multiple frames.
		 */
		public function isKeyDown(keyCode:uint, isStrict:Boolean):Boolean {
			var pos:uint = keyCode - SMALLEST_KEYCODE;
			var point:uint = keys[pos];
			if (point < ACTIONS_NUM && point > 0)
				return isActionDown(point, isStrict);
			else if (isStrict)
				return (keys[pos] == KEY_DOWN);
			else
				return (keys[pos] == KEY_DOWN || keys[pos] == KEY_HOLD_DOWN);

		}


		/**
		 * Returns true if the requested keycode is NOT being pressed.
		 *
		 * @param keyCode The code Flash uses to represent the keyboard key.
		 */
		public function isKeyUp(keyCode:uint):Boolean {
			var pos:uint = keyCode - SMALLEST_KEYCODE;
			var point:uint = keys[pos];
			if (point < ACTIONS_NUM && point > 0)
				return isActionUp(point);
			else
				return (keys[pos] == KEY_UP);
		}
	}
}
