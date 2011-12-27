package org.interguild.levels.collisions {
	import org.interguild.levels.objects.GameObject;
	
	import org.interguild.utils.LinkedList;
	
	public class GridElement {
		
		private var staticObjects:LinkedList;
		private var dynamicObjects:LinkedList;
		
		/**
		 * No-arg constructor for GridElement. Sets static and dynamic
		 * lists to empty.
		 */
		public function GridElement() {
			
			staticObjects = new LinkedList();
			dynamicObjects = new LinkedList();
			
		}
		
		/**
		 * Add object to the dynamic list.
		 */
		public function addDynamic( dynamic:GameObject ) {
			
			dynamicObjects.add( dynamic );
			
		}
		
		/**
		 * Clear all elements from dynamic list.
		 */
		public function clearDynamic():void {
			
			dynamicObjects.clear();
			
		}
		
		/**
		 * Add object to static list.
		 */
		public function addStatic( static:GameObject ):void {
			
			staticObjects.add( static );
			
		}
		
		/**
		 * Remove object from static list.
		 */
		public function removeStatic( static:GameObject ):void {

			staticObjects.remove( static );
			
		}
	}
}