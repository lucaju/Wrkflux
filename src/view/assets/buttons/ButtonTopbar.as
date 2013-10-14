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
	public class ButtonTopbar extends AbstractButton {
		
		//****************** Properties ****************** ****************** ******************
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ButtonTopbar() {			
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
			
			//1.Label
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
			
			
			this.addChild(labelTF);
			
			//2. Shape
			shape = new Sprite();
			if (this.line) shape.graphics.lineStyle(this.lineThickness,this.lineColor,this.lineColorAlpha,true);
			shape.graphics.beginFill(this.color,this.colorAlpha);
			shape.graphics.drawRect(0,0,labelTF.width + 10,20);
			shape.graphics.endFill();
			
			this.addChildAt(shape,0);
			
			//align
			labelTF.x = (shape.width/2) - (labelTF.width/2);
			labelTF.y = (shape.height/2) - (labelTF.height/2);
			
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
			TweenMax.to(shape,.4,{alpha:.5});
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

