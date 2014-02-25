package view.builder.structure {
	
	//imports
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class Background extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var image					:Sprite;
		
		
		//****************** Properties ****************** ****************** ******************
		
		/**
		 * 
		 * @param w
		 * @param h
		 * 
		 */
		public function Background(w:Number, h:Number) {
			
			this.mouseChildren = false;
			this.graphics.beginFill(Colors.getColorByName(Colors.WHITE),0);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
			
		}
		
	}
}