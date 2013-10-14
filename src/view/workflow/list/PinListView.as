package view.workflow.list {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import controller.WrkFlowController;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
	import util.Colors;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinListView extends AbstractView {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _maxHeight					:Number;
		protected var _maxWidth						:Number = 125;
		
		protected var separatorV					:Sprite;
		protected var background					:Sprite;
		protected var pinList						:PinList;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function PinListView(c:IController) {
			super(c);
			
			this._maxHeight = 500;
			
			if (Settings.platformTarget == "mobile") {
				_maxWidth = 220;
			} else {
				_maxWidth = 110;
			}
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init(openedItems:Array = null):void {
			
			
			
			//Background
			background = new Sprite();
			background.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			background.graphics.drawRect(0,0,_maxWidth,maxHeight);
			this.addChild(background);
			
			//Header
			var header:Header = new Header("Items");
			header.x = 5;
			header.y = 5;
			this.addChild(header);
			
			//list
			var pinData:Array = WrkFlowController(this.getController()).getFlow();
			
			pinList = new PinList(this);
			pinList.y = header.y + header.height + 5;
			pinList.maxHeight = this.maxHeight - pinList.y;
			pinList.init(pinData, openedItems);
			this.addChild(pinList);
			
			//separator
			separatorV = new Sprite();
			separatorV.graphics.lineStyle(2,Colors.getColorByName(Colors.DARK_GREY));
			separatorV.graphics.lineTo(0,maxHeight);
			separatorV.x = _maxWidth;
			this.addChild(separatorV);
			
			this.addEventListener(MouseEvent.CLICK, click);
			
		}		
		
		
		//****************** PROTECT EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function click(event:MouseEvent):void {
			//block background clicks
			event.stopImmediatePropagation();
		}		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param item
		 * 
		 */
		public function addItem(item:Object):void {
			pinList.addItem(item);
		}
		
		/**
		 * 
		 * @param uid
		 * 
		 */
		public function removeItem(uid:int):void {
			pinList.removeItem(uid);
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */
		public function updateItem(item:Object):void {
			pinList.updatePin(item);
		}
		
		/**
		 * 
		 * @param item
		 * @param value
		 * 
		 */
		public function highlightItem(itemUID:int, value:Boolean):void {
			pinList.highlightPin(itemUID,value);
		}
		
		/**
		 * 
		 * 
		 */
		public function closeAllOpenedPins():void {
			pinList.clearSelection();			
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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():Number {
			return _maxWidth;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxWidth(value:Number):void {
			_maxWidth = value;
		}


	}
}