package org.interguild.levels.collisions{
	
	public class GridElement{
		
		private LinkedNode:class {
			
			private next:LinkedNode;

            private stored:Object;
			
			private function LinkedNode(){
                
                next = null;

				
			}
			
		}
		
		private var contains:LinkedNode;
		private var size:uint;
		
		public function GridElement(){
			
			contains = null;
			size = 0;
			
		}
		
		public function get gridObjects():Array {
			
			return contains;
			
		}
		
		public function addObject( object:GameObject ): void {
			
		}
		
		public function removeObject( object:GameObject ): void {
			
		}
		
		
		
	}
	
}
