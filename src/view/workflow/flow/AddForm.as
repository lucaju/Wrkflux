package view.workflow.flow {
	
	//imports
	
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import font.HelveticaNeue;
	
	import mvc.IController;
	
	import util.Colors;
	import util.MessageType;
	
	import view.assets.buttons.Button;
	import view.forms.AbstractForm;
	import view.forms.MessageField;
	import view.forms.TextFormField;
	import view.forms.list.bullet.BulletList;
	import view.forms.list.slider.HorizontalSliderFormField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AddForm extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var content				:Sprite;
		
		protected var titleField			:TextFormField;
		protected var stepField				:HorizontalSliderFormField;
		protected var descriptionField		:TextFormField;
		protected var flagField				:BulletList;
		protected var sendBT				:Button;
		protected var cancelBT				:Button;
		protected var messageField			:MessageField;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function AddForm(c:IController) {
			super(c);
			
			this.maxWidth = 245;
			this.maxHeight = 150;
		}
			
			
		//****************** INITIALIZE ****************** ****************** ******************
			
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			
			
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
			formLabel.text = "Add";
			formLabel.setTextFormat(style);
			this.addChild(formLabel);
			
			formLabel.x = this.maxWidth/2 - formLabel.width/2;
			formLabel.y = gap;
			
			// FIELDS
			content = new Sprite();
			content.x = gap;
			content.y = formLabel.y + formLabel.height + gap;
			this.addChild(content);
			
			//1. Title
			titleField = new TextFormField();
			titleField.maxChars = 80;
			titleField.maxWidth = 190;
			titleField.required = true;
			titleField.maxHeight = 35;
			titleField.textPlaceHolder = "title";
			content.addChild(titleField);
			titleField.init("");
			titleField.name = "title";
			
			fieldCollection.push(titleField);
			
			//2. step
			var stepData:Array = this.getStepData();
			
			stepField = new HorizontalSliderFormField();
			stepField.maxWidth = 190;
			stepField.maxHeight = 35;
			stepField.required = true;
			stepField.data = stepData;
			content.addChild(stepField);
			stepField.init("");
			stepField.name = "step";
			
			stepField.y = titleField.y + titleField.height + gap;
			
			fieldCollection.push(stepField);
			
			//3. flag
			var flagData:Array = this.getFlagData();
			
			flagField = new BulletList();
			flagField.maxWidth = 40;
			flagField.data = flagData;
			content.addChild(flagField);
			flagField.init("");
			flagField.name = "flag";
			
			//size height
			if (flagField.maxHeight < 140) {
				flagField.maxHeight = 140;
				flagField.resize();
			}
			
			flagField.x = titleField.x + titleField.width + gap;
			
			fieldCollection.push(flagField);
			
			//4. description
			descriptionField = new TextFormField();
			descriptionField.maxWidth = 190;
			descriptionField.textArea = true;

			content.addChild(descriptionField);
			
			descriptionField.y = stepField.y + stepField.height + gap;
			
			var descHeight:Number = flagField.height - descriptionField.y;
			descriptionField.maxHeight = (descHeight > 60 ) ? descHeight : 54;
			descriptionField.textPlaceHolder = "description";
			descriptionField.init("");
			descriptionField.name = "description";
			
			fieldCollection.push(descriptionField);
			
			//5. cancel Button
			cancelBT = new Button();
			content.addChild(cancelBT);
			cancelBT.color = Colors.getColorByName(Colors.RED);
			cancelBT.textColor = Colors.getColorByName(Colors.WHITE);
			cancelBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			cancelBT.maxWidth = 115;
			cancelBT.maxHeight = 35;
			cancelBT.init("Cancel");
			
			cancelBT.y = descriptionField.y + descriptionField.height + gap;
			
			fieldCollection.push(cancelBT);
			
			//6. Ok Button
			sendBT = new Button();
			content.addChild(sendBT);
			sendBT.maxWidth = 115;
			sendBT.maxHeight = 35;
			sendBT.color = Colors.getColorByName(Colors.GREEN);
			sendBT.textColor = Colors.getColorByName(Colors.WHITE);
			sendBT.toggleColor = Colors.getColorByName(Colors.DARK_GREY);
			sendBT.init("Send");
			sendBT.x = cancelBT.x + cancelBT.width + gap;
			sendBT.y = cancelBT.y;
			
			fieldCollection.push(sendBT);
			
			//window
			this.windowGlow = true;
			this.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
			this.windowColor = Colors.getColorByName(Colors.WHITE_ICE);
			this.drawWindow(maxWidth, this.height + (2*gap));
			this.maxHeight = this.window.height;
			
			//listeners
			this.addEventListener(MouseEvent.CLICK, formClick);
			this.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function getFlagData():Array {
			
			var flagData:Array = WrkFlowController(this.getController()).getFlags();
			var adaptFlagsData:Array = new Array();
			var bulletObject:Object;
			
			for each (var flagObject:Object in flagData) {
				
				bulletObject = new Object();
				bulletObject.id = flagObject.uid;
				bulletObject.color = flagObject.color;
				bulletObject.label = flagObject.title;
				
				adaptFlagsData.push(bulletObject);
			}
			
			flagData = null;
			
			return adaptFlagsData;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function getStepData():Array {
			
			var stepData:Array = WrkFlowController(this.getController()).getSteps();
			var adaptStepData:Array = new Array();
			var listObject:Object;
			
			for each (var stepObject:Object in stepData) {
				listObject = new Object();
				listObject.id = stepObject.uid;
				listObject.label = stepObject.title;
				adaptStepData.push(listObject);
			}
			
			stepData = null;
			
			return adaptStepData;
		}
		
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
				
				case "cancel":
					var data:Object = {action:"addCanceled"};
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, data))
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
				messageField = null;
			}
			
			//collect  data
			var data:Object = new Object();
			data.action = "addItem";
			
			//title
			if (titleField.getInput() == "" || titleField.getInput() == titleField.textPlaceHolder) {
				readyToSend = false;
				titleField.validationWarning(true);
			} else {
				data.title = titleField.getInput();
			}
			
			//flag
			data.flagID = flagField.getSelectedID();
			
			//step
			data.stepID = stepField.getSelectedOption();
			
			//description
			if (descriptionField.getInput() != "") data.description = descriptionField.getInput();
			
			//send data
			if (readyToSend) {
				//WrkFlowController(this.getController()).getModel("Wrkflow").addEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
				super.addProgressBar();
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, data));
			} else {
				sendMessage("Please fill all required fields.",MessageType.WARNING);
				super.removeProgressBar();
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			this.addEventListener(MouseEvent.CLICK, formClick);
			this.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
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
			
			switch (event.target.name.toLowerCase()) {
				
				case "cancel":
					processFormSubmit("cancel");
					break;
				
				case "send":
					processFormSubmit("submit");
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
			super.kill();
			//WrkFlowController(this.getController()).getModel("Wrkflow").removeEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);	
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
				messageField.y = content.y + content.height + this.gap - 5;
				
				TweenLite.from(messageField, .3, {alpha:0, delay:.2});
				
			}
			
			messageField.sendMessage(message, type);
		}
		
		/**
		 * 
		 */
		override public function kill():void {
			super.kill();
			
			if (sendBT) sendBT.kill();
			if (cancelBT) cancelBT.kill(); 
			if (flagField) flagField.kill();
			if (stepField) stepField.kill();
			
			this.removeEventListener(MouseEvent.CLICK, formClick);
			//WrkFlowController(this.getController()).getModel("Wrkflow").removeEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
			
			TweenLite.to(this,.6,{y:0, autoAlpha: 0, delay: .8, onComplete:killView});
		}
		
	}
}