package org.interguild.levels.objects {
	import org.interguild.levels.Level;

	/**
	 * This class reads and parses the styles definitions written in the <styles> xml tag.
	 * It returns StyleDefinition objects to StyleMap.
	 */
	internal class StyleParser {

		private var styles:Array;
		private var n:uint;
		private var i:uint;
		private var level:Level
		private var lineNumber:uint;


		/**
		 * @param s:String - a string containing all of the style definitions of the level.
		 */
		public function StyleParser(s:String, lvl:Level) {
			styles = s.split("}");
			n = styles.length;
			level = lvl;
			if(trim(styles[n-1]).length==0){
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
			trace("Before: '"+s+"'");
			result = s.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2");
			trace("After: '"+result+"'");
			return result;
		}
		
		
		/**
		 * Returns true if there's still more styles to parse.
		 */
		public function hasNext():Boolean{
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
		public function next():StyleDefinition{
			return null;
		}
	}
}
