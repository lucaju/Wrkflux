package view.initial.wfList {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.initial.WorkflowItemModel;
	
	import view.assets.buttons.Button;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WFList extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target						:WFLoadList;
		
		protected var addBT							:NewWorkflowButton
		
		protected var container						:Sprite;
		protected var itemCollection				:Array;
		protected var filteredItemCollection		:Array;
		protected var actualCollection				:Array;
		
		protected var bg							:Sprite;
		
		protected var lineTop						:Shape;
		protected var lineBottom					:Shape;
		
		protected var _selectedItem					:int;
		protected var _selectedItemAction			:String;
		
		protected var gap							:Number = 7;
		
		protected var slotWidth						:Number;
		protected var numColumns					:int;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param _target
		 * 
		 */
		public function WFList(_target:WFLoadList) {
			target = _target;
			slotWidth = 200;
			numColumns = 4;
		}
		
		
		//****************** I ****************** ****************** ******************
			
		/**
		 * 
		 * @param data
		 * 
		 */
		public function init(data:Array):void {
			
			container = new Sprite();
			this.addChild(container);
			
			itemCollection = new Array();
			var wfItem:WFItem;
			var posY:Number = 10;
			var i:int = 0;
			
			//add first item: Create new Workflow
			addBT = new NewWorkflowButton();
			
			addBT.y = posY;
			container.addChild(addBT);
			
			
			//define
			slotWidth = addBT.width + gap;
			numColumns = Math.floor(target.maxWidth/slotWidth);
			
			var iColumns:int = 1;
			
			//item loop
			for each (var item:WorkflowItemModel in data) {
				
				wfItem = new WFItem(item.id, item.authorID, item.title, item.author, item.createdDate);
				
				//test positions
				if (iColumns >= numColumns) {
					iColumns = 0;
					posY += wfItem.height + gap;
				}
				
				//position
				wfItem.x = iColumns * slotWidth;
				wfItem.y = posY;
				container.addChild(wfItem);
				
				//add to array
				itemCollection.push(wfItem);
				
				//add tp posX
				iColumns++;
				
			}
			
			//faux bg
			bg = new Sprite();
			bg.graphics.beginFill(0x999999,0);
			bg.graphics.drawRect(0, 0, this.stage.stageWidth, this.height+20);
			bg.graphics.endFill();
			this.addChildAt(bg,0);
				
			
			//listeners
			this.addEventListener(MouseEvent.CLICK, itemClick);
			
			actualCollection = itemCollection;
			
			container.x = this.width/2 - container.width/2;
			
		}
		
		
		//****************** INITIALIZATION ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function show():void {
			for (var i:int = 0; i < actualCollection.length; i++) TweenMax.from(actualCollection[i],.6,{x: 1400, y:500, rotation:Math.random()*20, delay:i*.1});
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param from
		 * 
		 */
		protected function updateList(from:int = 0):void {
			
			//variables
			var iColumns:int = 1;
			var posX:Number;
			var posY:Number;
			var k:Number = .01;
			
			//condition
			if (from == 0) {
				iColumns = 1;
				posY = 10;
			} else {
				iColumns = Math.floor(numColumns/actualCollection[from-1].x + slotWidth);
				posY = actualCollection[from-1].y;
			}
			
			
			//item loop
			for (var i:int = from; i < actualCollection.length; i++) {
				
				//check position
				if (iColumns >= numColumns) {
					iColumns = 0;
					posY += actualCollection[i].height + gap;
				}
				
				//animation
				if (!actualCollection[i].visible) {
					actualCollection[i].x = iColumns * slotWidth;;
					actualCollection[i].y = posY;
					TweenMax.to(actualCollection[i],.6,{autoAlpha:1,delay:.6});
				} else {
					TweenMax.to(actualCollection[i],.6,{x: iColumns * slotWidth, y:posY, delay:i*k});
					
					
					if (i > 50) {
						k = .001; 
					} else if (i > 100) {
						k = .0001
					}
				}
				
				//if it is the las, call update listSize in the end
				if (i == actualCollection.length-1) TweenMax.to(actualCollection[i],.6,{autoAlpha:1,onComplete:updateListSize});
				
				//add tp posX
				iColumns++;
			}
			
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateListSize():void {
			bg.height = 0;
			bg.height = this.height+20;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function itemClick(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			var item:WFItem;
			
			if (event.target is WFItem) {
				
				item = WFItem(event.target);
				this._selectedItemAction = "use";
				this._selectedItem = item.id;
				
			} else if (event.target is Button) {
				
				var targetBT:Button = event.target as Button;
				item = targetBT.parent.parent.parent as WFItem;
				
				this._selectedItemAction = targetBT.name.toLocaleLowerCase();
				this._selectedItem = item.id;
				
			} else if (event.target is NewWorkflowButton) {
				this._selectedItemAction = "new";
				this._selectedItem = 0;
			}
			
			this.dispatchEvent(new Event(Event.SELECT));
			
			this._selectedItem = 0;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function filter(userID:int = 0):void {
			
			if (userID == 0) {
				
				//unfilter
				filteredItemCollection = null;
				
				actualCollection = itemCollection;
				
			} else {
				
				//filter
				filteredItemCollection = new Array();
				
				for each(var item:WFItem in itemCollection) {
					if (item.authorID == userID) {
						filteredItemCollection.push(item);
					} else {
						TweenMax.to(item,.3,{autoAlpha:0});
						TweenMax.to(item,.1,{x:0,y:0,delay:.3});
						//item.x = 0;
						//item.y = 0;
					}
				}
				
				actualCollection = filteredItemCollection;
				
			}
			
			//move list back to the top
			TweenMax.to(this,.6,{y:0});
			
			//check if there is any in the list to update position. If it haven't, make the height zero and dispatch change
			if (actualCollection.length > 0) {
				updateList();
			} else {
				bg.height = 0;
				TweenMax.to(bg,.1,{height:0, delay: .4,onComplete:dispatchEvent, onCompleteParams:[new Event(Event.CHANGE)]});
			}
		}
		
		/**
		 * 
		 * @param itemID
		 * 
		 */
		public function removeItem(itemID:int):void {
			
			var actualItemIndex:int;
			var collectionItemIndex:int;
			
			for each (var item:Sprite in actualCollection) {
			var wfItem:WFItem = item as WFItem;
				if (wfItem.id == itemID) {
					
					//save positon
					actualItemIndex = actualCollection.indexOf(wfItem);
					
					//remove from collections
					actualCollection.splice(actualItemIndex,1);
					
					//if it is filtered, save new fiter item collection and remove from the main collections
					if (filteredItemCollection) {
						filteredItemCollection = actualCollection;
						
						collectionItemIndex = itemCollection.indexOf(wfItem);
						itemCollection.splice(collectionItemIndex,1);
					}
					
					//remove item from screen
					container.removeChild(wfItem);
					
					//stop
					break;
				}
			}
			
			//update list, if affected item was not the last
			if (actualCollection.length != actualItemIndex) updateList(actualItemIndex);
			
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			
			if  (Math.floor(target.maxWidth/slotWidth) != numColumns) {
				numColumns = Math.floor(target.maxWidth/slotWidth);
				if (numColumns < 1) numColumns = 1;
				if (numColumns > 6) numColumns = 6;
				updateList();
				
			}
			
			bg.width = this.stage.stageWidth;
			
			TweenMax.to(container, .4, {x:bg.width/2 - (numColumns*slotWidth)/2});
			
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			this.removeEventListener(MouseEvent.CLICK, itemClick);
			addBT.kill();
			for each (var wf:WFItem in itemCollection) {
				wf.kill();
			}
			itemCollection = null;
			target = null;
		}

		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selectedItem():int {
			return _selectedItem;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selectedItemAction():String {
			return _selectedItemAction;
		}
	}
}