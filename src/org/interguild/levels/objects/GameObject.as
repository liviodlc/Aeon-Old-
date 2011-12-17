package org.interguild.levels.objects {
	import flash.display.Sprite;
	import utils.LinkedList;
	import org.interguild.levels.collisions.GridElement;

	/**
	 * GameObject represents any object in the games, such as tiles, players, enemies, etc.
	 */
	public class GameObject extends Sprite {
		
		private var gridOccupied:LinkedList;
		
		public function GameObject() {
			super();
			
			gridOccupied = new LinkedList();
			
		}
		
		public function addOccupied( element:GridElement ) {
			
			
			
		}
	}
}
