package org.interguild.levels.objects {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import org.interguild.levels.objects.styles.DynamicTriggers;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;
	import org.interguild.levels.objects.styles.StyleDefinition;
	import org.interguild.utils.Comparable;
	import org.interguild.utils.LinkedList;
	import org.interguild.utils.OrderedList;

	/**
	 * GameObject represents any object in the games, such as tiles, players, enemies, etc.
	 */
	public class GameObject extends Sprite implements Comparable {


		public static var NO_WALL:uint = 0x0; //anything can pass through boundaries
		public static var SOLID_WALL:uint = 0x1; //nothing can pass through boundaries
		public static var PSEUDO_WALL:uint = 0x2; //only arrows and dynamite may pass through boundaries
		public static var SOLID_LADDER:uint = 0x3; //only ladder users may pass through boundaries
		public static var PSEUDO_LADDER:uint = 0x4; //only ladder users, arrows, and dynamite may pass through boundaries

		public static var UP:uint = 0x0;
		public static var RIGHT:uint = 0x1;
		public static var DOWN:uint = 0x2;
		public static var LEFT:uint = 0x3;
		/**
		 * This is set to the Level.state of whichever level is currently in focus.
		 */
		public static var LEVEL_STATE:PseudoClassTriggers;

		/**
		 * This is a list of static objects that need to have their styles updated.
		 */
		public static var TO_UPDATE:LinkedList = new LinkedList();
		private var toUpdateMarked:Boolean;
		private var stylesInitialized:Boolean;

		private var def:GameObjectDefinition;
		private var classes:LinkedList;
		internal var normalTriggers:PseudoClassTriggers;
		internal var dynamicTriggers:DynamicTriggers;

		//for collision detection
		internal var newX:Number = 0;
		internal var newY:Number = 0;
		internal var currentSpeedX:Number = 0;
		internal var currentSpeedY:Number = 0;
		private var maxSpeedX:Number = 0;
		private var maxSpeedY:Number = 0;
		private var accX:Number = 0;
		private var accY:Number = 0;

		private var collBox:Rectangle;
		private var oldCollBox:Rectangle;
		internal var collEdgesSolidity:Array;
		internal var standingNums:Array;
		private var dynStandingList:LinkedList;
		internal var isLadderUser:Boolean;

		private var _static:Boolean;
		internal var allowStateChange:Boolean;
		private var collideable:Boolean;

		private var gridsOccupied:LinkedList;
		private var collMemory:LinkedList;
		private var resolutions:OrderedList;

		/**
		 * tracks whether or not this object has been collision-tested during this loop.
		 */
		public var tested:Boolean = false;


		public function GameObject(god:GameObjectDefinition, posX:Number, posY:Number) {
			x = newX = posX;
			y = newY = posY;

			// initialize stuff
			gridsOccupied = new LinkedList();
			classes = new LinkedList();
			collMemory = new LinkedList();
			dynStandingList = new LinkedList();
			normalTriggers = new PseudoClassTriggers();
			dynamicTriggers = new DynamicTriggers();

			//set defaults:
			isStatic = true;
			collideable = true;
			collBox = new Rectangle(0, 0, 31, 31);
			collEdgesSolidity = [0, 0, 0, 0];
			standingNums = [0, 0, 0, 0];
			allowStateChange = true;
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


		public function get oldHitbox():Rectangle {
			return oldCollBox.clone();
		}


		public function get isCollideable():Boolean {
			return collideable;
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
		 * This is called by LevelArea, when any state changes have been confirmed.
		 */
		public function resetSpeed():void{
			currentSpeedX = currentSpeedY = 0;
		}


		/**
		 * Adds the GridElement to this GameObject's internal list of grid tiles
		 * that it is currently in. GameObject will use this list to keep track
		 * of which grids need to be updated when the tile changes state.
		 */
		public function addGrid(g:GridElement):void {
			gridsOccupied.add(g);
		}


		/**
		 * If this instance is a dynamic object, it must clear its grids on every
		 * game loop.
		 */
		public function clearGrids():void {
			gridsOccupied.clear();
			tested = false;
			resolutions = new OrderedList();
		}


		/**
		 * Returns a list of all of the grids that this GameObject is located in.
		 */
		public function get listGrids():LinkedList {
			return gridsOccupied;
		}


		/**
		 * Adds the input GameObject to this object's list of collisions from the
		 * past frame.
		 */
		public function collidedWith(obj2:GameObject):void {
			collMemory.add(obj2);
		}


		public function remembers(obj2:GameObject):Boolean {
			return collMemory.contains(obj2);
		}


		/**
		 * Adds the collision resolution to this GameObject's list of possible
		 * collision results, and updates this object's priority level for
		 * when its collisions should be implemented.
		 */
		public function addResolution(r:CollisionResolution):void {
			resolutions.add(r);
		}


		/**
		 * Iterates through all CollisionResolution objects, in order of priority,
		 * and implements their changes if they are valid.
		 */
		public function resolveCollisions():void {
			collMemory.clear();
			var n:uint = resolutions.length;
			for (var i:uint = 0; i < n; i++) {
				CollisionResolution(resolutions.get(i)).applyResolution();
			}
		}


		/**
		 * This function should only be called if this is a dynamic object.
		 * This helps the dynamic object record which standing events it has
		 * caused recently so that when it moves away from the object, it may
		 * undo those events.
		 */
		public function addtoStandingList(ref:GameObject, direction:uint):void {
			dynStandingList.add([ref, direction]);
		}


		/**
		 * Clears this dynamic object's list of tiles that it's standing on.
		 */
		public function clearStandingList():void {
			if (dynStandingList.isEmpty())
				return;
			dynStandingList.beginIteration();
			while (dynStandingList.hasNext()) {
				var a:Array = dynStandingList.next as Array;
				var o:GameObject = a[0] as GameObject;
				if (o.standingNums[a[1]] == 0) {
					switch (a[1]) {
						case UP:
							o.normalTriggers.setStandingUp(false);
							break;
						case RIGHT:
							o.normalTriggers.setStandingRight(false);
							break;
						case DOWN:
							o.normalTriggers.setStandingDown(false);
							break;
						case LEFT:
							o.normalTriggers.setStandingLeft(false);
							break;
					}
					o.markToUpdate();
				}
			}
			dynStandingList.clear();
		}


		/**
		 * Updates the appropriate pseudo-classes, and if the object is dynamic,
		 * will make the object static.
		 *
		 * @param direction:uint Use GameObject.TOP, GameObject.RIGHT, GameObject.LEFT,
		 * or GameObject.BOTTOM.
		 * @param fromStatic:Boolean Set true if the object marking this is static as a
		 * result of this collision.
		 */
		internal function setStanding(direction:uint, fromStatic:Boolean):void {
			switch (direction) {
				case UP:
					normalTriggers.setStandingUp();
					break;
				case RIGHT:
					normalTriggers.setStandingRight();
					break;
				case DOWN:
					normalTriggers.setStandingDown();
					break;
				case LEFT:
					normalTriggers.setStandingLeft();
					break;
				default:
					new Error("Invalid Arguments");
					break;
			}
			if (fromStatic)
				standingNums[direction]++;
		}


		public function clearStandings():void {
			normalTriggers.setStandingDown(false);
			normalTriggers.setStandingLeft(false);
			normalTriggers.setStandingRight(false);
			normalTriggers.setStandingUp(false);
		}


		/**
		 * Adds this object to the list of those pending to have their styles updated.
		 */
		public function markToUpdate():void {
			if (!toUpdateMarked) {
				TO_UPDATE.add(this);
				toUpdateMarked = true;
			}
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
		public function updateStyles(init:Boolean = false):void {
			if (init || normalTriggers.hasChanged() || dynamicTriggers.hasChanged() || LEVEL_STATE.hasChanged()) {
				applyStyles(def);
				classes.beginIteration();
				while (classes.hasNext()) {
					applyStyles(GameObjectDefinition(classes.next));
				}
				stylesInitialized = true;
			}
			toUpdateMarked = false;
			normalTriggers.update();
			dynamicTriggers.update();
		}


		/**
		 * Applies the specified style definition and all of its ancestor definitions recursively.
		 * The ancestors are applied in the correct order so that their descendants may overwrite
		 * their effects.
		 */
		private function applyStyles(god:GameObjectDefinition):void {
			if (god == null)
				return;

			applyStyles(god.ancestor);

			applyStylesList(god.normalStylesList);
			applyStylesList(god.dynamicStylesList);
		}


		private function applyStylesList(list:OrderedList):void {
			var n:uint = list.length;
			for (var i:uint = 0; i < n; i++) {
				var styleDef:StyleDefinition = StyleDefinition(list.get(i));
				if (normalTriggers.isStyleActiveNormal(styleDef.normalTriggers) && LEVEL_STATE.isStyleActiveGlobal(styleDef.normalTriggers)) {
					var rules:Object = styleDef.rulesArray;
					for (var key:String in rules) {
						applyStyle(key, rules[key], styleDef);
					}
				}
			}
		}


		private function applyStyle(prop:String, val:Object, styleDef:StyleDefinition):void {
			// TODO implement function
			switch (prop) {
				case 'hitbox-width':
					collBox.width = Number(val) - 1;
					break;
				case 'hitbox-height':
					collBox.height = Number(val) - 1;
					break;
				case "hitbox-offset-x":
					collBox.x = Number(val);
					break;
				case "hitbox-offset-y":
					collBox.y = Number(val);
					break;
				case 'init-state':
					if (!stylesInitialized)
						isStatic = val;
					break;
				case 'set-state':
					isStatic = val;
					break;
				case 'allow-state-change':
					allowStateChange = val;
					break;
				case 'allow-collisions':
					collideable = val;
					break;
				case "can-use-ladder":
					isLadderUser = val;
					break;
				case "coll-edge-solidity":
					collEdgesSolidity[0] = collEdgesSolidity[1] = collEdgesSolidity[2] = collEdgesSolidity[3] = val;
					break;
				case "coll-edge-top-solidity":
					collEdgesSolidity[0] = val;
					break;
				case "coll-edge-right-solidity":
					collEdgesSolidity[1] = val;
					break;
				case "coll-edge-bottom-solidity":
					collEdgesSolidity[2] = val;
					break;
				case "coll-edge-left-solidity":
					collEdgesSolidity[3] = val;
					break;
			}
		}


		public var color:uint = 0x00CC00;


		private function TESTdrawBox():void {
			if (normalTriggers.getMoveRight())
				color = 0xCC0000; // TESTING
			else
				color = 0x00CC00;

			// for testing purposes:
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(collBox.x, collBox.y, collBox.width, collBox.height);
			graphics.endFill();
		}


		/**
		 * Goes through all collision grid elements that this is in and tells them to
		 * switch this tile to their list of either static or dynamic states.
		 */
		public function switchGridStates():void {
			gridsOccupied.beginIteration();
			while (gridsOccupied.hasNext()) {
				var g:GridElement = GridElement(gridsOccupied.next);
				if (_static) {
					g.addStatic(this);
				} else {
					g.removeStatic(this);
					g.addDynamic(this);
				}
			}
		}


		/**
		 * Animates the GameObject. This not only includes switching to the next frame
		 * in an animation, but also moving the object to the appropriate location.
		 */
		public function updateView():void {
			x = newX;
			y = newY;
			oldCollBox = hitbox;

			TESTdrawBox();
			//TODO update visuals based on styles and animation sequences
		}


		public function get isStatic():Boolean {
			return _static;
		}


		public function set isStatic(b:Boolean):void {
			if (b != _static) {
				_static = b;
				normalTriggers.setStatic(b);
			}
		}


		public function compareTo(other:Comparable):int {
			return 0;
		}


		public override function toString():String {
			var res:String = def.id;
			classes.beginIteration();
			while (classes.hasNext()) {
				res += GameObjectDefinition(classes.next).id;
			}
			return res + "[x:" + x + " y:" + y + "]";
		}
	}
}
