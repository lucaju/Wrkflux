package view.assets.menu {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import events.WrkfluxEvent;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.buttons.Button;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class AbstractMenu extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var container				:Sprite;
		protected var _gap					:Number;
		protected var _orientation			:String;
		protected var _direction			:String;
		protected var _type					:String;
		
		protected var _abstractBt			:AbstractButton;
		
		protected var items					:Array;
		protected var _lastClickedItem		:AbstractButton;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function AbstractMenu() {
			
			_gap = 5;
			_orientation = MenuOrientation.HORIZONTAL;
			_direction = MenuDirection.LEFT;
			_type = MenuType.NONE;
			
			_abstractBt = new AbstractButton();
			
			this.addEventListener(MouseEvent.CLICK, menuClick);
		}
		
		
		//****************** PUBLIC METHOD ****************** ****************** ******************
		
		/**
		 * 
		 * @param label
		 * @return 
		 * 
		 */
		public function add(label:String):AbstractButton {
			return new Button();
		}
		
		/**
		 * 
		 * @param label
		 * @return 
		 * 
		 */
		public function remove(label:String):AbstractButton {
			return null;
		}
		
		/**
		 * 
		 * @param label
		 * @return 
		 * 
		 */
		public function getOptionByLabel(label:String):AbstractButton {
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedItems():Array {
			
			var selctedItems:Array;
			
			if (items) {
				
				selctedItems = new Array();
				
				for each (var item:AbstractButton in items) {
					selctedItems.push(item.toggle);
				}
			}
			
			return selctedItems;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getItems():Array {
			if (items) return items;
			return null;;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLastClickedItem():AbstractButton {
			if (lastClickedItem) return lastClickedItem;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			this.removeEventListener(MouseEvent.CLICK, menuClick);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		public function menuClick(event:MouseEvent):void {
			if (event.target is AbstractButton) {
				lastClickedItem = event.target as AbstractButton;
			} else {
				lastClickedItem = null;
			}
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get gap():Number {
			return _gap;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set gap(value:Number):void {
			_gap = value;
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
			if (type != MenuType.NONE) this.abstractBt.togglable = true;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get abstractBt():AbstractButton {
			return _abstractBt;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get lastClickedItem():AbstractButton {
			return _lastClickedItem;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set lastClickedItem(value:AbstractButton):void {
			_lastClickedItem = value;
		}


	}
}