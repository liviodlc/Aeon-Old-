package org.interguild.levels.assets {
	import flash.display.BitmapData;
	import flash.media.Sound;

	internal class Asset {
		
		public static const IMAGE_ASSET:uint = 0x0;
		public static const SOUND_ASSET:uint = 0x1;
		public static const YOUTUBE_ASSET:uint = 0x2;
		
//		private var id:String;
		private var data:Object;
		private var type:uint
		
		public function Asset(/*id:String, */data:Object, type:uint) {
//			this.id = id;
			this.type = type;
			
			if(type == IMAGE_ASSET && !(data is BitmapData))
				throw new Error("Image Assets only accept BitmapData instances for data.");
			if(type == SOUND_ASSET && !(data is Sound))
				throw new Error("Sound Assets only accept Sound instances for data.");
			this.data = data;
		}
		
		public function getImageData():BitmapData{
			if(type!= IMAGE_ASSET)
				throw new Error("Cannot retrieve image data from a non-image asset.");
			return BitmapData(data);
		}
		
		public function getSoundData():Sound{
			if(type!= SOUND_ASSET)
				throw new Error("Cannot retrieve image data from a non-image asset.");
			return Sound(data);
		}
	}
}
