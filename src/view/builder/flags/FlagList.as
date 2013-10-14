package view.builder.flags {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import controller.WrkBuilderController;
	
	import model.FlagModel;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlagList extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target				:FlagsView;
		
		internal var itemCollection			:Array;
		protected var itemContainer			:Sprite;
		
		protected var _selectedItem			:int;
		protected var _selectedItemAction	:String;
		
		internal var gap					:int = 5;
		internal var currentHeight			:Number = 0;
		
		protected var maxItens				:int = 5;
		
		protected var reorderHandle			:ReorderHandle;
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param target
		 * @param data
		 * 
		 */
		public function FlagList(target:FlagsView, data:Array = null) {
			
			//initial
			this.target = target;
			
			//checking data
			if (!data) data = WrkBuilderController(target.getController()).getFlagsPreset(4);
			
			itemCollection = new Array();
			var flag:Flag;
			
			data.sortOn("order");
			
			for each (var item:FlagModel in data) {
				
				flag = new Flag(item.uid, item.title, item.color);
				
				flag.order = item.order;
				
				if (item.title == "") flag.label = Colors.getColorByUint(item.color);
				
				flag.y = currentHeight;
				this.addChild(flag);
				flag.init();
				
				itemCollection.push(flag);
				currentHeight += flag.height + gap;
				
				TweenLite.from(flag,.6,{y:500, alpha:0, delay:item.order * 0.05});
				
				flag.addEventListener(MouseEvent.MOUSE_DOWN, flagPressed);
			}
				
			
			//listeners
			this.addEventListener(Event.CLOSING, removeFlag);
			
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function removeFlag(event:Event):void {
			
			if (event.target is Flag) {
				var selectedFlag:Flag = event.target as Flag;
				var id:int = selectedFlag.id;
				
				currentHeight = 0;
				var flag:Flag;
				
				//remove selected flag from the list
				for each (flag in itemCollection) {
					if (flag.id == selectedFlag.id) {
						itemCollection.splice(itemCollection.indexOf(selectedFlag),1);
						break;
					}
				}
				
				//rearrange the list
				var numOrder:int = 0;
				
				for each (flag in itemCollection) {
					flag.order = numOrder;
					TweenLite.to(flag, .6, {y:currentHeight, delay:.4 + flag.order * 0.05});
					currentHeight += flag.height + gap;
					numOrder++;
				}
				
				//
				selectedFlag.kill();
				
				//if there is only one left
				if (itemCollection.length == 1) {
					var singleFlag:Flag = itemCollection[0] as Flag;
					singleFlag.removable = false;
				}
				
				//update order position
				for each (flag in itemCollection) {
					flag.dispatchEvent(new Event(Event.SELECT,true));
				}
				
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function flagPressed(event:MouseEvent):void {
			if (event.currentTarget is Flag) {
				ReorderHandle.start(this, event.currentTarget as Flag);
				ReorderHandle.getInstance().addEventListener(Event.COMPLETE, reorderComplete);
			}
		}		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function reorderComplete(event:Event):void {
			for each (var flag:Flag in itemCollection) {
				flag.dispatchEvent(new Event(Event.SELECT,true));
			}
		}		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addItem(flag:Object):void {
			
			var flagModel:FlagModel = flag as FlagModel;
			
			var newFlag:Flag = new Flag(flagModel.uid, flagModel.title, flagModel.color);
			newFlag.tempID = flagModel.tempID;
			newFlag.order = flagModel.order;
			
			newFlag.y = currentHeight;
			
			this.addChild(newFlag);
			newFlag.init();
			
			itemCollection.push(newFlag);
			
			currentHeight += newFlag.height + gap;	
			
			TweenLite.from(newFlag,.6,{y:500, alpha:0});
			
			newFlag.addEventListener(MouseEvent.MOUSE_DOWN, flagPressed);
			
			//if there WAS only one
			if (itemCollection.length == 2) {
				var singleFlag:Flag = itemCollection[0] as Flag;
				singleFlag.removable = true;
			}
			
		}
		
		/**
		 * 
		 * @param recentAddedFlags
		 * 
		 */
		public function updateFlagsUID(recentAddedFlags:Array):void {
			
			for each (var recentAddedFlag:FlagModel in recentAddedFlags) {
				
				for each (var flag:Flag in itemCollection) {
					
					if (recentAddedFlag.tempID == flag.tempID) {
						flag.id = recentAddedFlag.uid;
						flag.tempID = "";
						break;
					}
					
				}
				
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		public function restarActions():void {
			for each (var flag:Flag in itemCollection) {
				flag.addListeners();
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function stopActions():void {
			for each (var flag:Flag in itemCollection) {
				flag.removeListeners();
			}
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