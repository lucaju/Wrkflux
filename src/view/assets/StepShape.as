package view.assets {
	
	//imports
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StepShape extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		static public const RECTANGLE		:int = 0;
		static public const CIRCLE			:int = 1;
		static public const HEXAGON			:int = 2;
		static public const PENTAGON		:int = 3;
		
		protected var _baseShape			:Sprite;
		protected var mask					:Sprite;
		protected var _stripe				:Sprite;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param shape
		 * 
		 */
		public function StepShape(shape:int) {
			drawShape(shape);
			this.mouseChildren = false;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param shape
		 * 
		 */
		public function drawShape(shape:int):void {
			switch (shape) {
				
				case RECTANGLE:
					drawRectangle();
					break;
				
				case CIRCLE:
					drawCircle();
					break;
				
				case HEXAGON:
					drawHexangon();
					break;
				
				case PENTAGON:
					drawPentagon();
					break;
				
			}
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function drawRectangle():void {
			
			//base shape
			if (!baseShape) {
				_baseShape = new Sprite();
				this.addChild(baseShape);
			} else {
				baseShape.graphics.clear();
				
			}
			
			baseShape.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			baseShape.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			baseShape.graphics.drawRect(0,0,80,100);
			baseShape.graphics.endFill();
			
			baseShape.x = -baseShape.width/2;
			baseShape.y = -baseShape.height/2;
			
			
			//stripe
			if (!stripe) {
				_stripe = new Sprite();
				this.addChild(stripe);
			} else {
				stripe.graphics.clear();
			}
			
			stripe.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY));
			stripe.graphics.drawRect(0,0,80,20);
			stripe.graphics.endFill();
			
			stripe.x = -stripe.width/2;
			stripe.y = baseShape.y + baseShape.height - stripe.height - 1;
			
			//no mask
			if (mask) {
				stripe.mask = null;
				this.removeChild(mask);
				mask = null;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function drawHexangon():void {
			
			//base shape
			if (!baseShape) {
				_baseShape = new Sprite();
				this.addChild(baseShape);
			} else {
				baseShape.graphics.clear();
			}
			
			baseShape.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			baseShape.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			baseShape.graphics.moveTo(30,0);
			baseShape.graphics.lineTo(85,0);
			baseShape.graphics.lineTo(115,50);
			baseShape.graphics.lineTo(85,100);
			baseShape.graphics.lineTo(30,100);
			baseShape.graphics.lineTo(0,50);
			baseShape.graphics.lineTo(30,0);
			baseShape.graphics.endFill();
			
			baseShape.x = -baseShape.width/2;
			baseShape.y = -baseShape.height/2;
			
			
			//stripe
			if (!stripe) {
				_stripe = new Sprite();
				this.addChild(stripe);
			} else {
				stripe.graphics.clear();
			}
			
			stripe.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY));
			stripe.graphics.drawRect(0,0,80,20);
			stripe.graphics.endFill();
			
			stripe.x = -stripe.width/2;
			stripe.y = baseShape.y + baseShape.height - stripe.height - 1;
			
			//stripe mask
			if (!mask) {
				mask = new Sprite();
				this.addChild(mask);
			} else {
				mask.graphics.clear();
			}
			
			mask.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			mask.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			mask.graphics.moveTo(30,0);
			mask.graphics.lineTo(85,0);
			mask.graphics.lineTo(115,50);
			mask.graphics.lineTo(85,100);
			mask.graphics.lineTo(30,100);
			mask.graphics.lineTo(0,50);
			mask.graphics.lineTo(30,0);
			mask.graphics.endFill();
			
			mask.x = -baseShape.width/2;
			mask.y = -baseShape.height/2;
			
			stripe.mask = mask;
		}
		
		/**
		 * 
		 * 
		 */
		protected function drawPentagon():void {
			
			//base shape
			if (!baseShape) {
				_baseShape = new Sprite();
				this.addChild(baseShape);
			} else {
				baseShape.graphics.clear();
			}
			
			baseShape.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			baseShape.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			baseShape.graphics.moveTo(0,40);
			baseShape.graphics.lineTo(56,0);
			baseShape.graphics.lineTo(106,40);
			baseShape.graphics.lineTo(87,100);
			baseShape.graphics.lineTo(19,100);
			baseShape.graphics.lineTo(0,40);
			baseShape.graphics.endFill();
			
			baseShape.x = -baseShape.width/2;
			baseShape.y = -baseShape.height/2;
			
			
			//stripe
			if (!stripe) {
				_stripe = new Sprite();
				this.addChild(stripe);
			} else {
				stripe.graphics.clear();
			}
			
			stripe.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY));
			stripe.graphics.drawRect(0,0,80,20);
			stripe.graphics.endFill();
			
			stripe.x = -stripe.width/2;
			stripe.y = baseShape.y + baseShape.height - stripe.height - 1;
			
			//stripe mask
			if (!mask) {
				mask = new Sprite();
				this.addChild(mask);
			} else {
				mask.graphics.clear();
			}
			
			mask.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			mask.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			mask.graphics.moveTo(0,40);
			mask.graphics.lineTo(56,0);
			mask.graphics.lineTo(106,40);
			mask.graphics.lineTo(87,100);
			mask.graphics.lineTo(19,100);
			mask.graphics.lineTo(0,40);
			mask.graphics.endFill();
			
			mask.x = -baseShape.width/2;
			mask.y = -baseShape.height/2;
			
			stripe.mask = mask;
		}
		
		/**
		 * 
		 * 
		 */
		protected function drawCircle():void {
			
			//base shape
			if (!baseShape) {
				_baseShape = new Sprite();
				this.addChild(baseShape);
			} else {
				baseShape.graphics.clear();
			}
			
			baseShape.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			baseShape.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			baseShape.graphics.drawCircle(0,0,50);
			baseShape.graphics.endFill();
			
			baseShape.x = 0;
			baseShape.y = 0;
			
			//stripe
			if (!stripe) {
				_stripe = new Sprite();
				this.addChild(stripe);
			} else {
				stripe.graphics.clear();
			}
			
			stripe.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY));
			stripe.graphics.drawRect(0,0,80,20);
			stripe.graphics.endFill();
			
			stripe.x = -stripe.width/2;
			stripe.y = (baseShape.height/2) - stripe.height - 1;
			
			//stripe mask
			if (!mask) {
				mask = new Sprite();
				this.addChild(mask);
			} else {
				mask.graphics.clear();
			}
			
			mask.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			mask.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			mask.graphics.drawCircle(0,0,50);
			mask.graphics.endFill();
			
			mask.x = 0;
			mask.y = 0;
			
			stripe.mask = mask;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get stripe():Sprite {
			return _stripe;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get baseShape():Sprite {
			return _baseShape;
		}


	}
}