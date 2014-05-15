package view.profile {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Sprite;
	
	import model.Session;
	
	import settings.Settings;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class ProfileTopBar extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var image						:Sprite;
		
		protected var SERVER_IMAGE_PATH			:String = "http://labs.fluxo.art.br/wrkflux/users/profile_image/";
		protected var GENERIC_PROFILE_IAMGE		:String = "generic_profile.png";
		
		protected var maxWidth					:Number = 30;
		protected var maxHeight					:Number = 30;
		
		//****************** Costructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ProfileTopBar() {
			
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xFFFFFF,.0);
			bg.graphics.drawRect(0,0,30,30);
			bg.graphics.endFill();
			this.addChild(bg);
			
			image = new Sprite();
			image.alpha = .6;
			this.addChild(image);
			
			var profileImageName:String;
			if (Session.userProfileImage) {
				profileImageName = Session.userProfileImage;
			} else {
				profileImageName = GENERIC_PROFILE_IAMGE;
			}
			
			startImageLoader(profileImageName);
			
			this.buttonMode = true;
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param profileImageName
		 * 
		 */
		protected function startImageLoader(profileImageName:String):void {
			var imageLoader:ImageLoader;
			imageLoader = new ImageLoader(SERVER_IMAGE_PATH+profileImageName,
									      {name:"profileImage", estimatedBytes:5000,
										   container:image,
										   width:this.maxWidth,
										   height:this.maxWidth,
										   scaleMode:"proportionalInside",
										   onProgress:progressHandler,
										   onComplete:completeHandler,
										   onError:errorHandler,
										   onFail:failHandler,
										   onHTTPStatus:httpStatusHandler});
			imageLoader.load();
		}
		
		/**
		 * 
		 * 
		 */
		protected function forceLoadGenericImage():void {
			startImageLoader(GENERIC_PROFILE_IAMGE)
		}
		
		/**
		 * 
		 * @param target
		 * 
		 */
		protected function removeImageLoaderListeners(target:ImageLoader):void {
			target.removeEventListener(LoaderEvent.COMPLETE, progressHandler);
			target.removeEventListener(LoaderEvent.PROGRESS, completeHandler);
			target.removeEventListener(LoaderEvent.ERROR, errorHandler);
			target.removeEventListener(LoaderEvent.FAIL, failHandler);
			target.removeEventListener(LoaderEvent.HTTP_STATUS, failHandler);
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
			image.addChild(event.target.content);
			removeImageLoaderListeners(event.target as ImageLoader);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandler(event:LoaderEvent):void {
			if (Settings.debug) trace("error occured with " + event.target + ": " + event.text);
			removeImageLoaderListeners(event.target as ImageLoader);
			forceLoadGenericImage();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function failHandler(event:LoaderEvent):void {
			if (Settings.debug) trace("A failure occured with " + event.target + ": " + event.text);
			removeImageLoaderListeners(event.target as ImageLoader);
			forceLoadGenericImage();		
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function httpStatusHandler(event:LoaderEvent):void {
			if (Settings.debug) trace("HTTP Statues of " + event.target + ": " + event.text)
			removeImageLoaderListeners(event.target as ImageLoader);
			if (event.text == "404") forceLoadGenericImage();
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function update():void {
			var profileImageName:String;
			if (Session.userProfileImage) {
				profileImageName = Session.userProfileImage;
			} else {
				profileImageName = GENERIC_PROFILE_IAMGE;
			}
			startImageLoader(profileImageName);
		}
	}
}