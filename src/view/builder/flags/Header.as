package view.builder.flags {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.HelveticaNeue;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Header extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function Header(label:String = " ") {
			
			//background
			var bg:Shape = new Shape();
			bg.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY));
			bg.graphics.drawRect(0, 0, 110, 25);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//title
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.MEDIUM;
			style.size = 14;
			style.color = Colors.getColorByName(Colors.WHITE);
			
			var titleTF:TextField = new TextField();
			titleTF.selectable = false;
			titleTF.autoSize = TextFieldAutoSize.LEFT;
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.embedFonts = true;
			titleTF.text = label;
			titleTF.setTextFormat(style);
			
			titleTF.x = (bg.width/2) - (titleTF.width/2);
			titleTF.y = (bg.height/2) - (titleTF.height/2);
			
			this.addChild(titleTF);
			
		}
	}
}