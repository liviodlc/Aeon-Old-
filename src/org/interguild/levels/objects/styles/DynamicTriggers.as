package org.interguild.levels.objects.styles {

	public class DynamicTriggers implements TriggerTracker {

		private var triggers:uint;


		public function DynamicTriggers() {
			
		}


		/**
		 * Should be called on every iteration, if this the instance of triggers
		 * stored by a GameObject, not if this is the instance of conditions
		 * stored by a StyleDefinition.
		 */
		public function update():void {

		}


		/**
		 * Returns true if any of these triggers have changed since the last call
		 * to reset(). Returns false otherwise.
		 */
		public function hasChanged():Boolean {
			return false;
		}


		public function isEmpty():Boolean {
			if (triggers == 0)
				return true;
			else
				return false;
		}
	}
}
