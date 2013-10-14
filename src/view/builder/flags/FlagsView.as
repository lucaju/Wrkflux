package view.builder.flags {
	
	//imports
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import controller.WrkBuilderController;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	
	import view.assets.buttons.Button;
	import view.assets.buttons.ButtonShapeForm;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlagsView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var plusButton			:Button;
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
			
			//Header
			var header:Header = new Header("Flags");
			header.x = 5;
			header.y = 5;
			this.addChild(header);
			
			//Plus
			var plusButton:Button = new Button();
			plusButton.shapeForm = ButtonShapeForm.RECT;
			plusButton.color = Colors.getColorByName(Colors.DARK_GREY);
			plusButton.maxHeight = 20;
			plusButton.maxWidth = 100;
			this.addChild(plusButton);
			
			plusButton.x = 5;
			plusButton.y = this.stage.stageHeight - 60;
			
			plusButton.init("Add");
			
			//list
			var flagsData:Array = WrkBuilderController(this.getController()).getflags();
			
			flagList = new FlagList(this,flagsData);
			flagList.x = 5;
			flagList.y = header.y + header.height + 5;
			this.addChild(flagList);
			
			//separator
			separatorV = new Sprite();
			separatorV.graphics.lineStyle(1,Colors.getColorByName(Colors.DARK_GREY));
			separatorV.graphics.lineTo(0,this.height + 15);
			separatorV.x = 110;
			this.addChild(separatorV);
			
			//listeners
			plusButton.addEventListener(MouseEvent.CLICK, addFlag);
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
	}
}