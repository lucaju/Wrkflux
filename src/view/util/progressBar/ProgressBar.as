package view.util.progressBar {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.Colors;
	
	import view.assets.logo.Logo;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ProgressBar extends Sprite {

		//****************** Properties ****************** ****************** ******************
		
		protected var logo			:Logo;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ProgressBar() {
			
			//base
			var container:Sprite = new Sprite();
			this.addChild(container);
			
			var base:Shape = new Shape();
			//logo
			logo = new Logo();
			container.scaleX = container.scaleY = .2;
			container.addChild(logo);
			
			container.x = -container.width/2;
			container.y = -container.height/2;
				
			TweenMax.to([logo.arrow2,logo.arrow3,logo.arrow4],0,{tint:Colors.getColorByName(Colors.DARK_GREY)});
			logo.arrow2.alpha = .25;
			logo.arrow3.alpha = .5;
			logo.arrow4.alpha = .75;
			TweenMax.to(container, 1.2, {rotation:360, repeat:-1, ease:Linear.easeNone});
			
		}
		
		
	}
}