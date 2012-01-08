package org.interguild.levels.objects {

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.interguild.pages.GamePage;
	import org.interguild.utils.Comparable;

	public class CollisionResolution implements Comparable {

		private var obj1:GameObject;
		private var obj2:GameObject;
		private var oldBox1:Rectangle;
		private var oldBox2:Rectangle;
		private var newBox1:Rectangle;
		private var newBox2:Rectangle;
		private var side1:uint;
		private var side2:uint;

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
			 * [!remembers][!isValid][!isSolid][deadly][proximity]
			 */
			if (!isValid(newBox1, newBox2))
				precedence = 8; // binary: 1000
			if (!obj1.remembers(obj2))
				precedence += 4; // binary: 0100
			if (!checkSolid(side1, side2))
				precedence += 2; // binary: 0010
			if (isDeadly())
				precedence += 1; // binary: 0010
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
//			if (curBox1.intersects(curBox2)) { // valid collision
			if (isValid(curBox1, curBox2)) {
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

//				if (obj1.normalTriggers.getCrawling())
//					with (GamePage.instance.graphics) {
//						clear();
//						//prev position for obj1
//						beginFill(0x00CCCC);
//						drawRect(oldBox1.x, oldBox1.y, oldBox1.width, oldBox1.height);
//						endFill();
//						//where obj1 was trying to go
//						beginFill(0xCCCC00);
//						drawRect(newBox1.left, newBox1.top, newBox1.width, newBox1.height);
//						endFill();
//						//new position for obj1
//						beginFill(0xCC0000);
//						drawRect(curBox1.x, curBox1.y, curBox1.width, curBox1.height);
//						endFill();
//						//obj2's bottom edge
//						beginFill(0xFFFFFF);
//						drawRect(oldBox2.left, oldBox2.bottom, oldBox2.width, 1);
//						endFill();
//					}

				//collide on bottom
				if (side1 != 0xF) {
					checkSolid(side1, side2, curBox1, curBox2);
					if (!obj1.isStatic)
						obj1.collidedWith(obj2);
				}

				if (obj2.collEffectLadder)
					obj1.normalTriggers.setOnLadder();
				if (obj2.collEffectWater)
					obj1.normalTriggers.setUnderwater();
			} else if (wasValid()) { // would've been a valid collision
				if (side1 != 0xF && checkSolid(side1, side2)) {
					if (side1 == 2 && curBox1.bottom == curBox2.top) {
						obj2.normalTriggers.setStandingUp();
						if (obj2.isStatic)
							obj2.markToUpdate();
						if (!obj1.isStatic)
							obj1.addtoStandingList(obj2, side2);
					} else if (side1 == 0 && curBox1.top == curBox2.bottom) {
						obj2.normalTriggers.setStandingDown();
						if (obj2.isStatic)
							obj2.markToUpdate();
						if (!obj1.isStatic)
							obj1.addtoStandingList(obj2, side2);
					} else if (side1 == 1 && curBox1.right == curBox2.left) {
						obj2.normalTriggers.setStandingLeft();
						if (obj2.isStatic)
							obj2.markToUpdate();
						if (!obj1.isStatic)
							obj1.addtoStandingList(obj2, side2);
					} else if (side1 == 3 && curBox1.left == curBox2.right) {
						obj2.normalTriggers.setStandingRight();
						if (obj2.isStatic)
							obj2.markToUpdate();
						if (!obj1.isStatic)
							obj1.addtoStandingList(obj2, side2);
					}
				}
			}
		}


		/**
		 * Returns true if obj1 and obj2 are in collision with one another, based on
		 * the current coordinates.
		 *
		 * This function also calculates which side the collisions came from.
		 */
		private function isValid(curBox1:Rectangle, curBox2:Rectangle, optimize:Boolean = false):Boolean {
			if (curBox1.intersects(curBox2)) {
				side1 = getSide(curBox1, curBox2);
				side2 = getOtherSide();
				return true;
			} else {
				var yCollA:Boolean = hasYCollision(oldBox1, oldBox2);
				var xCollA:Boolean = hasXCollision(oldBox1, oldBox2);
				var yCollB:Boolean = hasYCollision(curBox1, curBox2);
				var xCollB:Boolean = hasXCollision(curBox1, curBox2);

				if ((yCollA && xCollB) || (xCollA && yCollB)) {
					side1 = getSide2(curBox1, curBox2);
					side2 = getOtherSide();
					return side1 != 0xF;
				} else
					return false;
			}
		}


		private function getOtherSide():uint {
			switch (side1) {
				case 0:
					return 2;
					break;
				case 1:
					return 3;
					break;
				case 2:
					return 0;
					break;
				case 3:
					return 1;
					break;
				default:
					return 0xF;
					break;
			}
		}


		private function hasYCollision(box1:Rectangle, box2:Rectangle):Boolean {
			box1 = box1.clone();
			box2 = box2.clone();
			box1.x = box2.x;
			box1.width = box2.width;
			return box1.intersects(box2);
		}


		private function hasXCollision(box1:Rectangle, box2:Rectangle):Boolean {
			box1 = box1.clone();
			box2 = box2.clone();
			box1.y = box2.y;
			box1.height = box2.height;
			return box1.intersects(box2);
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
		 * Checks to see if obj1 and obj2 are solid to each other, and then resolves the collision.
		 *
		 * Include curBox1 and curBox2 into the paramateters to have the function resolve the collisions.
		 * Ignore these parameters if you only want a true/false result of whether or not the collision
		 * will be solid.
		 */
		private function checkSolid(obj1Side:uint, obj2Side:uint, curBox1:Rectangle = null, curBox2:Rectangle = null):Boolean {
			var obj1Wall:uint = obj1.collEdgesSolidity[obj1Side];
			var obj2Wall:uint = obj2.collEdgesSolidity[obj2Side];

			if (obj1Wall == GameObject.NO_WALL || obj2Wall == GameObject.NO_WALL)
				return false;
			//TODO add pseudo-wall and pseudo-ladder
			//ladder issues
			if ((obj2Wall == GameObject.SOLID_LADDER && obj1.isLadderUser) || (obj1Wall == GameObject.SOLID_LADDER && obj2.isLadderUser))
				return false;

			if (curBox1 == null)
				return true;


			//test for buffers
			if ((precedence & 2) == 2) { // binary: 010, then !obj1.remembers(obj2)
				if (obj1Side == 0 || obj1Side == 2) {
					//left buffer
					if (curBox1.right < curBox2.left + obj2.collEdgesBuffer[3] && curBox1.right > curBox2.left) {
						obj1.newX += curBox2.left - curBox1.right;
						trace("left buffer");
						return false;
					}
					//right buffer
					if (curBox1.left > curBox2.right - obj2.collEdgesBuffer[1] && curBox1.left < curBox2.right) {
						obj1.newX += curBox2.right - curBox1.left;
						trace("right buffer");
						return false;
					}
				} else {
					//top buffer
					if (curBox1.bottom < curBox2.top + obj2.collEdgesBuffer[0] && curBox1.bottom > curBox2.top) {
						obj1.newY += curBox2.top - curBox1.bottom;
						obj2.color += 0xFF;
						obj2.TESTdrawBox();
						trace("top buffer");
						return false;
					}
					//bottom buffer
					if (curBox1.top > curBox2.bottom - obj2.collEdgesBuffer[2] && curBox1.top < curBox2.bottom) {
						obj1.newY += curBox2.bottom - curBox1.top;
						obj2.color += 0xFF;
						obj2.TESTdrawBox();
						trace("bottom buffer");
						return false;
					}
				}
			}

			//resolve collision
			if (obj1.allowStateChange)
				obj1.isStatic = true;
			obj1.setStanding(obj1Side, obj1.isStatic);
			obj2.setStanding(obj2Side, obj1.isStatic);
			if (obj2.isStatic)
				obj2.markToUpdate();
			if (obj1.isStatic)
				obj1.markToUpdate();
			else
				obj1.addtoStandingList(obj2, obj2Side);
			switch (obj1Side) {
				case 0:
					obj1.newY += curBox2.bottom - curBox1.top + obj2.collEdgesRecoil[2];
					obj1.currentSpeedY = obj2.collEdgesBounce[2];
					break;
				case 2:
					obj1.newY += curBox2.top - curBox1.bottom - obj2.collEdgesRecoil[0];
					obj1.currentSpeedY = -obj2.collEdgesBounce[0];
					break;
				case 3:
					obj1.newX += curBox2.right - curBox1.left + obj2.collEdgesRecoil[1];
					obj1.currentSpeedX = obj2.collEdgesBounce[1];
					break;
				case 1:
					obj1.newX += curBox2.left - curBox1.right - obj2.collEdgesRecoil[3];
					obj1.currentSpeedX = -obj2.collEdgesBounce[3];
					break;
			}
			return true;
		}


		/**
		 * Returns the direction in which obj1 has collided with obj2.
		 * This function compares the object's previous position with
		 * its most up-to-date position.
		 *
		 * Returns one of the directional values stored in GameObject's
		 * static variable, or if no valid direction was dedected, 0xF
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
					y = getYatIntersection(oldBox1.bottomRight, curBox1.bottomRight, curBox2.left);
					if (y <= curBox2.top)
						return 2;
					else
						return 1;
				} else if (left) {
					y = getYatIntersection(new Point(oldBox1.left, oldBox1.bottom), new Point(curBox1.left, curBox1.bottom), curBox2.right);
					if (y <= curBox2.top)
						return 2;
					else
						return 3;
				} else {
					return 2;
				}
			} else if (top) {
				if (right) {
					y = getYatIntersection(new Point(oldBox1.right, oldBox1.top), new Point(curBox1.right, curBox1.top), curBox2.left);
					if (y >= curBox2.bottom)
						return 0;
					else
						return 1;
				} else if (left) {
					y = getYatIntersection(oldBox1.topLeft, curBox1.topLeft, curBox2.right);
					if (y >= curBox2.bottom)
						return 0;
					else
						return 3;
				} else {
					return 0;
				}
			} else if (right) {
				return 1;
			} else if (left) {
				return 3;
			}
			return 0xF;
		}


		private function getSide2(curBox1:Rectangle, curBox2:Rectangle):uint {
			var y:Number;

			//bottom
			if (oldBox1.bottom <= oldBox2.top && curBox1.bottom > curBox2.top) {
				if (curBox1.left > oldBox1.left) { //right
					y = getYatIntersection(new Point(oldBox1.left, oldBox1.bottom), new Point(curBox1.left, curBox1.bottom), curBox2.right);
					if (y >= curBox2.top)
						return 2;
					else
						return 0xF;
				} else if (curBox1.right < oldBox1.right) { //left
					y = getYatIntersection(oldBox1.bottomRight, curBox1.bottomRight, curBox2.left);
					if (y >= curBox2.top)
						return 2;
					else
						return 0xF;
				} else {
					return 0xF;
				}
					//top
			} else if (oldBox1.top >= oldBox2.bottom && curBox1.top < curBox2.bottom) {
				if (curBox1.left > oldBox1.left) { //right
					y = getYatIntersection(oldBox1.topLeft, curBox1.topLeft, curBox2.right);
					if (y <= curBox2.bottom)
						return 0;
					else
						return 0xF;
				} else if (curBox1.right < oldBox1.right) { //left
					y = getYatIntersection(new Point(oldBox1.right, oldBox1.top), new Point(curBox1.right, curBox1.top), curBox2.left);
					if (y <= curBox2.bottom)
						return 0;
					else
						return 0xF;
				} else {
					return 0xF;
				}
					//right
			} else if (oldBox1.right <= oldBox2.left && curBox1.right > curBox2.left) {
				if (curBox1.top > oldBox1.top) { //down
					y = getYatIntersection(new Point(oldBox1.right, oldBox1.top), new Point(curBox1.right, curBox1.top), curBox2.left);
					if (y <= curBox2.bottom)
						return 1;
					else
						return 0xF;
				} else if (curBox1.bottom < oldBox1.bottom) { //up
					y = getYatIntersection(oldBox1.bottomRight, curBox1.bottomRight, curBox2.left);
					if (y >= curBox2.top)
						return 1;
					else
						return 0xF;
				} else {
					return 0xF;
				}
					//left
			} else if (oldBox1.left >= oldBox2.right && curBox1.left < curBox2.right) {
				if (curBox1.top > oldBox1.top) { //down
					y = getYatIntersection(oldBox1.topLeft, curBox1.topLeft, curBox2.right);
					if (y <= curBox2.bottom)
						return 3;
					else
						return 0xF;
				} else if (curBox1.bottom < oldBox1.bottom) { //up
					y = getYatIntersection(new Point(oldBox1.left, oldBox1.bottom), new Point(curBox1.left, curBox1.bottom), curBox2.right);
					if (y >= curBox2.top)
						return 3;
					else
						return 0xF;
				} else {
					return 0xF;
				}
			}
			return 0xF;
		}


		private function getYatIntersection(prevPoint:Point, nextPoint:Point, x:Number):Number {
			return ((nextPoint.y - prevPoint.y) / (nextPoint.x - prevPoint.x)) * (x - nextPoint.x) + nextPoint.y;
		}
	}
}
