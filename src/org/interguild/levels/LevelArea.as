package org.interguild.levels {
	import flash.display.Sprite;

	import org.interguild.levels.objects.GameObject;
	import org.interguild.levels.objects.collisions.CollisionGrid;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;
	import org.interguild.utils.LinkedList;

	internal class LevelArea extends Sprite {

		private var levelState:PseudoClassTriggers;

		private var grid:CollisionGrid;

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


		public function LevelArea(width:uint, height:uint, lvlstate:PseudoClassTriggers) {
			levelState = lvlstate;
			grid = new CollisionGrid(width, height);
			staticObjs = [];
			nonstaticObjs = [];
			stateChanged = new LinkedList();
			destroyedObjs = new LinkedList();
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
			return grid.width;
		}


		/**
		 * Will add or remove space in the level to make it match the given width.
		 *
		 * @param w The number of tiles wide you want the level to be.
		 *
		 */
		public function set levelWidth(w:uint):void {
			grid.width = w;
		}


		public function get levelHeight():uint {
			return grid.height;
		}


		/**
		 * Will add or remove space in the level to make it match the given height.
		 *
		 * NOTE: It's more efficient to change the levelHeight BEFORE changing the levelWidth!
		 *
		 * @param h The number of tiles tall you want the level to be.
		 *
		 */
		public function set levelHeight(h:uint):void {
			grid.height = h;
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
			if (levelState.hasChanged()) {
				if (levelState.getPreview()) {
					// camera zoom fit
					updateViews();
				} else if (!levelState.getEnding()) {
					// transition from preview to playing
				}
			} else if (!levelState.getPreview() && !levelState.getEnding()) {

				// play level!
//				trace("--LOOP--");

				grid.clearDynamicObjects(nonstaticObjs);

				// TODO next step would be to update all Behaviors

				updateModels();

				// TODO now we do collision detection
				grid.detectCollisions(nonstaticObjs);
				/* the UML says to update styles as we go along, but it would probably be a much
				 * better idea if we kept a list of all the objects that have had collisions
				 * and then update their styles later. This will avoid the problem of when tiles
				 * collide with multiple objects at once.
				 */

				updateViews();
				updateStates();
			}
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
			levelState.setPreview();
			levelState.setEnding(false); // make sure we're not on win screen
		}


		/**
		 * This function goes through all non-static objects and updates their
		 * positions, speed, hitbox locations, etc.
		 */
		private function updateModels():void {
			for each (var o:GameObject in nonstaticObjs) {
				o.updateModel();
				grid.add(o);
			}
		}


		/**
		 * Initializes the styles of all of the GameObjects that have been added
		 * to the LevelArea so far.
		 */
		public function initStyles():void {
			var n:uint = staticObjs.length;
			for (var i:uint = 0; i < n; i++) {
				var p:GameObject = staticObjs[i];
				if (p.updateStyles(true)) {
					stateChanged.add(i << 1); //LSB = 0, for staticObjs array
				}
			}
			updateStates();
		}


		/**
		 * The stateChanged LinkedList contains uints where the LSB stores
		 * the current state of the GameObject (static or nonstatic), and
		 * the rest of the bits store the index in the array in wich it is
		 * stored.
		 */
		private function updateStates():void {
			stateChanged.beginIteration();
			while (stateChanged.hasNext()) {
				var i:uint = uint(stateChanged.next);
				var o:GameObject;
				if ((i & 0x1) == 0x0) { // staticObjs to nonstaticObjs
					i = i >> 0x1;
					o = GameObject(staticObjs[i]);
					nonstaticObjs.push(o);
					staticObjs.splice(i, 1);
					o.switchGridStates();
				} else { //nonstaticObjs to staticObjs
					i = i >> 0x1;
					o = GameObject(nonstaticObjs[i]);
					staticObjs.push(o);
					nonstaticObjs.splice(i, 1);
					o.switchGridStates();
				}
			}
			stateChanged.clear();
		}


		/**
		 * Goes through all non-destroyed objects in the LevelArea and tells them
		 * to animate.
		 */
		private function updateViews():void {
			var n:uint = nonstaticObjs.length;
			var i:uint, o:GameObject;
			for (i = 0; i < n; i++) {
				o = GameObject(nonstaticObjs[i]);
				if (o.isStatic) {
					stateChanged.add((i << 2) | 1);
				}
				o.updateView();
			}
			n = staticObjs.length;
			for (i = 0; i < n; i++) {
				o = GameObject(staticObjs[i]);
				if (!o.isStatic) {
					stateChanged.add(i << 2);
				}
				o.updateView();
			}
		}
	}
}
