package view.builder.structure.steps {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InfoButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function InfoButton() {
			
			this.buttonMode = true;
			
			//background
			var bg:Shape = new Shape();
			bg.graphics.lineStyle(2,Colors.getColorByName(Colors.BLUE));
			bg.graphics.beginFill(Colors.getColorByName(Colors.WHITE));
			bg.graphics.drawCircle(0,0,13);
			bg.graphics.endFill();
			
			bg.y = -bg.height/4;
			
			this.addChild(bg);
			
			//Shape
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(Colors.getColorByName(Colors.BLUE));
			shape.graphics.drawCircle(2,-14,1.5);
			shape.graphics.moveTo(0,0);
			shape.graphics.lineTo(0,-2);
			shape.graphics.lineTo(1,-2);
			shape.graphics.lineTo(1,-2);
			shape.graphics.lineTo(1,-9);
			shape.graphics.lineTo(-1,-10);
			shape.graphics.lineTo(3,-11);
			shape.graphics.lineTo(3,-2);
			shape.graphics.lineTo(5,-3);
			shape.graphics.lineTo(5,0);
			shape.graphics.endFill();
			
			shape.x = -2;
			
			this.addChild(shape);
			
		}
	}
}