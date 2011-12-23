package org.interguild.levels.objects {
	import flash.display.BitmapData;
	import org.interguild.levels.objects.styles.StyleDefinition;

	/**
	 * This class stores all of the information associated with any one GameObject
	 * type or class name. This mainly includes all of its style definitions, but
	 * it also include the name of this type and the icon it uses in the editor.
	 */
	public class GameObjectDefinition {
		
		private var name:String;
		private var icon:String;
		
		private var normalStyles:Array;
		private var dynamicStyles:Array;
		
		/**
		 * Leave the editorIcon as a string for now. We'll worry about it later when
		 * we start to implement the editor.
		 */
		public function GameObjectDefinition(editorName:String, editorIcon:String) {
			name = editorName;
			icon = editorIcon;
			
			normalStyles = [];
			dynamicStyles = [];
		}
		
		/**
		 * Adds the StyleDefinition to the appropriate array, in order based on priority.
		 */
		public function addStyles(s:StyleDefinition):void{
			
			/*
			TODO:
				create OrderedList class, and maybe Comparable interface.
				create StyleDefinition.isDynamic():Boolean
				create StyleDefinition.getPriority():Boolean
			*/
		}
	}
}
