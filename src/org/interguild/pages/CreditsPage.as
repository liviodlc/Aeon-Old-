package org.interguild.pages {

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import org.interguild.Aeon;
	import org.interguild.gui.Btn;
	import org.interguild.gui.BtnRecSolid;
	import org.interguild.gui.BtnRndGrad;

	public class CreditsPage extends Page {

		private var list:TextField;

		private var exit:Btn;
		private var theStage:Stage;

		public function CreditsPage() {
			theStage = Aeon.instance.stage;
			
			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;

			/**initialize CSS:**/
			var css:StyleSheet = new StyleSheet();
			//set body styles:
			var body:Object = new Object();
			body.fontFamily = "Arial";
			body.fontSize = 12;
			body.color = "#EFEFEF";
			body.textAlign = "center";
			//set name css class:
			var name:Object = new Object();
			name.fontSize = 17;
			name.fontWeight = "bold";
			name.color = "#FFFFFF";
			var heading:Object = new Object();
			heading.fontSize = 15;
			heading.textDecoration = "underline";
			//apply css classes:
			css.setStyle("body", body);
			css.setStyle(".name", name);
			css.setStyle(".heading", heading);

			//initialize credits text:
			list = new TextField();
			list.styleSheet = css;
			list.wordWrap = true;
			list.width = 300;
			list.height = sh - 30;
			list.htmlText =
				"<body><p class='heading'>Programming:</p>\n\n<p class='name'>Livio</p>\n\n\n" +
				"<p class='heading'>Repository Support:</p>\n\n<p class='name'>Rory</p>\n\n\n" +
				"<p class='heading'>Artwork:</p>\n\n<p class='name'>Kittikiyana\njellsprout</p>\n\n\n" +
				"<p class='heading'>Music and Sound:</p>\n\n<p class='name'>Dekudude\nthe_grimace</p>\n\n\n" +
				"<p class='heading'>Special thanks to:</p>\n\n" +
				"All of the members from <b>interguild.org</b> who contributed ideas, criticisim, and support for the dream behind Aeon.</p>\n\n" +
				"</body>";
			list.y = 20;
			list.x = 20;

			//create exit button:
			exit = new BtnRecSolid("Back to Main");
			exit.x = sw - exit.width / 2 - 20;
			exit.y = sh - 28;
			exit.addEventListener(MouseEvent.CLICK, onExitClick, false, 0, true);

			addChild(list);
			addChild(exit);
		}

		private function onStageResize(evt:Event):void {
			var mid:Number = theStage.stageWidth / 2;
			var end:int = theStage.stageHeight;
			exit.x = theStage.stageWidth - exit.width / 2 - 20;
			list.height = end - 30;
			exit.y = end - 28;
		}

		private function onExitClick(evt:MouseEvent):void {
			Aeon.instance.gotoHomePage();
		}
		
		/**
		 * Should hide the page and remove event listeners
		 */
		public override function close():void {
			visible = false;
			theStage.removeEventListener(Event.RESIZE,onStageResize);
		}
		
		/**
		 * Should make the page visible and activate event listeners
		 */
		public override function open():void {
			onStageResize(null);
			visible = true;
			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
		}
	}
}