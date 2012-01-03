package org.interguild.levels.objects.collisions {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.interguild.levels.objects.GameObject;
	import org.interguild.utils.LinkedList;
	import org.interguild.utils.OrderedList;

	public class CollisionGrid {

		private static var GRID_SIZE:uint = 32;

		private var grid:Array;

		private var _width:uint;
		private var _height:uint;

		private var wrapAround:Boolean; // TODO implement feature


		/**
		 * Constructor with arguments of the width
		 * and height of the level. With this information
		 * creates an empty 2D array of height and width
		 * to store all grid elements.
		 */
		public function CollisionGrid(w:uint, h:uint) {
			_width = 1;
			_height = 1;
			grid = [[new GridElement()]]; //grid of size 1x1
			height = h;
			width = w;
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
						grid[i].push(new GridElement());
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
					grid.push([new GridElement()]); //default width of 1
					for (var j:uint = 1; j < _width; j++) {
						grid[i].push(new GridElement());
					}
				}
			} else if (h < _height) {
				// remove from height
				grid.splice(h);
			}
			_height = h;
		}




		/**
		 * Considers the object's collision bounds and adds it to the grids that it's in,
		 * plus the layer of surrounding grids.
		 */
		public function add(obj:GameObject):void {
			if (!obj.isCollideable)
				return;

			var rect:Rectangle = obj.hitbox;

			var right:int = rect.right / GRID_SIZE;
			var bottom:int = rect.bottom / GRID_SIZE;
			var top:int = rect.top / GRID_SIZE;
			var left:int = rect.left / GRID_SIZE;
			if (!obj.isStatic) {
				right++;
				bottom++;
				top--;
				left--;
			}
			for (; top <= bottom; top++) {
				if (top >= 0 && top < _height) {
					for (var col:int = left; col <= right; col++) {
						if (col >= 0 && col < _width) {
							var el:GridElement = grid[top][col];
							obj.addGrid(el);
							if (obj.isStatic) {
								el.addStatic(obj);
							} else {
								el.addDynamic(obj);
							}
						}
					}
				}
			}
		}


		/**
		 * Goes through all dynamic objects, seeing the grids they're in, and clearing
		 * these grids' list of dynamic objects.
		 *
		 * @param a:Array an arry of all the dynamic objects to iterate through.
		 */
		public function clearDynamicObjects(a:Array):void {
			/*
			 * It's likely that we'll clear a single grid tile multiple times, but as
			 * long as the number of dynamic objects in a level isn't very high, it's
			 * more efficient than iterating through every grid tile.
			 *
			 * Perhaps we could optimize this by using a different algorithm when the
			 * number of dynamic objects is greater than a certain amount depending on
			 * the level size.
			 */
			for each (var o:GameObject in a) {
				var list:LinkedList = o.listGrids;
				list.beginIteration();
				while (list.hasNext()) {
					GridElement(list.next).clearDynamic();
				}
				o.clearGrids();
			}
		}


		/**
		 * @param a:Array an arry of all the dynamic objects to iterate through.
		 */
		public function detectCollisions(a:Array):void {
			var objs:OrderedList = new OrderedList();

			//scan for collisions
			for each (var o:GameObject in a) {
				if (o.isCollideable) {
					var list:LinkedList = o.listGrids;
					list.beginIteration();
					while (list.hasNext()) {
						GridElement(list.next).detectCollisions(o);
					}
					objs.add(o);
				}
			}

			//resolve collisions
			var n:uint = objs.length;
			for (var i:uint = 0; i < n; i++) {
				GameObject(objs.get(i)).resolveCollisions();
			}
		}
	}
}
