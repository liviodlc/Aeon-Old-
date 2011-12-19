package org.interguild.levels.assets {
	import fl.motion.Color;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.xml.XMLNode;
	import org.interguild.levels.Level;

	/**
	 * Drawings are generally composed of dynamically created shapes. These shapes can then have
	 * a variety of different fills and borders applied to them, and can even use Masks as their
	 * fills.
	 *
	 * A DrawingFactory creates and maintains one vector-based drawing based on the input XML.
	 * It then distributes this drawing for use for multiple purposes and instances by passing
	 * along the BitmapData of the dynamic image.
	 *
	 * At this point in time, once the BitmapData is available, there is no more need for maintaining
	 * a reference to this DrawingFactory instance. However, we keep this reference in the likely
	 * chance that we implement a camera feature that can zoom in and out of the level, in which case,
	 * this class would be responsible for supplying the BitmapData at multiple zoom levels. Of course,
	 * we could also simply allow things to get pixelated...
	 * 
	 * TODO
	 * 	implement other shapes
	 * 	gradient fills
	 * 	consider allowing text to be rendered as part of Drawings, rather than their own thing. 
	 */
	public class DrawingFactory implements ContentFactory {

		private var xml:XML;
		private var assets:AssetMan;
		private var level:Level;
		private var id:String;

		public var sp:Sprite;
		private var data:BitmapData;
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;


		/**
		 * The constructor takes the xml instructions, adds all of its errors to the Level's error
		 * log, and then fixes those errors, so that getContent() can run as smoothly as possible.
		 */
		public function DrawingFactory(xml:XML, lvl:Level) {
			this.xml = xml;
			level = lvl;
			assets = level.assets;

			id = String(xml.@id);
			sp = new Sprite();

			/* Possible errors to avoid:
				- Broken ID references
				- negative sizes
				- invalid color numbers
				- convert color names to hexadecimal
				- invalid shapes
				- important fields left unspecified.
			*/
			for each (var el:XML in xml.elements()) {
				var name:String = String(el.name());
				if (name == "circle") {
					var offX:Number, offY:Number;
					var radius:Number;
					var center:Array;
					var border:Array;
					var solidFill:Array;
					var imageFill:Array;

					radius = checkCircleRadius(Number(el.@radius));
					center = checkCircleCenter(String(el.@centerX), String(el.@centerY), String(el.@center));
					border = checkBorder(el.border);
					solidFill = checkSolidFill(el.solidFill);
					imageFill = checkImageFill(el.imageFill);

					// TESTS
//					centerX = -16;
//					centerY = -100;
//					rad = 32;

					// CALCULATE OFFSETS
					offX = center[0] - radius - border[0] / 2;
					if (offX < offsetX)
						offsetX = offX;
					offY = center[1] - radius - border[0] / 2;
					if (offY < offsetY)
						offsetY = offY;

					// DRAW SHAPE
					sp.graphics.lineStyle(border[0], border[2], border[1]);
					// may want to include more border options, such as caps, joints, and miterLimit
					if (imageFill[0] != null) {
						sp.graphics.beginBitmapFill(imageFill[0], imageFill[1]);
					} else
						sp.graphics.beginFill(solidFill[0], solidFill[1]);
					sp.graphics.drawCircle(center[0], center[1], radius);
					sp.graphics.endFill();

				} else if (name == "rectangle") {

				} else {
					level.addError("Drawing Asset with ID '" + id + "' contains invalid shape '" + name + "'");
				}
			}
			updateData();
		}


		private function checkCircleRadius(rad:Number):Number {
			// TODO: check to see if a radius of zero will cause runtime errors
			if (isNaN(rad))
				rad = 0;
			else if (rad < 0)
				rad = -rad;
			return rad;
		}


		/**
		 * Returns an array of exactly two valid numbers:
		 *  a[0] = centerX
		 *  a[1] = centerY
		 */
		private function checkCircleCenter(cenX:String, cenY:String, cen:String):Array {
			var a:Array = new Array(0, 0);

			if (cenX.length > 0) {
				a[0] = Number(cenX);
				if (isNaN(a[0]))
					a[0] = 0;
			}
			if (cenY.length > 0) {
				a[1] = Number(cenY);
				if (isNaN(a[1]))
					a[1] = 0;
			}

			// if center="0 0" is defined, overwrite prev definitions
			if (cen.length > 0) {
				var arr:Array = cen.split(" ", 2);
				a[0] = Number(arr[0]);
				if (isNaN(a[0]))
					a[0] = 0;

				a[1] = a[0]; // centerY = centerX by default
				if (arr.length >= 2) {
					a[1] = Number(arr[1]);
					if (isNaN(a[1]))
						a[1] = 0;
				}
			}
			return a;
		}


		/**
		 * returns an array with the following items:
		 * a[0]:Number	border size;
		 * a[1]:Number	border alpha;
		 * a[2]:uint	border color;
		 */
		private function checkBorder(xml:XMLList):Array {
			var a:Array = new Array(3);

			// border size
			a[0] = Number(xml.@size);
			if (isNaN(a[0]))
				a[0] = 0;
			if (a[0] == 0) // no border
				return a;

			// border transparency
			a[1] = checkAlpha(String(xml.@alpha));
			if (a[1] == 0) {
				a[0] = 0; // no border
				return a;
			}

			// border color
			a[2] = checkHex(String(xml.@color));

			// border ready
			return a;
		}


		/**
		 * Returns array of valid values for:
		 *  a[0] = color
		 *  a[1] = alpha
		 */
		private function checkSolidFill(fill:XMLList):Array {
			var a:Array = new Array(0, 0);

			// check fill color
			a[0] = checkHex(String(fill.@color));

			// check fill transparency
			a[1] = checkAlpha(String(fill.@alpha));

			// solid fill ready
			return a;
		}


		/**
		 * Returns an array of valid values for:
		 * 	a[0] = BitmapData for the image fill
		 *  a[1] = Matrix
		 */
		private function checkImageFill(xml:XMLList):Array {
			var a:Array = new Array(2);

			// get BitmapData
			var box:Rectangle = checkBox(xml.@box);
			var bm:BitmapData = assets.getImageBox(String(xml.@assetid), box);
			a[0] = bm;
			if (a[0] == null) {
				return a;
			}

			// get Matrix
			var matrix:Matrix = new Matrix();
			var angle:Number = checkAngle(String(xml.@rotate));
			matrix.rotate(angle);
			var scale:Array = checkScale(String(xml.@scale));
			matrix.scale(scale[0], scale[1]);
			a[1] = matrix;

			// get alpha
			var alpha:Number = checkAlpha(String(xml.@alpha));

			// get tint color
			var tintColor:uint = checkHex(String(xml.@tintColor));

			// get tint strength
			var tintStrength:Number = checkAlpha(String(xml.@tintAlpha));

			var trans:Color = new Color();
			trans.alphaOffset = alpha * 255 - 255;
			trans.setTint(tintColor, tintStrength);
			bm.colorTransform(bm.rect, trans);

			return a;
		}


		/**
		 * Parses the string into a color. Input string may or may not start with "0x"
		 */
		private function checkHex(color:String):uint {
			if (color.substr(0, 2) != "0x")
				color = "0x" + color;
			var result:uint = uint(color);
			if (isNaN(result))
				result = 0; // default color: black
			return result;
		}


		private function checkAlpha(s:String):Number {
			var num:Number = Number(s);
			if (isNaN(num)) {
				num = 0;
			} else if (num > 100) {
				num = 100;
			} else if (num < 0) {
				num = 0;
			}
			num = num / 100;
			return num;
		}


		/**
		 * Validates the angle and returns its equivalent in radians
		 */
		private function checkAngle(s:String):Number {
			var num:Number = Number(s);
			if (isNaN(num))
				return 0;
			return (num / 180) * Math.PI;
		}


		/**
		 * Returns an array with scaleX and scaleY values.
		 */
		private function checkScale(s:String):Array {
			var a:Array = s.split(" ", 2);

			a[0] = Number(a[0]);
			if (isNaN(a[0])) {
				a[0] = 1;
			} else if (a[0] == 0) {
				a[0] = 0.01;
			}
			a[0] = a[0] / 100;

			if (a.length < 2) {
				a.push(a[0]);
			} else {
				a[1] = Number(a[1]);
				if (isNaN(a[1])) {
					a[1] = 1;
				} else if (a[1] == 0) {
					a[1] = 0.01;
				}
				a[1] = a[1] / 100;
			}

			return a;
		}


		/**
		 * Parses the box="1 2 3 4" text and returns a Rectangle with valid values.
		 */
		private function checkBox(box:String):Rectangle {
			var a:Array = box.split(" ", 4);
			var n:uint = a.length;
			for (var i:uint = 0; i < n; i++) {
				a[i] = Number(a[i]);
				if (i < 2) {
					if (isNaN(a[i])) {
						a[i] = 0;
					}
				} else {
					if (isNaN(a[i]) || a[i] < 0) {
						a[i] = 1;
					}
				}
			}
			if (n == 3)
				a.push(1);
			else if (n == 2)
				a.push(1, 1);
			else if (n == 1)
				a.push(0, 1, 1);

			return new Rectangle(a[0], a[1], a[2], a[3]);
		}


		public function getContent():Content {
			return null;
		}


		public function getClone():BitmapData {
			return data;
		}


		private function updateData():void {
			var result:BitmapData = new BitmapData(sp.width, sp.height, true, 0x00000000);
			var m:Matrix = new Matrix();
			m.createBox(1, 1, 0, -offsetX, -offsetY);
			result.draw(sp, m);

			data = result;
		}
	}
}