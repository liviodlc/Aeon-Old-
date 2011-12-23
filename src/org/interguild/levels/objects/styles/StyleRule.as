package org.interguild.levels.objects.styles {
	import org.interguild.levels.Level;

	import utils.LinkedList;

	/**
	 * An instance of this class represents a single property/value definition in
	 * one StyleDefinition. This class is in charge of implementing the desired
	 * changes as instructed in the CSS.
	 */
	public class StyleRule {

		private var property:String;
		private var value:Object;
		private var good:Boolean;


		public function StyleRule(prop:String, val:String, level:Level) {
			good = true;
			property = prop;
			switch (property) {
				case "hitbox-width":
					value = checkNum(val);
					break;
				case "hitbox-height":
					value = checkNum(val);
					break;
				case "hitbox-size":
					value = check2Nums(val);
					break;
				default:
					level.addError("Invalid property '" + prop + "' used in <styles> tag.");
					good = false;
			}
			if (good)
				trace("'" + property + "': '" + value + "'");
		}


		public function get isGood():Boolean {
			return good;
		}


		/**
		 * Returns a valid number for the string
		 */
		private function checkNum(s:String, notZero:Boolean = false):Number {
			trace("checkNum: '"+s+"'");
			var n:Number = Number(s);
			if (isNaN(n))
				if (notZero)
					n = 1;
				else
					n = 0;
			return n;
		}


		/**
		 * Returns an array of valid numbers from the string.
		 *
		 * If no second number is found in the string, it's default value
		 * will be the first number supplied.
		 */
		private function check2Nums(s:String, notZero:Boolean = false):Array {
			var a:Array = s.split(" ", 2);
			a[0] = Number(a[0]);
			if (isNaN(a[0]))
				if (notZero)
					a[0] = 1;
				else
					a[0] = 0;

			if (a[1] == null)
				a[1] = a[0];
			else if (isNaN(a[1]))
				if (notZero)
					a[1] = 1;
				else
					a[1] = 0;

			return a;
		}
	}
}
