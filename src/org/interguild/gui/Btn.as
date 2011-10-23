package org.interguild.gui {

	import flash.display.Sprite;

	/**
	 * A class with many sub classes. Defines some standard functions such as moveTo and moveTo2.
	 */
	public class Btn extends Sprite {

		/**standard move function where x and y represent the top-middle point of the button*/
		public function moveTo(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}


		/**for moveTo2, x and y represent the top-left point of the button*/
		public function moveTo2(x:Number, y:Number):void {
			this.x = x + width / 2;
			this.y = y;
		}


		/**
		 * Sets the button label and resizes the button accordingly.
		 * Check to ensure that the Btn subclass that you're working
		 * with actually implements this function.
		 */
		public function set text(txt:String):void {
			//not implemented
		}
	}
}
