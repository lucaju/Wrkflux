package view.assets.logo {
	
	//imports
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class LogoArrow extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function LogoArrow(color:uint = 0x000000) {
			
			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(color,1);
			shape.graphics.lineTo(10,12);
			shape.graphics.lineTo(0,22);
			shape.graphics.cubicCurveTo(15,23,28,36,29,52);
			shape.graphics.lineTo(38,63);
			shape.graphics.lineTo(52,52);
			shape.graphics.cubicCurveTo(50,23,28,1,0,0);
			shape.graphics.endFill();
			
			shape.y = -shape.height;
			
			this.addChild(shape);

		}
	}
}