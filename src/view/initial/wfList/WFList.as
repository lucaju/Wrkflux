package view.initial.wfList {
	
	//imports
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
		
		protected var itemCollection		:Array;
		protected var itemContainer			:Sprite;
		
		protected var lineTop				:Shape;
		protected var lineBottom			:Shape;
		
		protected var _selectedItem			:int;
		protected var _selectedItemAction	:String;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function WFList(data:Array) {
			
			
			
			//test
			/*var data:Array = new Array({id:1, title:"Teste1", author:"Luciano Frizzera", date:"23 nov 2013"},
				{id:2, title:"Teste2", author:"Luciano Frizzera", date:"23 nov 2013"},
				{id:3, title:"Teste3", author:"Luciano Frizzera", date:"23 nov 2013"},
				{id:4, title:"Teste4", author:"Luciano Frizzera", date:"23 nov 2013"},
				{id:5, title:"Teste5", author:"Luciano Frizzera", date:"23 nov 2013"});*/
			
			itemCollection = new Array();
			var wfItem:WFItem;
			var posY:Number = 0;
			
			for each (var item:WorkflowItemModel in data) {
				
				wfItem = new WFItem(item.id, item.title, item.author, item.createdDate);
				wfItem.y = posY;
				this.addChild(wfItem);
				
				itemCollection.push(wfItem);
				posY += wfItem.height;
			}
				
			
			//listeners
			this.addEventListener(MouseEvent.CLICK, itemClick);
			
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
				
				
			} else if (event.target is Button) {
				
				item = WFItem(event.target.parent);
				this._selectedItemAction = "edit";
				
			}
			
			this._selectedItem = item.id;
			this.dispatchEvent(new Event(Event.SELECT));
			
			
			this._selectedItem = 0;
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