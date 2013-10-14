package view.assets.buttons {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.FontFolio;
	
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
			
			this.addChild(shape);
			
			//2.Label
			var style:TextFormat = new TextFormat();
			style.font = FontFolio.BOLD_CONDENSED;
			style.bold = true;
			style.size = 16;
			style.color = 0xFFFFFF;
			
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.autoSize = TextFieldAutoSize.LEFT;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.embedFonts = true;
			labelTF.text = labelString;
			labelTF.setTextFormat(style);
			
			labelTF.x = (shape.width/2) - (labelTF.width/2);
			labelTF.y = (shape.height/2) - (labelTF.height/2);
			
			this.addChild(labelTF);
			
			
			//Interaction
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOver(event:MouseEvent):void {
			TweenMax.to(shape,.4,{alpha:.8});
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOut(event:MouseEvent):void {
			TweenMax.to(shape,.6,{alpha:1});
		}	
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		override public function getLabel():String {
			return labelTF.text;
		}
		
	}
}