package view.workflow.flow {
	
	//imports
	
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import mvc.IController;
	
	import util.Colors;
	import util.MessageType;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.buttons.ButtonFactory;
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
		protected var okBT					:AbstractButton;
		protected var cancelBT				:AbstractButton;
		protected var messageField			:MessageField;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function AddForm(c:IController) {
			super(c);
			
			// FIELDS
			content = new Sprite();
			content.x = gap;
			content.y = gap;
			this.addChild(content);
			
			//1. Title
			titleField = new TextFormField();
			titleField.maxChars = 80;
			titleField.maxWidth = 190;
			titleField.required = true;
			content.addChild(titleField);
			titleField.init("title");
			
			fieldCollection.push(titleField);
			
			//2. step
			var stepData:Array = this.getStepData();
			
			stepField = new HorizontalSliderFormField();
			stepField.maxWidth = 190;
			stepField.required = true;
			stepField.data = stepData;
			content.addChild(stepField);
			stepField.init("step");
			
			stepField.y = titleField.y + titleField.height + gap;
			
			fieldCollection.push(stepField);
			
			//3. flag
			var flagData:Array = this.getFlagData();
			
			flagField = new BulletList();
			flagField.maxWidth = 40;
			flagField.data = flagData;
			content.addChild(flagField);
			flagField.init("flag");
			
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
			descriptionField.maxHeight = (descHeight > 60 ) ? descHeight : 60;
			
			descriptionField.init("description");
			
			fieldCollection.push(descriptionField);
			
			//5. cancel Button
			cancelBT = ButtonFactory.getButton((Colors.RED), ButtonFactory.FORM);
			content.addChild(cancelBT);
			cancelBT.maxWidth = 115;
			cancelBT.maxHeight = 35;
			cancelBT.init("cancel");
			
			cancelBT.y = descriptionField.y + descriptionField.height + gap;
			
			fieldCollection.push(cancelBT);
			
			//6. Ok Button
			okBT = ButtonFactory.getButton((Colors.GREEN), ButtonFactory.FORM);
			content.addChild(okBT);
			okBT.maxWidth = 115;
			okBT.maxHeight = 35;
			okBT.init("ok");
			
			okBT.x = cancelBT.x + cancelBT.width + gap;
			okBT.y = descriptionField.y + descriptionField.height + gap;
			
			fieldCollection.push(okBT);
			
			//window
			this.drawWindow(245, this.height + (2*gap));
			
			//listeners
			this.addEventListener(MouseEvent.CLICK, formClick);
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
		 * 
		 */
		protected function validateAndSendData():void {
			
			var readyToSend:Boolean = true;
			var failToValidate:Array = new Array();
			
			//collect  data
			var data:Object = new Object();
			data.action = "addItem";
			
			//title
			if (titleField.getInput() == "") {
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
			
			switch (event.target.name) {
				
				case "cancel":
					var data:Object = {action:"addCanceled"};
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_EVENT, data));
					break;
				
				case "ok":
					validateAndSendData();
					break;
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
				messageField.y = this.gap/2;
				
				var offset:Number = messageField.y + messageField.height + (gap/2);
				
				TweenLite.from(messageField, .3, {alpha:0, delay:.2});
				TweenLite.to(content, .3, {y:content.y + offset});
				TweenLite.to(window, .3, {height:window.height + offset})
				TweenLite.to(this, .3, {y:this.y - offset})
				
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