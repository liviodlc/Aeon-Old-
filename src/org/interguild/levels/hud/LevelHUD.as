package org.interguild.levels.hud {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	import org.interguild.Aeon;
	import org.interguild.levels.objects.styles.PseudoClassTriggers;

	public class LevelHUD extends Sprite {

		protected var levelState:PseudoClassTriggers;
		protected var theStage:Stage;

		protected var page_start:Sprite;
		protected var page_play:Sprite;
		protected var page_win:Sprite;


		public function LevelHUD(levelstate:PseudoClassTriggers) {
			levelState = levelstate;
			theStage = Aeon.instance.stage;

			page_start = new Sprite();
			page_play = new Sprite();
			page_win = new Sprite();

			page_play.visible = false;
			page_win.visible = false;

			addChild(page_start);
			addChild(page_play);
			addChild(page_win);

			theStage.addEventListener(Event.RESIZE, eventResize, false, 0, true);
		}


		public function gotoPage_Start():void {
			page_play.visible = false;
			page_win.visible = false;
			page_start.visible = true;
		}


		public function gotoPage_Play():void {
			page_win.visible = false;
			page_start.visible = false;
			page_play.visible = true;
		}


		public function gotoPage_Win():void {
			page_start.visible = false;
			page_play.visible = false;
			page_win.visible = true;
		}


		private function eventResize(evt:Event):void {
			onStageResize();
		}


		protected function onStageResize():void {
			//TODO resize all elements with percent sizes.
		}


		public function onLoadComplete():void {
			//TODO update all elements that respond to event LEVEL_LOAD_COMPLETE
		}


		/**
		 * Called by Level.onGameLoop(evt:TimerEvent)
		 */
		public function onGameLoop():void {
			if (levelState.hasChanged(true)) {
				if (levelState.getPreview()) {
					page_start.visible = true;
					page_play.visible = false;
					page_win.visible = false;
					if (!levelState.getLoading())
						onLoadComplete();
				} else if (levelState.getEnding()) {
					page_start.visible = false;
					page_play.visible = false;
					page_win.visible = true;
				} else {
					page_start.visible = false;
					page_play.visible = true;
					page_win.visible = false;
				}
			}
		}
	}
}
