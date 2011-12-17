package org.interguild.levels.collisions {
	
	public class CollisionGrid {
		
		private var grid:Array;
		
		private var width:uint;
		private var height:uint;
		
		private var wrapAround:Boolean;
		
		/**
		 * Constructor with arguments of the width
		 * and height of the level. With this information
		 * creates an empty 2D array of height and width
		 * to store all grid elements.
		 * 
		 */
		public function CollisionGrid( w:uint, h:uint ) {
			
			width = w;
			height = h;
			
			grid = new Array( height );
			
			for( var i:uint = 0; i < height; i++ ) {
				
				grid[i] = new Array( width );
				
			}
			
		}
	}
}