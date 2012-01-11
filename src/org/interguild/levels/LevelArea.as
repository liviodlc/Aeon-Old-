package org.interguild.levels {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import org.interguild.levels.objects.Behavior;
	import org.interguild.levels.objects.CollisionGrid;
	import org.interguild.levels.objects.GameObject;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;
	import org.interguild.utils.LinkedList;

	internal class LevelArea extends Sprite {

		private var levelState:PseudoClassTriggers;

		private var grid:CollisionGrid;
		internal var behaviors:Object;
		private var camera:LevelCamera;
		private var player:GameObject;

		/* we may want to reconsider the choice of data structures here.
		 * I only picked Arrays for the first two because I knew we'd be
		 * adding and deleting stuff a lot, but that doesn't mean it's a
		 * good idea. destroyedObjs is good as a LinkedList as we'll only
		 * be adding stuff to it and iterating through all of it.
		 */
		private var staticObjs:Array;
		private var nonstaticObjs:Array;
		private var destroyedObjs:LinkedList;
		private var stateChanged:LinkedList;

		private var checkpoints:LinkedList;


		public function LevelArea(width:uint, height:uint, lvlstate:PseudoClassTriggers) {
			levelState = lvlstate;
			grid = new CollisionGrid(width, height);
			staticObjs = [];
			nonstaticObjs = [];
			stateChanged = new LinkedList();
			destroyedObjs = new LinkedList();
			checkpoints = new LinkedList();
		}


//		/**
//		 * A debugging function that will spit out the dimensions of the collision grid
//		 */
//		private function traceGridSize():void {
//			var height:uint = gridArray.length;
//			for (var i:uint = 0; i < height; i++) {
//				var width:uint = gridArray[i].length;
//				var print:String = "";
//				for (var j:uint = 0; j < width; j++) {
//					print += "x";
//				}
//				trace(print + "	width:	" + width);
//			}
//			trace("height:	" + height);
//		}


		public function get levelWidth():uint {
			return grid.width * 32;
		}



		public function get levelHeight():uint {
			return grid.height * 32;
		}


		public function setCamera(c:LevelCamera):void {
			camera = c;
		}


		/**
		 * Adds the GameObject to the LevelArea, and calculates the grid elements
		 * that it intersects with.
		 */
		public function add(obj:GameObject):void {
			staticObjs.push(obj);
			grid.add(obj);
			addChild(obj);
		}


		/**
		 * Called by Level.onGameLoop()
		 */
		public function onGameLoop():void {
			if (levelState.hasChanged(true)) {
				if (levelState.getPreview()) {
					// camera zoom fit
					updateAllStylesAndViews();
//					updateViews();
				} else if (!levelState.getEnding()) {
					// transition from preview to playing
					trace("LEVEL START");
					updateAllStylesAndViews();
				}
			} else if (!levelState.getPreview() && !levelState.getEnding()) {

				// play level!
//				trace("--LOOP--");

				grid.clearDynamicObjects(nonstaticObjs);
				updateModels();
				grid.detectCollisions(nonstaticObjs);
				updateBehaviors();
				updateStylesAndViews(); // TODO mark animated objects as TO_UPDATE
				updateStates();
			}
			updateCamera();
		}


		/**
		 * Depending on how long it takes to reset everything, we may want
		 * to stop the game loop and give things a chance to load.
		 *
		 * In any case, this function will first change the state of the
		 * level to preview and begin resetting all the tiles to their
		 * last checkpoint state.
		 */
		public function restart():void {
			var o:GameObject;
			for each (o in staticObjs) {
				o.restart();
				if (!o.isStatic)
					stateChanged.add(o);
			}
			for each (o in nonstaticObjs) {
				o.restart();
				if (o.isStatic)
					stateChanged.add(o);
			}
			updateStates(true);

			checkpoints.beginIteration();
			var check:Object = checkpoints.next;
			for (var key:String in check) {
				switch (key) {
					case "levelState":
						levelState.normalTriggers = check["levelState"];
						break;
					case "TO_UPDATE": // LinkedList
						GameObject.TO_UPDATE = (check["TO_UPDATE"] as LinkedList).clone();
						break;
					default:
						this[key] = check[key];
						break;
				}
			}

			levelState.setPreview();
			levelState.setEnding(false); // make sure we're not on win screen

			// TODO go through destroyedObjs:LinkedList;
			dispatchEvent(new Event(Event.COMPLETE));
		}


		/**
		 * Creates a new checkpoint
		 */
		private function checkpoint():void {
			var check:Object = new Object();
			check["levelState"] = levelState.normalTriggers;
			check["TO_UPDATE"] = GameObject.TO_UPDATE.clone();
			checkpoints.add(check);

			var o:GameObject;
			for each (o in staticObjs) {
				o.checkpoint();
			}
			for each (o in nonstaticObjs) {
				o.checkpoint();
			}
		}


		public function updateBehaviors():void {
			for each (var b:Behavior in behaviors) {
				b.onGameLoop();
			}
		}


		/**
		 * This function goes through all non-static objects and updates their
		 * positions, speed, hitbox locations, etc.
		 */
		private function updateModels():void {
			var o:GameObject;
			for each (o in nonstaticObjs) {
				o.updateModel();
				grid.add(o);
				o.clearStandings();
				o.clearStandingList();
			}
		}


		/**
		 * Initializes the styles of all of the GameObjects that have been added
		 * to the LevelArea so far.
		 */
		public function initStyles():void {
			var n:uint = staticObjs.length;
			for (var i:uint = 0; i < n; i++) {
				var o:GameObject = staticObjs[i];
				var b:Rectangle = o.hitbox;
				o.updateStyles(true)
				if (!o.isStatic) {
					stateChanged.add(o);
				} else if (!b.equals(o.hitbox)) {
					o.clearGrids();
					grid.add(o);
				}
				o.checkpoint();
				if (o.isPlayer)
					player = o;
			}
			updateStates();
			checkpoint();
		}


		/**
		 * Updates the styles of all GameObjects.
		 */
		private function updateAllStylesAndViews():void {

			updateNonstaticStylesAndViews();

			var o:GameObject;
			for each (o in staticObjs) {
				updateStaticStylesAndViews(o);
			}
		}


		private function updateStylesAndViews():void {

			updateNonstaticStylesAndViews();

			//update static objects:
			var list:LinkedList = GameObject.TO_UPDATE;
			if (list.isEmpty())
				return;
			list.beginIteration();
			var o:GameObject;
			while (list.hasNext()) {
				o = list.next as GameObject;
				updateStaticStylesAndViews(o);
			}
			list.clear();
		}


		private function updateNonstaticStylesAndViews():void {
			var o:GameObject;
			for each (o in nonstaticObjs) {
				o.updateStyles();
				if (o.isStatic)
					stateChanged.add(o);
				o.updateView();
				updateZIndex(o);
			}
		}


		private function updateStaticStylesAndViews(o:GameObject):void {
			var h:Rectangle = o.hitbox;
			o.updateStyles();
			if (!o.isStatic)
				stateChanged.add(o);
			else if (!h.equals(o.hitbox)) {
				o.clearGrids();
				grid.add(o);
			}
			o.updateView();
			updateZIndex(o);
		}


		private function updateZIndex(o:GameObject):void {
			if (o.zIndex == "front") {
				addChildAt(o, numChildren - 1);
				o.zIndex = "";
			} else if (o.zIndex == "back") {
				addChildAt(o, 0);
				o.zIndex = "";
			}
		}


		/**
		 * The stateChanged LinkedList contains uints where the LSB stores
		 * the current state of the GameObject (static or nonstatic), and
		 * the rest of the bits store the index in the array in wich it is
		 * stored.
		 */
		private function updateStates(restarting:Boolean = false):void {
			stateChanged.beginIteration();
			while (stateChanged.hasNext()) {
				var o:GameObject = stateChanged.next as GameObject;
				var i:int;
				if (!o.isStatic) { // staticObjs to nonstaticObjs
					i = staticObjs.indexOf(o);
					if (i != -1) {
						staticObjs.splice(i, 1);
						nonstaticObjs.push(o);
						o.switchGridStates();
					}
				} else { //nonstaticObjs to staticObjs
					i = nonstaticObjs.indexOf(o);
					if (i != -1) {
						nonstaticObjs.splice(i, 1);
						staticObjs.push(o);
						if (!restarting) {
							o.resetSpeed();
							o.clearGrids();
							grid.add(o);
						}
					}
				}
				if (restarting) {
					o.clearGrids();
					grid.add(o);
				}
			}
			stateChanged.clear();
		}


//		/**
//		 * Goes through all non-destroyed objects in the LevelArea and tells them
//		 * to animate.
//		 */
//		private function updateViews():void {
//			var n:uint = nonstaticObjs.length;
//			var i:uint, o:GameObject;
//			for (i = 0; i < n; i++) {
//				o = GameObject(nonstaticObjs[i]);
//				if (o.isStatic) {
//					stateChanged.add(o);
//				}
//				o.updateView();
//			}
//			n = staticObjs.length;
//			for (i = 0; i < n; i++) {
//				o = GameObject(staticObjs[i]);
//				if (!o.isStatic) {
//					stateChanged.add(o);
//				}
//				o.updateView();
//			}
//		}


		private function updateCamera():void {
			if (player != null) {
				var hitbox:Rectangle = player.hitbox;
				var focusX:Number = hitbox.x + hitbox.width / 2;
				var focusY:Number = hitbox.y + hitbox.height / 2;
				camera.onGameLoop(focusX, focusY);
			}
		}
	}
}
