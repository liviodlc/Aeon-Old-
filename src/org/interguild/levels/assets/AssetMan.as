package org.interguild.levels.assets {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;

	import org.interguild.levels.Level;

	/**
	 * Asset Man appears! His specialty is... to manage assets!
								   @@@@@@@@@@@@@@@@@@@@@@@@
								   @@@@@@@@@@@@@@@@@@@@@@@@
								   @@@@@@@@@@@@@@@@@@@@@@@@
								   @@@@@@@@@@@@@@@@@@@@@@@@
							   @@@@::::::::::::::::::::::::@@@
							   @@@@::::::::::::::::::::::::@@@
							   @@@@::::::::::::::::::::::::@@@
							@@@::::::::::::::::::::::::;;;;:::@@@@
							@@@::::::::::::::::::::::::;;;;:::@@@@
							@@@::::::::::::::::::::::::;;;;:::@@@@
							@@@::::::::::::::::::::::::;;;;:::@@@@
							@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;::::@@@
							@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;::::@@@
							@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;::::@@@
	   @@@@@@@@@@              @@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;:::@@@@
	   @@@@@@@@@@              @@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;:::@@@@
	   @@@@@@@@@@              @@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;:::@@@@
	   @@@@@@@@@@              @@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;:::@@@@
	@@@;;;;;;;;;;@@@@              @@@@@@@@@@@@@@::::::@@@@@@@;;;;;;;::::@@@
	@@@;;;;;;;;;;@@@@              @@@@@@@@@@@@@@::::::@@@@@@@;;;;;;;::::@@@
	@@@;;;;;;;;;;@@@@              @@@@@@@@@@@@@@::::::@@@@@@@;;;;;;;::::@@@
@@@@;;;;;;;;;;;;;@@@@              @@@@@@@:::::::@@@@@@;;;;@@@@@@@;;;;;;;:::@@@@
@@@@;;;;;;;;;;;;;@@@@              @@@@@@@:::::::@@@@@@;;;;@@@@@@@;;;;;;;:::@@@@
@@@@;;;;;;;;;;;;;@@@@              @@@@@@@:::::::@@@@@@;;;;@@@@@@@;;;;;;;:::@@@@
@@@@;;;;;;;;;;;;;@@@@          @@@@:::@@@@@@@@@@@::::::@@@@;;;@@@@@@@;;;;;;;@@@@   @@@@@@@@@@
@@@@;;;;;;;;;;;;;@@@@          @@@@:::@@@@@@@@@@@::::::@@@@;;;@@@@@@@;;;;;;;@@@@   @@@@@@@@@@
@@@@;;;;;;;;;;;;;@@@@          @@@@:::@@@@@@@@@@@::::::@@@@;;;@@@@@@@;;;;;;;@@@@   @@@@@@@@@@
@@@@;;;;;;;;;;;;;@@@@          @@@@:::@@@@@@@@@@@::::::@@@@;;;@@@@@@@;;;;;;;@@@@   @@@@@@@@@@
@@@@;;;;;;;@@@@@@@@@@       @@@:::::::::::@@@::::::::::::::@@@;;;;@@@@@@@@@@    @@@;;;;;;;;;;@@@@
@@@@;;;;;;;@@@@@@@@@@       @@@:::::::::::@@@::::::::::::::@@@;;;;@@@@@@@@@@    @@@;;;;;;;;;;@@@@
@@@@;;;;;;;@@@@@@@@@@       @@@:::::::::::@@@::::::::::::::@@@;;;;@@@@@@@@@@    @@@;;;;;;;;;;@@@@
	@@@;;;;;;;;;;;;;;@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@@@:::@@@@@@@;;;;;;;;;;@@@@
	@@@;;;;;;;;;;;;;;@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@@@:::@@@@@@@;;;;;;;;;;@@@@
	@@@;;;;;;;;;;;;;;@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@@@:::@@@@@@@;;;;;;;;;;@@@@
	@@@;;;;;;;;;;;;;;@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;@@@@@@@:::@@@@@@@;;;;;;;;;;@@@@
	@@@;;;;;;;;;;;;;;@@@@@@@@@@    @@@@@@@   @@@@@@@       @@@;;;;@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;@@@
	@@@;;;;;;;;;;;;;;@@@@@@@@@@    @@@@@@@   @@@@@@@       @@@;;;;@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;@@@
	@@@;;;;;;;;;;;;;;@@@@@@@@@@    @@@@@@@   @@@@@@@       @@@;;;;@@@@@@@@@@@@@@@@@;;;;;;;;;;;;;;@@@
	   @@@@;;;;;;@@@@@@@:::::::@@@@       ...          ....@@@@@@@@@@:::::::::::@@@;;;;;;;;;;;;;;@@@
	   @@@@;;;;;;@@@@@@@:::::::@@@@       ...          ....@@@@@@@@@@:::::::::::@@@;;;;;;;;;;;;;;@@@
	   @@@@;;;;;;@@@@@@@:::::::@@@@       ...          ....@@@@@@@@@@:::::::::::@@@;;;;;;;;;;;;;;@@@
	   @@@@;;;;;;@@@@@@@:::::::@@@@       ...          ....@@@@@@@@@@:::::::::::@@@;;;;;;;;;;;;;;@@@
		   @@@@@@@@@@@@@;;;;@@@.......@@@@@@@..............@@@@@@@:::;;;;;;;;;;;@@@@@@@@@@@@@;;;;@@@
		   @@@@@@@@@@@@@;;;;@@@.......@@@@@@@..............@@@@@@@:::;;;;;;;;;;;@@@@@@@@@@@@@;;;;@@@
		   @@@@@@@@@@@@@;;;;@@@.......@@@@@@@..............@@@@@@@:::;;;;;;;;;;;@@@@@@@@@@@@@;;;;@@@
			  @@@@@@@@@@;;;;@@@.......@@@@@@@..........@@@@@@@::::;;;;;;;;;;;;;;@@@@@@;;;;;;;@@@@@@@
			  @@@@@@@@@@;;;;@@@.......@@@@@@@..........@@@@@@@::::;;;;;;;;;;;;;;@@@@@@;;;;;;;@@@@@@@
			  @@@@@@@@@@;;;;@@@.......@@@@@@@..........@@@@@@@::::;;;;;;;;;;;;;;@@@@@@;;;;;;;@@@@@@@
			  @@@@@@@@@@;;;;@@@.......@@@@@@@..........@@@@@@@::::;;;;;;;;;;;;;;@@@@@@;;;;;;;@@@@@@@
					 @@@@@@@;;;@@@@.................@@@@@@@:::;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@@@@
					 @@@@@@@;;;@@@@.................@@@@@@@:::;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@@@@
					 @@@@@@@;;;@@@@.................@@@@@@@:::;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@@@@@@
							@@@::::@@@@@@@@@@@@@@@@@:::::::;;;;;;;;;;@@@@@@@@@@@@@@@@@@@@@@@@
							@@@::::@@@@@@@@@@@@@@@@@:::::::;;;;;;;;;;@@@@@@@@@@@@@@@@@@@@@@@@
							@@@::::@@@@@@@@@@@@@@@@@:::::::;;;;;;;;;;@@@@@@@@@@@@@@@@@@@@@@@@
							@@@::::::::::::::::::::::::;;;;;;;;;;;;;;;;;;@@@
							@@@::::::::::::::::::::::::;;;;;;;;;;;;;;;;;;@@@
							@@@::::::::::::::::::::::::;;;;;;;;;;;;;;;;;;@@@
							@@@::::::::::::::::::::::::;;;;;;;;;;;;;;;;;;@@@
							@@@:::::::@@@@@@@::::::::::;;;;;;;;;;;;;;@@@@@@@
							@@@:::::::@@@@@@@::::::::::;;;;;;;;;;;;;;@@@@@@@
							@@@:::::::@@@@@@@::::::::::;;;;;;;;;;;;;;@@@@@@@
						@@@@@@@::::@@@;;;;:::@@@@::::::;;;;;;;;;;;@@@@@@@@@@@@@@
						@@@@@@@::::@@@;;;;:::@@@@::::::;;;;;;;;;;;@@@@@@@@@@@@@@
						@@@@@@@::::@@@;;;;:::@@@@::::::;;;;;;;;;;;@@@@@@@@@@@@@@
						@@@@@@@::::@@@;;;;:::@@@@::::::;;;;;;;;;;;@@@@@@@@@@@@@@
					 @@@@@@@@@@::::@@@;;;;;;;@@@@::::::;;;;;;;@@@@@@@@@@@@@@@@@@@@@
					 @@@@@@@@@@::::@@@;;;;;;;@@@@::::::;;;;;;;@@@@@@@@@@@@@@@@@@@@@
					 @@@@@@@@@@::::@@@;;;;;;;@@@@::::::;;;;;;;@@@@@@@@@@@@@@@@@@@@@
				 @@@@@@@@@@@@@@:::::::@@@@@@@::::::::::::::@@@@@@@@@@@@@@;;;;;;;@@@
				 @@@@@@@@@@@@@@:::::::@@@@@@@::::::::::::::@@@@@@@@@@@@@@;;;;;;;@@@
				 @@@@@@@@@@@@@@:::::::@@@@@@@::::::::::::::@@@@@@@@@@@@@@;;;;;;;@@@
				 @@@@@@@@@@@@@@:::::::@@@@@@@::::::::::::::@@@@@@@@@@@@@@;;;;;;;@@@
		   @@@@@@;;;;;;;@@@@@@@@@@@:::::::::::::::::@@@@@@@   @@@@@@@;;;;;;;;;;;;;;@@@
		   @@@@@@;;;;;;;@@@@@@@@@@@:::::::::::::::::@@@@@@@   @@@@@@@;;;;;;;;;;;;;;@@@
		   @@@@@@;;;;;;;@@@@@@@@@@@:::::::::::::::::@@@@@@@   @@@@@@@;;;;;;;;;;;;;;@@@
	@@@@@@@;;;;;;;;;;;;;@@@@@@@    @@@@@@@@@@@@@@@@@              @@@;;;;;;;;;;;@@@@@@@@@@
	@@@@@@@;;;;;;;;;;;;;@@@@@@@    @@@@@@@@@@@@@@@@@              @@@;;;;;;;;;;;@@@@@@@@@@
	@@@@@@@;;;;;;;;;;;;;@@@@@@@    @@@@@@@@@@@@@@@@@              @@@;;;;;;;;;;;@@@@@@@@@@
	@@@@@@@;;;;;;;;;;;;;@@@@@@@    @@@@@@@@@@@@@@@@@              @@@;;;;;;;;;;;@@@@@@@@@@
@@@@;;;;;;;;;;;;;;;;;;;;;;;;@@@                               @@@@;;;;;;;;;;;;;;;;;;;;;;;;@@@
@@@@;;;;;;;;;;;;;;;;;;;;;;;;@@@                               @@@@;;;;;;;;;;;;;;;;;;;;;;;;@@@
@@@@;;;;;;;;;;;;;;;;;;;;;;;;@@@                               @@@@;;;;;;;;;;;;;;;;;;;;;;;;@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	 *
	 * His job is to store all of the level's raw assets, custom content,
	 * and animation frames. He keeps track of all of the ID names, making
	 * sure there are no conflicts while making it easy to find what you're
	 * looking for.
	 */
	public class AssetMan {

		private var assets:Object;

		private var level:Level;


		public function AssetMan(lvl:Level) {
			level = lvl;

			//initialize assets
			assets = {};
		}


		/**
		 * Registers the ID for an asset.
		 *
		 * Returns true if successful, false if there was an error.
		 *
		 * Errors are added to the level's error log.
		 */
		public function addID(assetID:String):Boolean {
			if (assetID == "none") {
				level.addError("You cannot define assets using the ID of 'none'");
				return false;
			} else if (!assetID || assetID == "") {
				level.addError("You tried to define a new asset without an ID name.");
				return false;
			} else if (assets[assetID] == false) {
				level.addError("You tried to define two different assets under the same ID: '" + assetID + "'");
				return false;
			} else {
				assets[assetID] = false;
				return true;
			}
		}


		/**
		 * Returns true if the id exists.
		 */
		public function checkID(assetID:String):Boolean {
			return (assets[assetID] != null && assets[assetID] != false);
		}


		private function runSetChecks(id:String, value:Object):void {
			if (assets[id] == null) {
				throw new Error("Asset ID '" + id + "' not registered yet.");
			} else if (assets[id] != false) {
				throw new Error("Asset ID '" + id + "' already has data in it!");
			} else if (value == null) {
				throw new Error("AssetMan rejects the addition of a null asset into his list.");
			}
		}


		/**
		 * Assigns a non-null value to the registered id.
		 */
		public function setAsset(id:String, value:Object):void {
			runSetChecks(id, value);
			assets[id] = value;
		}


		/**
		 * This function is called to validate all retreivals of assets.
		 *
		 * For the tag parameter, put in the name of the tag that is relevant
		 * to any errors that might occur. Examples include "assets", "content",
		 * "animation".
		 */
		private function runGetChecks(id:String, tag:String):Boolean {
			if (id == "")
				return false;
			if (assets[id] == null) {
				level.addError("You failed to define the ID '" + id + "' under the <" + tag + "> tag.");
				return false;
			} else if (assets[id] == false) {
				level.addError("Asset ID '" + id + "' failed to load and could not be instantiated.");
				return false;
			}
			return true;
		}


		/**
		 * Returns the BitmapData of the image, if it exists.
		 * Otherwise, returns null and an error message is added to
		 * the Level's error log. Please plan your code accordingly
		 * so that the game doesn't crash from a NullPointerException.
		 */
		public function getImage(id:String):BitmapData {
			var test:Boolean = runGetChecks(id, "assets");
			if (test) {
				var thing:Object = assets[id];
				if (thing is BitmapData) {
					return (thing as BitmapData).clone();
				}
				level.addError("The Asset ID '" + id + "' is not an image and could not be retrieved.");
			}
			return null;
		}


		/**
		 * Just like getImage(), but only returns a segment of the image as defined by the
		 * parameter box.
		 */
		public function getImageBox(id:String, box:Rectangle):BitmapData {
			var img:BitmapData = getImage(id);
			if (img != null) {
				var imgcopy:BitmapData = new BitmapData(box.width, box.height, true, 0x00000000);
				imgcopy.copyPixels(img, box, new Point());
				return imgcopy;
			}
			return null;
		}


		private var visited:Object;


		public function getFrame(id:String):AnimationFrame {
			visited = new Object();
			return duplicateFrame(id);
		}


		private function duplicateFrame(id:String):AnimationFrame {
			if (visited[id] != null)
				return visited[id];
			if (id == null || id == "")
				return null;
			var test:Boolean = runGetChecks(id, "assets");
			if (test) {
				var thing:Object = assets[id];
				if (thing is AnimationFrame) {
					var result:AnimationFrame = (thing as AnimationFrame).clone();
					visited[id] = result;
					if (result.nextID != "")
						result.nextFrame = duplicateFrame(result.nextID);
					return result;
				}
				level.addError("The Asset ID '" + id + "' is not an image and could not be retrieved.");
			}
			return null;
		}
	}
}
