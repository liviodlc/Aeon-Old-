package tests {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.interguild.levels.objects.GameObject;

	public class GetSideTest {

		public function GetSideTest() {
			var r1a:Rectangle, r2a:Rectangle, r1b:Rectangle, r2b:Rectangle;

			r1a = new Rectangle(0, 0, 29, 29);
			r1b = new Rectangle(30, 30, 29, 29);
			r2a = new Rectangle(30, 0, 29, 29);
			r2b = new Rectangle(30, 0, 29, 29);
			Test.AssertEquals(getSide2(r1a, r2a, r1b, r2b), GameObject.RIGHT);
			r1a = new Rectangle(30, 30, 29, 29);
			r1b = new Rectangle(0, 0, 29, 29);
			r2a = new Rectangle(30, 0, 29, 29);
			r2b = new Rectangle(30, 0, 29, 29);
			Test.AssertEquals(getSide2(r1a, r2a, r1b, r2b), GameObject.UP);
			r1a = new Rectangle(231, 231, 29, 41);
			r1b = new Rectangle(223, 221, 29, 41);
			r2a = new Rectangle(256, 192, 31, 31);
			r2b = new Rectangle(256, 192, 31, 31);
			Test.AssertEquals(getSide2(r1a, r2a, r1b, r2b), 0);
		}


		private function getSide2(oldBox1:Rectangle, oldBox2:Rectangle, curBox1:Rectangle, curBox2:Rectangle):uint {
			var y:Number;

			//bottom
			if (oldBox1.bottom <= oldBox2.top && curBox1.bottom > curBox2.top) {
				if (curBox1.left > oldBox1.left) { //right
					y = getYatIntersection(new Point(oldBox1.left, oldBox1.bottom), new Point(curBox1.left, curBox1.bottom), curBox2.right);
					if (y >= curBox2.top)
						return GameObject.DOWN;
					else
						return 0;
				} else if (curBox1.right < oldBox1.right) { //left
					y = getYatIntersection(oldBox1.bottomRight, curBox1.bottomRight, curBox2.left);
					if (y >= curBox2.top)
						return GameObject.DOWN;
					else
						return 0;
				} else {
					return GameObject.DOWN;
				}
					//top
			} else if (oldBox1.top >= oldBox2.bottom && curBox1.top < curBox2.bottom) {
				if (curBox1.left > oldBox1.left) { //right
					y = getYatIntersection(oldBox1.topLeft, curBox1.topLeft, curBox2.right);
					if (y <= curBox2.bottom)
						return GameObject.UP;
					else
						return 0;
				} else if (curBox1.right < oldBox1.right) { //left
					y = getYatIntersection(new Point(oldBox1.right, oldBox1.top), new Point(curBox1.right, curBox1.top), curBox2.left);
					if (y <= curBox2.bottom)
						return GameObject.UP;
					else
						return 0;
				} else {
					return GameObject.UP;
				}
					//right
			} else if (oldBox1.right <= oldBox2.left && curBox1.right > curBox2.left) {
				if (curBox1.top > oldBox1.top) { //down
					y = getYatIntersection(new Point(oldBox1.right, oldBox1.top), new Point(curBox1.right, curBox1.top), curBox2.left);
					if (y <= curBox2.bottom)
						return GameObject.RIGHT;
					else
						return 0;
				} else if (curBox1.bottom < oldBox1.bottom) { //up
					y = getYatIntersection(oldBox1.bottomRight, curBox1.bottomRight, curBox2.left);
					if (y >= curBox2.top)
						return GameObject.RIGHT;
					else
						return 0;
				} else {
					return GameObject.RIGHT;
				}
					//left
			} else if (oldBox1.left >= oldBox2.right && curBox1.left < curBox2.right) {
				if (curBox1.top > oldBox1.top) { //down
					y = getYatIntersection(oldBox1.topLeft, curBox1.topLeft, curBox2.right);
					if (y <= curBox2.bottom)
						return GameObject.LEFT;
					else
						return 0;
				} else if (curBox1.bottom < oldBox1.bottom) { //up
					y = getYatIntersection(new Point(oldBox1.left, oldBox1.bottom), new Point(curBox1.left, curBox1.bottom), curBox2.right);
					if (y >= curBox2.top)
						return GameObject.LEFT;
					else
						return 0;
				} else {
					return GameObject.LEFT;
				}
			}
			return 0;
		}


		private function getYatIntersection(prevPoint:Point, nextPoint:Point, x:Number):Number {
			return ((nextPoint.y - prevPoint.y) / (nextPoint.x - prevPoint.x)) * (x - nextPoint.x) + nextPoint.y;
		}
	}
}

