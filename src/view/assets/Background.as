package view.assets {
	
	//imports
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import settings.Settings;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class Background extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var image					:Sprite;
		protected var bitmapData			:BitmapData;
		
		//****************** Properties ****************** ****************** ******************

		
		
		/**
		 * 
		 * 
		 */
		public function Background() {
			
			this.mouseChildren = false;
		
			image = new Sprite();
			image.alpha = .6;
			this.addChild(image);
			
			var loader:Loader = new Loader();
			var imagePath:String = "images/noise_lines.png";
			loader.load(new URLRequest(imagePath)); 
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function completeHandler(event:Event):void {
			bitmapData = event.target.content.bitmapData as BitmapData;
			stage.addEventListener(Event.RESIZE, onStageResized);
			onStageResized();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onStageResized(event:Event = null):void {
			image.graphics.clear();
			image.graphics.beginBitmapFill(bitmapData, null, true, true);
			image.graphics.moveTo(0, 0);
			image.graphics.lineTo(stage.stageWidth, 0);
			image.graphics.lineTo(stage.stageWidth, stage.stageHeight);
			image.graphics.lineTo(0, stage.stageHeight);
			image.graphics.lineTo(0, 0);
			image.graphics.endFill();
		}
	
	}
}