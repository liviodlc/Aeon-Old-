package org.interguild.pages {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.display.Stage;
	
	import org.interguild.Aeon;
	import org.interguild.gui.Btn;
	import org.interguild.levels.Level;
	import org.interguild.levels.editor.LevelEditor;
	import org.interguild.levels.pause.Pause;
	import org.interguild.log.LoadingBox;

	/**
	 * This class represents the "Game Page", where the level and level editor live.
	 * It's manages having multiple levels open, making sure that no two levels are trying to load at the same time.
	 * This is also the class to contact when you want to have a level loaded.
	 */
	public class GamePage extends Page {

		private static var thisInstance:GamePage;


		public static function get instance():GamePage {
			return thisInstance;
		}

		private var theStage:Stage;

		private var allLevels:Array;
		private var curLevel:Level;

		private var loadingBox:LoadingBox;
		private var _loader:BulkLoader;
		private var loadLocked:Boolean = false;

//		private var pause:Pause;
		private var editor:LevelEditor;


		public function GamePage() {
			thisInstance = this;

			theStage = Aeon.instance.stage;

			//create the loader
			_loader = new BulkLoader("gamepage");

			//create the loading text
			loadingBox = new LoadingBox(true);

			//create the pause menu
//			pause = new Pause();

			//create editor
			editor = new LevelEditor();

			//initialize level array
			allLevels = [];
		}


		public function get loader():BulkLoader {
			return _loader;
		}


		/**
		 * Sets the text displayed by the GamePage's LoadingBox instance.
		 */
		public function set loadingText(txt:String):void {
			loadingBox.text = txt;
		}


		/**
		 * Returns a reference to the GamePage's LoadingBox's cancel button.
		 */
		public function get loadingButton():Btn {
			return loadingBox.cancelButton;
		}


		/**
		 * Hides the LoadingBox from view. Usually called after a level has finished loading.
		 */
		public function hideLoadingText():void {
			removeChild(loadingBox);
		}


		/**
		 * Got a level code and don't know what to do with it? Pass it through this function to start loading that level
		 * and start playing it once it's done loading.
		 */
		public function loadAndPlay(lvlCode:String):void {
			if (loadLocked) {
				throw new Error("Tried to load a level while the GamePage was already loading another level.");
			} else {
				Aeon.instance.gotoGamePage();
				var lvl:Level = new Level(false, lvlCode);
				allLevels.push(lvl);
				curLevel = lvl;
				addChild(lvl);
				lvl.startLoading();
			}
		}


		/**
		 * Got a level code and don't know what to do with it? Pass it through this function to start loading that level
		 * specifically for the Level Editor.
		 */
		public function loadAndEdit(lvlCode:String):void {

		}


		/**
		 * When a level loads, it calls this function to lock the GamePage from loading more stuff at the same time.
		 * Not only could such an event interfere with our BulkLoader instance as it runs, but the two levels would
		 * be fighting over our LoadingBox instance.
		 *
		 * This function locks GamePage and makes LoadingBox visible. To make it invisible again, the level must call
		 * loadUnlock()
		 */
		public function loadLock():Boolean {
			if (loadLocked)
				return false;
			else {
				loadLocked = true;
				addChild(loadingBox);
				return true;
			}
		}


		/**
		 * Unlocks the GamePage, freeing it to load other things. Also hides the LoadingBox as it's not needed anymore.
		 */
		public function loadUnlock():void {
			loadLocked = false;
			removeChild(loadingBox);
		}

		/**
		 * Removes the level from the GamePage.
		 */
		public function closeLevel(lvl:Level):void{
			var index:int = allLevels.indexOf(lvl);
			if(index==-1){
				throw new Error("You tried to close a level that was not in GamePage");
			}else{
				allLevels.splice(index,1);
			}
			removeChild(lvl);
		}
	}
}
