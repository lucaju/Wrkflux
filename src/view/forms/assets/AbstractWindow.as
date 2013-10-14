package view.forms.assets {
	
	//imports
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractWindow extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _maxWidth				:Number;
		protected var _maxHeight			:Number;
		protected var _roundness			:Number;
		
		protected var _color				:uint;
		protected var _lineThickness		:uint;
		protected var _lineColor			:uint;
		protected var _isScale9Grid			:Boolean;
		
		protected var _shape				:Sprite;
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function AbstractWindow() {
			roundness = 10;
			lineThickness = 0;
			lineColor = Colors.getColorByName(Colors.DARK_GREY);
			color = Colors.getColorByName(Colors.WHITE);
		}
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init(width:Number, height:Number):void {
			//to override
		}
		
		/**
		 * 
		 * @param offset
		 * 
		 */
		public function arrowOffsetX(offset:Number):void {
			//to override
		}
		
		/**
		 * 
		 * @param offset
		 * 
		 */
		public function changeArrowOrientation(value:String):void {
			//to override
		}
		
		//****************** GETTERS // SETTER ****************** ******************  ****************** 
		
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
		public function get roundness():Number {
			return _roundness;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set roundness(value:Number):void {
			_roundness = value;
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
		public function set color(value:uint):void {
			_color = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get lineThickness():uint {
			return _lineThickness;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lineThickness(value:uint):void {
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
		public function set lineColor(value:uint):void {
			_lineColor = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shape():Sprite {
			return _shape;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shape(value:Sprite):void {
			_shape = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get isScale9Grid():Boolean {
			return _isScale9Grid;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set isScale9Grid(value:Boolean):void {
			_isScale9Grid = value;
		}

		
	}
}