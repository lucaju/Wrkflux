package view.workflow.flow {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CrossButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var bg							:Shape;
		protected var cross							:Shape;
		
		protected var highlighted					:Boolean;
		
		protected var _color						:uint;
		protected var _highlightedColor				:uint;
		
		protected var _crossColor					:uint;
		protected var _highlightedCrossColor		:uint;
	
		protected var _lineThickness				:int;
		protected var _lineColor					:uint;
		
		protected var _rotation						:Number;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function CrossButton() {
			
			color = Colors.getColorByName(Colors.DARK_GREY);
			highlightedColor = Colors.getColorByName(Colors.RED);
			
			crossColor = Colors.getColorByName(Colors.WHITE);
			highlightedCrossColor = Colors.getColorByName(Colors.WHITE);
			
			lineThickness = 0;	
			lineColor = Colors.getColorByName(Colors.DARK_GREY);
			
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function init():void {
			
			this.color = color;
			
			this.mouseChildren = false;
			
			//background
			bg = new Shape();
			if (lineThickness > 0) bg.graphics.lineStyle(lineThickness,lineColor);
			bg.graphics.beginFill(color);
			bg.graphics.drawCircle(0,0,13);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//Shape
			cross = new Shape();
			cross.graphics.beginFill(crossColor);
			cross.graphics.drawRoundRect(-2, -10, 4, 20, 4);		//vertical
			cross.graphics.drawRoundRect(-10, -2, 20, 4, 4);		//horizontal
			cross.graphics.drawRect(-2, -2, 4, 4);		//central
			cross.graphics.endFill();
			
			cross.rotation = rotation;
			
			this.alpha = .8;
			this.addChild(cross);
			
			//listeners
			bg.addEventListener(MouseEvent.ROLL_OVER, over);
			bg.addEventListener(MouseEvent.ROLL_OUT, out);
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function over(event:MouseEvent):void {
			highlight(true);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function out(event:MouseEvent):void {
			highlight(false);
		}				
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param enable
		 * @return 
		 * 
		 */
		public function highlight(enable:Boolean):void {
			
			if (enable && !highlighted) {
				highlighted = true;
				TweenMax.to(this,.6,{scaleX:1.5, scaleY:1.5, ease:Elastic.easeOut});
				TweenMax.to(bg,.6,{tint:highlightedColor, ease:Elastic.easeOut});
				TweenMax.to(cross,.6,{tint:highlightedCrossColor, ease:Elastic.easeOut});
			} else if (!enable && highlighted) {
				highlighted = false;
				TweenMax.to(this,.6,{scaleX:1, scaleY:1, ease:Elastic.easeOut});
				TweenMax.to(bg,.6,{removeTint:true, ease:Elastic.easeOut});
				TweenMax.to(cross,.6,{removeTint:true, ease:Elastic.easeOut});
			}
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
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
		public function get highlightedColor():uint {
			return _highlightedColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set highlightedColor(value:uint):void {
			_highlightedColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get crossColor():uint {
			return _crossColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set crossColor(value:uint):void {
			_crossColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get highlightedCrossColor():uint {
			return _highlightedCrossColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set highlightedCrossColor(value:uint):void {
			_highlightedCrossColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get lineThickness():int {
			return _lineThickness;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lineThickness(value:int):void {
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
		override public function get rotation():Number {
			return _rotation;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		override public function set rotation(value:Number):void {
			_rotation = value;
		}


	}
}