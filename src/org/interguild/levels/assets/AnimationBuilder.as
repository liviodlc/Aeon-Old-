package org.interguild.levels.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import org.interguild.levels.Level;

	/**
	 * AnimationBuilder builds AnimationFrame nodes, and gives them to AssetMan
	 * via the getFrame() method.
	 */
	public class AnimationBuilder extends AssetBuilder {

		private var id:String;
		private var xml:XML;
		private var assets:AssetMan;
		private var level:Level;

		private var frame:AnimationFrame;


		public function AnimationBuilder(xml:XML, lvl:Level) {
			this.xml = xml;
			level = lvl;
			assets = lvl.assets;

			id = String(xml.@id);
			var nextID:String = String(xml.@next);
			if (id == nextID || nextID.length == 0)
				nextID = null;
			frame = new AnimationFrame(id, nextID, checkPosInt(String(xml.@delay)), level.assets);

			for each (var el:XML in xml.elements()) {
				var name:String = String(el.name());
				var box:String = String(el.@box);
				var imgData:BitmapData, img:Bitmap, a:Array, m:Matrix;
				if (name == "image" || name == "drawing") {
					if (box.length > 0)
						imgData = assets.getImageBox(String(el.@id), checkBox(box));
					else
						imgData = assets.getImage(String(el.@id));
					if(imgData==null)
						break;
					if (String(el.@flipY) == "true") {
						m = new Matrix()
						m.scale(1, -1)
						m.translate(0, imgData.height)
					}
					if (String(el.@flipX) == "true") {
						m = new Matrix()
						m.scale(-1, 1)
						m.translate(imgData.width, 0)
					}
					if(m!=null){
						var temp:BitmapData = imgData.clone();
						imgData.fillRect(imgData.rect,0x00000000);
						imgData.draw(temp, m);
					}
					img = new Bitmap(imgData);
					a = checkPosition(String(el.@position));
					img.x = a[0];
					img.y = a[1];
					frame.addImage(img);
				} else {
					level.addError("Animation frame id '" + id + "' contains an invalid tag: '" + name + "'");
				}
			}
		}


		public function getFrame():AnimationFrame {
			return frame;
		}


		private function checkPosInt(s:String):uint {
			var n:int = int(s);
			if (n < 0)
				n = -n;
			return uint(n);
		}


		private function checkPosition(s:String):Array {
			var a:Array = s.split(" ", 2);
			a[0] = Number(a[0]);
			if (isNaN(a[0]))
				a[0] = 0;

			if (a[1] == null)
				a[1] = 0;
			else if (isNaN(a[1]))
				a[1] = 0;

			return a;
		}
	}
}
