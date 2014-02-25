package view.forms.list.slider {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import view.assets.Arrow;
	import view.forms.AbstractFormField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class HorizontalSliderFormField extends AbstractFormField {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var itemCollection			:Array;
		protected var itemContainer				:Sprite;
		protected var maskContainer				:Sprite;
		
		protected var ffButton					:Arrow
		protected var rewButton					:Arrow;
		
		protected var _data						:Array;
		
		protected var selectedItem				:Item;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function HorizontalSliderFormField() {
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
			
			//Containers
			itemContainer = new Sprite();
			itemContainer.y = label ? 14 : 8;
			this.addChild(itemContainer);

			maskContainer = new Sprite();
			maskContainer.graphics.beginFill(0xFFFFFF,0);
			maskContainer.graphics.drawRect(0,0,this.maxWidth,23);
			maskContainer.graphics.endFill();
			
			maskContainer.y = itemContainer.y;
			
			this.addChild(maskContainer);
			
			itemContainer.mask = maskContainer;
			
			//data
			if (data) {
				itemCollection = new Array();
				
				var item:Item;
				var posX:Number = 0;
				for each (var itemInfo:Object in data) {
					item = new Item(itemInfo.id);
					item.maxWidth = this.maxWidth;
					item.init(itemInfo.label);
					item.x = posX;
					
					itemContainer.addChild(item);
					itemCollection.push(item);
					
					posX += item.width;
				}
				
				//selected
				selectedItem = itemCollection[0];
				
			};
			
			//Controllers
			
			//ff button
			ffButton = new Arrow(10,14,"right");
			ffButton.buttonMode = true;
			ffButton.draw();
			
			ffButton.x = maskContainer.width - ffButton.width;
			ffButton.y = (this.height/2) + (ffButton.height/2);
			this.addChild(ffButton);
			
			//rew button
			rewButton = new Arrow(10,14,"left");
			rewButton.buttonMode = true;
			rewButton.draw();
			
			rewButton.x = rewButton.width;
			rewButton.y = (this.height/2) + (rewButton.height/2);
			this.addChild(rewButton);
			
			activateControl(rewButton,false);
			
			if (label) {
				rewButton.y = (this.height/2) + (rewButton.height/2);
				ffButton.y = (this.height/2) + (ffButton.height/2);
			} else {
				rewButton.y = (this.height/2);
				ffButton.y = (this.height/2);
			}
			
			//listeners
			ffButton.addEventListener(MouseEvent.CLICK, ffClick);
			rewButton.addEventListener(MouseEvent.CLICK, rewClick);
			
		}
		
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function listGoTo(id:int):void {	
			
			selectedItem = this.getItem(id);
				
			var jump:Number = - (selectedItem.x);
			TweenMax.to(itemContainer, .8, {x:jump, ease:Expo.easeOut});
				
			//activate REW
			if (selectedItem.id == 0) {
				activateControl(rewButton,false);
			} else {
				activateControl(rewButton,true);
			}
			
			//activate FF
			if (selectedItem.id == itemCollection.length-1) {
				activateControl(ffButton,false);
			} else {
				activateControl(ffButton,true);
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function forward():void {	
			
			if (itemCollection.indexOf(selectedItem) < itemCollection.length-1) {
				
				selectedItem = itemCollection[itemCollection.indexOf(selectedItem) + 1];
					
				
				var jump:Number = - (selectedItem.x);
				TweenMax.to(itemContainer, .8, {x:jump, ease:Expo.easeOut});
				
				//activate REW
				if (rewButton.mouseEnabled == false) activateControl(rewButton,true);
				//deactivate FF
				if (selectedItem.id == itemCollection.length-1) activateControl(ffButton,false);
				
				this.dispatchEvent(new Event(Event.SELECT));
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function rewind():void {	
			if (itemCollection.indexOf(selectedItem) > 0) {
				
				selectedItem = itemCollection[itemCollection.indexOf(selectedItem) - 1];
				
				var jump:Number = -selectedItem.x;
				TweenMax.to(itemContainer, .8, {x:jump, ease:Expo.easeOut});
				
				//activate FF
				if (ffButton.mouseEnabled == false) activateControl(ffButton,true);
				//deactivate REW
				if (selectedItem.id == 0) activateControl(rewButton,false);
			
				this.dispatchEvent(new Event(Event.SELECT));
			}
			
		}
		
		/**
		 * 
		 * @param control
		 * @param enable
		 * 
		 */
		protected function activateControl(control:Sprite,enable:Boolean):void {
			if (enable) {
				control.alpha = 1;
				control.mouseEnabled = true;
			} else {
				control.alpha = .5;
				control.mouseEnabled = false;
			}
			
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function ffClick(event:MouseEvent):void {
			forward();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rewClick(event:MouseEvent):void {
			rewind();
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
		 * @return 
		 * 
		 */
		public function setSelectedItem(id:int):void {
			listGoTo(id);
		}
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			super.kill();
			ffButton.removeEventListener(MouseEvent.CLICK, ffClick);
			rewButton.removeEventListener(MouseEvent.CLICK, rewClick);
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