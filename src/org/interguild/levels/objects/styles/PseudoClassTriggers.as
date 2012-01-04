package org.interguild.levels.objects.styles {

	/**
	 * This class can either be used
	 */
	public class PseudoClassTriggers implements TriggerTracker {

		private var global:uint = 0; // 4 bits
		private var triggers:uint = 0; // 16 bits
		private var test1:uint;
		private var test2:uint;
		private var b:uint = 0;
		private var c:uint = 0;


		public function PseudoClassTriggers() {
			super();
		}


		/**
		 * Returns true if 'this' has the same conditions as 'other'.
		 */
		public function equals(other:PseudoClassTriggers):Boolean {
			return (this.global == other.global && this.triggers == other.triggers);
		}


		private function set(bit:uint, on:Boolean = true):void {
			var u:uint = 0x1 << bit;
			if (on) {
				triggers = triggers | u;
			} else {
				u = ~u;
				triggers = triggers & u;
			}
		}


		private function get(bit:uint):Boolean {
			var u:uint = 0x1 << bit;
			return ((triggers & u) != 0);
		}


		private function set2(bit:uint, on:Boolean = true):void {
			var u:uint = 0x1 << bit;
			if (on) {
				global = global | u;
			} else {
				u = ~u;
				global = global & u;
			}
		}


		private function get2(bit:uint):Boolean {
			var u:uint = 0x1 << bit;
			return ((global & u) != 0);
		}


		/**
		 * Should be called on every iteration, if this the instance of triggers
		 * stored by a GameObject, not if this is the instance of conditions
		 * stored by a StyleDefinition.
		 */
		public function update():void {
			test1 = triggers;
			test2 = global;
			b = c = 0; //don't let these numbers get too big.
		}


		/**
		 * Returns true if any of these triggers have changed since the last call
		 * to reset(). Returns false otherwise.
		 */
		public function hasChanged():Boolean {
			return (test1 != triggers || test2 != global);
		}


		/**
		 * Returns the number of global conditions plus the number of 'static', 'nonstatic',
		 * and 'destroyed' pseudo conditions that this instance is listening to. The 'C'
		 * refers to the way in which StyleDefinition calculates precendence.
		 */
		public function getB():uint {
			return b;
		}


		/**
		 * Returns the number of pseudo conditions that this instance is listening to, and
		 * which aren't global, 'static', 'nonstatic', or 'destroyed'. The 'D' refers to the
		 * way in which StyleDefinition calculates precendence.
		 */
		public function getC():uint {
			return c;
		}


		/**
		 * x:water
		 */
		public function setUnderwater(on:Boolean = true):void {
			set(0, on);
			c++;
		}


		/**
		 * x:water
		 */
		public function getUnderwater():Boolean {
			return get(0);
		}


		/**
		 * x:ladder
		 */
		public function setOnLadder(on:Boolean = true):void {
			set(1, on);
			c++;
		}


		/**
		 * x:ladder
		 */
		public function getOnLadder():Boolean {
			return get(1);
		}


		/**
		 * x:crawling
		 */
		public function setCrawling(on:Boolean = true):void {
			set(2, on);
			c++;
		}


		/**
		 * x:crawling
		 */
		public function getCrawling():Boolean {
			return get(2);
		}


		/**
		 * x:standing-on-down
		 */
		public function setStandingDown(on:Boolean = true):void {
			set(3, on);
			c++;
		}


		/**
		 * x:standing-on-down
		 */
		public function getStandingDown():Boolean {
			return get(3);
		}


		/**
		 * x:standing-on-up
		 */
		public function setStandingUp(on:Boolean = true):void {
			set(4, on);
			c++;
		}


		/**
		 * x:standing-on-up
		 */
		public function getStandingUp():Boolean {
			return get(4);
		}


		/**
		 * x:standing-on-right
		 */
		public function setStandingRight(on:Boolean = true):void {
			set(5, on);
			c++;
		}


		/**
		 * x:standing-on-right
		 */
		public function getStandingRight():Boolean {
			return get(5);
		}


		/**
		 * x:standing-on-left
		 */
		public function setStandingLeft(on:Boolean = true):void {
			set(6, on);
			c++;
		}


		/**
		 * x:standing-on-left
		 */
		public function getStandingLeft():Boolean {
			return get(6);
		}


		/**
		 * x:left
		 */
		public function setMoveLeft(on:Boolean = true, updating:Boolean = true):void {
			set(7, on);
			if (updating)
				set(12);
			c++;
		}


		/**
		 * x:left
		 */
		public function getMoveLeft():Boolean {
			return get(7);
		}


		/**
		 * x:right
		 */
		public function setMoveRight(on:Boolean = true, updating:Boolean = true):void {
			set(8, on);
			if (updating)
				set(12, false);
			c++;
		}


		/**
		 * x:right
		 */
		public function getMoveRight():Boolean {
			return get(8);
		}


		/**
		 * x:up
		 */
		public function setMoveUp(on:Boolean = true, updating:Boolean = true):void {
			set(9, on);
			if (updating)
				set(11);
			c++;
		}


		/**
		 * x:up
		 */
		public function getMoveUp():Boolean {
			return get(9);
		}


		/**
		 * x:down
		 */
		public function setMoveDown(on:Boolean = true, updating:Boolean = true):void {
			set(10, on);
			if (updating)
				set(11, false);
			c++;
		}


		/**
		 * x:down
		 */
		public function getMoveDown():Boolean {
			return get(10);
		}


		/**
		 * x:face-down
		 */
		public function setFaceDown(on:Boolean = true):void {
			set(11, !on);
			c++;
		}


		/**
		 * x:face-down
		 */
		public function getFaceDown():Boolean {
			return !get(11);
		}


		/**
		 * x:face-down
		 */
		public function setFaceUp(on:Boolean = true):void {
			set(11, on);
			c++;
		}


		/**
		 * x:face-up
		 */
		public function getFaceUp():Boolean {
			return get(11);
		}


		/**
		 * x:face-down
		 */
		public function setFaceLeft(on:Boolean = true):void {
			set(12, on);
			c++;
		}


		/**
		 * x:face-up
		 */
		public function getFaceLeft():Boolean {
			return get(12);
		}


		/**
		 * x:face-down
		 */
		public function setFaceRight(on:Boolean = true):void {
			set(12, !on);
			c++;
		}


		/**
		* x:face-up
		*/
		public function getFaceRight():Boolean {
			return !get(12);
		}


		/**
		 * x:static
		 */
		public function setStatic(on:Boolean = true):void {
			set(13, on);
			b++;
		}


		/**
		 * x:static
		 */
		public function getStatic():Boolean {
			return get(13);
		}


		/**
		 * x:nonstatic
		 */
		public function setNonstatic(on:Boolean = true):void {
			set(14, on);
			b++;
		}


		/**
		 * x:nonstatic
		 */
		public function getNonstatic():Boolean {
			return get(14);
		}


		/**
		 * x:destroyed
		 */
		public function setDestroyed(on:Boolean = true):void {
			set(15, on);
			b++;
		}


		/**
		 * x:destroyed
		 */
		public function getDestroyed():Boolean {
			return get(15);
		}



		/**
		 * x:preview
		 */
		public function setPreview(on:Boolean = true):void {
			set2(0, on);
			b++;
		}


		/**
		 * x:preview
		 */
		public function getPreview():Boolean {
			return get2(0);
		}


		/**
		 * x:loading
		 */
		public function setLoading(on:Boolean = true):void {
			set2(1, on);
			b++;
		}


		/**
		 * x:loading
		 */
		public function getLoading():Boolean {
			return get2(1);
		}


		/**
		 * x:door-open
		 */
		public function setDoorOpen(on:Boolean = true):void {
			set2(2, on);
			b++;
		}


		/**
		 * x:door-open
		 */
		public function getDoorOpen():Boolean {
			return get(2);
		}


		/**
		 * x:ending
		 */
		public function setEnding(on:Boolean = true):void {
			set2(3, on);
			b++;
		}


		/**
		 * x:ending
		 */
		public function getEnding():Boolean {
			return get2(3);
		}


		/**
		 * This method should ONLY be called from the GameObject's instance of this class,
		 * and the parameter should be the StyleDefinition's instance that you want to
		 * compare it with.
		 */
		public function isStyleActiveNormal(style:PseudoClassTriggers):Boolean {
			return (style.triggers == 0 || (style.triggers & this.triggers) == style.triggers);
		}


		/**
		 * This method should ONLY be called from the GameObject's level instance of this class,
		 * and the parameter should be the StyleDefinition's instance that you want to
		 * compare it with.
		 */
		public function isStyleActiveGlobal(style:PseudoClassTriggers):Boolean {
			return (style.global == 0 || style.global == this.global);
		}


//		public function testing():void {
//			trace("		triggers: " + triggers);
//			trace("		global: " + global);
//		}
	}
}
