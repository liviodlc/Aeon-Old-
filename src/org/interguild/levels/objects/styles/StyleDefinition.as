package org.interguild.levels.objects.styles {
	import org.interguild.levels.objects.Behavior;
	import org.interguild.utils.Comparable;
	import org.interguild.utils.LinkedList;

	public class StyleDefinition implements Comparable {

		private var pseudoConditions:PseudoClassTriggers;
		private var dynamicConditions:DynamicTriggers;
		private var rules:Object;
		private var frames:Object;

		private var a:uint;
		private var b:uint;
		private var c:uint;


		/**
		 * @param pseudo:PseudoClassTriggers The pseudo-class conditions that trigger this style definition
		 * @param dynmap:DynamicTriggers The dynamic conditions that trigger this style definition
		 * @param rules:Object An associative array of all of the rules that this definiton puts into effect
		 * when valid. It holds the rule properties as keys and rule values as values.
		 */
		public function StyleDefinition(pseudo:PseudoClassTriggers, dynam:DynamicTriggers, rules:Object, framesMap:Object) {
			this.rules = rules;
			frames = framesMap;
			/*
			Style precendence is calculated based on four numbers: a, b, c.
				a = number of dynamic triggers this references
				b = number of global, static, nonstatic, or destroyed pseudo classes used
				c = number of all other pseudo classes used
			*/
			if (dynam != null) {
				a = dynam.getA();
				dynamicConditions = dynam;
			} else {
				dynamicConditions = new DynamicTriggers();
			}
			if (pseudo != null) {
				b = pseudo.getB();
				c = pseudo.getC();
				pseudoConditions = pseudo;
			} else {
				pseudoConditions = new PseudoClassTriggers();
			}
		}


		public function get framesMap():Object {
			return frames;
		}


		public function get isDynamic():Boolean {
			return !dynamicConditions.isEmpty();
		}


		/**
		 * Returns an associative array of all of the rules that this StyleDefinition
		 * activates when it's active. The keys are the properties, and the values are
		 * the rule values.
		 */
		public function get rulesArray():Object {
			return rules;
		}


		public function get normalTriggers():PseudoClassTriggers {
			return pseudoConditions;
		}


		/**
		 * Returns a positive number if 'this' yeilds more precendence than
		 * the 'other' StyleDefinition. Returns a negative number in the reverse
		 * case, and returns zero if they have the same precendence. If 'this'
		 * has the same conditions as 'other', then the two 'this' is merged into
		 * 'other', and this function returns int.MIN_VALUE signifying that add
		 * action must be cancelled.
		 *
		 * @param other:StyleDefinition The 'other' StyleDefinition.
		 */
		public function compareTo(other:Comparable):int {
			var that:StyleDefinition = StyleDefinition(other);

			if (this.equals(that)) {
				that.mergeWith(this);
				return int.MIN_VALUE;
			}

			var result:int = this.a - that.a;
			if (result != 0)
				return result;
			result = this.b - that.b;
			if (result != 0)
				return result;
			result = this.c - that.c;
			return result;
		}


		/**
		 * Returns true if 'this' shares the same conditions as 'other'.
		 */
		private function equals(that:StyleDefinition):Boolean {
			return (this.pseudoConditions.equals(that.pseudoConditions) && this.dynamicConditions.equals(that.dynamicConditions));
		}


		/**
		 * Dumps all of the rules 'other' into 'this', overwriting any conflicting rules.
		 */
		private function mergeWith(other:StyleDefinition):void {
			var key:String;
			for (key in other.rules) {
				rules[key] = other.rules[key];
			}
			for (key in other.frames) {
				frames[key] = other.frames[key];
			}
		}


//		public function testPrint():void {
//			trace("	" + a + ", " + b + ", " + c);
//			pseudoConditions.testing();
//		}
	}
}
