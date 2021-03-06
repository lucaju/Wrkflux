package view.forms {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import font.HelveticaNeue;
	
	import settings.Settings;
	
	import util.Colors;
	import util.MessageType;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class MessageField extends AbstractFormField {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var messageTF				:TextField;
		protected var icon					:Sprite;
		
		protected var _fontSize				:int;
		protected var _fontWeight			:String;
		protected var _textAlign			:String;
		protected var _textArea				:Boolean;
		protected var _type					:String = MessageType.ERROR;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function MessageField() {
			
			super();

			textArea = false;
			fontSize = 10;
			fontWeight = "condensed_bold";
			textAlign = TextFormatAlign.LEFT;
			this.maxHeight = fontSize * 1.3;
			this.line = false;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param label
		 * 
		 */
		override public function init(label:String = ""):void {
			
			super.init();
			
			//icon
			icon = new Sprite();
			this.addChild(icon);
			
			//2. Style
			var style:TextFormat = new TextFormat();
			style.color = Colors.getColorByName(Colors.DARK_GREY);
			style.size = fontSize;
			style.align = textAlign;
			
			//weight
			switch(fontWeight) {
				
				case "medium":
					style.font = HelveticaNeue.MEDIUM;
					break;
				
				case "condensed_bold":
					style.font = HelveticaNeue.CONDENSED_BOLD;
					break;
				
				default:
					style.font = HelveticaNeue.LIGHT;
					break;
				
			}
			
			
			//3. label
			messageTF = new TextField();
			messageTF.mouseEnabled = false;
			messageTF.selectable = false;
			messageTF.autoSize = TextFieldAutoSize.LEFT;
			messageTF.embedFonts = true;
			messageTF.antiAliasType = AntiAliasType.ADVANCED;
			messageTF.defaultTextFormat = style;
			messageTF.width = this.maxWidth;
			
			
			if (textArea) {
				messageTF.wordWrap = true;
				messageTF.multiline = true;
				messageTF.width = this.maxWidth;
			}
			
			this.addChild(messageTF);
			
			if (this.labelTF) {
				messageTF.y = -4;
			} else {
				icon.y = 2;
			}
			
			//resize
			if (maxHeight < messageTF.height) {
				this.maxWidth = messageTF.width;
				this.maxHeight = messageTF.height;
				this.resize();
			}
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param message
		 * @param type
		 * 
		 */
		public function sendMessage(message:String, type:String = MessageType.ERROR):void {
			
			//type
			_type = type;
			
			//message
			messageTF.text = message;
			
			//remove previous icon
			if (icon.numChildren > 0) icon.removeChildAt(0);
			
			//get icon
			if (type != MessageType.NONE) {
				var imageLoader:ImageLoader;
				
				switch (type) {
					
					case MessageType.SUCCESS:
						imageLoader = new ImageLoader("images/icons/darkCheckmark.png", {name:"successIcon", estimatedBytes:500, container:icon, width:10, height:10, scaleMode:"proportionalInside", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
						break;
					
					case MessageType.WARNING:
						imageLoader = new ImageLoader("images/icons/darkTriangle.png", {name:"warningIcon", estimatedBytes:500, container:icon, width:10, height:10, scaleMode:"proportionalInside", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
						break;
					
					case MessageType.ERROR:
						imageLoader = new ImageLoader("images/icons/darkX.png", {name:"errorIcon", estimatedBytes:500, container:icon, width:10, height:10, scaleMode:"proportionalInside", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
						break;
				}
				
				imageLoader.load();
				
				messageTF.width = messageTF.width - (2*icon.width);
			}
			
			//resize
			if (maxHeight < messageTF.height) {
				this.maxWidth = messageTF.width;
				this.maxHeight = messageTF.height;
				this.resize();
			}
			
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
			messageTF.x = icon.width + 3;
			
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

		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			super.kill();
			
			messageTF.text = "";
			if (icon.numChildren > 0) icon.removeChildAt(0);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get type():String {
			return _type;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get message():String {
			return messageTF.text;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get textArea():Boolean {
			return _textArea;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textArea(value:Boolean):void {
			_textArea = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get fontSize():int {
			return _fontSize;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set fontSize(value:int):void {
			_fontSize = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get fontWeight():String {
			return _fontWeight;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set fontWeight(value:String):void{
			_fontWeight = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get textAlign():String {
			return _textAlign;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textAlign(value:String):void {
			_textAlign = value;
		}

		
	}
}