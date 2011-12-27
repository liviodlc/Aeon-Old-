package org.interguild.levels.objects.styles {

	public class DynamicTriggers implements TriggerTracker {

		private var triggers:uint;


		public function DynamicTriggers() {
			
		}
		
		
		/**
		 * Returns true if 'this' has the same conditions as 'other'.
		 */
		public function equals(other:DynamicTriggers):Boolean{
			//TODO implement function
			return true;
		}


		/**
		 * Should be called on every iteration, if this the instance of triggers
		 * stored by a GameObject, not if this is the instance of conditions
		 * stored by a StyleDefinition.
		 */
		public function update():void {
			//TODO implement function
		}


		/**
		 * Returns true if any of these triggers have changed since the last call
		 * to reset(). Returns false otherwise.
		 */
		public function hasChanged():Boolean {
			//TODO implement function
			return false;
		}


		public function isEmpty():Boolean {
			if (triggers == 0)
				return true;
			else
				return false;
		}
		
		/**
		 * Returns the number of dynamic conditions that this instance is listening to.
		 * The 'B' refers to the way in which StyleDefinition calculates precendence.
		 */
		public function getA():uint{
			//TODO implement function
			return 0;
		}
	}
}
