package org.interguild.levels.editor {
	import flash.display.Sprite;
	
	import org.interguild.levels.Level;

	/**
	 * This is the main lass of the Level Editor user interface.
	 * Only one editor should be initialized per game, but the editor can switch between levels.
	 */
	public class LevelEditor extends Sprite {
		
		public function LevelEditor() {
			super();
		}
		
		public function focusOnLevel(lvl:Level):void{
			
		}
	}
}
