package view.forms.list.bullet {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	import view.workflow.assets.Ball;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Item extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id 				:int;
		protected var _label			:String;
		protected var _color			:uint;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param color
		 * @param label
		 * 
		 */
		public function Item(id:int, color:uint, label:String = "") {
			
			this._id = id;
			this._color = color;
			this._label = label;
			
			//ball
			var ball:Ball = new Ball(color);
			ball.radius = 8;
			ball.init();
			
			this.addChild(ball);
			
			this.mouseChildren = false;
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function highlight(value:Boolean):void {
			var scale:Number;
			
			if (value) {
				scale = 1.3;
			} else {
				scale = 1;
			}
			
			TweenLite.to(this, .6, {scaleX: scale, scaleY: scale})
		}
		
		//****************** GETTER // SETTER ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get color():uint {
			return _color;
		}


	}
}