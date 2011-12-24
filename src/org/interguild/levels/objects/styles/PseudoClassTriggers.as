package org.interguild.levels.objects.styles {

	/**
	 * This class can either be used
	 */
	public class PseudoClassTriggers implements TriggerTracker {

		private var global:uint = 0;
		private var triggers:uint = 0;
		private var test1:uint;
		private var test2:uint;


		public function PseudoClassTriggers() {
			super();
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
		}


		/**
		 * Returns true if any of these triggers have changed since the last call
		 * to reset(). Returns false otherwise.
		 */
		public function hasChanged():Boolean {
			return (test1 != triggers || test2 != global);
		}


		/**
		 * x:static
		 */
		public function setStatic(on:Boolean = true):void {
			set(0, on);
		}


		/**
		 * x:static
		 */
		public function getStatic():Boolean {
			return get(0);
		}


		/**
		 * x:nonstatic
		 */
		public function setNonstatic(on:Boolean = true):void {
			set(1, on);
		}


		/**
		 * x:nonstatic
		 */
		public function getNonstatic():Boolean {
			return get(1);
		}


		/**
		 * x:destroyed
		 */
		public function setDestroyed(on:Boolean = true):void {
			set(2, on);
		}


		/**
		 * x:destroyed
		 */
		public function getDestroyed():Boolean {
			return get(2);
		}


		/**
		 * x:water
		 */
		public function setUnderwater(on:Boolean = true):void {
			set(3, on);
		}


		/**
		 * x:water
		 */
		public function getUnderwater():Boolean {
			return get(3);
		}


		/**
		 * x:ladder
		 */
		public function setOnLadder(on:Boolean = true):void {
			set(4, on);
		}


		/**
		 * x:ladder
		 */
		public function getOnLadder():Boolean {
			return get(4);
		}


		/**
		 * x:standing-on-down
		 */
		public function setStandingDown(on:Boolean = true):void {
			set(5, on);
		}


		/**
		 * x:standing-on-down
		 */
		public function getStandingDown():Boolean {
			return get(5);
		}


		/**
		 * x:standing-on-up
		 */
		public function setStandingUp(on:Boolean = true):void {
			set(6, on);
		}


		/**
		 * x:standing-on-up
		 */
		public function getStandingUp():Boolean {
			return get(6);
		}


		/**
		 * x:standing-on-right
		 */
		public function setStandingRight(on:Boolean = true):void {
			set(7, on);
		}


		/**
		 * x:standing-on-right
		 */
		public function getStandingRight():Boolean {
			return get(7);
		}


		/**
		 * x:standing-on-left
		 */
		public function setStandingLeft(on:Boolean = true):void {
			set(8, on);
		}


		/**
		 * x:standing-on-left
		 */
		public function getStandingLeft():Boolean {
			return get(8);
		}


		/**
		 * x:left
		 */
		public function setMoveLeft(on:Boolean = true, updating:Boolean = true):void {
			set(9, on);
			if (updating)
				set(14);
		}


		/**
		 * x:left
		 */
		public function getMoveLeft():Boolean {
			return get(9);
		}


		/**
		 * x:right
		 */
		public function setMoveRight(on:Boolean = true, updating:Boolean = true):void {
			set(10, on);
			if (updating)
				set(14, false);
		}


		/**
		 * x:right
		 */
		public function getMoveRight():Boolean {
			return get(10);
		}


		/**
		 * x:up
		 */
		public function setMoveUp(on:Boolean = true, updating:Boolean = true):void {
			set(11, on);
			if (updating)
				set(13);
		}


		/**
		 * x:up
		 */
		public function getMoveUp():Boolean {
			return get(11);
		}


		/**
		 * x:down
		 */
		public function setMoveDown(on:Boolean = true, updating:Boolean = true):void {
			set(12, on);
			if (updating)
				set(13, false);
		}


		/**
		 * x:down
		 */
		public function getMoveDown():Boolean {
			return get(12);
		}


		/**
		 * x:face-down
		 */
		public function setFaceDown(on:Boolean = true):void {
			set(13, !on);
		}


		/**
		 * x:face-down
		 */
		public function getFaceDown():Boolean {
			return !get(13);
		}


		/**
		 * x:face-down
		 */
		public function setFaceUp(on:Boolean = true):void {
			set(13, on);
		}


		/**
		 * x:face-up
		 */
		public function getFaceUp():Boolean {
			return get(13);
		}


		/**
		 * x:face-down
		 */
		public function setFaceLeft(on:Boolean = true):void {
			set(14, on);
		}


		/**
		 * x:face-up
		 */
		public function getFaceLeft():Boolean {
			return get(14);
		}


		/**
		 * x:face-down
		 */
		public function setFaceRight(on:Boolean = true):void {
			set(14, !on);
		}


		/**
		* x:face-up
		*/
		public function getFaceRight():Boolean {
			return !get(14);
		}


		/**
		 * x:crawling
		 */
		public function setCrawling(on:Boolean = true):void {
			set(15, on);
		}


		/**
		 * x:crawling
		 */
		public function getCrawling():Boolean {
			return get(15);
		}


		/**
		 * x:preview
		 */
		public function setPreview(on:Boolean = true):void {
			set2(0, on);
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
			return (style.triggers == 0 || style.triggers == this.triggers);
		}


		/**
		 * This method should ONLY be called from the GameObject's level instance of this class,
		 * and the parameter should be the StyleDefinition's instance that you want to
		 * compare it with.
		 */
		public function isStyleActiveGlobal(style:PseudoClassTriggers):Boolean {
			return (style.global == 0 || style.global == this.global);
		}


		public function testing():void {
			trace("testing: " + triggers);
			trace("global: " + global);
		}
	}
}
