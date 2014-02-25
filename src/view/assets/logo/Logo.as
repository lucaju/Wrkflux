package view.assets.logo {
	
	//import
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class Logo extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _arrow1		:LogoArrow;
		protected var _arrow2		:LogoArrow;
		protected var _arrow3		:LogoArrow;
		protected var _arrow4		:LogoArrow;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Logo() {
			
			var shape:Sprite = new Sprite();
			this.addChild(shape);
			
			_arrow1 = new LogoArrow(0x2F99C9);
			shape.addChild(arrow1);
			
			_arrow2 = new LogoArrow(0xC39A27);
			arrow2.rotation = 90;
			arrow2.y = -4;
			arrow2.x = -12.5;
			shape.addChild(arrow2);
			
			_arrow3 = new LogoArrow(0xD94038);
			arrow3.rotation = 180;
			arrow3.x = -8;
			arrow3.y = -16.5;
			shape.addChild(arrow3);
			
			_arrow4 = new LogoArrow(0x819352);
			arrow4.rotation = 270;
			arrow4.x = 4.5;
			arrow4.y = -12;
			shape.addChild(arrow4);
			
			this.rotation = -45;
			
			var shapeBounds:Rectangle = this.getBounds(shape);
			
			shape.x = (-shapeBounds.width/2) - (shapeBounds.x);
			shape.y = (-shapeBounds.height/2) - (shapeBounds.y);
			
		}
		
		
		//****************** GETTERS AND SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrow1():LogoArrow {
			return _arrow1;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrow2():LogoArrow {
			return _arrow2;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrow3():LogoArrow {
			return _arrow3;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrow4():LogoArrow {
			return _arrow4;
		}


	}
}