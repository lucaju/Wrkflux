package view.structure {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class Background extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var image					:Sprite;
		
		
		//****************** Properties ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Background() {
			
			this.mouseChildren = false;
			
			//icon
			image = new Sprite();
			this.addChild(image);
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0x999999;
			glow.alpha = 1; 
			glow.blurX = 5; 
			glow.blurY = 5; 
			glow.quality = BitmapFilterQuality.MEDIUM;
			
			image.filters = [glow];
			
			var imageLoader:ImageLoader;
			imageLoader = new ImageLoader("images/new_background4.jpg", {name:"bg",
																		estimatedBytes:1023000,
																		container:image,
																		width:1260,
																		height:700, 
																		//scaleMode:"proportionalInside", 
																		onProgress:progressHandler, 
																		onComplete:completeHandler, 
																		onError:errorHandler});
			imageLoader.load();
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function progressHandler(event:LoaderEvent):void {
			//trace("progress: " + event.target.progress);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function completeHandler(event:LoaderEvent):void {
			//trace("Complete: " + event.target);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandler(event:LoaderEvent):void {
			//trace("error occured with " + event.target + ": " + event.text);
		}
	}
}