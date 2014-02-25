package view.builder {
	
	//imports
	
	import com.greensock.TweenLite;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import controller.WrkBuilderController;
	
	import events.WrkfluxEvent;
	
	import font.HelveticaNeue;
	
	import model.Session;
	
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
	public class TitleForm extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var titleField			:TextFormField;
		protected var authorField			:TextFormField;
		
		protected var sendBT				:Button;
		protected var messageField			:MessageField;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function TitleForm(c:IController) {
			super(c);
			
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
			formLabel.text = "New Workflow";
			formLabel.setTextFormat(style);
			this.addChild(formLabel);
			
			formLabel.y = gap;
			
				
			//2. Title
			titleField = new TextFormField();
			titleField.maxChars = 30;
			titleField.maxHeight = 35;
			titleField.maxWidth = 190;
			titleField.required = true;
			titleField.textPlaceHolder = "title";
			this.addChild(titleField);
			titleField.init("");
			titleField.name = "title";
			
			titleField.x = gap;
			titleField.y = formLabel.y + formLabel.height + gap;
			
			fieldCollection.push(titleField);
			
			//3. Ok Button
			sendBT = new Button();
			this.addChild(sendBT);
			
			sendBT.maxWidth = 190;
			sendBT.maxHeight = 35;
			sendBT.color = Colors.getColorByName(Colors.BLUE);
			sendBT.textColor = Colors.getColorByName(Colors.WHITE);
			sendBT.init("ok");
			
			sendBT.x = gap;
			sendBT.y = titleField.y + titleField.height + gap;
			
			//window
			this.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
			this.windowColor = Colors.getColorByName(Colors.WHITE_ICE);
			this.drawWindow(this.width + gap, this.height + (5*gap));

			formLabel.x = this.window.width/2 - formLabel.width/2;
			
			//.warning
			if (Session.userID == 0) {
				
				style.font = HelveticaNeue.LIGHT;
				style.color = Colors.getColorByName(Colors.DARK_GREY);
				style.align = TextFormatAlign.CENTER;
				style.size = 12;
				style.leading = 2;
				style.letterSpacing = .5;
				
				var warningTF:TextField = new TextField();
				warningTF.selectable = false;
				warningTF.embedFonts = true;
				warningTF.antiAliasType = AntiAliasType.ADVANCED;
				warningTF.autoSize = TextFieldAutoSize.CENTER;
				warningTF.width = 2*this.window.width;
				warningTF.wordWrap = true;
				warningTF.multiline = true;
				warningTF.text = "You are about to create a new Workflow as an anonymous user.\n" +
					"The workflow will be stored in our database, but you will not be able to edit or use it when you close this session.\n" +
					"Please, consider sign up to be able to use, edit or delete your workflows whenver you need.";
				warningTF.setTextFormat(style);
				this.addChild(warningTF);
				
				warningTF.x = -warningTF.width/4;
				warningTF.y = this.window.height + gap;
				
			}
			
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
			validateAndSendData();
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
				messageField = null;
			}
			
			//collect  data
			var formData:Object = new Object();
			formData.name = "TitleForm";
			
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
				WrkBuilderController(this.getController()).getModel("wrkflux").addEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
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
				
			} else {
				
				return true;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			this.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			WrkBuilderController(this.getController()).getModel("wrkflux").removeEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
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
			
			if (event.target == sendBT) {
				event.stopImmediatePropagation();
				processFormSubmit("submit");
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
			WrkBuilderController(this.getController()).getModel("wrkflux").removeEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
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
				messageField.y = sendBT.y + sendBT.height + this.gap - 3;
				
				TweenLite.from(messageField, .3, {alpha:0, delay:.2});
				//TweenLite.to(window, .3, {height:window.height + this.messageFieldHeight});
				
			}
			
			messageField.sendMessage(message, type);
		}
		
		/**
		 * 
		 */
		override public function kill():void {
			super.removeProgressBar();
			TweenLite.to(this,.6,{y:this.y-this.height, autoAlpha: 0, delay: .4, onComplete:killView});
		}
		
	}
}