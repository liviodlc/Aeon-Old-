package org.interguild.pages {

	import flash.display.Sprite;

	/**
	 * This is an abstract class, so do not instantiate.
	 */
	public class Page extends Sprite {
		
		public function Page(){
			visible = false;
		}
		
		/**
		 * Should hide the page and remove event listeners
		 */
		public function close():void {
			visible = false;
		}

		/**
		 * Should make the page visible and activate event listeners
		 */
		public function open():void {
			visible = true;
		}
	}
}