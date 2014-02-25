package view.forms.list.slider {
	
	//imports
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import font.HelveticaNeue;
	
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
		protected var _maxWidth		:Number;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param label
		 * 
		 */
		public function Item(id:int) {
			_id = id;
			_maxWidth = 140;
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param label
		 * 
		 */
		public function init(label:String):void {
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this._id = id;
			
			//1.shape
			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(Colors.getColorByName(Colors.WHITE),0);
			shape.graphics.drawRect(0,0,_maxWidth,23);
			shape.graphics.endFill();
			
			this.addChild(shape);
			
			//2. Style
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.LIGHT;
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
			
			labelTF.y = -2;
			
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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():Number {
			return _maxWidth;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxWidth(value:Number):void {
			_maxWidth = value;
		}


	}
}