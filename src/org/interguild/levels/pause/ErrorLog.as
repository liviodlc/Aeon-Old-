package org.interguild.levels.pause {

	import fl.controls.TextArea;

	import flash.events.MouseEvent;

	public class ErrorLog extends PauseLog {

		public function ErrorLog(w:Number, h:Number, ps:Pause) {
			super(w, h, ps, "Error Log", false);
		}


		public function set errors(s:String):void {
			log.text = s;
		}


		protected override function onMid(evt:MouseEvent):void {
			pause.show("code");
		}
	}
}
