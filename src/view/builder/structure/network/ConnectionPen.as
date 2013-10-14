package view.builder.structure.network {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ConnectionPen extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ConnectionPen() {
			
			var shape:Shape = new Shape();
			this.addChild(shape);
			
			shape.graphics.beginFill(Colors.getColorByName(Colors.GREEN));
			
			//outter donut
			shape.graphics.drawCircle(0,0,13);
			shape.graphics.drawCircle(0,0,5);
			
			//inner circle
			shape.graphics.beginFill(Colors.getColorByName(Colors.GREEN),.7);
			shape.graphics.drawCircle(0,0,5);
			shape.graphics.endFill();
			
			shape.x = shape.width/4;
			shape.y = shape.height/4;
			
		}
	}
}