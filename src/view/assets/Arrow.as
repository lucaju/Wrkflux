package view.assets {
	
	//imports
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Arrow extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var shape			:Sprite;
		protected var _width		:Number;
		protected var _height		:Number;
		protected var _direction	:String;
		protected var _color		:uint;
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param width
		 * @param height
		 * @param direction
		 * 
		 */
		public function Arrow(width:Number = 10, height:Number = 14, direction:String = "right") {
			
			this._width = width;
			this._height = height;
			this._direction = direction;
			this._color = Colors.getColorByName(Colors.DARK_GREY);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function draw():void {
			
			if (!shape) {
				shape = new Sprite();
				this.addChild(shape);
				
			} else {
				shape.graphics.clear();
			}
			
			
			shape.graphics.beginFill(color);
			
			switch (direction) {
				
				case "right":
					shape.graphics.lineTo(width,height/2);
					shape.graphics.lineTo(0,height);
					shape.graphics.lineTo(0,0);
					break;
				
				case "left":
					shape.graphics.moveTo(width,0);
					shape.graphics.lineTo(0,height/2);
					shape.graphics.lineTo(width,height);
					shape.graphics.lineTo(width,0);
					break;
			}
			
			shape.graphics.endFill();
			
			shape.x = -shape.width/2;
			shape.y = -shape.height/2;
			
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		override public function get width():Number {
			return _width;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		override public function set width(value:Number):void {
			_width = value;
			if (shape) draw();
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		override public function get height():Number {
			return _height;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		override public function set height(value:Number):void {
			_height = value;
			if (shape) draw();
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get direction():String {
			return _direction;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set direction(value:String):void {
			_direction = value;
			if (shape) draw();
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


	}
}