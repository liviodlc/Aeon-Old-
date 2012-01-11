package org.interguild.pages {

	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import org.interguild.Aeon;
	import org.interguild.gui.Btn;
	import org.interguild.gui.BtnRecText;
	import org.interguild.gui.ResizeIcon;

	/**
	 * This class builds the homepage, which is a menu with links to the game's various features.
	 * Contents include: the Aeon logo, a gradient background, a button to the Demo level, a button to
	 * the editor, and a button to credits.
	 */
	public class HomePage extends Page {

		[Embed(source = "images/aeon_logo.png")]
		private var Aeon_Logo:Class;

		private var logo:Bitmap;
		private var levelsLink:Btn;
		private var editorLink:Btn;
		private var creditsLink:Btn;
		private var gradBg:Sprite;
		private var version:TextField;

		private var theStage:Stage;

		//These variables define the colors used in the gradient background.
		private static const BG_COLOR1:uint = 0x444444;
		private static const BG_COLOR2:uint = 0; //black is 0


		/**
		 * @param sw:int = the current stage width
		 * @param sh:int = the current stage height
		 * @param _aeon = a reference to the document class Aeon
		 */
		public function HomePage() {
			//store reference to stage for optimized and later use
			theStage = Aeon.instance.stage;
			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;

			//draw gradient background
			gradBg = new Sprite();
			var myMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
			myMatrix.createGradientBox(sw, sh, Math.PI / 2);
			with (gradBg.graphics) {
				beginGradientFill(GradientType.LINEAR, [BG_COLOR1, BG_COLOR2], [1, 1], [0, 255], myMatrix);
				drawRect(0, 0, sw, sh);
				endFill();
			}

			var midStage:Number = sw / 2;

			//instantiate the logo from .fla's library
			logo = new Aeon_Logo();
			logo.x = midStage - 184;
			logo.y = 30;

			//create the button linking to the demo
			levelsLink = new BtnRecText("User Levels");
			levelsLink.moveTo(midStage, 220);
			levelsLink.addEventListener(MouseEvent.CLICK, demoLinkClick, false, 0, true);

			//create button for editor
			editorLink = new BtnRecText("Level Editor");
			editorLink.moveTo(midStage, 260);
			editorLink.addEventListener(MouseEvent.CLICK, editorLinkClick, false, 0, true);

			//create button for credits
			creditsLink = new BtnRecText("Credits");
			creditsLink.moveTo(midStage, 340);
			creditsLink.addEventListener(MouseEvent.CLICK, creditsLinkClick, false, 0, true);

			//create textfield for version number
			version = new TextField();
			version.autoSize = TextFieldAutoSize.LEFT;
			version.defaultTextFormat = new TextFormat("Arial", 12, 0xBBBBBB);
			version.text = "Aeon Demo | Verion 4.0";
			version.selectable = true;
			version.x = 10;
			version.y = sh - version.height - 10;

			addChild(gradBg);
			addChild(logo);
			addChild(levelsLink);
			addChild(editorLink);
			addChild(creditsLink);
			addChild(version);

			//create resize icon
			addChild(new ResizeIcon(640, 480));
		}


		private function onStageResize(evt:Event):void {
			// rather than using "Stage(evt.target).stageWidth", it's faster to use our stored reference to the stage.
			var stage:Stage = Aeon.instance.stage;
			var newWidth:int = stage.stageWidth;
			var newHeight:int = stage.stageHeight
			logo.x = levelsLink.x = editorLink.x = creditsLink.x = newWidth / 2;
			logo.x -= 184;
			gradBg.width = newWidth;
			gradBg.height = newHeight;
			version.x = 10;
			version.y = newHeight - version.height - 10;
		}


		private function demoLinkClick(evt:MouseEvent):void {
			Aeon.instance.gotoLevelsPage();
		}


		private function editorLinkClick(evt:MouseEvent):void {
			Aeon.instance.gotoFakeEditorPage();
		}


		private function creditsLinkClick(evt:MouseEvent):void {
			Aeon.instance.gotoCreditsPage();
		}


		/**
		 * Should hide the page and remove event listeners
		 */
		public override function close():void {
			visible = false;
			theStage.removeEventListener(Event.RESIZE, onStageResize);
		}


		/**
		 * Should make the page visible and activate event listeners
		 */
		public override function open():void {
			visible = true;
			onStageResize(null);
			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
		}
	}
}
