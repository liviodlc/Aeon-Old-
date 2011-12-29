package org.interguild.levels.collisions {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.interguild.levels.objects.GameObject;

	public class CollisionGrid {

		private static var GRID_SIZE:uint = 32;

		private var grid:Array;

		private var _width:uint;
		private var _height:uint;

		private var wrapAround:Boolean;


		/**
		 * Constructor with arguments of the width
		 * and height of the level. With this information
		 * creates an empty 2D array of height and width
		 * to store all grid elements.
		 *
		 */
		public function CollisionGrid(w:uint, h:uint) {
			_width = w;
			_height = h;

			grid = new Array(h);
			for (var i:uint = 0; i < h; i++) {
				grid[i] = new Array(w);
			}
		}


		public function get width():uint {
			return _width;
		}


		public function set width(w:uint):void {
			if (w == 0)
				w = 1;
			if (w > _width) {
				// add to width
				var diff:uint = w - _width;
				for (var i:uint = 0; i < _height; i++) {
					for (var j:uint = 0; j < diff; j++) {
						grid[i].push([0]);
					}
				}
			} else if (w < _width) {
				// remove from width
				for (var k:uint = 0; k < _height; k++) {
					grid[k].splice(w);
				}
			}
			_width = w;
		}


		public function get height():uint {
			return _height;
		}


		public function set height(h:uint):void {
			if (h == 0)
				h = 1;
			if (h > _height) {
				// add to height
				for (var i:uint = _height; i < h; i++) {
					grid.push([[0]]);
					for (var j:uint = 1; j < _width; j++) {
						grid[i].push([0]);
					}
				}
			} else if (h < _height) {
				// remove from height
				grid.splice(h);
			}
			_height = h;
		}


		/*
		Collision detection algorithm
			1. GridElements track all objects that are within their borders. They
				maintain two lists: one for dynamic objects, and one for static.
				The dynamic list is cleared at the beginning of every loop, and
				elements are repopulated based on where dynamic objects move.
			2. Go through all elements that have had a dynamic object added to them
				this iteration, and test for collisions in each grid. To make sure
				we aren't resolving a collision more than once, check that the
				collision still exists.
			3. Now we need to make sure that collisions with multiple objects don't
				interfere with each other. A player should be able to walk on a line
				of tiles without being misunderstood to be hitting invisible walls.
		*/

		/**
		 * Considers the object's collision bounds and adds it to the grids that it's in,
		 * plus the layer of surrounding grids.
		 */
		public function add(obj:GameObject):void {
			var rect:Rectangle = obj.hitbox;

			var right:int = rect.right / GRID_SIZE + 1;
			var bottom:int = rect.bottom / GRID_SIZE + 1;
			for (var top:int = rect.top / GRID_SIZE - 1; top <= bottom; top++)
				if (top >= 0 && top < _height)
					for (var left:int = rect.left / GRID_SIZE - 1; left <= right; left++)
						if (left >= 0 && left < _width)
							if (obj.isStatic)
								GridElement(grid[top][left]).addStatic(obj);
							else
								GridElement(grid[top][left]).addDynamic(obj);
		}
	}
}
