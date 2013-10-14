package view.builder {
	
	//imports
	
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import events.WrkfluxEvent;
	
	import mvc.IController;
	
	import util.Colors;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.buttons.ButtonFactory;
	import view.forms.AbstractForm;
	import view.forms.MessageField;
	import util.MessageType;
	import view.forms.TextFormField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TitleForm extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var titleField			:TextFormField;
		protected var authorField			:TextFormField;
		protected var okBT					:AbstractButton;
		protected var messageField			:MessageField;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function TitleForm(c:IController) {
			super(c);
			
			//window
			this.drawWindow(230,85);
			
			// FIELDS
			
			//1. Title
			titleField = new TextFormField();
			titleField.maxChars = 30;
			titleField.maxWidth = 220;
			titleField.required = true;
			this.addChild(titleField);
			titleField.init("title");
			
			titleField.x = gap;
			titleField.y = gap;
			
			fieldCollection.push(titleField);
			
			//2. Author
			authorField = new TextFormField();
			authorField.maxChars = 30;
			authorField.maxWidth = 175;
			authorField.required = true;
			this.addChild(authorField);
			authorField.init("author");
			
			authorField.x = gap;
			authorField.y = titleField.y + titleField.height + gap;
			
			fieldCollection.push(authorField);
			
			//3. Ok Button
			var okBT:AbstractButton = ButtonFactory.getButton((Colors.BLUE), ButtonFactory.FORM);
			this.addChild(okBT);
			okBT.maxWidth = 40;
			okBT.maxHeight = 35;
			okBT.init("ok");
			
			okBT.x = authorField.x + authorField.width + gap;
			okBT.y = titleField.y + titleField.height + gap;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function validateAndSendData():void {
			
			var readyToSend:Boolean = true;
			var failToValidate:Array = new Array();
			
			//collect  data
			var formData:Object = new Object();
			formData.name = "TitleForm";
			
			//validation
			for each (var form:TextFormField in fieldCollection) {
				if (fillValidation(form)) {
					formData[form.getLabel()] = form.getInput();
					form.validationWarning(false);
				} else {
					form.validationWarning(true);
					readyToSend = false;
				}
			}
			
			//send data
			if (readyToSend) {
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, formData));
				super.addProgressBar();
			} else {
				sendMessage("Please fill all required fields.",MessageType.WARNING);
				super.removeProgressBar();
			}
			
		}
		
		/**
		 * 
		 * @param field
		 * @return 
		 * 
		 */
		protected function fillValidation(field:TextFormField):Boolean {
			
			if (field.required) {
			
				if (field.getInput() == "") {
					return false;
				} else {
					return true;
				}
				
			} else {
				
				return true;
			}
		}
		
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
			
			super.formClick(event);
			
			if (event.target.name == "ok") {
				event.stopImmediatePropagation();
				validateAndSendData();
			}
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param messsage
		 * @param type
		 * 
		 */
		override public function sendMessage(message:String, type:String = MessageType.NONE, textArea:Boolean = false):void {
			
			if (!messageField) {
				
				messageField = new MessageField();
				messageField.maxWidth = this.maxWidth - (2*this.gap);
				messageField.maxHeight = 15 - this.gap;
				messageField.backgroundAlpha = 0;
				messageField.init();
				this.addChild(messageField);
				
				messageField.x = this.gap;
				messageField.y = authorField.y + authorField.height + this.gap - 3;
				
				TweenLite.from(messageField, .3, {alpha:0, delay:.2});
				TweenLite.to(window, .3, {height:window.height + this.messageFieldHeight});
				
			}
			
			messageField.sendMessage(message, type);
		}
		
		/**
		 * 
		 */
		override public function kill():void {
			super.removeProgressBar();
			TweenLite.to(this,.6,{y:0, autoAlpha: 0, delay: .8, onComplete:killView});
		}
		
	}
}