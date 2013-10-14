package view.workflow.flow.pin.big.panels {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import view.workflow.flow.pin.PinView;
	import view.workflow.flow.pin.big.BigPin;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class SlicePanel extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var target					:BigPin;
		
		protected var itemCollection			:Array;					//collection
		protected var container					:Sprite;
		
		protected var _startAngle				:Number;
		
		protected var _selectedItem				:int;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function SlicePanel(target:BigPin) {
			
			//initial
			this.target = target;
			selectedItem = target.source.currentFlag;
			
			var options:Array = this.getFlagData();
			itemCollection = new Array();
			
			var imageFilePath:String = "images/icons/";
			
			//container
			container = new Sprite();
			this.addChild(container)
						
			//loop in the buttons
			startAngle = -180/options.length;
			var slice:Slice;
			var iterationAngle:Number = startAngle;
			var arcLength:Number = (360/options.length);

			for each (var flag:Object in options) {
				
				slice = SliceFactory.addPinControlButton(flag);
				slice.init(iterationAngle, arcLength);
				container.addChild(slice);
				
				itemCollection.push(slice);
				
				//update arch
				iterationAngle += arcLength;
				
			}
			
			this.addEventListener(MouseEvent.CLICK, buttonClick,false,0,true);
			
		}
			
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function getFlagData():Array {
			
			var flagData:Array = target.getController().getFlags();
			var adaptFlagsData:Array = new Array();
			var bulletObject:Object;
			
			for each (var flagObject:Object in flagData) {
				
				bulletObject = new Object();
				bulletObject.uid = flagObject.uid;
				bulletObject.color = flagObject.color;
				bulletObject.label = flagObject.title;
				
				adaptFlagsData.push(bulletObject);
			}
			
			flagData = null;
			
			return adaptFlagsData;
		}
		
		//****************** Public Methods ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function buttonClick(event:MouseEvent):void {
			if (event.target is Slice) {
				
				event.stopImmediatePropagation();
				
				var slice:Slice = event.target as Slice;
				selectedItem = slice.uid;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT));
			}
		}	
		
		//****************** Public Methods ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function highlightOption(value:int):void {
			
			var select:Boolean = false;
			
			for each(var button:Slice in itemCollection) {
				select = false;
				if (itemCollection.indexOf(button) == value) select = true;
				button.highlight(select);
			}
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getOptionsNum():int {
			return itemCollection.length;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getIndexPosition(value:int):int {
			for each (var slice:Slice in itemCollection) {
				if (slice.uid == value) return itemCollection.indexOf(slice);
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getSliceUIDByIndexPosition(value:int):int {
			return itemCollection[value].uid;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getSliceByUID(value):Slice {
			for each (var slice:Slice in itemCollection) {
				if (slice.uid == value) return slice;
			}
			return null;
		}
		
		
		//****************** GETTERS //SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get startAngle():Number {
			return _startAngle;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set startAngle(value:Number):void {
			_startAngle = value;
		}

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
		 * @param value
		 * 
		 */
		public function set selectedItem(value:int):void {
			_selectedItem = value;
		}

		
	}
}