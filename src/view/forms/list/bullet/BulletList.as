package view.forms.list.bullet {
	
	//imports
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import view.forms.AbstractFormField;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class BulletList extends AbstractFormField {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var itemCollection			:Array;
		protected var itemContainer				:Sprite;
		
		protected var _data						:Array;
		
		protected var selectedItem				:Item;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function BulletList() {
			super();
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function init(label:String = ""):void {
			
			//label
			this.name = label;
			super.init(label);
			if (label) labelTF.x = (this.width/2) - (labelTF.width/2);
			
			//data
			if (data) {
				
				itemContainer = new Sprite();
				itemContainer.y = 20;
				this.addChild(itemContainer);
				
				itemCollection = new Array();
				
				var item:Item;
				var gap:Number = 7;
				var posY:Number = 0;
				
				for each (var itemInfo:Object in data) {
					//trace (itemInfo.color)
					item = new Item(itemInfo.id, itemInfo.color, itemInfo.label);
					item.x = item.width/2;
					item.y = posY;
					
					item.buttonMode = true;
					
					itemContainer.addChild(item);
					
					itemCollection.push(item);
					
					posY += item.height + gap;
				}
				
				//selected
				selectedItem = itemCollection[0];
				selectedItem.highlight(true);
				
				//positioning
				itemContainer.x = (this.maxWidth/2) - (itemContainer.width/2);
				
				//background
				this.maxHeight = this.height + gap;
				this.resize();
			};
			
			//listener
			this.addEventListener(MouseEvent.CLICK, itemClick);
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function itemClick(event:MouseEvent):void {
			if (event.target is Item) {
				
				var item:Item = event.target as Item;
				
				if (selectedItem) {
					
					if (selectedItem != item) {
						selectedItem.highlight(false);
						selectedItem = item;
						selectedItem.highlight(true);
					}
					
				} else {
					selectedItem = item;
					selectedItem.highlight(true);
				}
				
			}
			
		}	
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			super.kill();
			this.removeEventListener(MouseEvent.CLICK, itemClick);
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getItem(id:int):Item {
			for each (var item:Item in itemCollection) {
				if (item.id == id) return item;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLabel():String {
			return labelTF.text;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedID():int {
			return selectedItem.id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedLabel():String {
			return selectedItem.label;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function setSelectedItem(id:int):void {
			for each (var item:Item in itemCollection) {
				if (item.id == id) {
					selectedItem = item;
					break;
				}
			}
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get data():Array {
			return _data;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set data(value:Array):void {
			_data = value;
		}

	}
}