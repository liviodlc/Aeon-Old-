package org.interguild.levels.objects {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import org.interguild.levels.objects.styles.DynamicTriggers;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;
	import org.interguild.levels.objects.styles.StyleDefinition;
	import org.interguild.levels.objects.styles.TriggerTracker;
	import org.interguild.utils.Comparable;
	import org.interguild.utils.LinkedList;
	import org.interguild.utils.OrderedList;

	/**
	 * GameObject represents any object in the games, such as tiles, players, enemies, etc.
	 */
	public class GameObject extends Sprite implements Comparable {


		public static var NO_WALL:uint = 0; //anything can pass through boundaries
		public static var SOLID_WALL:uint = 1; //nothing can pass through boundaries
		public static var PSEUDO_WALL:uint = 2; //only arrows and dynamite may pass through boundaries
		public static var SOLID_LADDER:uint = 3; //only ladder users may pass through boundaries
		public static var PSEUDO_LADDER:uint = 4; //only ladder users, arrows, and dynamite may pass through boundaries

		public static var UP:uint = 1;
		public static var RIGHT:uint = 2;
		public static var DOWN:uint = 3;
		public static var LEFT:uint = 4;
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
		private var maxSpeed:Array;
		private var friction:Array;
		private var accX:Number = 0;
		private var accY:Number = 0;
		internal var canJump:Boolean;
		internal var jumpLimit:int;
		internal var numJumps:int;
		internal var isLadderUser:Boolean;

		private var collBox:Rectangle;
		private var oldCollBox:Rectangle;
		internal var collEdgesSolidity:Array;

		internal var standingNums:Array;
		private var dynStandingList:LinkedList;

		private var _static:Boolean;
		internal var allowStateChange:Boolean;
		private var collideable:Boolean;

		private var gridsOccupied:LinkedList;
		private var collMemory:LinkedList;
		private var resolutions:OrderedList;

		private var checkpoints:LinkedList;

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
			checkpoints = new LinkedList();
			normalTriggers = new PseudoClassTriggers();
			dynamicTriggers = new DynamicTriggers();

			//set defaults:
			isStatic = true;
			collideable = true;
			collBox = new Rectangle(0, 0, 31, 31);
			collEdgesSolidity = [0, 0, 0, 0];
			standingNums = [0, 0, 0, 0];
			maxSpeed = [0, 0, 0, 0];
			friction = [0, 0, 0, 0];
			allowStateChange = true;

			def = god;
			if (def.behavior != null)
				def.behavior.add(this);
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

			// update horizontal speed
			if (accX == 0) { // if not accelerating, then decelerate
				if (currentSpeedX > 0) {
					currentSpeedX += friction[RIGHT];
					if (currentSpeedX < 0)
						currentSpeedX = 0;
				} else if (currentSpeedX < 0) {
					currentSpeedX += friction[LEFT];
					if (currentSpeedX > 0)
						currentSpeedX = 0;
				}
			} else { // else, accelerate
				currentSpeedX += accX;
			}
			// update vertical speed
			if (accY == 0) { // if not accelerating, then decelerate
				if (currentSpeedY > 0) {
					currentSpeedY += friction[DOWN];
					if (currentSpeedY < 0)
						currentSpeedY = 0;
				} else if (currentSpeedY < 0) {
					currentSpeedY += friction[UP];
					if (currentSpeedY > 0)
						currentSpeedY = 0;
				}
			} else { // else, accelerate
				currentSpeedY += accY;
			}

			// check horizontal max speeds
			if (maxSpeed[RIGHT] != 0 && currentSpeedX > 0 && currentSpeedX > maxSpeed[RIGHT])
				currentSpeedX = maxSpeed[RIGHT];
			else if (maxSpeed[LEFT] != 0 && currentSpeedX < 0 && currentSpeedX < maxSpeed[LEFT])
				currentSpeedX = maxSpeed[LEFT];
			// check vertical max speeds
			if (maxSpeed[DOWN] != 0 && currentSpeedY > maxSpeed[DOWN])
				currentSpeedY = maxSpeed[DOWN];
			else if (maxSpeed[UP] != 0 && currentSpeedY < maxSpeed[UP])
				currentSpeedY = maxSpeed[UP];

			// update positions
			newX += currentSpeedX;
			newY += currentSpeedY;
		}


		/**
		 * This is called by LevelArea, when any state changes have been confirmed.
		 */
		public function resetSpeed():void {
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
		 * The initialization also records to see which triggers this object is
		 * looking for.
		 */
		public function updateStyles(init:Boolean = false):void {
			if (init || normalTriggers.hasChanged() || dynamicTriggers.hasChanged() || LEVEL_STATE.hasChanged(true)) {
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
				if (!stylesInitialized) {
					normalTriggers.track(styleDef.normalTriggers);
				}
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
				case "accelerate-x":
					accX = Number(val);
					break;
				case "accelerate-y":
					accY = Number(val);
					break;
				case "max-speed":
					maxSpeed[RIGHT] = maxSpeed[DOWN] = Number(val);
					maxSpeed[UP] = maxSpeed[LEFT] = -maxSpeed[RIGHT];
					break;
				case "max-speed-up":
					maxSpeed[UP] = Number(val);
					break;
				case "max-speed-down":
					maxSpeed[DOWN] = Number(val);
					break;
				case "max-speed-right":
					maxSpeed[RIGHT] = Number(val);
					break;
				case "max-speed-left":
					maxSpeed[LEFT] = Number(val);
					break;
				case "friction":
					friction[UP] = friction[LEFT] = Number(val);
					friction[RIGHT] = friction[DOWN] = -friction[UP];
					break;
				case "friction-right":
					friction[RIGHT] = Number(val);
					break;
				case "friction-left":
					friction[LEFT] = Number(val);
					break;
				case "friction-up":
					friction[UP] = Number(val);
					break;
				case "friction-down":
					friction[DOWN] = Number(val);
					break;
				case 'init-state':
					if (!stylesInitialized)
						isStatic = val;
					break;
				case 'set-state':
					isStatic = val;
					break;
				case "set-speed-x":
					currentSpeedX = Number(val);
					break;
				case "set-speed-y":
					currentSpeedY = Number(val);
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
				case "allow-jump":
					canJump = val;
					break;
				case "mid-air-jump-limit":
					jumpLimit = Number(val);
					break;
			}
		}


		public var color:uint = 0x00CC00;


		private function TESTdrawBox():void {
			if (this.def.id == "#")
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


		/*
				public static var TO_UPDATE:LinkedList = new LinkedList();
				internal var dynamicTriggers:DynamicTriggers;

				private var resolutions:OrderedList;

				private var checkpoints:LinkedList;
		*/
		/**
		 * Resets all of the object's values to the last checkpoint.
		 */
		public function restart():void {
			checkpoints.beginIteration();
			var check:Object = checkpoints.next;
			var a:Array, n:uint, i:uint;
			for (var key:String in check) {
				switch (key) {
					case "maxSpeed": // arrays
					case "friction":
					case "collEdgesSolidity":
					case "standingNums":
						a = check[key];
						for (i = 0; i < n; i++)
							this[key][i] = a[i];
						break;
					case "collBox": // rectangles
						this[key] = (check[key] as Rectangle).clone();
						break;
					case "dynStandingList": // LinkedList
//					case "gridsOccupied":
					case "collMemory":
						this[key] = (check[key] as LinkedList).clone();
						break;
					case "normalTriggers": // PsuedoClassTriggers
						this.normalTriggers.normalTriggers = check[key];
						// TODO dynamic triggers
						break;
					default:
						this[key] = check[key];
						break;
				}
			}
		}


		/**
		 * Sets a new checkpoint for this object.
		 */
		public function checkpoint():void {
			var check:Object = new Object();
			var a:Array, n:uint, i:uint;
			check["maxSpeed"] = duplicateArray(maxSpeed);
			check["friction"] = duplicateArray(friction);
			check["collEdgesSolidity"] = duplicateArray(collEdgesSolidity);
			check["standingNums"] = duplicateArray(standingNums);
			check["collBox"] = collBox.clone();
			check["dynStandingList"] = dynStandingList.clone();
//			check["gridsOccupied"] = gridsOccupied.clone();
			check["collMemory"] = collMemory.clone();
			check["normalTriggers"] = normalTriggers.normalTriggers;
			check["toUpdateMarked"] = toUpdateMarked;
			check["stylesInitialized"] = stylesInitialized;
			check["newX"] = newX;
			check["newY"] = newY;
			check["currentSpeedX"] = currentSpeedX;
			check["currentSpeedY"] = currentSpeedY;
			check["accX"] = accX;
			check["accY"] = accY;
			check["canJump"] = canJump;
			check["jumpLimit"] = jumpLimit;
			check["numJumps"] = numJumps;
			check["isLadderUser"] = isLadderUser;
			check["_static"] = _static;
			check["allowStateChange"] = allowStateChange;
			check["collideable"] = collideable;

			checkpoints.add(check);
		}


		private function duplicateArray(a:Array):Array {
			var b:Array = new Array(a.length);
			var n:uint = a.length;
			for (var i:uint = 0; i < n; i++)
				b[i] = a[i];
			return b;
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


		public function get aa_id():String {
			return toString();
		}
	}
}
