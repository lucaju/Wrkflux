package view.assets.menu {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import events.WrkfluxEvent;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.buttons.ButtonFactory;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Menu extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected const gap			:Number = 5;
		
		protected var items			:Array;
		protected var _clickedItem	:String;
		
		protected var _orientation	:String = MenuOrientation.HORIZONTAL;
		protected var _direction	:String = MenuDirection.LEFT;
		protected var _type			:String = MenuType.TOPBAR;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Menu() {
			items = new Array();
			
			this.addEventListener(MouseEvent.CLICK, menuClick);
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param label
		 * @param color
		 * 
		 */
		public function add(label:String, color:*):AbstractButton {
			
			
			//var bt:Button = new Button();
			var bt:AbstractButton = ButtonFactory.getButton(color, type);
			
			bt.init(label);
			
			//position
			
			if (orientation == MenuOrientation.HORIZONTAL && direction == MenuDirection.LEFT) {
				
				if (items.length > 0) bt.x = this.width + gap;
				
			} else if (orientation == MenuOrientation.HORIZONTAL && direction == MenuDirection.RIGHT) {
				
				if (items.length > 0)  bt.x = this.width + gap;
				
			} else if (orientation == MenuOrientation.VERTICAL && direction == MenuDirection.TOP) {
				
				if (items.length > 0) bt.y = this.height + gap;
				
			} else if (orientation == MenuOrientation.VERTICAL && direction == MenuDirection.BOTTOM) {
				
				bt.y = -this.height -bt.height - gap;
			}
			
			
			
			this.addChild(bt);
			items.push(bt);
			
			return bt;
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function menuClick(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			var bt:AbstractButton = AbstractButton(event.target);
			this._clickedItem = bt.getLabel();
			
			var data:Object = {clickedItem:this.clickedItem};
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT,data));
			
			this._clickedItem = null;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get clickedItem():String {
			return _clickedItem;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get orientation():String {
			return _orientation;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set orientation(value:String):void {
			_orientation = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get direction():String {
			return _direction;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set direction(value:String):void {
			_direction = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get type():String {
			return _type;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set type(value:String):void {
			_type = value;
		}

		
	}
}