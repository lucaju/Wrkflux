package view.workflow.list {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import model.wrkflow.PinModel;
	
	import util.DeviceInfo;
	import util.MessageType;
	
	import view.forms.MessageField;
	import view.forms.MessageWindow;
	import view.util.scroll.Scroll;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinList extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var target						:PinListView;
		
		protected var _maxHeight					:Number							//Maximum Height\
		
		protected var itemCollection				:Array;							//Colletion of Items
							
		protected var container						:Sprite;						//Container
		protected var containerMask					:Sprite;						//Mask
		
		protected var scroll						:Scroll;
		
		protected var messageWindow					:MessageWindow;

		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * 
		 */
		public function PinList(target:PinListView) {
			this.target = target;
		}
		
		
		//****************** Initialize ****************** ****************** ******************
			
		/**
		 * 
		 * @param data
		 * 
		 */
		public function init(data:Array = null, openedItems:Array = null):void {	
			
			//data
			if (data) {
				
				//array
				itemCollection = new Array();
				
				//container
				container = new Sprite();
				this.addChild(container);
				
				//load data
				data = data.reverse();
				this.loadContent(data);
				
				//add mask
				this.addListMask();
				
				//test Scroll;
				this.testForScroll();
				
				//listeners
				//this.addEventListener(MouseEvent.CLICK, itemClick);
			
				//check for opened items
				if (openedItems && openedItems.length > 0) {
					for each (var openedItem:Object in openedItems) {
						var pinItem:PinListItem = this.getItemByUID(openedItem.uid);
						if (pinItem) pinItem.highlight(true);
					}
				}
				
			} else {
				
				addMessageWindow();
				
			}
				
		}		
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		protected function loadContent(data:Array):void {
			
			var item:PinListItem;		
			var posY:Number = 0;
			
			for each (var doc:PinModel in data) {
				
				//create pin view and pass the information
				item = new PinListItem(doc.uid);
				item.title = doc.title;
				item.flagUID = doc.currentFlag;
				item.color = WrkFlowController(target.getController()).getFlagColor(doc.currentFlag);
				item.maxWidth = target.maxWidth;
				item.init();
				
				if (DeviceInfo.os() != "Mac") item.scaleX = item.scaleY = 2;
				
				item.y = posY;
				
				//add pin view to a collection
				itemCollection.push(item);
				
				//add to screen
				container.addChild(item);
				
				posY += item.height + 1;
				
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function addListMask():void {
			containerMask = new Sprite();
			containerMask.graphics.beginFill(0xFFFFFF,1);
			containerMask.graphics.drawRect(container.x,container.y, container.width, maxHeight);
			this.addChild(containerMask);
			
			container.mask = containerMask;
		}
		
		/**
		 * 
		 * 
		 */
		protected function testForScroll():void {
			
			
			
			//if list exists
			if (container) {
				
				if (!scroll) { //if scroll doesn't exists
					
					if (container.height > maxHeight) this.addScroll(); // if needs scroll, create one
					
				} else { //if scroll exists
					
					if (container.height <= maxHeight)  { //if doesn't need scroll anymore
						scroll.kill();
						scroll = null;
						
					} else { // else update - mask width and height
						
						scroll.update();
					}
					
				}
				
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function addScroll():void {
			
			scroll = new Scroll();
			//scroll.gestureInput = "gestouch";
			scroll.rollVisible = true;
			scroll.target = container;
			scroll.maskContainer = containerMask;
			this.addChild(scroll);
			scroll.x = containerMask.width - scroll.width;
		}
		
		/**
		 * 
		 * @param fromItem
		 * 
		 */
		protected function updateListPositions(fromItem:PinListItem = null):void {
			
			var index:int = (fromItem) ? itemCollection.indexOf(fromItem) : -1;
			var posY:Number = (fromItem) ? fromItem.y : 0;
			
			for (var i:int = index + 1; i < itemCollection.length; i++) {
				
				TweenLite.to(itemCollection[i],.5,{y:posY});
				posY += itemCollection[i].height + 1;
			}
			
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */
		protected function removePinItem(item:PinListItem):void {
			container.removeChild(item);
		}
		
		/**
		 * 
		 * 
		 */
		protected function addMessageWindow():void {
			
			messageWindow = new MessageWindow(target.getController());
			messageWindow.windowAlpha = 0;
			messageWindow.maxWidth = target.maxWidth - 20;
			messageWindow.maxHeight = 17;
			messageWindow.init();
			
			this.addChild(messageWindow);
			
			var messageField:MessageField = new MessageField();
			messageField.backgroundAlpha = 0;
			messageField.textArea = true;
			messageField.maxWidth = messageWindow.maxWidth;
			messageField.fontSize = 22;
			messageField.alpha = .6;
			messageField.fontWeight = "light";
			messageField.init();
			messageField.sendMessage("No items!", MessageType.NONE);
			messageWindow.addMessage(messageField);
			
			messageWindow.x = (target.maxWidth/2) - (messageWindow.width/2);
			messageWindow.y = (this.maxHeight/4) - (messageWindow.height/2)	;
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * @return 
		 * 
		 */
		public function addItem(data:Object):Boolean {
			
			//create pin view and pass the information
			var item:PinListItem = new PinListItem(data.uid);
			item.title = data.title;
			item.flagUID = data.currentFlag;
			item.color = WrkFlowController(target.getController()).getFlagColor(data.currentFlag);
			item.maxWidth = target.maxWidth;
			item.init();
			
			if (DeviceInfo.os() != "Mac") item.scaleX = item.scaleY = 2;
			
			item.y = 0;
			
			TweenLite.from(item,.5,{y:"-20",alpha:0});
			
			//add pin view to a collection
			itemCollection.unshift(item);
			
			//add to screen
			container.addChild(item);
			
			//
			updateListPositions();
			
			//
			TweenLite.to(container,1,{y:0})
			
			//
			testForScroll();
			
			//
			if (messageWindow) {
				this.removeChild(messageWindow);
				messageWindow = null;
			}
		
			return true;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getItemByUID(uid:int):PinListItem {
			for each(var item:PinListItem in itemCollection) {
				if (item.uid == uid) return item;
			}
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function clearSelection():void {
			for each(var item:PinListItem in itemCollection) {
				if (item.highlighted) item.highlight(false);
			}
		}
		
		/**
		 * 
		 * @param id
		 * @param status
		 * 
		 */
		public function updatePinFlag(uid:int, flagColor:uint):void {
			var item:PinListItem = getItemByUID(uid);
			item.updateFlag(flagColor);
		}
		
		/**
		 * 
		 * @param id
		 * @param status
		 * 
		 */
		public function updatePinTitle(uid:int, title:String):void {
			var item:PinListItem = getItemByUID(uid);
			item.updateTitle(title);
			
			//update list height
			updateListPositions(item);
		}
		
		/**
		 * 
		 * @param id
		 * @param status
		 * 
		 */
		public function updatePin(item:Object):void {
			var pin:PinListItem = getItemByUID(item.uid);
			
			pin.flagUID = item.currentFlag;
			pin.updateFlag(WrkFlowController(target.getController()).getFlagColor(item.currentFlag));
		}
			
		/**
		 * 
		 * @param uid
		 * @return 
		 * 
		 */
		public function removeItem(uid:int):Boolean {
			
			var item:PinListItem
			
			//splice
			for each(item in itemCollection) {
				if (item.uid == uid) {
					itemCollection.splice(itemCollection.indexOf(item),1);
					break;
				}
			}
			
			//list adjust
			TweenLite.to(item,.5,{x:-item.width, onComplete:removePinItem, onCompleteParams:[item]});
			
			//update list height
			if (itemCollection.length > 0) {
				updateListPositions();
			} else {
				addMessageWindow();
			}
			
			
			return true;
		}
		
		/**
		 * 
		 * @param item
		 * @param value
		 * 
		 */
		public function highlightPin(itemUID:int, value:Boolean):void {
			var pin:PinListItem = this.getItemByUID(itemUID);
			pin.highlight(value);
		}

		/**
		 * 
		 * 
		 */
		public function resize():void {
			if (containerMask) containerMask.height = maxHeight;
			testForScroll();
			if (scroll) if (container.y != 0) container.y = -container.height/2 + containerMask.height/2;
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function itemClick(event:MouseEvent):void {
			if (event.target is PinListItem) {
				var selectedItem:PinListItem = event.target as PinListItem;
				selectedItem.highlight(!selectedItem.highlighted);
				
				//data
				var data:Object = new Object();
				data.open = selectedItem.highlighted;
				data.pinUID = selectedItem.uid;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.ACTIVATE_PIN, data));
			}
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxHeight():Number {
			return _maxHeight;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
		}

	}
}