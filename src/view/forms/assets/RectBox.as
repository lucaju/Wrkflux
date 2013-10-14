package view.forms.assets {
	
	//imports
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class RectBox extends AbstractWindow {
		
		//****************** Properties ****************** ******************  ****************** 
		
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function RectBox() {
			super();
		}
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param width
		 * @param height
		 * 
		 */
		override public function init(width:Number, height:Number):void {
			
			this.maxWidth = width;
			this.maxHeight = height;
			
			shape = new Sprite();
			shape.graphics.lineStyle(this.lineThickness,this.lineColor);
			shape.graphics.beginFill(this.color);
			shape.graphics.drawRect(0, 0, maxWidth, maxHeight);
			shape.graphics.endFill();
			this.addChild(shape);
			
		}
		
	}
}