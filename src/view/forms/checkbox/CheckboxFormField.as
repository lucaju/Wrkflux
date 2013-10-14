package view.forms.checkbox {
	
	//imports
	import flash.display.Sprite;
	
	import view.forms.AbstractFormField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CheckboxFormField extends AbstractFormField {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var itemCollection			:Array;
		
		protected var content					:Sprite;
		
		protected var selectedItem				:CheckboxItem;
		
		protected var data						:Array;
		
		protected var gap						:Number = 5;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function CheckboxFormField(data:Array = null) {
			
			super();
			this.data = data;
			
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function init(label:String = ""):void {
			
			//label
			this.maxHeight = content.y + content.height + gap;
			super.init(label);
			if (label) labelTF.x = (this.width/2) - (labelTF.width/2);
			
		}
		
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		

		
		//****************** PROTECTED EVENTS ****************** ****************** ******************

		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function populate():void {
			//Containers
			content = new Sprite();
			content.x = gap;
			content.y = 17;
			this.addChild(content);
			
			//data
			if (data) {
				
				itemCollection = new Array();
				
				var item:CheckboxItem;
				var posX:Number = 0;
				var posY:Number = 0;
				
				for each (var itemInfo:Object in data) {
					
					item = new CheckboxItem(itemInfo.uid);
					item.x = posX;
					item.init();
					content.addChild(item);
					itemCollection.push(item);
					
					if (content.width > this.maxWidth) {
						posY = item.height + gap;
						posX = 0;
						
						item.x = posX;
						item.y = posY;
					}
					
					posX += item.width + gap;
					
				}
			}
		}
		
		public function getItem(id:int):CheckboxItem {
			for each (var item:CheckboxItem in itemCollection) {
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
		public function getSelectedOption():int {
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
		 * @param Y
		 * 
		 */
		override public function resize():void {
			this.maxHeight = content.y + content.height + gap;
			super.resize();
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		
	}
}