package view.initial {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Brand extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var token			:Sprite;
		protected var wrk			:Sprite;
		protected var flux			:Sprite;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Brand() {
		
		}
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function init():void {
			//1.brand
			
			token = new Sprite();
			wrk = new Sprite();
			flux = new Sprite();
			
			this.addChild(token);
			this.addChild(wrk);
			this.addChild(flux);
			
			var dataQueu:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			dataQueu.append( new ImageLoader("images/initial/token.png", {name:"token", estimatedBytes:2000, alpha:0, container:token, width:210, height:210, scaleMode:"proportionalInside"}) );
			dataQueu.append( new ImageLoader("images/initial/wrk.png", {name:"wrk", estimatedBytes:720, alpha:0, container:wrk, width:80, height:60, scaleMode:"proportionalInside"}) );
			dataQueu.append( new ImageLoader("images/initial/flux.png", {name:"flux", estimatedBytes:500, alpha:0, container:flux, width:80, height:60, scaleMode:"proportionalInside"}) );
			dataQueu.load();
			
		}
		
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
			
			var tokenImage:ContentDisplay = LoaderMax.getContent("token");
			tokenImage.x = -tokenImage.width/2;
			tokenImage.y = -tokenImage.height/2;
			tokenImage.alpha = 1;
			token.x += tokenImage.width/2;
			token.y += tokenImage.height/2;
			
			var wrkImage:ContentDisplay = LoaderMax.getContent("wrk");
			var fluxImage:ContentDisplay = LoaderMax.getContent("flux");
			wrkImage.alpha = fluxImage.alpha = 1;
			wrk.y = flux.y = token.height + 10;
			wrk.x = 25;
			flux.x = wrk.x + wrk.width;
			
			this.x = (this.stage.stageWidth/2) - (token.width/2);
			this.y = 100;
			
			TweenMax.from(token, 2, {alpha:0, scaleX:0, scaleY:0});
			//TweenMax.from(token, 240, {rotation:360, yoyo:true, repeat:-1});
			TweenMax.from(wrk, 2, {alpha:0, x:0, delay:1.5});
			TweenMax.from(flux, 2, {alpha:0, x:flux.x + 10, delay:1.5});
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}
	}
}