package org.interguild.levels {
	import flash.display.Sprite;

	import org.interguild.levels.objects.GameObject;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;

	import org.interguild.utils.LinkedList;

	internal class LevelArea extends Sprite {

		/**
		 * For the grid used in collision detection
		 */
		private static var GRID_SIZE:uint = 32;

		private var levelState:PseudoClassTriggers;

		private var gridArray:Array;

		/* we may want to reconsider the choice of data structures here.
		 * I only picked Arrays for the first two because I knew we'd be
		 * adding and deleting stuff a lot, but that doesn't mean it's a
		 * good idea. destroyedObjs is good as a LinkedList as we'll only
		 * be adding stuff to it and iterating through all of it.
		 */
		private var staticObjs:Array;
		private var nonstaticObjs:Array;
		private var destroyedObjs:LinkedList;

		private var _levelWidth:uint;
		private var _levelHeight:uint;


		public function LevelArea(width:uint, height:uint, lvlstate:PseudoClassTriggers) {
			levelState = lvlstate;
			initLevelGrid();
			levelWidth = width;
			levelHeight = height;
		}


		/**
		 * Initializes the level space and the collision detection grid. This must be called before
		 * trying to set the level width or height.
		 *
		 * HOW THIS GRID WORKS
		 * We have a two-dimensional array, with rows representing the first dimension (array[1])
		 * and columns in the second dimension (array[0][1]). In each of these slots, we have another
		 * array holding references to all of the tiles that intersect that specific grid element.
		 */
		public function initLevelGrid():void {
			gridArray = [[[0]]];
			staticObjs = [];
			nonstaticObjs = [];
			_levelWidth = 1;
			_levelHeight = 1;
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
			return _levelWidth;
		}


		/**
		 * Will add or remove space in the level to make it match the given width.
		 *
		 * @param w The number of tiles wide you want the level to be.
		 *
		 */
		public function set levelWidth(w:uint):void {
			if (w == 0)
				w = 1;
			if (w > _levelWidth) {
				// add to width
				var diff:uint = w - _levelWidth;
				for (var i:uint = 0; i < _levelHeight; i++) {
					for (var j:uint = 0; j < diff; j++) {
						gridArray[i].push([0]);
					}
				}
			} else if (w < _levelWidth) {
				// remove from width
				for (var k:uint = 0; k < _levelHeight; k++) {
					gridArray[k].splice(w);
				}
			}
			_levelWidth = w;
		}


		public function get levelHeight():uint {
			return _levelHeight;
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
			if (h == 0)
				h = 1;
			if (h > _levelHeight) {
				// add to height
				for (var i:uint = _levelHeight; i < h; i++) {
					gridArray.push([[0]]);
					for (var j:uint = 1; j < _levelWidth; j++) {
						gridArray[i].push([0]);
					}
				}
			} else if (h < _levelHeight) {
				// remove from height
				gridArray.splice(h);
			}
			_levelHeight = h;
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

			addChild(obj);
			//TODO collision grid testing
		}
		
		
		/**
		 * Initializes the styles of all of the GameObjects that have been added
		 * to the LevelArea so far.
		 */
		public function initStyles():void{
			for each (var o:GameObject in nonstaticObjs) {
				o.updateStyles(levelState,true);
			}
			for each (var p:GameObject in staticObjs) {
				o.updateStyles(levelState,true);
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
