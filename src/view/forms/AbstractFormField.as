package view.forms {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractFormField extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var background		:Shape;
		protected var labelTF			:TextField;
		
		protected var _required			:Boolean;
		
		protected var _maxWidth			:Number;
		protected var _maxHeight		:Number;
		
		protected var _backgroundColor	:uint;
		protected var _backgroundAlpha	:Number
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function AbstractFormField() {
			
			//initials
			required = false;
			
			maxWidth = 200;
			maxHeight = 35;
			
			backgroundColor = Colors.getColorByName(Colors.WHITE);
			backgroundAlpha = .5;
			
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init(label:String = ""):void {
			
			//1. Background
			background = new Shape();
			background.graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
			background.graphics.drawRect(0,0,this.maxWidth,this.maxHeight);
			background.graphics.endFill();
			
			this.addChildAt(background,0);
			
			if (label) {
			
				this.name = label;
				
				
				//2. Style
				var labelStyle:TextFormat = new TextFormat();
				labelStyle.font = FontFreightSans.BOOK;
				labelStyle.color = Colors.getColorByName(Colors.BLACK);
				labelStyle.size = 11;
				
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
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function validationWarning(value:Boolean = true):void {
			
			if (value) {
				TweenMax.to(labelTF,.8,{tint:Colors.getColorByName(Colors.RED)});
			} else {
				TweenMax.to(labelTF,.8,{removeTint:true});
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
		
	}
}