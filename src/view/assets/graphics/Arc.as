package view.assets.graphics {
	
	//imports
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Arc extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _outerRadius					:Number					= 150;
		
		protected var _donut						:Boolean				= true;
		protected var _lockDonutRadiusProportion	:Boolean				= true;
		protected var _donutRadiusProportion		:Number					= 2;
		protected var _donutArchLenthProportion		:Number					= 2;
		
		protected var _innerRadius					:Number					= this._outerRadius / this._donutRadiusProportion;
		
		protected var _outerArcLength				:Number 				= 20;
		protected var _innerArcLength				:Number 				= this._outerArcLength / this._donutArchLenthProportion;
		
		protected var centerX						:Number					= 0;
		protected var centerY						:Number					= 0;
		
		protected var _median						:Point;							// point: intersection between radius and half of the arc lenght
		
		protected var _steps						:Number					= 20;
				
		protected var _color						:uint					= 0xFFFFFF;
		protected var _colorAlpha					:Number					= 1;
		
		protected var _line							:Boolean				= false;
		protected var _lineThickness				:Number					= 1;
		protected var _lineColor					:uint					= 0x000000;
		protected var _lineAlpha					:Number					= 1;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Arc() {
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param radius
		 * @param startPos
		 * @param arcLength
		 * @param gapLength
		 * 
		 */
		public function draw(radius:Number, startPos:Number, arcLength:Number, gapLength:Number = 0):void {
			
			//save data
			outerRadius = radius;
			outerArcLength = arcLength;
			
			var startAngle:Number = startPos/360;
			var arcleAngle:Number = arcLength/360;
			var gapAngle:Number = gapLength/360;
			
			if (line) this.graphics.lineStyle(lineThickness,lineColor,lineAlpha);
			this.graphics.beginFill(color,colorAlpha);
			
			this.drawArc("outer",outerRadius, startAngle, arcleAngle);
			if (donut) {
				startAngle += gapAngle/4;
				arcleAngle -= gapAngle/2;
				this.drawArc("inner",innerRadius, startAngle, arcleAngle);
			} else {
				this.graphics.lineTo(0,0);
			}
			this.graphics.endFill();
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param type
		 * @param radius
		 * @param startAngle
		 * @param arcAngle
		 * 
		 */
		protected function drawArc(type:String, radius:Number, startAngle:Number, arcAngle:Number):void {
			
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			var iAngle:Number;
			var xx:Number;
			var yy:Number;
			var angle:Number;
			var i:Number;
			
			switch(type) {
				
				case "outer":
					iAngle = startAngle;
					iAngle -= .25;
					
					xx = centerX + Math.cos(iAngle * twoPI) * radius;
					yy = centerY + Math.sin(iAngle * twoPI) * radius;
					angle = 0;
					
					median = new Point();
					median.x = centerX + Math.cos((iAngle + (steps/2 * angleStep)) * twoPI) * radius;
					median.y = centerY + Math.sin((iAngle + (steps/2 * angleStep)) * twoPI) * radius;
					
					this.graphics.moveTo(xx, yy);
					
					for(i=1; i<=steps; i++){
						angle = iAngle + (i * angleStep);
						xx = centerX + Math.cos(angle * twoPI) * radius;
						yy = centerY + Math.sin(angle * twoPI) * radius;
						this.graphics.lineTo(xx, yy);
					}
					
					break;
				
				case "inner":
					
					iAngle = arcAngle + startAngle;
					iAngle -= .25;
					
					xx = centerX + Math.cos(iAngle * twoPI) * radius;
					yy = centerY + Math.sin(iAngle * twoPI) * radius;
					angle = arcAngle;
					
					this.graphics.lineTo(xx, yy);
					
					for(i=1; i<steps; i++){
						angle = iAngle - (i * angleStep);
						xx = centerX + Math.cos(angle * twoPI) * radius;
						yy = centerY + Math.sin(angle * twoPI) * radius;
						this.graphics.lineTo(xx, yy);
					}
					
					break
				
			}
			
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get outerRadius():Number {
			return _outerRadius;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set outerRadius(value:Number):void {
			_outerRadius = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get donut():Boolean {
			return _donut;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set donut(value:Boolean):void {
			_donut = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get innerRadius():Number {
			return _innerRadius;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set innerRadius(value:Number):void {
			_innerRadius = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get lockDonutRadiusProportion():Boolean {
			return _lockDonutRadiusProportion;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lockDonutRadiusProportion(value:Boolean):void {
			_lockDonutRadiusProportion = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get donutRadiusProportion():Number {
			return _donutRadiusProportion;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set donutRadiusProportion(value:Number):void {
			_donutRadiusProportion = value;
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get outerArcLength():Number {
			return _outerArcLength;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set outerArcLength(value:Number):void {
			_outerArcLength = value;
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
		public function set lineColor(value:uint):void {
			_lineColor = value;
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
		public function get lineColor():uint {
			return _lineColor;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get lineAlpha():Number {
			return _lineAlpha;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lineAlpha(value:Number):void {
			_lineAlpha = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get median():Point {
			return _median;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set median(value:Point):void {
			_median = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get steps():Number {
			return _steps;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set steps(value:Number):void {
			if (value > _steps) _steps = value;
		}

	}
}