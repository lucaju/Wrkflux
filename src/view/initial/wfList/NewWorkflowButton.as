package view.initial.wfList {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.HelveticaNeue;
	
	import util.Colors;
	
	import view.assets.graphics.Cross;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class NewWorkflowButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int = 0;
		
		protected var shape				:Sprite;
		protected var titleTF			:TextField;
		protected var plus				:Cross;
		
		protected var currentWidth		:Number = 240;
		protected var currentHeight		:Number = 50;
		
		//****************** Properties ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function NewWorkflowButton() {
			
			//shape
			shape = new Sprite();
			shape.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
			shape.graphics.beginFill(Colors.getColorByName(Colors.GREEN));
			shape.graphics.drawRoundRect(0,0,currentWidth,currentHeight,4);
			shape.graphics.endFill();
			this.addChildAt(shape,0);
			
			//Plus
			plus = new Cross(21);
			plus.x = 25;
			plus.y = shape.height/2 - 1;
			plus.alpha = .8;
			this.addChild(plus);
			
			//title
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.CONDENSED_BOLD;
			style.size = 18;
			style.color = Colors.getColorByName(Colors.WHITE);
			
			titleTF =  new TextField();
			titleTF.selectable = false;
			titleTF.mouseEnabled = false;
			titleTF.embedFonts = true;
			titleTF.autoSize = TextFieldAutoSize.RIGHT;
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			
			titleTF.text = "Add New Workflow";
			titleTF.setTextFormat(style);
			
			titleTF.alpha = .8;
			titleTF.x = 50;
			titleTF.y = shape.height/2 - titleTF.height/2;
			
			this.addChild(titleTF)
				
			//4. interaction
			this.buttonMode = true;
			this.mouseChildren = false;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOver(event:MouseEvent):void {
			TweenMax.to(plus,.4,{alpha:.5, scaleX:1.5, scaleY:1.5, ease:Back.easeOut});
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOut(event:MouseEvent):void {
			TweenMax.to(plus,.6,{alpha:.8, scaleX:1, scaleY:1, ease:Back.easeOut});
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouseOut);
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
	}
}