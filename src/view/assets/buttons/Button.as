package view.assets.buttons {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import font.HelveticaNeue;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Button extends AbstractButton {
		
		//****************** Properties ****************** ****************** ******************
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Button() {
			super();
		}
		
		/**
		 * 
		 * @param labelString
		 * @param color
		 * 
		 */
		override public function init(labelString:String):void {
			
			this.name = labelString;
			
			//1. Shape
			shape = new Sprite();
			if (this.line) shape.graphics.lineStyle(this.lineThickness,this.lineColor,this.lineColorAlpha,true);
			shape.graphics.beginFill(this.color,this.colorAlpha);
			
			if (this.shapeForm == ButtonShapeForm.RECT) {
				shape.graphics.drawRect(0,0,this.maxWidth,this.maxHeight);
			} else {
				shape.graphics.drawRoundRect(0,0,this.maxWidth,this.maxHeight,10);
			}
			shape.graphics.endFill();
			
			shape.alpha = this.shapeAlpha;
			
			this.addChild(shape);
			
			//2.Label
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.CONDENSED_BOLD;
			style.align = this.textAlign;
			style.size = this.textSize;
			style.color = this.textColor;
			
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.autoSize = TextFieldAutoSize.LEFT;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.embedFonts = true;
			labelTF.text = labelString;
			labelTF.setTextFormat(style);
			
			switch (this.textAlign) {
				
				case TextFormatAlign.LEFT:
					labelTF.x = 5;
					break;
				
				case TextFormatAlign.CENTER:
					labelTF.x = (shape.width/2) - (labelTF.width/2);
					break;
				
				case TextFormatAlign.RIGHT:
					labelTF.x = shape.width - labelTF.width - 5;
					break;
			}
			
			
			labelTF.y = (shape.height/2) - (labelTF.height/2);
			
			this.addChild(labelTF);
			
			
			//Interaction
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function changeColor():void {
			
			shape.graphics.clear();
			
			if (this.line) shape.graphics.lineStyle(this.lineThickness,this.lineColor,this.lineColorAlpha,true);
			
			if (this.toggle) {
				shape.graphics.beginFill(this.toggleColor,this.toggleColorAlpha);
				shape.alpha = this.toggleAlpha;
			} else {
				shape.graphics.beginFill(this.color,this.colorAlpha);
				shape.alpha = this.shapeAlpha;
			}
			
			
			if (this.shapeForm == ButtonShapeForm.RECT) {
				shape.graphics.drawRect(0,0,this.maxWidth,this.maxHeight);
			} else {
				shape.graphics.drawRoundRect(0,0,this.maxWidth,this.maxHeight,10);
			}
			
			shape.graphics.endFill();
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOver(event:MouseEvent):void {
			
			if (!this.toggle) {
				shape.alpha = this.toggleAlpha;
				TweenMax.to(shape,.4,{colorTransform:{tint:this.toggleColor, tintAmount:0.3}});
			} else {
				TweenMax.to(shape,.4,{colorTransform:{tint:this.color, tintAmount:0.3}});
			}
			
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOut(event:MouseEvent):void {
			if (this.toggle) {
				shape.alpha = this.toggleAlpha;
			} else {
				shape.alpha = this.shapeAlpha;
			}
			
			TweenMax.to(shape,.4,{removeTint:true});
		}	
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		override public function getLabel():String {
			return labelTF.text;
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		
		//****************** GETTERS AND SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		override public function set toggle(value:Boolean):void {
			if (this.togglable) {
				super.toggle = value;
				if (shape) changeColor();	
			}
		}
		
	}
}