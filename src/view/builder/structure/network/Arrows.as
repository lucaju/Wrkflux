package view.builder.structure.network {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	import util.Colors;
	
	import view.assets.Arrow;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Arrows extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var container				:Sprite;
		
		protected var w						:Number;
		protected var h						:Number;
		
		protected var rightArrows			:Sprite;
		protected var leftArrows			:Sprite;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param direction
		 * 
		 */
		public function Arrows() {
			
			w = 6;
			h = 5;
			
			rightArrows = new Sprite();
			this.addChild(rightArrows);
			
			drawArrows(rightArrows);
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function drawArrows(container:Sprite):void {
			
			var a1:Arrow = new Arrow(w,h);
			a1.color = Colors.getColorByName(Colors.WHITE);
			a1.draw();
			a1.x = -a1.width;
			container.addChild(a1);
			
			var a2:Arrow = new Arrow(w,h);
			a2.color = Colors.getColorByName(Colors.WHITE);
			a2.draw();
			container.addChild(a2);
			
			var a3:Arrow = new Arrow(w,h);
			a3.color = Colors.getColorByName(Colors.WHITE);
			a3.draw();
			a3.x = a3.width;
			container.addChild(a3);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param object
		 * 
		 */
		protected function removeArrow(arrow:Sprite):void {
			this.removeChild(arrow);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addComplement():void {
			
			leftArrows = new Sprite();
			this.addChild(leftArrows);
			leftArrows.rotation = 180;
			
			drawArrows(leftArrows);
			leftArrows.x = -leftArrows.width;
			
			//align
			TweenLite.to(rightArrows, .4, {x:rightArrows.width/2});
			TweenLite.from(leftArrows, .4, {alpha:0,x:0});
		}

		/**
		 * 
		 * 
		 */
		public function removeComplement():void {
			TweenLite.to(rightArrows, .4, {x:0});
			TweenLite.to(leftArrows, .4, {alpha:0, x:-2*leftArrows.width, onComplete:removeArrow, onCompleteParams:[leftArrows]});
			leftArrows = null;
		}


	}
}

