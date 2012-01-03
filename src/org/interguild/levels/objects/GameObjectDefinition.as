package org.interguild.levels.objects {
	import flash.display.BitmapData;
	
	import org.interguild.levels.objects.styles.StyleDefinition;
	import org.interguild.utils.OrderedList;

	/**
	 * This class stores all of the information associated with any one GameObject
	 * type or class name. This mainly includes all of its style definitions, but
	 * it also include the name of this type and the icon it uses in the editor.
	 */
	public class GameObjectDefinition {

		private var name:String;
		private var icon:String;

		private var normalStyles:OrderedList;
		private var dynamicStyles:OrderedList;

		private var _ancestor:GameObjectDefinition;


		/**
		 * Leave the editorIcon as a string for now. We'll worry about it later when
		 * we start to implement the editor.
		 */
		public function GameObjectDefinition(editorName:String, editorIcon:String, ancestor:GameObjectDefinition) {
			name = editorName;
			icon = editorIcon;

			normalStyles = new OrderedList();
			dynamicStyles = new OrderedList();

			this._ancestor = ancestor;
		}


		public function hasAncestor():Boolean {
			return (_ancestor != null);
		}


		public function get ancestor():GameObjectDefinition {
			return _ancestor;
		}


		/**
		 * Adds the StyleDefinition to the appropriate array, in order based on priority.
		 */
		public function addStyles(s:StyleDefinition):void {
			if (s.isDynamic)
				dynamicStyles.add(s);
			else
				normalStyles.add(s);
		}


		/**
		 * Returns an OrderdList of StyleDefinition instances that do not rely
		 * on dynamic style conditions.
		 *
		 * They're ordered based on precedence, so you can simply itereate through
		 * the list in order and allow the styles to overwrite themselves.
		 */
		public function get normalStylesList():OrderedList {
			return normalStyles;
		}


		/**
		 * Returns an OrderdList of dynamic StyleDefinition instances.
		 *
		 * They're ordered based on precedence, so you can simply itereate through
		 * the list in order and allow the styles to overwrite themselves.
		 */
		public function get dynamicStylesList():OrderedList {
			return dynamicStyles;
		}


//		public function testPrint():void {
//			trace(name + ":");
//			var n:uint = normalStyles.length;
//			for (var i:uint = 0; i < n; i++) {
//				StyleDefinition(normalStyles.get(i)).testPrint();
//			}
//		}

		public function get id():String {
			return name;
		}
	}
}
