package org.interguild.levels.objects {
	import org.interguild.levels.Level;
	
	import utils.LinkedList;

	/**
	 * This class reads and parses the styles definitions written in the <styles> xml tag.
	 * It returns StyleDefinition objects to StyleMap.
	 */
	internal class StyleParser {

		private var styles:Array;
		private var n:uint;
		private var i:uint;
		private var level:Level


		/**
		 * @param s:String - a string containing all of the style definitions of the level.
		 */
		public function StyleParser(s:String, lvl:Level) {
			styles = s.split("}");
			n = styles.length;
			level = lvl;
			if (trim(styles[n - 1]).length == 0) {
				styles.pop();
				n--;
			}
		/*
		scanning conditions:
		class and tile names should only be 1 or 2 chars.
		if next char is '['
			then scan for known variables, including global variables
			then scan for operator
			then scan for value, which depends on variable?
			then finally scan for ']'
		then scan for more dynamic conditions
		if next char is ':'
			then scan for known psuedo classes
		then scan for more psuedo classes

		also scan for commas separating multiple conditions

		Order:
		scan next rule definition{
			scan next conditions
			scan property/values
		}
		*/
		}


		/**
		 * @author Jeff Channell from:
		 * http://jeffchannell.com/ActionScript-3/as3-trim.html
		 */
		private function trim(s:String):String {
			var result:String;
			trace("Before: '" + s + "'");
			result = s.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n|\r]+)?$/gm, "$2");
			trace("After: '" + result + "'");
			return result;
		}


		/**
		 * If i = 1, return "1st"
		 * If i = 2, return "2nd"
		 * and so on...
		 */
		private function nth(i:uint):String {
			var lsd:uint = i % 10;
			var th:String = "";
			switch (lsd) {
				case 1:
					th = "st";
					break;
				case 2:
					th = "nd";
					break;
				case 3:
					th = "rd";
					break;
				default:
					th = "th";
					break;
			}
			return i + th;
		}


		private function syntaxError(i:uint):String {
			return "You have a syntax error when defining your '" + nth(i) + "' style definition. ";
		}


		/**
		 * Returns true if there's still more styles to parse.
		 */
		public function hasNext():Boolean {
			return i < n;
		}


		/**
		 * Returns a complete StyleDefinition object describing a set of
		 * property definitions and the conditions that trigger them.
		 *
		 * If the parsing fails, due to a parsing error, this may return
		 * an incomplete but functional StyleDefinition instance, or it
		 * may return null.
		 *
		 * Always check to make sure the result is not null before doing
		 * anything with it.
		 */
		public function next():StyleDefinition {
			var cur:String = String(styles[i]);
			var point:int = cur.indexOf("{");
			if (point == -1) {
				level.addError(syntaxError(i) + "Expecting '{' symbol before '}'.");
			} else {
				/*
				when parsing first line, we want to know:
					(1) which object type IDs need this StyleDefinition
					(2) the PsuedoClassTriggers bit string for this definition
					(3) the DynamicClassTriggers
					(4) any errors that render this definition useless
				*/
				// users = the first line of definition, divided by commas separating conditions
				var userConditions:Array = cur.substring(0, point).split(",");
				var validCount:uint=0;
				for each (var s:String in userConditions) {
					s = trim(s);
					var id:String = s.substr(0,2);
					if(styles[id]==null)//THIS DOES NOT WORK: StyleParser doesn't have ref to StyleMap's mapping.
						level.addError(syntaxError(i) + "You tried to apply styles to an invalid object type ID.");
					else{
						//TODO
					}
				}
			}
			i++;
			return null;
		}
	}
}
