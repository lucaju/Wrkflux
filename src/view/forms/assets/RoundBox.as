package view.forms.assets {
	
	//imports
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class RoundBox extends AbstractWindow {
		
		//****************** Properties ****************** ******************  ****************** 
		
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function RoundBox() {
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
			shape.graphics.drawRoundRect(0, 0, maxWidth, maxHeight, this.roundness);
			shape.graphics.endFill();
			this.addChild(shape);
			
			if (this.isScale9Grid) {
				var scaleArea:Rectangle = new Rectangle(roundness, roundness, shape.width - (2*roundness), shape.height - (2*roundness));
				shape.scale9Grid = scaleArea;
			}
		}
		
	}
}