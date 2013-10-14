package view.assets.buttons {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class RemoveRedButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var icon					:Sprite;
		
		
		//****************** Properties ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function RemoveRedButton() {
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			//icon
			icon = new Sprite();
			this.addChild(icon);
			
			var imageLoader:ImageLoader;
			imageLoader = new ImageLoader("images/icons/redX.png", {name:"x", estimatedBytes:500, container:icon, width:10, height:10, scaleMode:"proportionalInside", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
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