package org.interguild.levels {
	import flash.display.Sprite;

	import org.interguild.levels.collisions.CollisionGrid;
	import org.interguild.levels.objects.GameObject;
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


		public function LevelArea(width:uint, height:uint, lvlstate:PseudoClassTriggers) {
			levelState = lvlstate;
			grid = new CollisionGrid(width, height);
			staticObjs = [];
			nonstaticObjs = [];
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
			if (obj.isStatic)
				staticObjs.push(obj);
			else
				nonstaticObjs.push(obj);
			grid.add(obj);
			addChild(obj);
		}


		/**
		 * Initializes the styles of all of the GameObjects that have been added
		 * to the LevelArea so far.
		 */
		public function initStyles():void {
			for each (var o:GameObject in nonstaticObjs) {
				o.updateStyles(levelState, true);
			}
			for each (var p:GameObject in staticObjs) {
				o.updateStyles(levelState, true);
			}
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

				// TODO according to UML, we must clear dynamic objects from collision grid

				// TODO next step would be to update all Behaviors

				updateModels();

				// TODO now we do collision detection
				/* the UML says to update styles as we go along, but it would probably be a much
				 * better idea if we kept a list of all the objects that have had collisions
				 * and then update their styles later. This will avoid the problem of when tiles
				 * collide with multiple objects at once.
				 */

				updateViews();
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
			}
		}


		/**
		 * Goes through all non-destroyed objects in the LevelArea and tells them
		 * to animate.
		 */
		private function updateViews():void {
			for each (var o:GameObject in nonstaticObjs) {
				o.updateView();
			}
			for each (var p:GameObject in staticObjs) {
				p.updateView();
			}
		}
	}
}
