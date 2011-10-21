package org.interguild.gui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.filters.ShaderFilter;
	
	import org.interguild.Aeon;
	import org.interguild.resize.WindowResizer;

	/**
	 * How to use: Add an instance of this class as a child. A small icon will appear on the bottom right of the page,
	 * and when it's clicked on, it will resize the window to the default size that you set it to.
	 */
	public class ResizeIcon extends Sprite
	{

		[Embed(source="images/resize.png")]
		private var ResizeImg:Class;
		private var resize:Bitmap;

		private var theStage:Stage;
		private var resizer:WindowResizer = new WindowResizer();

		private var defaultWidth:int;
		private var defaultHeight:int;

		/**
		 * Specify the "default" window width and height. When this icon is clicked on, it will resize the Aeon window
		 * to that size.
		 */
		public function ResizeIcon(windowWidth:int, windowHeight:int)
		{
			defaultWidth=windowWidth;
			defaultHeight=windowHeight;

			theStage = Aeon.instance.stage;
			var sw:int=theStage.stageWidth;
			var sh:int=theStage.stageHeight;

			resize=new ResizeImg();
			resize.x=sw - resize.width - 10;
			resize.y=sh - resize.height - 10;
			resize.alpha=.5;
			if (sw == defaultWidth && sh == defaultHeight){
				resize.visible=false;
			}
			addChild(resize);

			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addEventListener(MouseEvent.CLICK,onMouseClick,false,0,true);
			theStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
		}

		private function onMouseClick(event:MouseEvent):void{
			resizer.resize(defaultHeight,defaultWidth);
		}

		private function onStageResize(event:Event):void{
			var sw:int=theStage.stageWidth;
			var sh:int=theStage.stageHeight;
			resize.x=sw - resize.width - 10;
			resize.y=sh - resize.height - 10;

			if (sw == defaultWidth && sh == defaultHeight)
			{
				resize.visible=false;
			}
			else if (resize.visible == false)
			{
				resize.visible=true;
			}
		}

		private function onMouseOut(event:MouseEvent):void
		{
			resize.alpha=.5;
		}

		private function onMouseOver(event:MouseEvent):void
		{
			resize.alpha=1;
		}


	}
}
