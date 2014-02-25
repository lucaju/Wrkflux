package view.assets.graphics {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class Cross extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var radius			:Number;
		protected var thickness			:int;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Cross(_radius:Number = 14, _thickness:int = 0) {
			
			radius = _radius;
			
			if (_thickness == 0) thickness = radius /7;
			
			var cross:Shape = new Shape();
			cross.graphics.beginFill(Colors.getColorByName(Colors.WHITE));
			cross.graphics.drawRoundRect(-thickness, -radius/2, thickness*2, radius, 4);		//vertical
			cross.graphics.drawRoundRect(-radius/2, -thickness, radius, thickness*2, 4);		//horizontal
			cross.graphics.drawRect(-thickness, -thickness, thickness*2, thickness*2);		//central
			cross.graphics.endFill();
			
			
			//cross.x = bg.x + bg.width - cross.width + 2;
			//cross.y = bg.y + (bg.height/2);
			
			this.addChild(cross);
			
		}
	}
}