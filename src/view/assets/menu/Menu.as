package view.assets.menu {
	
	//imports
	import flash.events.MouseEvent;
	
	import events.WrkfluxEvent;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.buttons.Button;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Menu extends AbstractMenu {
		
		//****************** Properties ****************** ****************** ******************
		

		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Menu() {
			super();
			
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
		override public function add(label:String):AbstractButton {
			
			var bt:Button = new Button();
			
			bt.shapeForm = this.abstractBt.shapeForm;
			bt.shapeAlpha = this.abstractBt.shapeAlpha;
			
			bt.color = this.abstractBt.color;
			bt.colorAlpha = this.abstractBt.colorAlpha;
			
			bt.line = this.abstractBt.line;
			bt.lineThickness = this.abstractBt.lineThickness;
			bt.lineColor = this.abstractBt.lineColor;
			bt.lineColorAlpha = this.abstractBt.lineColorAlpha;
			
			bt.textSize = this.abstractBt.textSize;
			bt.textColor = this.abstractBt.textColor;
			
			bt.maxWidth = this.abstractBt.maxWidth;
			bt.maxHeight = this.abstractBt.maxHeight;
			
			bt.togglable = this.abstractBt.togglable;
			bt.toggle = this.abstractBt.toggle;
			bt.toggleAlpha = this.abstractBt.toggleAlpha;
			bt.toggleColor = this.abstractBt.toggleColor;
			bt.toggleColorAlpha = this.abstractBt.toggleColorAlpha;
			
			bt.init(label);
			
			//position
			
			if (orientation == MenuOrientation.HORIZONTAL && direction == MenuDirection.LEFT) {
				
				if (items.length > 0) bt.x = this.width + gap;
				
			} else if (orientation == MenuOrientation.HORIZONTAL && direction == MenuDirection.RIGHT) {
				
				bt.x = - this.width - bt.width - gap;
				
			} else if (orientation == MenuOrientation.VERTICAL && direction == MenuDirection.TOP) {
				
				if (items.length > 0) bt.y = this.height;
				
			} else if (orientation == MenuOrientation.VERTICAL && direction == MenuDirection.BOTTOM) {
				
				bt.y = -this.height -bt.height - gap;
			}
			
			this.addChild(bt);
			items.push(bt);
			
			return bt;
		}
		
		/**
		 * 
		 * @param label
		 * @return 
		 * 
		 */
		override public function remove(label:String):AbstractButton {
			
			for each(var bt:Button in items) {
				if (bt.name == label) {
					items.splice(items.indexOf(bt),1);
					if (this.contains(bt)) this.removeChild(bt);
					return bt;
				}
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param label
		 * @return 
		 * 
		 */
		override public function getOptionByLabel(label:String):AbstractButton {
			for each(var bt:Button in items) {
				if (bt.name == label) return bt;
			}
			
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			super.kill();
			this.removeEventListener(MouseEvent.CLICK, menuClick);
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function deselectAll():void {
			for each (var item:Button in items) {
				if (item != this.lastClickedItem) item.toggle = false;
			}
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override public function menuClick(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			//save current select item or fail;
			var bt:Button;
			
			if (event.target is AbstractButton) {
				
				bt = event.target as Button;
				
				//toggle
				if (this.type == MenuType.UNIQUE) if (lastClickedItem) lastClickedItem.toggle = !lastClickedItem.toggle;
				lastClickedItem = bt;
				bt.toggle = !bt.toggle;
				
				
			} else {
				lastClickedItem = null;
				return;
			}
			
			//deselect others
			if (this.type == MenuType.UNIQUE) this.deselectAll();
			
			//send data
			var data:Object = new Object();
			data.clickedItem = bt.getLabel();
			if (bt.togglable) data.toggle = bt.toggle;
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT,data));
			
		}
		
	}
}