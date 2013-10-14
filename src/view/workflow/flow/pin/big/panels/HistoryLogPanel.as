package view.workflow.flow.pin.big.panels {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import mvc.IController;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class HistoryLogPanel extends AbstractPanel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var logItemCollection			:Array;					//log collection
		protected var itemLog					:HistoryLogItem;
		
		protected var headerTF					:TextField;
		protected var headerStyle				:TextFormat;
		
		protected var gap						:Number = 5;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function HistoryLogPanel(c:IController) {
			super(c);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		override public function init(id:int = 0):void {
			
			//init
			pinUID = id;
			
			//get info
			WrkFlowController(this.getController()).loadDocLog(pinUID);
			
			//listener
			this.getController().getModel("wrkflow").addEventListener(WrkfluxEvent.COMPLETE, loadLog,false,0,true);
			this.getController().getModel("wrkflow").addEventListener(WrkfluxEvent.UPDATE_PIN, addNewItemLog,false,0,true);	
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function loadLog(event:WrkfluxEvent):void {
			
			if (pinUID == event.data.item.uid) {
			
				//this log table has 4 columns. The width proportion is: Date (40%), step (40%), flag (20%)
				var dateW:Number = (this.maxWidth-gap) * .3;
				var stepW:Number = (this.maxWidth-gap) * .4;
				var flagW:Number = (this.maxWidth-gap) * .3;
				
				var porportionsArray:Array = new Array(dateW,stepW,flagW);
				
				HistoryLogItem.columnProportion = porportionsArray;
				
				var posY:Number = margin;
				
				//add Header
				itemLog = new HistoryLogItem();
				
				itemLog.x = margin;
				itemLog.y = posY - 5;
				
				posY += itemLog.height -5;
				
				this.addChild(itemLog)
					
					//--------
				
				var data:Object = WrkFlowController(this.getController()).getDocData(pinUID);
				
				//scrolled area
				scrolledArea = new Sprite();
				scrolledArea.y = posY;
				
				this.addChild(scrolledArea);
				
				//list container
				container = new Sprite();
				scrolledArea.addChild(container);
				
				posY = 5;
				
				//inverted loop
				logItemCollection = new Array;
				
				var logArray:Array = data.log;
				logArray.sortOn("logUID",Array.DESCENDING);
				
				for each(var logItem:Object in logArray) {
					
					var stepAbbr:String = WrkFlowController(this.getController()).getStepAbbreviation(logItem.stepUID);
					var flagColor:uint = WrkFlowController(this.getController()).getFlagColor(logItem.flagUID);
					
					itemLog = new HistoryLogItem(logItem.logUID, logItem.date, stepAbbr, flagColor);
					
					itemLog.x = margin;
					itemLog.y = posY
					
					posY += itemLog.height + 3;
					
					container.addChild(itemLog)
					
					logItemCollection.push(itemLog);
					
				}
				
				
				//line
				var line:Shape = new Shape();
				line.graphics.lineStyle(1,0x999999);
				line.graphics.moveTo(-50,0);
				line.graphics.lineTo(maxWidth,0);
				line.y = scrolledArea.y;
				this.addChild(line);
				
				this.getController().getModel("wrkflow").removeEventListener(WrkfluxEvent.COMPLETE, loadLog);
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE));
				
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function addNewItemLog(event:WrkfluxEvent):void {
			
			//move list
			var offset:Number;
			for each(var item:Sprite in logItemCollection) {
				item.y = item.y + item.height + 3;
			}
			
			//get Data
			var data:Object = WrkFlowController(this.getController()).getLastLog(pinUID);
			
			
			var stepAbbr:String = WrkFlowController(this.getController()).getStepAbbreviation(data.stepUID);
			var flagColor:uint = WrkFlowController(this.getController()).getFlagColor(data.flagUID);
			
			itemLog = new HistoryLogItem(data.logUID, data.date, stepAbbr, flagColor);
			
			itemLog.x = margin;
			itemLog.y = 5;
			
			container.addChild(itemLog)
			logItemCollection.push(itemLog);
			
			TweenMax.from(itemLog,2,{alpha:0, ease:Back.easeOut});
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override public function removeEvents():void {
			this.getController().getModel("wrkflow").removeEventListener(WrkfluxEvent.COMPLETE, loadLog);
			this.getController().getModel("wrkflow").removeEventListener(WrkfluxEvent.UPDATE_PIN, addNewItemLog);	
		}

	}
}