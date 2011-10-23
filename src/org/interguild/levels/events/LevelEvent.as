package org.interguild.levels.events {

	public class LevelEvent {

		public var name:String;

		private var _isActive:Boolean;
		public var id:uint;

		/**
		 * Creates a new event with that name. Don't forget to give it to EventMan.
		 *
		 * @param name:String
		 */
		public function LevelEvent(_name:String) {
			name = _name;

			_isActive = false;
		}


		public function activate():void {
			_isActive = true;
		}


		public function isActive():Boolean {
			return _isActive;
		}


		public function deactivate():void {
			_isActive = false;
		}
	}
}
