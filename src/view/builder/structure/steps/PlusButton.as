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
	public class PlusButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function PlusButton() {
			
			this.buttonMode = true;
			
			//background
			var bg:Shape = new Shape();
			bg.graphics.lineStyle(2,Colors.getColorByName(Colors.DARK_GREY),1,true);
			bg.graphics.beginFill(Colors.getColorByName(Colors.GREEN));
			bg.graphics.drawRoundRect(0,0,40,25,10);
			bg.graphics.endFill();
			
			bg.x = -bg.width/2;
			bg.y = -bg.height/2;
			
			this.addChild(bg);
			
			//Shape
			var sR:Number = 14; //radius
			var sT:int = 2;		//thickness
			
			var cross:Shape = new Shape();
			cross.graphics.beginFill(Colors.getColorByName(Colors.WHITE));
			cross.graphics.drawRoundRect(-sT, -sR/2, sT*2, sR, 4);		//vertical
			cross.graphics.drawRoundRect(-sR/2, -sT, sR, sT*2, 4);		//horizontal
			cross.graphics.drawRect(-sT, -sT, sT*2, sT*2);		//central
			cross.graphics.endFill();
			
			cross.x = bg.x + bg.width - cross.width + 2;
			cross.y = bg.y + (bg.height/2);
			
			cross.alpha = .6;
			
			this.addChild(cross);
			
		}
	}
}