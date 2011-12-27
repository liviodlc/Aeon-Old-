package org.interguild.levels.objects {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import org.interguild.levels.collisions.GridElement;
	import org.interguild.levels.objects.styles.DynamicTriggers;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;
	import org.interguild.levels.objects.styles.StyleDefinition;
	import org.interguild.utils.LinkedList;
	import org.interguild.utils.OrderedList;

	/**
	 * GameObject represents any object in the games, such as tiles, players, enemies, etc.
	 */
	public class GameObject extends Sprite {

		private var def:GameObjectDefinition;
		private var classes:LinkedList;
		private var normalTriggers:PseudoClassTriggers;
		private var dynamicTriggers:DynamicTriggers;

		//for collision detection
		private var newX:Number = 0;
		private var newY:Number = 0;
		private var currentSpeedX:Number = 0;
		private var currentSpeedY:Number = 0;
		private var maxSpeedX:Number = 0;
		private var maxSpeedY:Number = 0;
		private var accX:Number = 0;
		private var accY:Number = 0;
		private var collBox:Rectangle;

		private var _static:Boolean;
		private var collideable:Boolean;

		private var gridOccupied:LinkedList;


		public function GameObject(god:GameObjectDefinition, posX:Number, posY:Number) {
			x = newX = posX;
			y = newY = posY;

			// initialize stuff
			gridOccupied = new LinkedList();
			classes = new LinkedList();
			normalTriggers = new PseudoClassTriggers();
			dynamicTriggers = new DynamicTriggers();

			//set defaults:
			_static = false;
			collideable = true;
			collBox = new Rectangle(0, 0, 32, 32);
			accY = 1;
			maxSpeedY = 100;

			def = god;
		}


		/**
		 * Adds a user-defined CSS class to this object, which is almost like
		 * multiple inheretance of styles.
		 */
		public function addStyleClass(c:GameObjectDefinition):void {
			classes.add(c);
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


		public function addOccupied(element:GridElement):void {

		}


		/**
		 * Calculates the object's new position and settings for the next gameloop.
		 * The new position is put into different variables because we don't want
		 * to change the real variables until after we resolve collisions.
		 */
		public function updateModel():void {
			newX = x;
			newY = y;

			// increment speeds
			if (currentSpeedX < maxSpeedX && currentSpeedX > -maxSpeedX) {
				currentSpeedX += accX;
				if (currentSpeedX > maxSpeedX || currentSpeedX < -maxSpeedX) {
					currentSpeedX = maxSpeedX;
				}
			}
			if (currentSpeedY < maxSpeedY && currentSpeedY > -maxSpeedY) {
				currentSpeedY += accY;
				if (currentSpeedY > maxSpeedY || currentSpeedY < -maxSpeedY) {
					currentSpeedY = maxSpeedY;
				}
			}

			// update positions
			newX += currentSpeedX;
			newY += currentSpeedY;
		}


		/**
		 * Looks at this GameObject's list of active psuedo-classes, and if there was
		 * a change, it iterates through all of its style definitions looking to see
		 * if there's any style to be recalculated. If one style has to be updated,
		 * then all the styles will be recalculated, in order to keep the cascading
		 * effect of these settings.
		 *
		 * @param init:Boolean Mark this as true if you want to update styles as
		 * part of this object's initialization, as opposed to part of the game loop.
		 */
		public function updateStyles(global:PseudoClassTriggers, init:Boolean = false):void {
			if (init || normalTriggers.hasChanged() || dynamicTriggers.hasChanged()) {
				trace("update styles");
				if (def.hasAncestor()) {
					applyStylesList(def.ancestor.normalStylesList, global);
					applyStylesList(def.ancestor.dynamicStylesList, global);
				}
				applyStylesList(def.normalStylesList, global);
				applyStylesList(def.dynamicStylesList, global);
				classes.beginIteration();
				while (classes.hasNext()) {
					var god:GameObjectDefinition = GameObjectDefinition(classes.next);
					applyStylesList(god.normalStylesList, global);
					applyStylesList(god.dynamicStylesList, global);
				}
			}
			normalTriggers.update();
			dynamicTriggers.update();
		}


		private function applyStylesList(list:OrderedList, global:PseudoClassTriggers):void {
			var n:uint = list.length;
			for (var i:uint = 0; i < n; i++) {
				var styleDef:StyleDefinition = StyleDefinition(list.get(i));
				if (normalTriggers.isStyleActiveNormal(styleDef.normalTriggers) && global.isStyleActiveGlobal(styleDef.normalTriggers)) {
					var rules:Object = styleDef.rulesArray;
					for (var key:String in rules) {
						applyStyle(key, rules[key]);
					}
				}
			}
		}


		private function applyStyle(prop:String, val:Object):void {
			// TODO implement function
			switch (prop) {
				case 'hitbox-width':
					collBox.width = Number(val);
					break;
				case 'hitbox-height':
					collBox.height = Number(val);
					break;
			}
			TESTdrawBox();
		}


		private function TESTdrawBox():void {
			// for testing purposes:
			graphics.clear();
			graphics.beginFill(0x00CC00);
			graphics.drawRect(collBox.x, collBox.y, collBox.width, collBox.height);
			graphics.endFill();
		}


		/**
		 * Animates the GameObject. This not only includes switching to the next frame
		 * in an animation, but also moving the object to the appropriate location.
		 */
		public function updateView():void {
			x = newX;
			y = newY;

			//TODO update visuals based on styles and animation sequences
		}


		public function get isStatic():Boolean {
			return _static;
		}
	}
}
