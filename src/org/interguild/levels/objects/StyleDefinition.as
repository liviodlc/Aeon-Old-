package org.interguild.levels.objects {
	import utils.LinkedList;

	public class StyleDefinition {
		
		private var users:LinkedList;

		public function StyleDefinition() {
			
		}
		
		/**
		 * This function returns a list of object type IDs for whom this definition applies to.
		 * This function may only be called once, because this call also removes the reference
		 * to the list from this instance so that it may be garbage collected.
		 */
		public function get usersList():LinkedList{
			var u:LinkedList = users;
			users = null;
			return u;
		}
	}
}
