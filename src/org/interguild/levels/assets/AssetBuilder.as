package org.interguild.levels.assets {
	import flash.geom.Rectangle;

	/**
	 * This is an abstract class. The purpose of this class is to
	 * hold some common methods used by its subclasses.
	 */
	public class AssetBuilder {

		/**
		 * DO NOT INSTANTIATE. THIS IS AN ABSTRACT CLASS.
		 */
		public function AssetBuilder() {
		}


		/**
		 * Parses the box="1 2 3 4" text and returns a Rectangle with valid values.
		 */
		protected function checkBox(box:String):Rectangle {
			var a:Array = box.split(" ", 4);
			var n:uint = a.length;
			for (var i:uint = 0; i < n; i++) {
				a[i] = Number(a[i]);
				if (i < 2) {
					if (isNaN(a[i])) {
						a[i] = 0;
					}
				} else {
					if (isNaN(a[i]) || a[i] < 0) {
						a[i] = 1;
					}
				}
			}
			if (n == 3)
				a.push(1);
			else if (n == 2)
				a.push(1, 1);
			else if (n == 1)
				a.push(0, 1, 1);

			return new Rectangle(a[0], a[1], a[2], a[3]);
		}
	}
}
