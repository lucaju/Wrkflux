package view.menu {
	
	//imports
	import flash.events.MouseEvent;
	
	import events.WrkfluxEvent;
	
	import mvc.IController;
	import view.assets.buttons.ButtonTopIcon;
	import view.assets.buttons.ButtonBarFactory;
	
	public class TopMenu extends AbstractMenu {
		
		//properties
		private var item:ButtonTopIcon;
		
		/**
		 * CONTRUCTOR 
		 * @param c
		 * @param options
		 * 
		 */		
		public function TopMenu (c:IController, options:Array = null) {
			super(c, options);
			
			//initials
			gap = 0;
		}
		
		/**
		 * Initiate: Build Menu Items 
		 * 
		 */
		override public function init():void {
			
			//create menu items
			var posX:Number = 0;
			
			if (optionCollection) {
				
				for each (var option:Object in optionCollection) {
					
					item = ButtonBarFactory.addButtonBar(option.title);
					item.x = posX;
					this.addChild(item);
					
					item.addEventListener(MouseEvent.CLICK, _itemClick);
					
					itemCollection.push(item)
					
					posX += item.width + gap;
					item = null;
				
				}
				
			}
			
		}
		
		/**
		 * CLICK HANDLE 
		 * @param event
		 * 
		 */
		protected function _itemClick(event:MouseEvent):void {
			
			var data:Object = new Object();;
			
			item = event.currentTarget as ButtonTopIcon;
			item.toggle = !item.toggle;
			
			data.label = item.getLabel();
			data.toggle = item.toggle;

			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data));
		
		}
		
		protected function deselectAll():void {
			for each(var item:ButtonTopIcon in itemCollection) {
				item.toggle = false;
			}
		}
	}
}