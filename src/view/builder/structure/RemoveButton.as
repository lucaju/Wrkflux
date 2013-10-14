package view.builder.structure {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class RemoveButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var bg					:Shape;
		protected var highlighted			:Boolean;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function RemoveButton() {
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			//background
			bg = new Shape();
			bg.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY));
			bg.graphics.drawCircle(0,0,13);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//Shape
			var cross:Shape = new Shape();
			cross.graphics.beginFill(Colors.getColorByName(Colors.WHITE));
			cross.graphics.drawRoundRect(-2, -10, 4, 20, 4);		//vertical
			cross.graphics.drawRoundRect(-10, -2, 20, 4, 4);		//horizontal
			cross.graphics.drawRect(-2, -2, 4, 4);		//central
			cross.graphics.endFill();
			
			cross.rotation = 45;
			
			this.alpha = .8;
			this.addChild(cross);
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param enable
		 * @return 
		 * 
		 */
		public function highlight(enable:Boolean):void {
			
			if (enable && !highlighted) {
				highlighted = true;
				TweenMax.to(this,.6,{scaleX:1.5, scaleY:1.5, ease:Elastic.easeOut});
				TweenMax.to(bg,.6,{tint:Colors.getColorByName(Colors.RED), ease:Elastic.easeOut});
			} else if (!enable && highlighted) {
				highlighted = false;
				TweenMax.to(this,.6,{scaleX:1, scaleY:1, ease:Elastic.easeOut});
				TweenMax.to(bg,.6,{removeTint:true, ease:Elastic.easeOut});
			}
		}
	}
}