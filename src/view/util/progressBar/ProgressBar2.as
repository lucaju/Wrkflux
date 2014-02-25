package view.util.progressBar {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import util.Colors;
	
	import view.assets.graphics.Arc;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ProgressBar2 extends Sprite {

		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ProgressBar2() {
			
			//base
			
			var base:Shape = new Shape();
			base.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
			base.graphics.beginFill(Colors.getColorByName(Colors.WHITE));
			base.graphics.drawCircle(0,0,20);
			base.graphics.drawCircle(0,0,14);
			base.graphics.endFill();
			
			this.addChild(base);
			
			//arcs
			//var arcs:Array = new Array(Colors.BLUE, Colors.GREEN, Colors.YELLOW, Colors.RED);
			var arcs:Array = new Array(Colors.DARK_GREY, Colors.DARK_GREY, Colors.DARK_GREY, Colors.BLUE);
			var start:Number = 0;
			
			for each (var arcColor:String in arcs) {
				var arc:Arc = new Arc();
				arc.innerRadius = 15;
				arc.color = Colors.getColorByName(arcColor);
				arc.draw(19,start,80);
				
				var speed:Number = 1.2;
				
				if (arcColor != Colors.BLUE) {
					//arc.blendMode = "invert";
					arc.alpha = .2 + Math.random();
					//speed = 1+Math.random();
				}
				
				this.addChild(arc);
				
				TweenMax.to(arc, speed, {rotation:360, repeat:-1, ease:Linear.easeNone});
				
				start += 90;
			}
			
			arcs = null;
			
		}
		
		
	}
}