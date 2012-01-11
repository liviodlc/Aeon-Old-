package org.interguild.levels.pause {
	import flash.events.MouseEvent;

	public class CodeLog extends PauseLog {
		public function CodeLog(w:Number, h:Number, ps:Pause, lvlCode:String) {
			super(w, h, ps, "Level Code", true);
			log.text = lvlCode.split("\r\n").join("\r");
		}


		protected override function onMid(evt:MouseEvent):void {
			pause.show("errors");
		}
	}
}
