package org.interguild.levels.objects.styles {

	public interface TriggerTracker {
		/**
		 * Should be called on every iteration, if this the instance of triggers
		 * stored by a GameObject, not if this is the instance of conditions
		 * stored by a StyleDefinition.
		 */
		function reset():void;


		/**
		 * Returns true if any of these triggers have changed since the last call
		 * to reset(). Returns false otherwise.
		 */
		function hasChanged():Boolean;
	}
}
