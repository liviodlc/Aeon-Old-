package org.interguild.levels.objects {

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.interguild.utils.Comparable;

	public class CollisionResolution implements Comparable {

		private var obj1:GameObject;
		private var obj2:GameObject;
		private var oldBox1:Rectangle;
		private var oldBox2:Rectangle;
		private var newBox1:Rectangle;
		private var newBox2:Rectangle;

		private var precedence:uint;
		private var proximity:uint;


		public function CollisionResolution(obj1:GameObject, obj2:GameObject) {
			this.obj1 = obj1;
			this.obj2 = obj2;
			oldBox1 = obj1.oldHitbox;
			oldBox2 = obj2.oldHitbox;
			newBox1 = obj1.hitbox;
			newBox2 = obj2.hitbox;
			/*
			 * priority:
			 * 	always do valid collisions first
			 * 	if they collided in the previous frame, do those next
			 * 	then based on proximity
			 * 	leave deadly ones for last
			 * [!isValid][!remembers][deadly][proximity]
			 */
			if (!isValid())
				precedence = 0x4; // binary: 100
			if (!obj1.remembers(obj2))
				precedence += 0x2; // binary: 010
			if (isDeadly())
				precedence += 0x1; // binary: 001
			proximity = getProximity();
		}


		/**
		 * Returns a positive number if 'this' yeilds less precendence than
		 * the 'other' CollisionResolution.
		 */
		public function compareTo(other:Comparable):int {
			var that:CollisionResolution = CollisionResolution(other);
			var result:int = this.precedence - that.precedence;
			if (result == 0)
				return this.proximity - that.proximity;
			return result;
		}


		public function applyResolution():void {
//			trace(obj1 + " || " + obj2);
//			trace(v + "\n	" + oldBox1 + "	" + oldBox2 + "\n	" + newBox1 + "	" + newBox2);

			var curBox1:Rectangle = obj1.hitbox;
			var curBox2:Rectangle = obj2.hitbox;
			if (curBox1.intersects(curBox2)) { // valid collision
				/*
				check for lethality
					coll-edge-lathality, coll-edge-strength, proj-trigger
				check for solid borders
					this will determind standing states and cause movment
					coll-edge-recoil, coll-edge-bounce, coll-edge-bounce-lag, coll-edge-platform, boulder-push
					allow-state-change, change-to-static-delay, change-to-nonstatic-delay
					allow-auto-crawl
				check collision effects
					coll-effect, coll-edge-air, coll-edge-gem, coll-edge-points
				*/

//				obj2.color = 0xCC0000; // TESTING
				//collide on bottom
				var side:uint = getSide(curBox1, curBox2);
				if (side == GameObject.DOWN) {
					if (obj2.isStatic) {
						if (obj1.allowStateChange)
							obj1.isStatic = true;
						obj1.setStanding(GameObject.DOWN, obj1.isStatic);
						obj2.setStanding(GameObject.UP, obj1.isStatic);
						obj2.markToUpdate();
						if (obj1.isStatic)
							obj1.markToUpdate();
						else
							obj1.addtoStandingList(obj2, GameObject.UP);
						obj1.newY += curBox2.top - curBox1.bottom;
						obj1.currentSpeedY = 0;
					}
				} else if (side == GameObject.UP) {
					if (obj2.isStatic) {
						if (obj1.allowStateChange)
							obj1.isStatic = true;
						obj1.setStanding(GameObject.UP, obj1.isStatic);
						obj2.setStanding(GameObject.DOWN, obj1.isStatic);
						obj2.markToUpdate();
						if (obj1.isStatic)
							obj1.markToUpdate();
						else
							obj1.addtoStandingList(obj2, GameObject.DOWN);
						obj1.newY += curBox2.bottom - curBox1.top;
						obj1.currentSpeedY = 0;
					}
				} else if (side == GameObject.RIGHT) {
					if (obj2.isStatic) {
						if (obj1.allowStateChange)
							obj1.isStatic = true;
						obj1.setStanding(GameObject.RIGHT, obj1.isStatic);
						obj2.setStanding(GameObject.LEFT, obj1.isStatic);
						obj2.markToUpdate();
						if (obj1.isStatic)
							obj1.markToUpdate();
						else
							obj1.addtoStandingList(obj2, GameObject.LEFT);
						obj1.newX += curBox2.left - curBox1.right;
						obj1.currentSpeedX = 0;
					}
				} else if (side == GameObject.LEFT) {
					if (obj2.isStatic) {
						if (obj1.allowStateChange)
							obj1.isStatic = true;
						obj1.setStanding(GameObject.LEFT, obj1.isStatic);
						obj2.setStanding(GameObject.RIGHT, obj1.isStatic);
						obj2.markToUpdate();
						if (obj1.isStatic)
							obj1.markToUpdate();
						else
							obj1.addtoStandingList(obj2, GameObject.RIGHT);
						obj1.newX += curBox2.right - curBox1.left;
						obj1.currentSpeedX = 0;
					}
				}
				if (!obj1.isStatic)
					obj1.collidedWith(obj2);
			} else if (wasValid()) { // would've been a valid collision
				// collide on bottom
				if (oldBox1.bottom <= oldBox2.top && newBox1.bottom > newBox2.top) {
					if (curBox1.bottom == curBox2.top) {
						obj2.normalTriggers.setStandingUp();
						obj2.markToUpdate();
					}
				}
			}
		}


		private function isValid():Boolean {
			return obj1.hitbox.intersects(obj2.hitbox);
		}


		private function wasValid():Boolean {
			return newBox1.intersects(newBox2);
		}


		private function isDeadly():Boolean {
			//TODO
			return false;
		}


		private function getProximity():Number {
			var resultY:Number, resultX:Number;

			resultY = abs(oldBox1.top - oldBox2.top);
			resultY = min(resultY, abs(oldBox1.bottom - oldBox2.bottom));

			resultX = abs(oldBox1.left - oldBox2.left);
			resultX = min(resultY, abs(oldBox1.right - oldBox2.right));

			return Math.sqrt((resultY * resultY) + (resultX * resultX));
		}


		/**
		 * Absolute Value
		 */
		private function abs(n:Number):Number {
			if (n < 0)
				return -n;
			return n;
		}


		private function min(n1:Number, n2:Number):Number {
			if (n1 < n2)
				return n1;
			return n2;
		}


		/**
		 * Returns the direction in which obj1 has collided with obj2.
		 * This function compares the object's previous position with
		 * its most up-to-date position.
		 *
		 * Returns one of the directional values stored in GameObject's
		 * static variable, or if no valid direction was dedected, zero
		 * is returned.
		 */
		private function getSide(curBox1:Rectangle, curBox2:Rectangle):uint {
			var bottom:Boolean = false;
			var right:Boolean = false;
			var left:Boolean = false;
			var top:Boolean = false;
			var y:Number;

			// initial tests
			if (oldBox1.bottom <= oldBox2.top && curBox1.bottom > curBox2.top)
				bottom = true;
			if (oldBox1.right <= oldBox2.left && curBox1.right > curBox2.left)
				right = true;
			if (oldBox1.left >= oldBox2.right && curBox1.left < curBox2.right)
				left = true;
			if (oldBox1.top >= oldBox2.bottom && curBox1.top < curBox2.bottom)
				top = true;

			// resolve inaccuracies
			if (bottom) {
				if (right) {
					y = getYatIntersection(curBox1, curBox2, curBox2.left);
					if (y <= curBox2.top)
						return GameObject.DOWN;
					else
						return GameObject.RIGHT;
				} else if (left) {
					y = getYatIntersection(curBox1, curBox2, curBox2.right);
					if (y <= curBox2.top)
						return GameObject.DOWN;
					else
						return GameObject.LEFT;
				} else {
					return GameObject.DOWN;
				}
			} else if (top) {
				if (right) {
					y = getYatIntersection(curBox1, curBox2, curBox2.left);
					if (y >= curBox2.bottom)
						return GameObject.UP;
					else
						return GameObject.RIGHT;
				} else if (left) {
					y = getYatIntersection(curBox1, curBox2, curBox2.right);
					if (y >= curBox2.bottom)
						return GameObject.UP;
					else
						return GameObject.LEFT;
				} else {
					return GameObject.UP;
				}
			} else if (right) {
				return GameObject.RIGHT;
			} else if (left) {
				return GameObject.LEFT;
			}
			return 0;
		}


		private function getYatIntersection(curBox1:Rectangle, curBox2:Rectangle, x:Number):Number {
			return ((curBox1.y - oldBox1.y) / (curBox1.x - oldBox1.x)) * (x - curBox1.x) + curBox1.y;
		}
	}
}
