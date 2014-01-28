package view.assets.buttons {
	
	//imports
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import util.Colors;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var shape					:Sprite
		protected var labelTF				:TextField;
		
		protected var _shapeForm			:String; 
		
		protected var _color				:uint;
		protected var _colorAlpha			:Number;
		
		protected var _line					:Boolean;
		protected var _lineThickness		:Number;
		protected var _lineColor			:uint;
		protected var _lineColorAlpha		:Number;
		
		protected var _maxWidth				:Number;
		protected var _maxHeight			:Number;
		
		protected var _togglable			:Boolean;
		protected var _toggle				:Boolean;
		protected var _toggleColor			:uint;
		protected var _toggleColorAlpha		:Number;
		
		//****************** Constructor ****************** ****************** ******************
		
		public function AbstractButton() {
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			shapeForm = ButtonShapeForm.RECT;
			
			_color = Colors.getColorByName(Colors.BLUE);
			_colorAlpha = 1;
			
			_line = false;
			_lineThickness = 1;
			_lineColor = Colors.getColorByName(Colors.WHITE);
			_lineColorAlpha = 1;
			
			maxWidth = 100;
			maxHeight = 30;
			
			_togglable = false;
			_toggle = false;
			_toggleColor = Colors.getColorByName(Colors.GREEN);
			_toggleColorAlpha = 1;
			
		}
		
		//****************** Initialize ****************** ****************** ******************

		/**
		 * 
		 * @param label
		 * 
		 */
		public function init(label:String):void {
			//to override
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLabel():String {
			return null;
			//to override
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getColorName():String {
			return Colors.getColorByUint(color);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLineColorName():String {
			return Colors.getColorByUint(lineColor);
		}
	
		/**
		 * 
		 * 
		 */
		public function doToggle():void {
			
		}
		
		
		//****************** GETTERTS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shapeForm():String {
			return _shapeForm;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shapeForm(value:String):void {
			_shapeForm = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get color():uint {
			return _color;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:*):void {
			
			if (value is uint) {
				
				_color = value;
				
			} else if (value is String) {
				
				_color = Colors.getColorByName(value);
			}	
			
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get colorAlpha():Number {
			return _colorAlpha;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set colorAlpha(value:Number):void {
			_colorAlpha = value;
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
		public function get lineThickness():Number {
			return _lineThickness;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lineThickness(value:Number):void {
			_lineThickness = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get lineColor():uint {
			return _lineColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lineColor(value:*):void {
			if (color is uint) {
				
				_lineColor = color;
				
			} else if (color is String) {
				
				_lineColor = Colors.getColorByName(value);
			}	
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get lineColorAlpha():Number {
			return _lineColorAlpha;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lineColorAlpha(value:Number):void {
			_lineColorAlpha = value;
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
		public function get togglable():Boolean {
			return _togglable;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set togglable(value:Boolean):void {
			_togglable = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get toggle():Boolean {
			return _toggle;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set toggle(value:Boolean):void {
			_toggle = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get toggleColor():uint {
			return _toggleColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set toggleColor(value:uint):void {
			_toggleColor = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get toggleColorAlpha():Number {
			return _toggleColorAlpha;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set toggleColorAlpha(value:Number):void {
			_toggleColorAlpha = value;
		}


	}
}