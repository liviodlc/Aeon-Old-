package org.interguild.pages {

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import org.interguild.Aeon;
	import org.interguild.gui.Btn;
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
			body.fontSize = 13;
			body.color = "#EFEFEF";
			body.textAlign = "center";
			//set name css class:
			var name:Object = new Object();
			name.fontSize = 18;
			name.fontWeight = "bold";
			name.color = "#FFFFFF";
			var heading:Object = new Object();
			heading.fontSize = 16;
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
				"<p class='heading'>Artwork:</p>\n\n<p class='name'>Kittikiyana\njellsprout</p>\n\n\n" +
				"<p class='heading'>Music and Sound:</p>\n\n<p class='name'>Dekudude\nthe_grimace</p>\n\n\n" +
				"<p class='heading'>Special thanks to:</p>\n\n" +
				"All the other members from <b>interguild.org</b> who participated in the discussions and shared in the dream behind Aeon</p>\n\n" +
				"</body>";
			list.y = 20;
			list.x = sw / 2 - 150;

			//create exit button:
			exit = new BtnRndGrad("Back to Main Menu");
			exit.x = sw / 2;
			exit.y = sh - 28;
			exit.addEventListener(MouseEvent.CLICK, onExitClick, false, 0, true);

			addChild(list);
			addChild(exit);
		}

		private function onStageResize(evt:Event):void {
			var mid:Number = theStage.stageWidth / 2;
			var end:int = theStage.stageHeight;
			list.x = mid - 150;
			exit.x = mid;
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