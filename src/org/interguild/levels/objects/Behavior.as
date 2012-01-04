package org.interguild.levels.objects {
	import org.interguild.utils.LinkedList;

	/**
	 * Behavior classes provide special functionality to GameObjects by
	 * manipulating their psuedo-classes. For example, PlayerBehavior
	 * maps keyboard presses with specific pseudo-classes.
	 *
	 * At this point, all Behaviors are built-in. There are no designs
	 * for how customizeable Behavior class might work, but it's likely
	 * that this feature will be added later.
	 */
	public class Behavior {

		protected var list:LinkedList;


		/**
		 * THIS IS AN ABSTRACT CLASS. DO NOT INSTANTIATE.
		 */
		public function Behavior() {
			list = new LinkedList();
		}


		/**
		 * Adds a new user to this behavior.
		 */
		public function add(o:GameObject):void {
			list.add(o);
		}


		/**
		 * Updates all users of this behavior with the desired effects
		 * and functionality.
		 */
		public function onGameLoop():void {
			//sub classes must override this function
		}
	}
}
