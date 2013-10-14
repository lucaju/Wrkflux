package view.forms.list.slider {
	
	//imports
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Item extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id 			:int;
		protected var labelTF		:TextField
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param label
		 * 
		 */
		public function Item(id:int, label:String) {
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this._id = id;
			
			//1.shape
			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(0xFFFFFF,0);
			shape.graphics.drawRect(0,0,190,23);
			shape.graphics.endFill();
			
			this.addChild(shape);
			
			//2. Style
			var style:TextFormat = new TextFormat();
			style.font = FontFreightSans.BOOK;
			style.color = Colors.getColorByName(Colors.BLACK);
			style.size = 16;
			style.align = TextFormatAlign.CENTER;
			
			//3. input
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.embedFonts = true;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.name = label;
			labelTF.width = shape.width;
			labelTF.height = shape.height;
			
			labelTF.defaultTextFormat = style;
			
			labelTF.text = label;
			
			this.addChild(labelTF);
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return labelTF.text;
		}
		
		//****************** GETTER // SETTER ****************** ****************** ******************

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