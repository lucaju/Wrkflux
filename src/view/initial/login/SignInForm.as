package view.initial.login {
	
	//imports
	
	import com.greensock.TweenLite;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import controller.WrkfluxController;
	
	import events.WrkfluxEvent;
	
	import font.HelveticaNeue;
	
	import mvc.IController;
	
	import util.Colors;
	import util.MessageType;
	
	import view.assets.buttons.Button;
	import view.forms.AbstractForm;
	import view.forms.MessageField;
	import view.forms.TextFormField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class SignInForm extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var emailField				:TextFormField;
		protected var passField					:TextFormField;
		protected var sendBT					:Button;
		protected var forgotBT					:Button;
		protected var messageField				:MessageField;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function SignInForm(c:IController) {
			super(c);
			this.maxWidth = 200;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			// FIELDS
			//1. Label
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.CONDENSED_BOLD;
			style.color = Colors.getColorByName(Colors.DARK_GREY);
			style.size = 18;
			
			var formLabel:TextField = new TextField();
			formLabel.selectable = false;
			formLabel.embedFonts = true;
			formLabel.antiAliasType = AntiAliasType.ADVANCED;
			formLabel.autoSize = TextFieldAutoSize.LEFT;
			formLabel.text = "Sign In";
			formLabel.setTextFormat(style);
			this.addChild(formLabel);
			
			formLabel.y = gap;
			
			//2. email
			emailField = new TextFormField();
			emailField.maxChars = 30;
			emailField.maxHeight = 35;
			emailField.maxWidth = this.maxWidth - (2*gap);
			emailField.required = true;
			emailField.textPlaceHolder = "email";
			this.addChild(emailField);
			emailField.init("");
			emailField.name = "email";
			
			emailField.x = gap;
			emailField.y = formLabel.y + formLabel.height + gap;
			
			fieldCollection.push(emailField);
			
			//3. password
			passField = new TextFormField();
			passField.maxChars = 30;
			passField.maxHeight = 35;
			passField.maxWidth = this.maxWidth - (2*gap);
			passField.required = true;
			passField.textPlaceHolder = "password";
			passField.displayAsPassword = true;
			this.addChild(passField);
			passField.init("");
			passField.name = "password";
			
			passField.x = gap;
			passField.y = emailField.y + emailField.height + gap;
			
			fieldCollection.push(passField);
			
			//4. Send Button
			sendBT = new Button();
			this.addChild(sendBT);
			sendBT.maxWidth = this.maxWidth - (2*gap);
			sendBT.maxHeight = 35;
			sendBT.color = Colors.getColorByName(Colors.BLUE);
			sendBT.textColor = Colors.getColorByName(Colors.WHITE);
			sendBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			sendBT.init("SIGN IN");
			
			sendBT.x = gap;
			sendBT.y = passField.y + passField.height + gap;
			
			//5. Forgot Button
			forgotBT = new Button();
			this.addChild(forgotBT);
			forgotBT.maxWidth = this.maxWidth - (2*gap);
			forgotBT.maxHeight = 20;
			forgotBT.colorAlpha = 0.1;
			forgotBT.color = Colors.getColorByName(Colors.LIGHT_GREY);
			forgotBT.textSize = 10;
			forgotBT.textAlign = TextFormatAlign.RIGHT;
			forgotBT.textColor = Colors.getColorByName(Colors.DARK_GREY);
			forgotBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			forgotBT.init("Lost your password?");
			
			forgotBT.x = gap;
			forgotBT.y = sendBT.y + sendBT.height;
			
			//window
			this.drawWindow(this.maxWidth, this.height + 5*gap);
			
			formLabel.x = this.window.width/2 - formLabel.width/2;
			
			//listener
			this.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			
		}		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function processFormSubmit(value:String):void {
			switch (value) {
				case "submit":
					validateAndSendData();
					break;
				
				case "forgot":
					var formData:Object = new Object();
					formData.name = "SignInForm";
					formData.action = "forgotPassword";
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, formData));
					break;
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function validateAndSendData():void {
			
			var readyToSend:Boolean = true;
			var failToValidate:Array = new Array();
			
			//remove message field
			if (messageField) {
				this.removeChild(messageField);
				messageField.kill();
				messageField = null;
			}
			
			//collect  data
			var formData:Object = new Object();
			formData.name = "SignInForm";
			formData.action = "submit";
			
			//validation
			for each (var form:TextFormField in fieldCollection) {
				if (fillValidation(form)) {
					formData[form.name.toLowerCase()] = form.getInput();
					form.validationWarning(false);
				} else {
					form.validationWarning(true);
					readyToSend = false;
				}
			}
			
			//send data
			if (readyToSend) {
				WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
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
				if (field.getInput() == "" || field.getInput() == field.textPlaceHolder) {
					return false;
				} else {
					return true;
				}
			}
			
			return true;
		}
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			
			emailField.kill();
			passField.kill();
			sendBT.kill();
			forgotBT.kill();
				
			if (messageField) messageField.kill();
			
			this.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			WrkfluxController(this.getController()).getModel("wrkflux").removeEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
			
			if (this.parent) if (this.parent.contains(this)) this.parent.removeChild(this);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override protected function formClick(event:MouseEvent):void {
			if (event.target == sendBT) {
				event.stopImmediatePropagation();
				processFormSubmit("submit");
			} else if (event.target == forgotBT) {
				event.stopImmediatePropagation();
				processFormSubmit("forgot");
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function keyUp(event:KeyboardEvent):void {
			event.stopImmediatePropagation();
			if (event.charCode == 13) processFormSubmit("submit");
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function formFeedback(event:WrkfluxEvent):void {
			super.removeProgressBar();
			WrkfluxController(this.getController()).getModel("wrkflux").removeEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);	
			if (!event.data.success) sendMessage(event.data.error,MessageType.ERROR);
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
				messageField.y = forgotBT.y + forgotBT.height + this.gap - 5;
				
				TweenLite.from(messageField, .3, {alpha:0, delay:.2});
				
			}
			
			messageField.sendMessage(message, type);
		}
		
		/**
		 * 
		 */
		override public function kill():void {
			super.kill();
			TweenLite.to(this,.6,{y:0, autoAlpha: 0, delay: .8, onComplete:killView});
		}
		
	}
}