package view.builder.flags {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import util.Colors;
	
	public class FlagColorsOption extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var itemCollection		:Array;
		protected var itemContainer			:Sprite;
		protected var gap					:int = 3;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function FlagColorsOption(activeColor:uint) {
			
			var data:Array = [Colors.getColorByName(Colors.WHITE),
							  Colors.getColorByName(Colors.BLUE),
							  Colors.getColorByName(Colors.YELLOW),
							  Colors.getColorByName(Colors.RED),
							  Colors.getColorByName(Colors.GREEN)];
			
			itemCollection = new Array();
			var flag:Flag;
			
			var posX:Number = 0;
			
			var ball:Ball;
			
			var i:Number = 0;
			
			for each (var color:uint in data) {
				
				if (color != activeColor) {
					ball = new Ball(color);
					ball.radius = 6;
					ball.init();
					
					ball.x = posX;
					this.addChild(ball);
					
					itemCollection.push(ball);
					
					posX += ball.width + gap;
					i++;
					
					TweenLite.from(ball,.6,{x:-10, alpha:0, delay: i * 0.05});
					
				}
			}

			//listeners
			this.addEventListener(MouseEvent.MOUSE_OVER, rollOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, rollOut);

		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function remove():void {
			this.parent.removeChild(this);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOver(event:MouseEvent):void {
			TweenLite.to(event.target, .6, {width: 16, height: 16})
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOut(event:MouseEvent):void {
			TweenLite.to(event.target, .6, {width: 12, height: 12})
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			TweenLite.to(itemCollection, .3, {x:-10, onComplete:remove});
		}
		
	}
}