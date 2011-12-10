package org.interguild.levels.collisions {
	import flash.display.Sprite;
	
	public class CollisionGrid {
		
		private var wrapAround:Boolean;
		
		private var width:uint;
		private var height:uint;
		
		private var squares:Array;
		
		/**
		 *  Constructor takes in map width and height in tiles
		 */
		public function CollisionGrid(w:uint, h:uint) {
			height = h;
			width = w;
			
			var row:uint;
			var col:uint;
			
			squares = new Array(height);
			
			for(row = 0; row < height; row++) {
				
				squares[row] = new Array(width);
				
				for(col = 0; col < width; col++) {
					
					squares[row][col] = new GridElement();
					
				}
				
			}
			
		}
		
		public function getGridElement(row:uint, col:uint):GridElement {
			
			return squares[row][col];
			
		}
		
		public function removeFromSquares( citizen:GameObject ):void {
			
			// TODO:
			
		}
		
		public function addToSquares( citizen:GameObject ):void {
			
			// TODO:
			
		}
		
	}
	
}
