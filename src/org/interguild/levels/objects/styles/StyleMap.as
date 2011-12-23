package org.interguild.levels.objects.styles {
	import org.interguild.levels.Level;
	
	import utils.LinkedList;
	import org.interguild.levels.objects.GameObjectDefinition;

	/**
	 * StyleMap keeps all of the arrays of StyleDefinitions and maps them
	 * to tile id's and class id's.
	 */
	public class StyleMap extends Object {

		private var stylesMap:Array;
		private var level:Level;


		/**
		 * @param xml is the <objects> list. It will initialize all the objects and
		 * class names.
		 *
		 * @param styles is the value of <styles> in the XML.
		 *
		 * @param lvl is the Level instance that this StyleMap is for, and passing this
		 * reference allows StyleMap to log errors.
		 */
		public function StyleMap(xml:XMLList, styles:String, lvl:Level) {
			level = lvl;
			// initialize array:
			stylesMap = [];
//			stylesMap["level"] = new GameObjectDefinition(id, editorIcon);
//			stylesMap["global"] = new GameObjectDefinition(id, editorIcon);

			include "../DefaultObjects.as";

			if (level.loadDefaultSettings) {
				initObjects($default_objects.objects);
			}
			initObjects(xml);

			if (level.loadDefaultSettings) {
				initStyles(String($default_styles.styles));
			}
			initStyles(styles);
		}


		/**
		 * Initializes the object definitions in the map. This step helps us write
		 * more helpful error messages while also figuring out which styles need
		 * to get written to multiple object types.
		 */
		private function initObjects(xml:XMLList):void {
			for each (var type:XML in xml.elements()) {
				initType(type);
			}
		}


		/**
		 * Type ID's are usually one-character long. Or they can be two characters long,
		 * if the first character is a "$" or if it's a class name starting with a "."
		 */
		private function initType(xml:XML):void {
			var id:String = String(xml.@id);
			if (id.length == 0)
				level.addError("All <objects> types must include an 'id' label.");
			else if (id.length == 1) {
				switch (id) {
					case "$":
						level.addError("You are not allowed to use the '$' symbol as an object type ID. This is a reserved character used to mark double-character type IDs.");
						break;
					case ".":
						level.addError("You are not allowed to use the '.' symbol as an object type ID. This is a reserved character used to mark the beginning of a class ID.");
						break;
					case ";":
						level.addError("You are not allowed to use the ';' symbol as an object type ID. This is a reserved character used to mark the end of an instance multiplyer in the level code.");
						break;
					case "=":
						level.addError("You are not allowed to use the '=' symbol as an object type ID. This is a reserved character used to mark the beginning of an instance multiplyer in the level code.");
						break;
					case "\n":
					case "\r":
					case "\r\n":
						level.addError("You are not allowed to use the new line character as an object type ID. This is a reserved character used to mark the end of a row in the level code.");
						break;
					case " ":
						level.addError("You are not allowed to use the space character as an object type ID. This is a reserved character used to mark an empty tile in the level code.");
					default:
						addTypeID(id, String(xml.@editorIcon));
						break;
				}
			} else {
				var firstChar:String = id.substr(0, 1);
				var secondChar:String = id.substr(1, 1);
				if (id == "\r\n" || secondChar == "\r" || secondChar == "\n" || secondChar == "\r\n")
					level.addError("You are not allowed to use the new line character in an object type ID. This is a reserved character used to mark the end of a row in the level code.");
				else if ((id.length == 2 && firstChar != "$" && firstChar != ".")  || id.length > 2)
					level.addError("The object type ID '" + id + "' is too long. Object type IDs must only be one character. If you run out of characters, you can define a double-character ID by setting the first character as the '$' symbol. Class names are always two characters long, but their first character is the '.' symbol.");
				else if(secondChar == "." || secondChar==";" || secondChar=="=")
					level.addError("You are not allowed to use invalid characters such as '=', '.', or ';' in your object type IDs.");
				else {
					addTypeID(id, String(xml.@editorIcon));
				}
			}
		}


		private function addTypeID(id:String, editorIcon:String):void {
			if (stylesMap[id] is GameObjectDefinition) {
				level.addError("You attempted to define the object type ID '" + id + "' more than once.");
			} else {
				stylesMap[id] = new GameObjectDefinition(id, editorIcon);
				trace("Added ID '" + id + "'");
			}
		}


		/**
		 * Parses the <styles> tag and applies them to the relevant GameObjectDefinition
		 * instances in the map.
		 */
		private function initStyles(s:String):void {
			new StyleParser(s, level, this);
		}
		
		/**
		 * Returns the GameObjectDefinition of the registered object type ID.
		 * If the ID is not registered, returns null.
		 */
		public function get(id:String):GameObjectDefinition{
			return stylesMap[id];
		}
	}
}
