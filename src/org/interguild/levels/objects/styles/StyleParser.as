package org.interguild.levels.objects.styles {
	import mx.utils.StringUtil;
	
	import org.interguild.levels.Level;
	import org.interguild.levels.objects.GameObjectDefinition;
	import org.interguild.utils.LinkedList;

	/**
	 * This class reads and parses the styles definitions written in the <styles> xml tag.
	 * It returns StyleDefinition objects to StyleMap.
	 */
	internal class StyleParser {

		private var map:StyleMap;
		private var styles:Array;
		private var n:uint;
		private var i:uint;
		private var level:Level


		/**
		 * @param s:String - a string containing all of the style definitions of the level.
		 */
		public function StyleParser(s:String, lvl:Level, _map:StyleMap) {
			map = _map;
			styles = s.split("}");
			n = styles.length;
			level = lvl;
			if (StringUtil.trim(styles[n - 1]).length == 0) {
				styles.pop();
				n--;
			}
			//parse everything!
			while (hasNext()) {
				next();
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
			return "You have a syntax error when defining your '" + nth(i + 1) + "' style definition. ";
		}


		/**
		 * Returns true if there's still more styles to parse.
		 */
		private function hasNext():Boolean {
			return i < n;
		}


		/**
		 * Parses the next style definition and adds it to the StyleMap for
		 * all relevant IDs.
		 */
		private function next():void {
			var cur:String = String(styles[i]);
			var point:int = cur.indexOf("{");
			if (point == -1) {
				level.addError(syntaxError(i) + "Expecting '{' symbol before '}'.");
				i++;
				return;
			}
			var rules:Object = parseStyleRules(cur.substr(point + 1));
			/*
			when parsing first line, we want to know:
				(1) which object type IDs need this StyleDefinition
				(2) the PsuedoClassTriggers bit string for this definition
				(3) the DynamicClassTriggers
				(4) any errors that render this definition useless
			*/
			// users = the first line of definition, divided by commas separating conditions
			var userConditions:Array = cur.substring(0, point).split(",");
			for each (var s:String in userConditions) {
				s = StringUtil.trim(s);
				if (s.substr(0, 6) == "global") {
					//TODO
					// global doesn't have conditions, and its StyleRules are much different.
				} else if (s.substr(0, 5) == "level") {
					//TODO
					// level is limited to global conditions, and very specific StyleRules.
				} else {
					var id:String;
					if (s.charAt(1) == ":") {
						id = s.charAt(0);
					} else {
						id = s.substr(0, 2);
					}
//					trace("id: '" + id + "'");
					var objdef:GameObjectDefinition = map.get(id);
					if (objdef == null)
						level.addError(syntaxError(i) + "You tried to apply styles to an invalid object type ID: '" + id + "'");
					else {
						//TODO: add parseDynamicConditions();
						var p:PseudoClassTriggers = parsePseudoClasses(s.substr(id.length));
						objdef.addStyles(new StyleDefinition(p, null, rules/*, (id.charAt(0) == ".")*/));
					}
				}
			}
			i++;
		}


		/**
		 * Returns an associative array of all the StyleRules in the string.
		 */
		private function parseStyleRules(st:String):Object {
			var list:Object = new Object();
			var a:Array = st.split(";");
			for each (var s:String in a) {
				s = StringUtil.trim(s);
				if (s.length > 0) {
					var point:int = s.indexOf(":");
					if (point == -1) {
						level.addError(syntaxError(i) + "Could not parse this line: '" + s + "'");
					} else {
						var prop:String = StringUtil.trim(s.substring(0, point));
						var val:String = StringUtil.trim(s.substr(point + 1));
						if (val.indexOf(":") != -1)
							level.addError(syntaxError(i) + "You forgot to put a semicolon (;) somewhere, which makes it unclear how this line should be interpreted: '" + s + "'");
						parseRule(prop, val, list);
					}
				}
			}
			return list;
		}


		private function parsePseudoClasses(s:String):PseudoClassTriggers {
			if (s.length == 0)
				return new PseudoClassTriggers();
			else {
				var result:PseudoClassTriggers = new PseudoClassTriggers();
				var a:Array = s.split(":");
				for each (var sub:String in a) {
					sub = StringUtil.trim(sub);
					if (sub.length != 0) {
						switch (sub) {
							case "static":
								result.setStatic();
								break;
							case "nonstatic":
								result.setNonstatic();
								break;
							case "destroyed":
								result.setDestroyed();
								break;
							case "water":
								result.setUnderwater();
								break;
							case "ladder":
								result.setOnLadder();
								break;
							case "standing-on-down":
								result.setStandingDown();
								break;
							case "standing-on-up":
								result.setStandingUp();
								break;
							case "standing-on-right":
								result.setStandingRight();
								break;
							case "standing-on-left":
								result.setStandingLeft();
								break;
							case "up":
								result.setMoveUp(true, false);
								break;
							case "down":
								result.setMoveDown(true, false);
								break;
							case "right":
								result.setMoveRight(true, false);
								break;
							case "left":
								result.setMoveLeft(true, false);
								break;
							case "face-right":
								result.setFaceRight();
								break;
							case "face-left":
								result.setFaceLeft();
								break;
							case "face-up":
								result.setFaceUp();
								break;
							case "face-down":
								result.setFaceDown();
								break;
							case "crawling":
								result.setCrawling();
								break;
							case "preview":
								result.setPreview();
								break;
							case "loading":
								result.setLoading();
								break;
							case "door-open":
								result.setDoorOpen();
								break;
							default:
								level.addError(syntaxError(i) + "Invalid pseudo class used: '" + sub + "'");
								break;
						}
					}
				}
				return result;
			}
		}
		
		
		private function parseRule(prop:String, val:String, map:Object):void{
			switch (prop) {
				case "hitbox-width":
					map[prop] = checkNum(val);
					break;
				case "hitbox-height":
					map[prop] = checkNum(val);
					break;
				case "hitbox-size":
					var a:Array = check2Nums(val);
					map["hitbox-width"] = a[0];
					map["hitbox-height"] = a[1];
					break;
				default:
					level.addError(syntaxError(i) + "Invalid property: '" + prop + "'");
			}
		}
		
		/**
		 * Returns a valid number for the string
		 */
		private function checkNum(s:String, notZero:Boolean = false):Number {
			var n:Number = Number(s);
			if (isNaN(n))
				if (notZero)
					n = 1;
				else
					n = 0;
			return n;
		}
		
		
		/**
		 * Returns an array of valid numbers from the string.
		 *
		 * If no second number is found in the string, it's default value
		 * will be the first number supplied.
		 */
		private function check2Nums(s:String, notZero:Boolean = false):Array {
			var a:Array = s.split(" ", 2);
			a[0] = Number(a[0]);
			if (isNaN(a[0]))
				if (notZero)
					a[0] = 1;
				else
					a[0] = 0;
			
			if (a[1] == null)
				a[1] = a[0];
			else if (isNaN(a[1]))
				if (notZero)
					a[1] = 1;
				else
					a[1] = 0;
			
			return a;
		}
	}
}
