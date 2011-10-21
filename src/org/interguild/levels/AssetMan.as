package org.interguild.levels {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Sound;

	/**
	 * Asset Man appears! His specialty is... to manage assets!
	 */
	internal class AssetMan {

		private var assets_images:Object;
		private var assets_sounds:Object;

		private var level:Level;


		public function AssetMan(lvl:Level) {
			level = lvl;

			//initialize asset Objects:
			assets_images = {};
			assets_sounds = {};
		}


		/**
		 * Registers the ID for an image asset. Returns true if successful, false if there was an error.
		 * Errors are added to the level's error log.
		 */
		public function addImageID(assetID:String):Boolean {
			if (assetID == "none") {
				level.addError("You cannot define assets using the ID of 'none'");
				return false;
			} else if (!assetID || assetID == "") {
				level.addError("You tried to define a new image asset without an ID name.");
				return false;
			} else if (assets_images[assetID] == false) {
				level.addError("You tried to define two different image assets under the same ID: '" + assetID + "'");
				return false;
			} else {
				assets_images[assetID] = false;
				return true;
			}
		}

		/**
		 * Registers the ID for a sound asset. Returns true if successful, false if there was an error.
		 * Errors are added to the level's error log.
		 */
		public function addSoundID(assetID:String):Boolean {
			if (assetID == "none") {
				level.addError("You cannot define assets using the ID of 'none'");
				return false;
			} else if (!assetID || assetID == "") {
				level.addError("You tried to define a new image asset without an ID name.");
				return false;
			} else if (assets_sounds[assetID] == false) {
				level.addError("You tried to define two different sound assets under the same ID: '" + assetID + "'");
				return false;
			} else {
				assets_images[assetID] = false;
				return true;
			}
		}
		
		/**
		 * Assigns a non-null value to the registered id.
		 */
		public function setImage(id:String,value:BitmapData):void{
			if(assets_images[id]==null){
				throw new Error("Image Asset ID not registered.");
			}else if(value == null){
				throw new Error("Cannot assign null Value to assets list.");
			}else{
				assets_images[id] = value;
			}
		}
		
		/**
		 * Assigns a non-null value to the registered id.
		 */
		public function setSound(id:String,value:Sound):void{
			if(assets_images[id]==null){
				throw new Error("Image Asset ID not registered.");
			}else if(value == null){
				throw new Error("Cannot assign null Value to assets list.");
			}else{
				assets_sounds[id] = value;
			}
		}
	}
}
