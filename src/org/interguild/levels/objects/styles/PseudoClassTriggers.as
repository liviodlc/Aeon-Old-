package org.interguild.levels.objects.styles {

	/**
	 * This class can either be used
	 */
	public class PseudoClassTriggers implements TriggerTracker {

		private var global:uint = 0;
		private var triggers:uint = 0;
		private var test:uint;


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


		/**
		 * Should be called on every iteration, if this the instance of triggers
		 * stored by a GameObject, not if this is the instance of conditions
		 * stored by a StyleDefinition.
		 */
		public function reset():void {
			test = triggers;
		}


		/**
		 * Returns true if any of these triggers have changed since the last call
		 * to reset(). Returns false otherwise.
		 */
		public function hasChanged():Boolean {
			return (test != triggers);
		}


		/**
		 * x:static
		 */
		public function setStatic():void {
			set(0);
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
		public function setNonstatic():void {
			set(1);
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
		public function setDestroyed():void {
			set(2);
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
		public function setUnderwater():void {
			set(3);
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
		public function setOnLadder():void {
			set(4);
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
		public function setStandingDown():void {
			set(5);
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
		public function setStandingUp():void {
			set(6);
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
		public function setStandingRight():void {
			set(7);
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
		public function setStandingLeft():void {
			set(8);
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
		public function setMoveLeft(updating:Boolean = true):void {
			set(9);
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
		public function setMoveRight(updating:Boolean = true):void {
			set(10);
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
		public function setMoveUp(updating:Boolean = true):void {
			set(11);
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
		public function setMoveDown(updating:Boolean = true):void {
			set(12);
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
		public function setFaceDown():void {
			set(13, false);
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
		public function setFaceUp():void {
			set(13);
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
		public function setFaceLeft():void {
			set(14);
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
		public function setFaceRight():void {
			set(14, false);
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
		public function setCrawling():void {
			set(15);
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
		public function setPreview():void {
			global = global | 0x1;
		}


		/**
		 * x:preview
		 */
		public function getPreview():Boolean {
			return ((global & 0x1) == 1);
		}


		/**
		 * x:loading
		 */
		public function setLoading():void {
			global = global | 0x2;
		}


		/**
		 * x:loading
		 */
		public function getLoading():Boolean {
			return ((global & 0x2) == 1);
		}


		/**
		 * x:door-open
		 */
		public function setDoorOpen():void {
			global = global | 0x3;
		}


		/**
		 * x:door-open
		 */
		public function getDoorOpen():Boolean {
			return ((global & 0x3) == 1);
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
