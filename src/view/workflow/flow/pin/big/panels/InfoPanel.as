package view.workflow.flow.pin.big.panels {
	
	//import
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import font.FontFreightSans;
	
	import mvc.IController;
	
	import util.Colors;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InfoPanel extends AbstractPanel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var stepTF						:TextField;				//Step
		protected var flagTF						:TextField;				//status
		protected var descriptionTF					:TextField;				//Notes
		
		protected var labelStyle					:TextFormat;
		protected var valueStyle					:TextFormat;
		protected var flagValueStyle				:TextFormat;
		
		protected var historyPanel					:HistoryLogPanel;
		
		protected var gap							:Number = 5;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * @param id
		 * 
		 */
		public function InfoPanel(c:IController) {
			super(c);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		override public function init(id:int = 0):void {
			
			pinUID = id;
			
			//data
			var itemData:Object = WrkFlowController(this.getController()).getDocData(pinUID);
			
			//styles
			loadStyles();
			loadFlagColorStyles(itemData.currentFlag);
			
			//Built Layout
			
			container = new Sprite();
			this.addChild(container);
			
			panelShape = new Shape();
			var posY:Number = margin + 6;
			
			//1. Step
			var stepAbbr:String = itemData.stepAbbreviation;
			var stepTitle:String = itemData.stepTitle;
			
			stepTF = createTF();
			stepTF.wordWrap = true;
			stepTF.multiline = true;
			stepTF.text = "Step: "+ stepTitle + " (" +stepAbbr.toUpperCase() + ")";
			stepTF.setTextFormat(labelStyle,0,5);
			stepTF.setTextFormat(valueStyle,5,stepTF.length);
			
			stepTF.x = margin;
			stepTF.y = posY;
			stepTF.width = maxWidth - margin;
			
			container.addChild(stepTF);
			
			posY += stepTF.height;
			
			//2. status
			var flagTitle:String = itemData.flagTitle;
			
			flagTF = createTF();
			flagTF.wordWrap = true;
			flagTF.multiline = true;
			flagTF.text = "Flag: "+ flagTitle;
			flagTF.setTextFormat(labelStyle,0,5);
			flagTF.setTextFormat(flagValueStyle,5,flagTF.length);
			
			flagTF.x = margin;
			flagTF.y = posY;
			flagTF.width = maxWidth - margin;
			
			container.addChild(flagTF);
			
			posY += flagTF.height;
			
			//3. description
			
			var description:String = itemData.description;
			
			if (description) {
				descriptionTF = createTF();
				descriptionTF.wordWrap = true;
				descriptionTF.multiline = true;
				descriptionTF.text = "Description: "+ description;
				descriptionTF.setTextFormat(labelStyle,0,6);
				descriptionTF.setTextFormat(valueStyle,6,descriptionTF.length);
				
				descriptionTF.x = margin;
				descriptionTF.y = posY;
				descriptionTF.width = maxWidth - margin;
				
				container.addChild(descriptionTF);
				
				posY += descriptionTF.height;
			}
			
			//add history panel
			historyPanel = new HistoryLogPanel(this.getController());
			container.addChild(historyPanel);
			historyPanel.init(pinUID);
			historyPanel.y = posY + gap;
			historyPanel.addEventListener(WrkfluxEvent.COMPLETE, historyLoadComplete,false,0,true);
			
			//listener
			this.getController().getModel("wrkflow").addEventListener(WrkfluxEvent.UPDATE_PIN, updatePanel,false,0,true);
			
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function loadStyles():void {
			
			//Label
			labelStyle = new TextFormat();
			labelStyle.font = FontFreightSans.MEDIUM;
			labelStyle.size = 14;
			labelStyle.color = Colors.getColorByName(Colors.DARK_GREY);
			
			//Value
			valueStyle = new TextFormat();
			valueStyle.font = FontFreightSans.MEDIUM;
			valueStyle.size = 14;
			valueStyle.color = Colors.getColorByName(Colors.DARK_GREY);
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function loadFlagColorStyles(flagUID:int):void {
			
			//flagValue
			var currentFlagColor:uint = WrkFlowController(this.getController()).getFlagColor(flagUID);
			
			if (!flagValueStyle) {
				flagValueStyle = new TextFormat();
				flagValueStyle.font = FontFreightSans.MEDIUM;
				flagValueStyle.size = 14;
			}
			
			if (currentFlagColor == Colors.getColorByName(Colors.WHITE)) {
				flagValueStyle.color = Colors.getColorByName(Colors.DARK_GREY);
			} else {
				flagValueStyle.color = currentFlagColor;
			}
			
			
		}
		
		//****************** PUBLIC EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override public function removeEvents():void {
			if (historyPanel) {
				historyPanel.removeEventListener(WrkfluxEvent.COMPLETE, historyLoadComplete);
				historyPanel.removeEvents();
				container.removeChild(historyPanel);
				historyPanel = null;
			}
			this.getController().getModel("wrkflow").removeEventListener(WrkfluxEvent.UPDATE_PIN, updatePanel);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function historyLoadComplete(event:Event):void {
			event.stopImmediatePropagation();
			testForScroll();
		}
		
		/**
		 * 
		 * 
		 */
		override public function updatePanel(event:WrkfluxEvent):void {
			
			event.stopImmediatePropagation();
			
			var itemData:Object = WrkFlowController(this.getController()).getDocData(pinUID);
			
			loadFlagColorStyles(itemData.currentFlag);
			
			var flagTitle:String = itemData.flagTitle;
			flagTF.text = "Flag: "+ itemData.flagTitle;
			flagTF.setTextFormat(labelStyle,0,5);
			flagTF.setTextFormat(flagValueStyle,5,flagTF.length);
			
			testForScroll();
		}
		
	}
}