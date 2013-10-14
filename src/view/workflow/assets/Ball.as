package view.workflow.assets {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import util.Colors;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Ball extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _color		:uint;
		protected var _radius		:Number;
		protected var shape			:Sprite;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param colorName
		 * 
		 */
		public function Ball(color:* = null) {
			
			this.mouseChildren = false;
			
			//radius
			_radius = 10;
			
			//color
			if (color is String) {
				this._color = Colors.getColorByName(color);
				if (!this._color) this._color = Colors.getColorByName(Colors.WHITE);
				
			} else if (color is uint) {
				this._color = color;
			} else {
				this._color = Colors.getColorByName(Colors.WHITE);
			}
			
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {	
			
			this.buttonMode = true;
			
			//color shape
			shape = new Sprite();
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(0,0,radius);
			shape.graphics.endFill();
			
			this.addChild(shape);
			
			//outline
			var outline:Shape = new Shape();
			outline.graphics.lineStyle(1,Colors.getColorByName(Colors.DARK_GREY));
			outline.graphics.drawCircle(0,0,radius);
			outline.graphics.endFill();
			this.addChild(outline);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function updateColor(value:Object):void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = value.color;
			shape.transform.colorTransform = colorTransform;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function changeColor(value:uint):void {
			var currentColor:Object = {color:this._color};
			_color = value;
			TweenMax.to(currentColor,.4,{hexColors:{color:this.color}, onUpdate:updateColor, onUpdateParams:[currentColor]});
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get radius():Number {
			return _radius;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set radius(value:Number):void {
			_radius = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get color():uint {
			return _color;
		}


	}
}