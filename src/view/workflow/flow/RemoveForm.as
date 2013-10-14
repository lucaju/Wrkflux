package view.workflow.flow {
	
	//imports
	
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import flash.text.TextFormatAlign;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import mvc.IController;
	
	import util.Colors;
	import util.MessageType;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.buttons.ButtonFactory;
	import view.forms.AbstractForm;
	import view.forms.MessageField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class RemoveForm extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var itemUID				:int;
		
		protected var yesBT					:AbstractButton;
		protected var noBT					:AbstractButton;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function RemoveForm(c:IController, itemUID:int) {
			super(c);
			
			this.itemUID = itemUID;
			
			// FIELDS
			
			//1. message
			var messageLabel:MessageField = new MessageField();
			messageLabel.backgroundAlpha = 0;
			messageLabel.textArea = false;
			messageLabel.maxWidth = 115;
			messageLabel.maxHeight = 20;
			messageLabel.textAlign = TextFormatAlign.CENTER;
			messageLabel.fontSize = 11;
			messageLabel.fontWeight = "medium";
			messageLabel.init();
			messageLabel.sendMessage("Do you want to remove", MessageType.NONE);
			this.addChild(messageLabel);
			
			messageLabel.x = gap;
			messageLabel.y = gap;
			
			var msg:String = WrkFlowController(this.getController()).getDocTitle(itemUID) + "?";
			
			var messageField:MessageField = new MessageField();
			messageField.backgroundAlpha = 0;
			messageField.textArea = true;
			messageField.maxWidth = 115;
			messageField.maxHeight = 20;
			messageField.textAlign = TextFormatAlign.CENTER;
			messageField.fontSize = 16;
			messageField.fontWeight = "regular";
			messageField.init();
			messageField.sendMessage(msg, MessageType.NONE);
			this.addChild(messageField);
			
			messageField.x = gap;
			messageField.y = messageLabel.y + messageLabel.height - gap;
			
			//2. no Button
			noBT = ButtonFactory.getButton((Colors.RED), ButtonFactory.FORM);
			this.addChild(noBT);
			noBT.maxWidth = 55;
			noBT.maxHeight = 35;
			noBT.init("no");
			
			noBT.x = gap;
			//noBT.y = gap;
			noBT.y = messageField.y + messageField.height + gap;
			
			fieldCollection.push(noBT);
			
			//3. yes Button
			yesBT = ButtonFactory.getButton((Colors.GREEN), ButtonFactory.FORM);
			this.addChild(yesBT);
			yesBT.maxWidth = 55;
			yesBT.maxHeight = 35;
			yesBT.init("yes");
			
			yesBT.x = noBT.x + noBT.width + gap;
			//yesBT.y = gap;
			yesBT.y = messageField.y + messageField.height + gap;
			
			fieldCollection.push(yesBT);
			
			//window
			this.windowColor = Colors.getColorByName(Colors.WHITE);
			this.drawWindow(125, this.height + (2*gap));
			
			//listeners
			this.addEventListener(MouseEvent.CLICK, formClick);
		}		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			this.parent.removeChild(this);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override protected function formClick(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			var data:Object = new Object();
			
			switch (event.target.name) {
				
				case "no":
					data.action = "removeCanceled";
					data.uid = this.itemUID;
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, data));
					break;
				
				case "yes":
					super.addProgressBar();
					data.action = "removeItem";
					data.uid = this.itemUID;
					
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, data));
					break;
			}
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 */
		override public function kill():void {
			super.removeProgressBar();
			TweenLite.to(this,.6,{y:0, autoAlpha: 0, delay: .8, onComplete:killView});
		}
		
	}
}