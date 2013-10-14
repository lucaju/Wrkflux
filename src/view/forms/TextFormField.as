package view.forms {
	
	//imports
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
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
			inputStyle.font = FontFreightSans.BOOK;
			inputStyle.color = Colors.getColorByName(Colors.BLACK);
			inputStyle.size = 16;
			
			//2. input
			inputTF = new TextField();
			inputTF.name = this.name + "_input";
			inputTF.type = TextFieldType.INPUT;
			inputTF.width = this.maxWidth;
			inputTF.height = this.maxHeight - 12;
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
			inputTF.y = 12;
			
			this.addChild(inputTF);
			
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