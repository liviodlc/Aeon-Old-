package org.interguild.levels.objects {
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
		public function addDynamic(dynamic:GameObject):void {
			dynamicObjects.add(dynamic);
		}


		/**
		 * Clear all elements from dynamic list.
		 */
		public function clearDynamic():void {
			dynamicObjects.clear();
		}


		/**
		 * Returns true if this grid element has any dynamic objects in it.
		 */
		public function hasDynamic():Boolean {
			return !dynamicObjects.isEmpty();
		}


		/**
		 * Add object to static list.
		 */
		public function addStatic(static:GameObject):void {
			staticObjects.add(static);
		}


		/**
		 * Remove object from static list.
		 */
		public function removeStatic(static:GameObject):void {
			staticObjects.remove(static);
		}


		/**
		 * Iterates through all GameObjects in this GridElement and tests
		 * whether it collides with the input GameObject.
		 *
		 * @param obj:GameObject the GameObject to test collisions against.
		 * This is assumed to be a dynamic object.
		 */
		public function detectCollisions(obj1:GameObject):void {
			var obj2:GameObject;
			staticObjects.beginIteration();
			obj1.tested = true;
			while (staticObjects.hasNext()) {
				obj2 = GameObject(staticObjects.next);
				if (!obj2.tested) {
					obj1.addResolution(new CollisionResolution(obj1, obj2));
				}
			}
			
			dynamicObjects.beginIteration();
			while (dynamicObjects.hasNext()) {
				obj2 = GameObject(dynamicObjects.next);
				if (!obj2.tested) {
					obj1.addResolution(new CollisionResolution(obj1, obj2));
				}
			}
		}
	}
}
