package org.interguild.levels.objects {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.interguild.levels.collisions.GridElement;
	
	import utils.LinkedList;

	/**
	 * GameObject represents any object in the games, such as tiles, players, enemies, etc.
	 */
	public class GameObject extends Sprite {
		
		private var definition:GameObjectDefinition;
		private var classes:LinkedList;

		//included in Sprite:
//		public var x:Number;
//		public var y:Number;

		//for collision detection
		private var newX:Number;
		private var newY:Number;
		private var currentSpeedX:Number;
		private var currentSpeedY:Number;

		private var collideable:Boolean;
		private var collBox:Rectangle;

		private var gridOccupied:LinkedList;


		public function GameObject() {
			super();

			gridOccupied = new LinkedList();

		}


		/**
		 * Returns a Rectangle object describing this object's hit bounds,
		 * or null if this object is not collideable.
		 *
		 * The rectangle's coordinates are absolute, meaning they are the
		 * current position of the object plus the offset of its hitbox.
		 */
		public function get hitbox():Rectangle {
			if (!collideable)
				return null;
			var result:Rectangle = collBox.clone();
			result.offset(newX, newY);
			return result;
		}


		public function addOccupied(element:GridElement) {

		}
		
		/**
		 * Updates this GameObject's list of active psuedo-classes. If there's a
		 * change, it iterates through all of its style definitions looking to see
		 * if there's any style to be recalculated. If one style has to be updated,
		 * then all the styles will be recalculated, in order to keep the cascading
		 * effect of these settings.
		 */
		public function updateStyles():void{
			
		}
	}
}
