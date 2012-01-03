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
			var v:Boolean = isValid();
//			trace(v + "\n	" + oldBox1 + "	" + oldBox2 + "\n	" + newBox1 + "	" + newBox2);
			if (v) {

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
				if (oldBox1.bottom <= oldBox2.top && newBox1.bottom > newBox2.top) {
					obj1.normalTriggers.setStandingDown();
					obj2.normalTriggers.setStandingUp();
					if (obj2.isStatic) {
						if (obj1.allowStateChange)
							obj1.isStatic = true;
						obj1.newY = obj2.newY - obj1.oldHitbox.height;
						obj1.currentSpeedY = 0;
						obj1.currentSpeedX = 0.5;
					}
					/*
					TODO check whether obj2 is static or dynamic
						 set new positions
					*/
				}

				if (!obj1.isStatic)
					obj1.collidedWith(obj2);
			}
		}


		private function isValid():Boolean {
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
	}
}
