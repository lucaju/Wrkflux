package view.initial.profile {
	
	//imports
	
	import com.greensock.TweenLite;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import controller.WrkfluxController;
	
	import events.WrkfluxEvent;
	
	import font.HelveticaNeue;
	
	import model.Session;
	
	import mvc.IController;
	
	import settings.Settings;
	
	import util.Colors;
	import util.MessageType;
	
	import view.assets.buttons.Button;
	import view.forms.AbstractForm;
	import view.forms.AbstractFormField;
	import view.forms.MessageField;
	import view.forms.TextFormField;
	import view.forms.image.ImageField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class EditProfileScreen extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var firstNameField			:TextFormField;
		protected var lastNameField				:TextFormField;
		protected var emailField				:TextFormField;
		protected var passField					:TextFormField;
		protected var imageField				:ImageField;
		protected var sendBT					:Button;
		protected var closeBT					:Button;
		protected var messageField				:MessageField;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function EditProfileScreen(c:IController) {
			super(c);	
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
			formLabel.text = "Edit Profile";
			formLabel.setTextFormat(style);
			this.addChild(formLabel);
			
			formLabel.y = gap;
			
			//2. First Name
			firstNameField = new TextFormField();
			firstNameField.maxChars = 30;
			firstNameField.maxHeight = 35;
			firstNameField.maxWidth = 190;
			firstNameField.required = false;
			firstNameField.text = Session.userFirstName;
			this.addChild(firstNameField);
			firstNameField.init("");
			firstNameField.name = "firstName";
			
			firstNameField.x = gap;
			firstNameField.y = formLabel.y + formLabel.height + gap;
			
			fieldCollection.push(firstNameField);
			
			//3. Last Name
			lastNameField = new TextFormField();
			lastNameField.maxChars = 30;
			lastNameField.maxHeight = 35;
			lastNameField.maxWidth = 190;
			lastNameField.required = false;
			lastNameField.text = Session.userLastName;
			this.addChild(lastNameField);
			lastNameField.init("");
			lastNameField.name = "lastName";
			
			lastNameField.x = firstNameField.x + firstNameField.width + gap;;
			lastNameField.y = formLabel.y + formLabel.height + gap;
			
			fieldCollection.push(lastNameField);
			
			//4. Email
			emailField = new TextFormField();
			emailField.selectable = false;
			emailField.maxChars = 30;
			emailField.maxHeight = 35;
			emailField.maxWidth = 190;
			emailField.required = false;
			emailField.textPlaceHolder = Session.userEmail;
			this.addChild(emailField);
			emailField.init("");
			emailField.name = "email";
			
			emailField.x = gap;
			emailField.y = lastNameField.y + lastNameField.height + gap;
			
			fieldCollection.push(emailField);
			
			//5. password
			passField = new TextFormField();
			passField.maxChars = 30;
			passField.maxHeight = 35;
			passField.maxWidth = 190;
			passField.required = false;
			passField.textPlaceHolder = "new password";
			passField.displayAsPassword = true;
			this.addChild(passField);
			passField.init("");
			passField.name = "password";
			
			passField.x = emailField.x + emailField.width + gap;
			passField.y = emailField.y;
			
			fieldCollection.push(passField);
			
			//6. Image
			imageField = new ImageField();
			imageField.maxHeight = 75;
			imageField.maxWidth = 75;
			imageField.required = false;
			this.addChild(imageField);
			imageField.init("Add Photo");
			imageField.name = "image";
			
			imageField.x = lastNameField.x + lastNameField.width + gap;
			imageField.y = lastNameField.y;
			
			imageField.addEventListener(WrkfluxEvent.FORM_EVENT, imageEvent);
			
			fieldCollection.push(imageField);
			
			//7. Ok Button
			sendBT = new Button();
			this.addChild(sendBT);
			sendBT.color = Colors.getColorByName(Colors.GREEN);
			sendBT.textColor = Colors.getColorByName(Colors.WHITE);
			sendBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			sendBT.maxWidth = 190;
			sendBT.maxHeight = 35;
			sendBT.init("Update");
			
			sendBT.x = gap;
			sendBT.y = passField.y + passField.height + gap;
			
			//8. Close Button
			closeBT = new Button();
			this.addChild(closeBT);
			closeBT.color = Colors.getColorByName(Colors.YELLOW);
			closeBT.textColor = Colors.getColorByName(Colors.WHITE);
			closeBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			closeBT.maxWidth = 190;
			closeBT.maxHeight = 35;
			closeBT.init("Close");
			
			closeBT.x = sendBT.x + sendBT.width + gap;
			closeBT.y = passField.y + passField.height + gap;
			
			//window
			this.drawWindow(this.width + 2*gap, this.height + 5*gap);
			
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
			
			// check if there is a new profile picture. (1) no, go direct to test forms, (2) pic removed, update with the form (3) new pic, uploade and updat pic first.
			switch (imageField.getInput()) {
				case null:
					validateAndSendData();
					break;
					
				case "":
					validateAndSendData();
					break;
				
				default:
					imageField.uploadImage()
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
			formData.name = "updateProfile";
			
			//validation
			for each (var form:AbstractFormField in fieldCollection) {
				
				if (fillValidation(form)) {
					
					if (form.name.toLowerCase() == "firstname") if (form.getInput() != Session.userFirstName) formData[form.name.toLowerCase()] = form.getInput();
					if (form.name.toLowerCase() == "lastname") if (form.getInput() != Session.userLastName) formData[form.name.toLowerCase()] = form.getInput();
					if (form.name.toLowerCase() == "email") if (form.getInput() != form.textPlaceHolder) formData[form.name.toLowerCase()] = form.getInput();
					if (form.name.toLowerCase() == "password") if (form.getInput() != form.textPlaceHolder) formData[form.name.toLowerCase()] = form.getInput();
					
					if (form.name.toLowerCase() == "image") {
						if (imageField.hasNewImage) {
							formData[form.name.toLowerCase()] = form.getInput();
						} else {
							if (imageField.isRemovingImage) formData[form.name.toLowerCase()] = "remove";
						}	
					}
					
					//if (form.getInput() != form.textPlaceHolder) formData[form.name.toLocaleLowerCase()] = form.getInput();
					
					
					form.validationWarning(false);
				
				} else {
					form.validationWarning(true);
					readyToSend = false;
				}
			}
			
			//send data
			if (readyToSend) {
				
				if (!formData.firstname && !formData.lastname && !formData.password && !formData.image) {
					if (Settings.debug) trace ("Nothing to send");
				} else {
					WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, formData));
					super.addProgressBar();
				}
				
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
		protected function fillValidation(field:AbstractFormField):Boolean {
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
			
			firstNameField.kill();
			lastNameField.kill();
			emailField.kill();
			passField.kill();
			sendBT.kill();
			
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
		protected function imageEvent(event:WrkfluxEvent):void {
			switch (event.data.success) {
				case true:
					if (event.data.successType == "file chosen") if (messageField)  messageField.kill();
					if (event.data.successType == "file uploaded") validateAndSendData();
					break;
				
				case false:
					if (event.data.errorType == "warning") sendMessage(event.data.errorMessage,MessageType.WARNING);
					if (event.data.errorType == "error") sendMessage(event.data.errorMessage,MessageType.ERROR);
					break;
			}
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		override protected function formClick(event:MouseEvent):void {
			switch (event.target) {
				
				case sendBT:
					event.stopImmediatePropagation();
					processFormSubmit("submit");
					break;
				
				case closeBT:
					var data:Object = new Object();
					data.name = "updateProfileClose";
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, data));
					break;
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
			
			if (!event.data.success) {
				var message:String = "An error occurred.";
				if (event.data.errno == 1062) message = "This email was already registered.";
				sendMessage(message,MessageType.ERROR);
			} else {
				
				//change imageField's Label
				if (event.data.profileImage == "remove") {
					imageField.updateState("image removed");
				} else {
					imageField.updateState("image added");
				}
				
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
				messageField.y = sendBT.y + sendBT.height + this.gap - 5;
				
				TweenLite.from(messageField, .3, {alpha:0, delay:.2});
				
			}
			
			messageField.sendMessage(message, type);
		}
		
		/**
		 * 
		 * 
		 */
		public function updated():void {
			super.removeProgressBar();
		}
	
		
		/**
		 * 
		 */
		override public function kill():void {
			super.kill();
			imageField.removeEventListener(WrkfluxEvent.FORM_EVENT, imageEvent);
			this.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			TweenLite.to(this,.6,{y:0, autoAlpha: 0, delay: .8, onComplete:killView});
		}
		
	}	
}

