package view.assets {
	
	//imports
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import util.Directions;
	import view.forms.assets.AbstractWindow;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Balloon extends AbstractWindow {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _arrowDirection				:String;
		protected var _arrowWidth					:Number;
		protected var _arrowHeight					:Number;
		
		protected var arrow							:Sprite;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * Balooon Contructor.
		 * 
		 */
		public function Balloon() {
			arrowDirection = Directions.BOTTOM;
			arrowWidth = 20;
			arrowHeight = 10;
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 

		/**
		 * This method draws the ballon with an arrow positioned at the botton and add a glow effects.
		 *  
		 * @param w:Number
		 * @param h:Number
		 * 
		 */
		override public function init(width:Number, height:Number):void {
			
			this.maxWidth = width;
			this.maxHeight = height;
			
			//draw balloon
			shape = new Sprite();
			shape.graphics.lineStyle(this.lineThickness, this.lineColor);
			shape.graphics.beginFill(this.color);
			shape.graphics.drawRoundRect(0,0,maxWidth,maxHeight,this.roundness);
			shape.graphics.endFill();
			
			this.addChild(shape)
			
			if (this.isScale9Grid) {
				var scaleArea:Rectangle = new Rectangle(roundness, roundness, shape.width - (2*roundness), shape.height - (2*roundness));
				this.scale9Grid = scaleArea;	
			}
			
			//draw arrow
			arrow = new Sprite();
			arrow.graphics.lineStyle(this.lineThickness, this.lineColor);
			arrow.graphics.beginFill(this.color);
			arrow.graphics.moveTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(0,arrowHeight/2);
			arrow.graphics.lineTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.endFill();
			
			this.addChild(arrow);
			
			//position
			
			switch (arrowDirection) {
				case Directions.BOTTOM:
					arrow.x = shape.x + shape.width/2;
					arrow.y = shape.y + shape.height + arrow.height/2;
				break;
				
				case Directions.TOP:
					arrow.rotation = 180;
					arrow.x = shape.x + shape.width/2;
					arrow.y = shape.y - arrow.height/2;
					break;
				
				default:
					arrow.x = shape.x + shape.width/2;
					arrow.y = shape.y + shape.height + arrow.height/2;
					break;
			}
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * Switch arrow's position from bottom to top.
		 * Valid value: "top".
		 *  
		 * @param orientation:String
		 */
		override public function changeArrowOrientation(orientation:String):void {
			
			arrowDirection = orientation;
			
			switch(orientation) {
				
				case Directions.TOP:
					arrow.scaleY = -1;
					arrow.y = arrow.height/2;
					shape.y = arrow.y + arrow.height/2;
					break;
				
				case Directions.BOTTOM:
					arrow.scaleY = 1;
					arrow.x = shape.x + shape.width/2;
					arrow.y = shape.y + shape.height + arrow.height/2;
					break;
			}
		}
		
		/**
		 * Move arrow horizontally.
		 *   
		 * @param offset:Number
		 * 
		 */
		override public function arrowOffsetX(offset:Number):void {
			arrow.x += offset;
		}
		
		//****************** GETTERS // SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrowDirection():String {
			return _arrowDirection;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set arrowWidth(value:Number):void {
			_arrowWidth = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrowWidth():Number {
			return _arrowWidth;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set arrowDirection(value:String):void {
			_arrowDirection = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrowHeight():Number {
			return _arrowHeight;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set arrowHeight(value:Number):void {
			_arrowHeight = value;
		}

	}
}