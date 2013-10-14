package view.forms.checkbox {
	
	//imports
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CheckboxItem extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:*;
		protected var _value			:Boolean;
		protected var _label			:String;
		
		protected var bg				:Sprite;
		protected var labelTF			:TextField;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param label
		 * 
		 */
		public function CheckboxItem(id:*, value:Boolean = false, label:String = "") {
			
			//id
			this._id = id;
			this._value = value;
			this._label = label;
			
		}
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//1. Style
			var style:TextFormat = new TextFormat();
			style.font = FontFreightSans.BOOK;
			style.color = Colors.getColorByName(Colors.BLACK);
			style.size = 12;
			style.align = TextFormatAlign.CENTER;
			
			//2. Label
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.embedFonts = true;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.autoSize = TextFieldAutoSize.LEFT;
			labelTF.defaultTextFormat = style;
			
			labelTF.text = label;
			
			this.addChild(labelTF);
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addBackground(color:uint):void {
			
			var bgW:Number = labelTF.x + labelTF.width + labelTF.height/4;
			var bgH:Number = labelTF.height;
			var bgR:Number = labelTF.height/2;
			
			//0. bg
			bg = new Sprite();
			bg.graphics.beginFill(color);
			bg.graphics.drawRoundRect(0,0,bgW,bgH,bgR);
			bg.graphics.endFill();
			this.addChildAt(bg,0);
		}
		
		//****************** GETTER // SETTER ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():* {
			return _id;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get value():Boolean {
			return _value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set value(value:Boolean):void {
			_value = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			_label = value;
		}


	}
}