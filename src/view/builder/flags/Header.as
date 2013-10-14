package view.builder.flags {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.FontFolio;
	import font.FontFreightSans;
	
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
			bg.graphics.drawRect(0, 0, 100, 25);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//title
			var style:TextFormat = new TextFormat();
			style.font = FontFreightSans.MEDIUM;
			style.bold = true;
			style.size = 16;
			style.color = 0xFFFFFF;
			
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