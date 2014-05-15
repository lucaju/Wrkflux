package view.forms.image {
	
	//imports
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import events.WrkfluxEvent;
	
	import model.PHPGateWay;
	import model.Session;
	
	import settings.Settings;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class ImageFieldUploaderHelper extends EventDispatcher {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target					:ImageField;
		protected var fileRef					:FileReference;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ImageFieldUploaderHelper(_target:ImageField) {
			
			target = _target;
			fileRef = new FileReference();
			
			this.addEventListener(MouseEvent.CLICK, chooseFile);
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		public function chooseFile():void {
			fileRef.addEventListener(Event.SELECT, onSelectFile);
			fileRef.addEventListener(Event.COMPLETE, selectFileLoadComplete);
			
			var imageTypes:FileFilter = new FileFilter("Images (*.jpg, *.png)", "*.jpg;*.png");
			fileRef.browse([imageTypes]); 
		}
		
		/**
		 * 
		 * 
		 */
		public function uploadImage():void {
			
			var urlRequest:URLRequest = new URLRequest(PHPGateWay.receiveFile);
			
			var variables:URLVariables = new URLVariables();
			variables.todayDate = new Date();
			variables.userID = Session.userID;
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = variables;
			
			fileRef.upload(urlRequest);
			
			fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadDataComplete);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onSelectFile(event:Event):void {
			fileRef.load();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function selectFileLoadComplete(event:Event):void {
			
			var formData:Object = new Object();
			
			if (fileRef.size <= 50000) {
				
				target.imageFile = fileRef.name;
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener (Event.COMPLETE, selectedFileLoaded );
				
				loader.loadBytes (fileRef.data);
				
				formData.success = true;
				formData.successType = "file chosen";
				
			} else {
				formData.success = false;
				formData.errorType = "warning";
				formData.errorMessage = "Exceeded max file size limit (50kb - 240x20px)!";
				
			}
			
			target.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, formData));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function selectedFileLoaded(event:Event):void {
			event.target.removeEventListener (Event.COMPLETE, selectedFileLoaded );
			var bitmap:Bitmap = Bitmap (event.target.content) ;
			
			if (target.image.numChildren > 1) target.image.removeChildAt(0);
			
			bitmap.smoothing = true;
			
			var rate:Number = bitmap.height/bitmap.width;
			
			if (rate >= 1) {
				bitmap.height = target.maxHeight;
				bitmap.width = bitmap.height/rate;
			} else {
				bitmap.width = target.maxWidth;
				bitmap.height = bitmap.width*rate;
			}
			
			target.image.addChild(bitmap);
			
			target.usingGenericImage = false;
			
			target.addRemoveButton();
		}		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function handleError(event:IOErrorEvent):void {
			if (Settings.debug) trace("ioErrorHandler: " + event);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function uploadDataComplete(event:DataEvent):void {
			
			var data:Object = JSON.parse(event.data);
			
			var formData:Object = new Object();
			
			if (data.success == true) {
				
				//update Session
				formData.profileImage = data.file_name;
				Session.updateUser(formData);
				
				target.imageFile = data.file_name;
				
				formData.success = true;
				formData.successType = "file uploaded";
				
			} else {
				
				formData.success = false;
				formData.errorType = "Error";
				formData.errorMessage = "An error occurred! Please try again.";
				
			}
			
			
			target.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, formData));
		}
		
	}
}