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
	
	import view.assets.buttons.Button;
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
		
		protected var yesBT					:Button;
		protected var noBT					:Button;
		
		
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
			noBT = new Button();
			this.addChild(noBT);
			noBT.maxWidth = 70;
			noBT.maxHeight = 35;
			noBT.color = Colors.getColorByName(Colors.RED);
			noBT.textColor = Colors.getColorByName(Colors.WHITE);
			noBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			noBT.init("no");;
			
			noBT.x = gap;
			//noBT.y = gap;
			noBT.y = messageField.y + messageField.height + gap;
			
			fieldCollection.push(noBT);
			
			//3. yes Button
			yesBT = new Button();
			this.addChild(yesBT);
			yesBT.maxWidth = 70;
			yesBT.maxHeight = 35;
			yesBT.color = Colors.getColorByName(Colors.GREEN);
			yesBT.textColor = Colors.getColorByName(Colors.WHITE);
			yesBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			yesBT.init("yes");;
			
			
			yesBT.x = noBT.x + noBT.width + gap;
			//yesBT.y = gap;
			yesBT.y = messageField.y + messageField.height + gap;
			
			fieldCollection.push(yesBT);
			
			//window
			this.windowGlow = true;
			this.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
			this.windowColor = Colors.getColorByName(Colors.WHITE_ICE);
			this.drawWindow(this.width + (2*gap), this.height + (2*gap));
			this.maxHeight = this.window.height;
			
			messageLabel.x = this.window.width/2 - messageLabel.width/2;
			messageField.x = this.window.width/2 - messageField.width/2;
				
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
			super.kill();
			if (yesBT) yesBT.kill();
			if (noBT) noBT.kill();
			this.removeEventListener(MouseEvent.CLICK, formClick);
			TweenLite.to(this,.6,{y:0, autoAlpha: 0, delay: .8, onComplete:killView});
		}
		
	}
}