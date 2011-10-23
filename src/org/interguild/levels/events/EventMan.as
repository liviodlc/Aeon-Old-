package org.interguild.levels.events {
	import flash.events.Event;

	import org.interguild.levels.Level;

	/**
	 * EventMan appears! His specialty is.... to manage LevelEvents!
	 *
	 * Reserved Events:
	 * 		LEVEL_PAUSE
	 * 		LEVEL_START
	 * 		LEVEL_WIN
	 * 		PLAYER_DIE
	 * 		LEVEL_LOAD_START
	 * 		LEVEL_LOAD_COMPLETE
	 * 		LEVEL_RESET
	 */
	public class EventMan {

		private var allEvents:Object;


		public function EventMan() {
			allEvents = new Object();
		}


		/**
		 * Returns the lowest possible ID for an event. Useful for when creating new LevelEvents.
		 */
		public function get lowestEventID():uint {
			for (var i:uint = 0; i >= 0; i++) {
				if (allEvents["_" + i] == null) {
					return i;
				}
			}
			return 0;
		}


		/**
		 * This function is intended to be used by LevelBuilder when initializing the level,
		 * and for the sake of optimization, there are no checks to see if an event is being overwritten.
		 */
		public function addEvent(evt:LevelEvent):void {
			allEvents["_" + evt.id] = evt;
		}


		/**
		 * Similar to addEvent(), except that the given event's ID number will be set to the lowestEventID.
		 */
		public function addNewEvent(evt:LevelEvent):void {
			evt.id = this.lowestEventID;
			addEvent(evt);
		}


		public function isEventActive(id:uint):Boolean {
			var event:LevelEvent = allEvents["_" + id];
			return event.isActive();
		}


		public function onGameLoop():void {
			for each (var evt:LevelEvent in allEvents) {
				evt.deactivate(); //events only fire for one frame
			}
		}
	}
}
