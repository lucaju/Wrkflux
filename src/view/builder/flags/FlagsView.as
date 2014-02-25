package view.builder.flags {
	
	//imports
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import controller.WrkBuilderController;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	
	import view.workflow.flow.CrossButton;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlagsView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var bg					:Sprite;
		protected var addButton				:CrossButton;
		protected var flagList				:FlagList;
		
		protected var separatorV			:Sprite;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function FlagsView(c:IController) {
			super(c);
		}
			
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//bg
			//separator
			bg = new Sprite();
			bg.graphics.beginFill(Colors.getColorByName(Colors.WHITE_ICE),.6);
			bg.graphics.drawRect(0,0,110,stage.stageHeight-this.y);
			bg.graphics.endFill();
			this.addChild(bg);
			
			//Header
			var header:Header = new Header("Flags");
			//header.x = 5;
			//header.y = 5;
			this.addChild(header);
			
			//Plus
			//add button
			addButton = new CrossButton();
			addButton.color = Colors.getColorByName(Colors.WHITE);
			addButton.highlightedColor = Colors.getColorByName(Colors.GREEN);
			addButton.crossColor = Colors.getColorByName(Colors.GREEN);
			addButton.lineThickness = 2;
			addButton.lineColor = Colors.getColorByName(Colors.GREEN);
			addButton.init();
			addButton.buttonMode = true;
			addButton.x = this.width/2;
			addButton.y = this.stage.stageHeight - this.y - 30;
			this.addChild(addButton);
			addButton.scaleX = addButton.scaleY = .85;
			addButton.name = "Add";
			
			//list
			var flagsData:Array = WrkBuilderController(this.getController()).getflags();
			
			flagList = new FlagList(this,flagsData);
			flagList.x = 5;
			flagList.y = header.y + header.height + 5;
			this.addChild(flagList);
			
			//separator
			separatorV = new Sprite();
			separatorV.graphics.lineStyle(2,Colors.getColorByName(Colors.LIGHT_GREY));
			separatorV.graphics.lineTo(0,stage.stageHeight - this.y);
			separatorV.x = 110;
			this.addChild(separatorV);
			
			//listeners
			addButton.addEventListener(MouseEvent.CLICK, addFlag);
			flagList.addEventListener(Event.CLOSING, removeFlag);
			flagList.addEventListener(Event.SELECT, updateFlag);
		}	
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function addFlag(event:MouseEvent):void {
			event.stopImmediatePropagation();
			var newFlag:Object = WrkBuilderController(this.getController()).addFlag();
			if (newFlag) flagList.addItem(newFlag);	
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function removeFlag(event:Event):void {
			event.stopImmediatePropagation();
			
			if (event.target is Flag) {
				var selectedFlag:Flag = event.target as Flag;
				var id:* = (selectedFlag.tempID) ? selectedFlag.tempID : selectedFlag.id;
				WrkBuilderController(this.getController()).removeFlag(id);
			}
			
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updateFlag(event:Event):void {
			if (event.target is Flag) {
				var selectedFlag:Flag = event.target as Flag;
				
				var id:* = (selectedFlag.tempID) ? selectedFlag.tempID : selectedFlag.id;
				
				var data:Object = new Object();
				data.color = selectedFlag.color;
				data.label = selectedFlag.label;
				data.order = selectedFlag.order;
				
				WrkBuilderController(this.getController()).updateFlag(id,data);
			}
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function updateFlagsUID(recentAddedFlags:Array):void {
			flagList.updateFlagsUID(recentAddedFlags);
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			bg.height = stage.stageHeight-this.y;
			separatorV.height = stage.stageHeight - this.y;
			addButton.y = this.stage.stageHeight - this.y - 30;
		}
	}
}