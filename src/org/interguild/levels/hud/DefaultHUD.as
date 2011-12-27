package org.interguild.levels.hud {
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.interguild.Aeon;
	import org.interguild.levels.Level;
	import org.interguild.levels.LevelHUD;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;

	public class DefaultHUD extends LevelHUD {

		private var titleText:TextField;
		private var toStart:TextField;


		public function DefaultHUD(levelstate:PseudoClassTriggers, title:String) {
			super(levelstate);

			initTitle(title);
			initJumpToStart();
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
				text = title;
				setTextFormat(titleFormat);
				background = true;
				backgroundColor = 0x000000;
				selectable = true;
				x = 0;
				alpha = .75;
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


		public override function onLoadComplete():void {
			toStart.visible = true;
		}
	}
}
