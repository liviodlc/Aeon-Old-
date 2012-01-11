package org.interguild.levels.objects.styles {

	/**
	 * This class can either be used
	 */
	public class PseudoClassTriggers implements TriggerTracker {

		public var globalTriggers:uint = 0; // 4 bits
		public var normalTriggers:uint = 0; // 17 bits
		private var test1:uint;
		private var test2:uint;
		private var test1Tracker:uint = 0;
		private var test2Tracker:uint = 0;
		private var b:uint = 0;
		private var c:uint = 0;


		public function PseudoClassTriggers() {
			super();
		}


		/**
		 * Returns true if 'this' has the same conditions as 'other'.
		 */
		public function equals(other:PseudoClassTriggers):Boolean {
			return (this.globalTriggers == other.globalTriggers && this.normalTriggers == other.normalTriggers);
		}


		private function set(bit:uint, on:Boolean = true):void {
			var u:uint = 0x1 << bit;
			if (on) {
				normalTriggers = normalTriggers | u;
			} else {
				u = ~u;
				normalTriggers = normalTriggers & u;
			}
		}


		private function get(bit:uint):Boolean {
			var u:uint = 0x1 << bit;
			return ((normalTriggers & u) != 0);
		}


		private function set2(bit:uint, on:Boolean = true):void {
			var u:uint = 0x1 << bit;
			if (on) {
				globalTriggers = globalTriggers | u;
			} else {
				u = ~u;
				globalTriggers = globalTriggers & u;
			}
		}


		private function get2(bit:uint):Boolean {
			var u:uint = 0x1 << bit;
			return ((globalTriggers & u) != 0);
		}


		/**
		 * Should be called on every iteration, if this the instance of triggers
		 * stored by a GameObject, not if this is the instance of conditions
		 * stored by a StyleDefinition.
		 */
		public function update():void {
			test1 = normalTriggers;
			test2 = globalTriggers;
			b = c = 0; //don't let these numbers get too big.
		}


		/**
		 * Returns true if any of these triggers have changed since the last call
		 * to reset(). Returns false otherwise.
		 * 
		 * @param strict:Boolean Set to true to check changes in all the triggers.
		 * Set to false if you only want to check the tirggers that the tile cares
		 * about.
		 */
		public function hasChanged(strict:Boolean = false):Boolean {
			if (strict)
				return (test1 != normalTriggers || test2 != globalTriggers);
			else
				return ((test1 & test1Tracker) != (normalTriggers & test1Tracker) || (test2 & test1Tracker) != (globalTriggers & test2Tracker));

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
		 * x:jumping
		 */
		public function setJumping(on:Boolean = true):void {
			set(3, on);
			c++;
		}


		/**
		 * x:jumping
		 */
		public function getJumping():Boolean {
			return get(3);
		}


		/**
		 * x:standing-on-down
		 */
		public function setStandingDown(on:Boolean = true):void {
			set(4, on);
			c++;
		}


		/**
		 * x:standing-on-down
		 */
		public function getStandingDown():Boolean {
			return get(4);
		}


		/**
		 * x:standing-on-up
		 */
		public function setStandingUp(on:Boolean = true):void {
			set(5, on);
			c++;
		}


		/**
		 * x:standing-on-up
		 */
		public function getStandingUp():Boolean {
			return get(5);
		}


		/**
		 * x:standing-on-right
		 */
		public function setStandingRight(on:Boolean = true):void {
			set(6, on);
			c++;
		}


		/**
		 * x:standing-on-right
		 */
		public function getStandingRight():Boolean {
			return get(6);
		}


		/**
		 * x:standing-on-left
		 */
		public function setStandingLeft(on:Boolean = true):void {
			set(7, on);
			c++;
		}


		/**
		 * x:standing-on-left
		 */
		public function getStandingLeft():Boolean {
			return get(7);
		}


		/**
		 * x:left
		 */
		public function setMoveLeft(on:Boolean = true, updating:Boolean = false):void {
			set(8, on);
			if (updating)
				set(13);
			c++;
		}


		/**
		 * x:left
		 */
		public function getMoveLeft():Boolean {
			return get(8);
		}


		/**
		 * x:right
		 */
		public function setMoveRight(on:Boolean = true, updating:Boolean = false):void {
			set(9, on);
			if (updating)
				set(13, false);
			c++;
		}


		/**
		 * x:right
		 */
		public function getMoveRight():Boolean {
			return get(9);
		}


		/**
		 * x:up
		 */
		public function setMoveUp(on:Boolean = true, updating:Boolean = false):void {
			set(10, on);
			if (updating)
				set(12);
			c++;
		}


		/**
		 * x:up
		 */
		public function getMoveUp():Boolean {
			return get(10);
		}


		/**
		 * x:down
		 */
		public function setMoveDown(on:Boolean = true, updating:Boolean = false):void {
			set(11, on);
			if (updating)
				set(12, false);
			c++;
		}


		/**
		 * x:down
		 */
		public function getMoveDown():Boolean {
			return get(11);
		}


		/**
		 * x:face-down
		 */
		public function setFaceDown(on:Boolean = true):void {
			set(12, !on);
			c++;
		}


		/**
		 * x:face-down
		 */
		public function getFaceDown():Boolean {
			return !get(12);
		}


		/**
		 * x:face-down
		 */
		public function setFaceUp(on:Boolean = true):void {
			set(12, on);
			c++;
		}


		/**
		 * x:face-up
		 */
		public function getFaceUp():Boolean {
			return get(12);
		}


		/**
		 * x:face-down
		 */
		public function setFaceLeft(on:Boolean = true):void {
			set(13, on);
			c++;
		}


		/**
		 * x:face-up
		 */
		public function getFaceLeft():Boolean {
			return get(13);
		}


		/**
		 * x:face-down
		 */
		public function setFaceRight(on:Boolean = true):void {
			set(13, !on);
			c++;
		}


		/**
		* x:face-up
		*/
		public function getFaceRight():Boolean {
			return !get(13);
		}


		/**
		 * x:static
		 */
		public function setStatic(on:Boolean = true):void {
			set(14, on);
			b++;
		}


		/**
		 * x:static
		 */
		public function getStatic():Boolean {
			return get(14);
		}


		/**
		 * x:nonstatic
		 */
		public function setNonstatic(on:Boolean = true):void {
			set(15, on);
			b++;
		}


		/**
		 * x:nonstatic
		 */
		public function getNonstatic():Boolean {
			return get(15);
		}


		/**
		 * x:destroyed
		 */
		public function setDestroyed(on:Boolean = true):void {
			set(16, on);
			b++;
		}


		/**
		 * x:destroyed
		 */
		public function getDestroyed():Boolean {
			return get(16);
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
			return (style.normalTriggers == 0 || (style.normalTriggers & this.normalTriggers) == style.normalTriggers);
		}


		/**
		 * This method should ONLY be called from the GameObject's level instance of this class,
		 * and the parameter should be the StyleDefinition's instance that you want to
		 * compare it with.
		 */
		public function isStyleActiveGlobal(style:PseudoClassTriggers):Boolean {
			return (style.globalTriggers == 0 || style.globalTriggers == this.globalTriggers);
		}


		/**
		 * Tells this instance to only track changes in the active triggers in the input oject.
		 */
		public function track(other:PseudoClassTriggers):void {
			test1Tracker = test1Tracker | other.normalTriggers;
			test2Tracker = test2Tracker | other.globalTriggers;
		}


//		public function testing():void {
//			trace("		triggers: " + triggers);
//			trace("		global: " + global);
//		}
	}
}
