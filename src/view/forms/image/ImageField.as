package view.forms.image {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import font.HelveticaNeue;
	
	import model.Session;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.assets.buttons.RemoveRedButton;
	import view.forms.AbstractFormField;
	
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class ImageField extends AbstractFormField {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var SERVER_IMAGE_PATH			:String = "http://labs.fluxo.art.br/wrkflux/users/profile_image/";
		protected var GENERIC_PROFILE_IAMGE		:String = "generic_profile.png";
		
		protected var _imageFile				:String;
		
		protected var _usingGenericImage		:Boolean;
		protected var uploading					:Boolean;
		
		protected var _image					:Sprite;
		protected var removeButton				:RemoveRedButton;
		protected var labelStyle				:TextFormat;
		
		protected var uploaderHelper			:ImageFieldUploaderHelper;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ImageField() {
			uploading = false;
		}
			
		//****************** Initialize ****************** ****************** ******************
			
		/**
		 * 
		 * @param label
		 * 
		 */
		override public function init(label:String = ""):void {
			
			//initials
			this.name = label;
			this.buttonMode = true;
			super.init(label);
			
			//1. image area
			image = new Sprite();
			super.addChildAt(image,1);
			
			//2 override label style
			labelStyle = new TextFormat();
			labelStyle.font = HelveticaNeue.CONDENSED_BOLD;
			labelStyle.color = Colors.getColorByName(Colors.WHITE);
			labelStyle.size = 11;
			labelStyle.letterSpacing = .4;
			labelStyle.align = TextFormatAlign.CENTER;
			
			//3. check image to load
			var profileImageName:String;
			if (Session.userProfileImage) {
				profileImageName = Session.userProfileImage;
				label = "Replace Photo";
				usingGenericImage = false;
			} else {
				profileImageName = GENERIC_PROFILE_IAMGE;
				usingGenericImage = true;
			}
			
			//4. change label
			labelTF.text = label;
			labelTF.setTextFormat(labelStyle);
			labelTF.x = this.maxWidth/2 - labelTF.width/2;
			labelTF.y = this.maxHeight - labelTF.height;
			
			//5 Label BG
			var labelBG:Sprite = new Sprite();
			
			labelBG.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY),.5);
			labelBG.graphics.drawRect(0,0,this.maxWidth,labelTF.height);
			labelBG.graphics.endFill();
			super.addChildAt(labelBG,2);
			
			labelBG.y = labelTF.y;
			
			//6. load image
			startImageLoader(profileImageName);
			
			//7. update stuff
			uploaderHelper = new ImageFieldUploaderHelper(this);
			
			//8. Listener
			this.addEventListener(MouseEvent.CLICK, chooseFile);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addRemoveButton():void {
			if (!removeButton) {
				removeButton = new RemoveRedButton();
				removeButton.x = this.maxWidth - removeButton.width;
				removeButton.y = removeButton.height/2 - 2;
				this.addChild(removeButton);
				removeButton.addEventListener(MouseEvent.CLICK, removeChosenImage);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeRemoveButton():void {
			if (removeButton) {
				this.removeChild(removeButton);
				removeButton = null;
			}
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param profileImageName
		 * 
		 */
		protected function startImageLoader(profileImageName:String):void {
			var imageLoader:ImageLoader;
			imageLoader = new ImageLoader(SERVER_IMAGE_PATH+profileImageName,
										  {name:"profilePic", estimatedBytes:5000,
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
			usingGenericImage = true;
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
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param imageAdded
		 * 
		 */
		public function updateState(state:String):void {
			
			var newLabel:String;
			
			if (state == "image added") {
				newLabel = "Replace Photo";
			} else if (state == "image removed") {
				newLabel = "Add Photo";
				removeRemoveButton();
			}
			
			//update label
			labelTF.text = newLabel;
			labelTF.setTextFormat(labelStyle);
			labelTF.x = this.maxWidth/2 - labelTF.width/2;
			labelTF.y = this.maxHeight - labelTF.height;
		}
		
		/**
		 * 
		 * 
		 */
		public function uploadImage():void {
			uploaderHelper.uploadImage();
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function chooseFile(event:MouseEvent):void {
			uploaderHelper.chooseFile();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function removeChosenImage(event:MouseEvent):void {
			event.stopImmediatePropagation();
			removeButton.removeEventListener(MouseEvent.CLICK, removeChosenImage);
			removeRemoveButton();
			
			_imageFile = "";
			
			image.removeChildAt(0);
			
			usingGenericImage = true;
			
			startImageLoader(GENERIC_PROFILE_IAMGE)
		}
		
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
			if (Session.userProfileImage && !usingGenericImage) this.addRemoveButton();
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
		
		//****************** GETTERS AND SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLabel():String {
			return labelTF.text;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get usingGenericImage():Boolean {
			return _usingGenericImage;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set usingGenericImage(value:Boolean):void {
			_usingGenericImage = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get imageFile():String {
			return _imageFile;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set imageFile(value:String):void {
			_imageFile = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get image():Sprite {
			return _image;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set image(value:Sprite):void {
			_image = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		override public function getInput():String {
			return _imageFile;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasNewImage():Boolean {
			if (_imageFile != null && _imageFile != "") return true;
			return false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get isRemovingImage():Boolean {
			if (_imageFile == "") return true;
			return false;
		}


	}
}