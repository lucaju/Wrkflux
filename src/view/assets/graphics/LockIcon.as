package view.assets.graphics {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Sprite;
	
	import settings.Settings;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class LockIcon extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var image						:Sprite;
		protected var _maxWidth					:Number;
		protected var _maxHeight				:Number;
		
		
		//****************** Costructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function LockIcon() {
			_maxWidth = 15;
			_maxHeight = 15;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		public function init():void {
			
			image = new Sprite();
			image.alpha = .6;
			this.addChild(image);
			
			var imageLoader:ImageLoader;
			imageLoader = new ImageLoader("http://labs.fluxo.art.br/wrkflux/images/privateWF_icon.png",
										  {name:"LockIcon", estimatedBytes:250,
										   container:image,
										   width:this.maxWidth,
										   height:this.maxWidth,
										   scaleMode:"proportionalInside",
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
			if (Settings.debug) trace("progress: " + event.target.progress);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function completeHandler(event:LoaderEvent):void {
			if (image.numChildren > 1) image.removeChildAt(0);
			event.target.removeEventListener(LoaderEvent.COMPLETE, progressHandler);
			event.target.removeEventListener(LoaderEvent.PROGRESS, completeHandler);
			event.target.removeEventListener(LoaderEvent.ERROR, errorHandler);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandler(event:LoaderEvent):void {
			if (Settings.debug) trace("error occured with " + event.target + ": " + event.text);
			event.target.removeEventListener(LoaderEvent.COMPLETE, progressHandler);
			event.target.removeEventListener(LoaderEvent.PROGRESS, completeHandler);
			event.target.removeEventListener(LoaderEvent.ERROR, errorHandler);
		}

		
		//****************** GETTERS AND SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():Number {
			return _maxWidth;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxWidth(value:Number):void {
			_maxWidth = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxHeight():Number {
			return _maxHeight;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
		}


	}
}