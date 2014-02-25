package view.forms {
	
	//imports
	import com.greensock.TweenMax;
	
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
		protected var container				:Sprite;
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
			this.windowShape = WindowShape.RECTANGLE;
			this.windowColor = Colors.getColorByName(Colors.WHITE);
			
		}
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			itemCollection = new Array();
			
			//window
			this.drawWindow(this.maxWidth,this.maxHeight, this.windowShape);
			
			container = new Sprite();
			container.x = gap;
			container.y = gap;
			this.addChild(container);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function killMessage():void {
			if (itemCollection.length > 0) {
				var messageField:Sprite = itemCollection.shift();
				if (container.contains(messageField)) container.removeChild(messageField);
			}
			
			if (itemCollection.length > 0) {
				
				var posY:Number = 0;
				
				for each (messageField in itemCollection) {
					if (itemCollection.indexOf(messageField) == itemCollection.length-1){
						TweenMax.to(messageField,.6,{y: posY, onUpdate:resize});
					} else {
						TweenMax.to(messageField,.6,{y: posY});
					}
					posY += messageField.height + gap;
				}
			} else {
				maxHeight = 0;
				maxWidth = this.width
				TweenMax.to(this.window,.6,{height: maxHeight});
			}
			
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param messsage
		 * @param type
		 * @param textArea
		 * 
		 */
		override public function sendMessage(messsage:String, type:String = MessageType.NONE, textArea:Boolean = false):void {
			
			messageField = new MessageField();
			
			container.addChild(messageField);
			
			messageField.backgroundAlpha = 0;
			messageField.maxWidth = this.maxWidth - gap;
			messageField.textArea = textArea;
			messageField.init();
			messageField.sendMessage(messsage, type);
			
			itemCollection.push(messageField);
			
			if (itemCollection.length > 1) {
				
				//2.1 division
				var lastItem:MessageField = itemCollection[itemCollection.length-2];
				
				var line:Sprite = new Sprite();
				line.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
				line.graphics.lineTo(maxWidth - (2*this.gap),0);
				line.y = lastItem.height + gap;
				lastItem.addChild(line);
				
				//position
				messageField.y = lastItem.y + lastItem.height + gap;
			}
			
			
			//resize
			this.resize();
			
			TweenMax.to(messageField,1,{autoAlpha: 0, delay:3.6, onComplete:killMessage});
			
		}
		
		/**
		 * 
		 * 
		 */
		override public function resize():void {
			maxWidth = this.width;
			maxHeight = itemCollection[itemCollection.length-1].y + itemCollection[itemCollection.length-1].height + (2*gap);
			super.resize();
		}

		 /**
		  * 
		  * @param messsage
		  * 
		  */
		public function addMessage(messageField:MessageField):void {
			
			container.addChild(messageField);
			itemCollection.push(messageField);
			
			if (itemCollection.length > 1) {
				
				//2.1 division
				var lastItem:MessageField = itemCollection[itemCollection.length-2];
				
				var line:Sprite = new Sprite();
				line.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
				line.graphics.lineTo(maxWidth - (2*this.gap),0);
				line.y = lastItem.height + gap;
				lastItem.addChild(line);
				
				//position
				messageField.y = lastItem.y + lastItem.height + gap;
			}
			
			
			//resize
			this.resize();
			
			TweenMax.to(messageField,1,{autoAlpha: 0, delay:3.6, onComplete:killMessage});
			
		}
		
	}
}