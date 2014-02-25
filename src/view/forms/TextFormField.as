package view.forms {
	
	//imports
	import flash.events.FocusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import font.HelveticaNeue;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TextFormField extends AbstractFormField {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var inputTF			:TextField;
		
		protected var _currentValue		:String;
		
		protected var _textArea			:Boolean;
		protected var _maxChars			:int;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function TextFormField() {
			
			super();
			
			//initials
			textArea = false;
			maxChars = 0;
			
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function init(label:String = ""):void {

			this.name = label;
			
			super.init(label);
			
			//1. Style
			var inputStyle:TextFormat = new TextFormat();
			inputStyle.font = HelveticaNeue.THIN;
			inputStyle.color = this.textColor;
			inputStyle.size = this.textSize;
			
			//2. input
			inputTF = new TextField();
			inputTF.name = this.name + "_input";
			inputTF.type = TextFieldType.INPUT;
			if (this.textPlaceHolder == "") inputTF.displayAsPassword = this.displayAsPassword;
			inputTF.width = this.maxWidth - 2*gap;
			inputTF.height = this.maxHeight- 2*gap;
			inputTF.embedFonts = true;
			inputTF.antiAliasType = AntiAliasType.ADVANCED;
			if (this.labelTF) inputTF.y = -4;
			
			if (this.textArea) {
				inputTF.wordWrap = true;
				inputTF.multiline = true;
				inputTF.width = this.maxWidth;
			}
			
			if (this.maxChars > 0) inputTF.maxChars = this.maxChars;
			inputTF.defaultTextFormat = inputStyle;
			
			if (this.textPlaceHolder != "") inputTF.text = this.textPlaceHolder;
			
			inputTF.x = gap;
			inputTF.y = gap;
			
			this.addChild(inputTF);
			
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override protected function focusIn(event:FocusEvent):void {
			if (this.textPlaceHolder != "" && inputTF.text == this.textPlaceHolder) inputTF.text = "";
			if (this.displayAsPassword) inputTF.displayAsPassword = this.displayAsPassword;
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override protected function focusOut(event:FocusEvent):void {
			if (inputTF.text == "" && this.textPlaceHolder != "") {
				inputTF.displayAsPassword = false;
				inputTF.text = this.textPlaceHolder;
			}
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
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
		public function getInput():String {
			return inputTF.text;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function setValue(value:String):void {
			inputTF.text = value;
			currentValue = value;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

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
		public function get maxChars():int {
			return _maxChars;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxChars(value:int):void {
			_maxChars = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentValue():String {
			return _currentValue;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentValue(value:String):void {
			_currentValue = value;
		}

		
	}
}