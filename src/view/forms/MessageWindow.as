package view.forms {
	
	//imports
	import flash.display.Sprite;
	
	import mvc.IController;
	
	import util.Colors;
	import util.MessageType;
	
	import view.forms.AbstractForm;
	import view.forms.MessageField;
	import view.forms.assets.WindowShape;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class MessageWindow extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var itemCollection		:Array;
		protected var messageField			:MessageField;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function MessageWindow(c:IController) {
			super(c);
			this.windowAlpha = .5;
		}
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			itemCollection = new Array();
			
			//window
			this.windowColor = Colors.getColorByName(Colors.WHITE);
			this.drawWindow(maxWidth,maxHeight, WindowShape.RECTANGLE);
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param messsage
		 * @param type
		 * 
		 */
		override public function sendMessage(messsage:String, type:String = MessageType.NONE, textArea:Boolean = false):void {
			
			var posX:Number = this.gap;
			var posY:Number = this.gap;
			
			if (itemCollection.length > 0) {
				
				var lastItem:MessageField = itemCollection[itemCollection.length-1];
				
				//2.1 division
				var line:Sprite = new Sprite();
				line.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
				line.graphics.lineTo(maxWidth,0);
				line.y = lastItem.y + lastItem.height + gap;
				this.addChild(line);
				
				posY = line.y + this.gap;
			}
			
			messageField = new MessageField();
			this.addChild(messageField);
			messageField.x = posX;
			messageField.y = posY;
			messageField.backgroundAlpha = 0;
			messageField.maxWidth = this.maxWidth - (2*posX);
			messageField.maxHeight = this.maxHeight;
			messageField.textArea = textArea;
			messageField.init();
			messageField.sendMessage(messsage, type);
			
			itemCollection.push(messageField);
			
			//resize
			maxWidth = this.width + gap;
			maxHeight = this.height + gap;
			super.resize();
		}
		

		 /**
		  * 
		  * @param messsage
		  * 
		  */
		public function addMessage(messageField:MessageField):void {
			
			var posX:Number = this.gap;
			var posY:Number = this.gap;
			
			if (itemCollection.length > 0) {
				
				var lastItem:MessageField = itemCollection[itemCollection.length-1];
				
				//2.1 division
				var line:Sprite = new Sprite();
				line.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
				line.graphics.lineTo(maxWidth,0);
				line.y = lastItem.y + lastItem.height + gap;
				this.addChild(line);
				
				posY = line.y + this.gap;
			}
			
			this.addChild(messageField);
			messageField.x = posX;
			messageField.y = posY;
			messageField.maxWidth = this.maxWidth - (2*posX);
			messageField.maxHeight = this.maxHeight;
			
			itemCollection.push(messageField);
			
			//resize
			maxWidth = this.width + gap;
			maxHeight = this.height + gap;
			super.resize();
		}
		
	}
}