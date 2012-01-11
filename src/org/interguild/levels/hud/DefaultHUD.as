package org.interguild.levels.hud {
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import org.interguild.Aeon;
	import org.interguild.levels.Level;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;

	public class DefaultHUD extends LevelHUD {

		private var titleText:TextField;
		private var toStart:TextField;
		
		private var text:TextField;
		private var last:uint;
		private var data:Array;


		public function DefaultHUD(levelstate:PseudoClassTriggers, title:String) {
			super(levelstate);

			initTitle(title);
			initJumpToStart();
//			initText();
//			data = [];
		}


		protected override function onStageResize():void {
			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;
			titleText.width = sw;
			toStart.x = sw / 2 - toStart.width / 2;
			toStart.y = sh - 100;
		}


		private function initTitle(title:String):void {
			var titleFormat:TextFormat = new TextFormat("Verdana", 36, 0xFF0000);
			titleText = new TextField();
			titleFormat.align = TextFormatAlign.CENTER;
			with (titleText) {
				wordWrap = true;
				multiline = true;
				autoSize = TextFieldAutoSize.CENTER;
				width = theStage.stageWidth;
				text = title.split("\r\n").join("\r");
				setTextFormat(titleFormat);
				background = true;
				backgroundColor = 0x000000;
				selectable = true;
				x = 0;
			}
			page_start.addChild(titleText);
		}


		private function initJumpToStart():void {
			var format:TextFormat = new TextFormat("Verdana", 30, 0xFFFFFF);
			toStart = new TextField();
			format.align = TextFormatAlign.CENTER;
			with (toStart) {
				wordWrap = false;
				multiline = false;
				autoSize = TextFieldAutoSize.CENTER;
				toStart.defaultTextFormat = format;
				text = "Press Space to Start";
				background = true;
				backgroundColor = 0x990000;
				selectable = false;
				x = theStage.stageWidth / 2 - width / 2;
				y = theStage.stageHeight - 100;
				visible = false;
			}
			page_start.addChild(toStart);
		}
		
		private function initText():void{
			var format:TextFormat = new TextFormat("Arial", 30, 0xFFFFFF);
			text = new TextField();
			format.align = TextFormatAlign.LEFT;
			with (text) {
				wordWrap = false;
				multiline = true;
				autoSize = TextFieldAutoSize.LEFT;
				defaultTextFormat = format;
				text = "No\nData";
				background = true;
				backgroundColor = 0x0;
				selectable = false;
				x = 10;
				y = theStage.stageHeight - height - 10;
			}
			this.addChild(text);
		}

		

		public override function onLoadComplete():void {
			toStart.visible = true;
//			data = [];
		}
		
		public override function onGameLoop():void{
			super.onGameLoop();
//			var cur:uint = getTimer();
//			var elapsed:uint = cur - last;
//			var n:uint = data.length;
//			if(n < 10){
//				data.push(elapsed);
//			}else{
//				var avg:Number = 0;
//				for(var i:uint = 0; i < n; i++){
//					avg += data[i]
//				}
//				avg = avg / n;
//				var fps:Number = Math.round(1 / (avg / 1000));
//				text.text = Math.round(avg) +" / 33 ms\n"+fps+" fps";
//				data = [];
//			}
//			last = cur;
		}
	}
}
