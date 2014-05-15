package view.forms {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import flash.events.FocusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.HelveticaNeue;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractFormField extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var background			:Shape;
		
		protected var _label				:String;
		protected var labelTF				:TextField;
		
		protected var _required				:Boolean;
		protected var _displayAsPassword	:Boolean;
		
		protected var _maxWidth				:Number;
		protected var _maxHeight			:Number;
		
		protected var _line					:Boolean;
		protected var _backgroundColor		:uint;
		protected var _backgroundAlpha		:Number
		
		protected var _textColor			:uint;
		protected var _textSize				:int;
		protected var _textPlaceHolder		:String;
		
		protected var gap					:Number = 5;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function AbstractFormField() {
			
			//initials
			_required = false;
			_displayAsPassword = false;
			
			_label = "";
			
			maxWidth = 200;
			maxHeight = 35;
			
			_line = true;
			backgroundColor = Colors.getColorByName(Colors.WHITE);
			backgroundAlpha = .8;
			
			_textColor = Colors.getColorByName(Colors.DARK_GREY);
			_textSize = 18;
			_textPlaceHolder = "";
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init(label:String = ""):void {
			
			//1. Background
			background = new Shape();
			if (this.line) background.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY),.5,true,LineScaleMode.NONE);
			background.graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
			background.graphics.drawRect(0,0,this.maxWidth,this.maxHeight);
			background.graphics.endFill();
			
			this.addChildAt(background,0);
			
			if (label != "") {
				
				this.name = label;
				
				//2. Style
				var labelStyle:TextFormat = new TextFormat();
				labelStyle.font = HelveticaNeue.CONDENSED_BOLD;
				labelStyle.color = Colors.getColorByName(Colors.BLACK);
				labelStyle.size = 11;
				labelStyle.letterSpacing = .4;
				
				//3. label
				labelTF = new TextField();
				labelTF.mouseEnabled = false;
				labelTF.selectable = false;
				labelTF.autoSize = TextFieldAutoSize.LEFT;
				labelTF.embedFonts = true;
				labelTF.antiAliasType = AntiAliasType.ADVANCED;
				labelTF.defaultTextFormat = labelStyle;
				
				labelTF.text = label;
				
				this.addChild(labelTF);
			}
			
			this.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function focusIn(event:FocusEvent):void {
			//to override
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function focusOut(event:FocusEvent):void {
			//to override
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getInput():String {
			//override
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function validationWarning(value:Boolean = true):void {
			
			if (value) {
				//if (labelTF) TweenMax.to(labelTF,.8,{tint:Colors.getColorByName(Colors.RED)});
				if (background) TweenMax.to(background,.8,{colorTransform:{tint:Colors.getColorByName(Colors.RED), tintAmount:0.3}});
			} else {
				//if (labelTF) TweenMax.to(labelTF,.8,{removeTint:true});
				if (background) TweenMax.to(background,.8,{removeTint:true});
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			
			background.width = maxWidth;
			background.height = maxHeight;
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			this.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
			this.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get required():Boolean {
			return _required;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set required(value:Boolean):void {
			_required = value;
		}
		
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
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get line():Boolean {
			return _line;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set line(value:Boolean):void {
			_line = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get backgroundAlpha():Number {
			return _backgroundAlpha;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set backgroundAlpha(value:Number):void {
			_backgroundAlpha = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			_label = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get textColor():uint {
			return _textColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textColor(value:uint):void {
			_textColor = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get textSize():int {
			return _textSize;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textSize(value:int):void {
			_textSize = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get textPlaceHolder():String {
			return _textPlaceHolder;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textPlaceHolder(value:String):void {
			_textPlaceHolder = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get displayAsPassword():Boolean {
			return _displayAsPassword;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set displayAsPassword(value:Boolean):void {
			_displayAsPassword = value;
		}

	
	}
}