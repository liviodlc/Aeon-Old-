package org.interguild.levels.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * When put together, AnimationFrames form a LinkedList, with each
	 * frame pointing to the next. For the sake of not having to duplicate
	 * frames for each use, AnimationFrame objects should not be changed
	 * after they are created. It is the GameObject's responsibility to
	 * maintain a counter for each frame's delay, for example.
	 */
	public class AnimationFrame extends Sprite {

		private var id:String;
		private var next:AnimationFrame;
		private var next_id:String;
		private var next_delay:uint;
		
		private var assets:AssetMan;


		public function AnimationFrame(id:String, nextFrameID:String, delay:uint, assetsMan:AssetMan) {
			this.id = id;
			next_id = nextFrameID;
			next_delay = delay;
			assets = assetsMan;
		}


		public function get nextID():String {
			return next_id;
		}


		public function set nextFrame(f:AnimationFrame):void {
			next = f;
		}


		public function get nextFrame():AnimationFrame {
			return next;
		}


		public function get delay():uint {
			return next_delay;
		}


		internal function addImage(o:DisplayObject):void {
			addChild(o);
		}


		public function clone():AnimationFrame {
			var result:AnimationFrame = new AnimationFrame(id, next_id, next_delay, assets);
			var n:uint = this.numChildren;
			for (var i:uint = 0; i < n; i++) {
				var d:DisplayObject = this.getChildAt(i);
				if (d is Bitmap) {
					var bitmap:Bitmap = (d as Bitmap);
					var newbitmap:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x00000000);
					newbitmap.copyPixels(bitmap.bitmapData, new Rectangle(0, 0, bitmap.width, bitmap.height), new Point());
					d = new Bitmap(newbitmap);
					d.x = bitmap.x;
					d.y = bitmap.y;
				} else {
					//TODO add functionality for video and sound.
				}
				result.addChild(d);
			}
			return result;
		}
	}
}
