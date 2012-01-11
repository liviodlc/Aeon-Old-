package org.interguild.levels {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import org.interguild.Aeon;
	import org.interguild.levels.objects.styles.DynamicTriggers;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;
	import org.interguild.levels.objects.styles.StyleDefinition;
	import org.interguild.utils.OrderedList;

	public class LevelCamera {

		private var normalTriggers:PseudoClassTriggers;
		private var dynamicTriggers:DynamicTriggers;
		private var levelState:PseudoClassTriggers;

		private var normalStyles:OrderedList;
		private var dynamicStyles:OrderedList;
		private var stylesInitialized:Boolean = false;

		private var lvl:LevelArea;
		private var box:Rectangle;
		private var boxRelative:Array;
		private var isRelative:Boolean;

		private var s:Stage;


		public function LevelCamera(level:Level) {
			lvl = level.levelArea;
			levelState = level.state;

			normalTriggers = new PseudoClassTriggers();
			dynamicTriggers = new DynamicTriggers();

			normalStyles = new OrderedList();
			dynamicStyles = new OrderedList();

			s = Aeon.instance.stage;
			box = new Rectangle(0, 0, s.stageWidth, s.stageHeight);
			boxRelative = [0, 0, 0, 0];
			s.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
		}


		public function onGameLoop(focusX:Number, focusY:Number):void {
			lvl.x = int(-focusX + box.x + box.width / 2);
			lvl.y = int(-focusY + box.y + box.height / 2);

			if ( /*lvl.x < 0 &&*/lvl.levelWidth + lvl.x < box.width) {
				lvl.x = int(box.width - lvl.levelWidth);
			}
			if ( /*lvl.y < 0 &&*/lvl.levelHeight + lvl.y < box.height) {
				lvl.y = int(box.height - lvl.levelHeight);
			}
			if(lvl.x > 0){
				lvl.x = 0;
			}
			if(lvl.y > 0){
				lvl.y = 0;
			}
		}


		public function onStageResize(evt:Event):void {
			box = new Rectangle(boxRelative[3], boxRelative[0], s.stageWidth + boxRelative[3] + boxRelative[1], s.stageHeight + boxRelative[0] + boxRelative[2]);
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


		public function updateStyles(init:Boolean = false):void {
			if (init || normalTriggers.hasChanged() || dynamicTriggers.hasChanged() || levelState.hasChanged(true)) {
				applyStylesList(normalStyles);
				applyStylesList(dynamicStyles);
				stylesInitialized = true;
			}
			normalTriggers.update();
			dynamicTriggers.update();
		}


		private function applyStylesList(list:OrderedList):void {
			var n:uint = list.length;
			for (var i:uint = 0; i < n; i++) {
				var styleDef:StyleDefinition = StyleDefinition(list.get(i));
				if (!stylesInitialized) {
					normalTriggers.track(styleDef.normalTriggers);
				}
				if (normalTriggers.isStyleActiveNormal(styleDef.normalTriggers) && levelState.isStyleActiveGlobal(styleDef.normalTriggers)) {
					var rules:Object = styleDef.rulesArray;
					for (var key:String in rules) {
						applyStyle(key, rules[key], styleDef);
					}
				}
			}
		}


		private function applyStyle(prop:String, val:Object, styleDef:StyleDefinition):void {
			// TODO implement function
			switch (prop) {
				case 'hitbox-width':
//					collBox.width = Number(val) - 1;
					break;
			}
		}
	}
}
