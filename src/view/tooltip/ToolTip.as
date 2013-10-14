package view.tooltip {
	
	//
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import font.FontFreightSans;
	
	import util.Colors;
	import util.Directions;
	
	import view.assets.Balloon;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ToolTip extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var _id						:int;						//Holds ToolTip Id
		protected var _sourceId					:int;						//Holds Source Id
		protected var _source					:Sprite
		
		protected var gap						:Number;					// Margin size
		protected var _arrowDirection			:String;					// Arrow point direction
		
		protected var _balloonColor				:uint;						//Balloon Color
		protected var _balloonAlpha				:Number;					//Balloon Alpha
		protected var _textColor				:uint;						//Text Color
		
		protected var balloon					:Balloon;
		protected var textTF					:TextField;
		protected var style						:TextFormat;
		protected var _fontSize					:uint;
		
		
		//****************** Properties ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param id_
		 * 
		 */
		public function ToolTip(id_:int = 0) {
			_id = id_;
			
			gap = 5;
			_arrowDirection = Directions.BOTTOM;
			
			_balloonColor = Colors.getColorByName(Colors.WHITE);
			_balloonAlpha = 1;
			_textColor = Colors.getColorByName(Colors.BLACK);
			
		}
			
		//****************** INITIALIZE ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param data
		 * @param orientation_
		 * 
		 */
		public function init(data:Object, orientation:String = Directions.BOTTOM):void {
			
			source = data.source;
			
			this._arrowDirection = orientation;
			if (data.id) _sourceId = data.id;
		
			//style
			style = new TextFormat();
			style.font = FontFreightSans.BOOK;
			style.size = _fontSize;
			style.bold = true;
			style.color = _textColor;
			style.align = TextFormatAlign.CENTER;
			
			//title
			textTF = new TextField();
			textTF.selectable = false;
			textTF.antiAliasType = AntiAliasType.ADVANCED;
			textTF.embedFonts = true;
			textTF.multiline = true;
			textTF.mouseWheelEnabled = false;
			textTF.mouseEnabled = false;
			textTF.wordWrap = true;
			textTF.autoSize = TextFieldAutoSize.LEFT;
			
			textTF.text = data.info;
			
			textTF.setTextFormat(style);
			
			addChild(textTF);
			
			//shape
			balloon = new Balloon();
			balloon.arrowWidth = 15;
			balloon.lineColor = Colors.getColorByName(Colors.WHITE);
			balloon.color = balloonColor;
			balloon.alpha = balloonAlpha;
			balloon.arrowDirection = arrowDirection;
			balloon.init(this.width + (2*gap), this.height);
			
			this.addChildAt(balloon,0);
			
			//elements Position
			balloon.x = -(balloon.width/2) + gap;
			balloon.y = -balloon.height;
			
			var balloonBound:Rectangle = balloon.getBounds(balloon.parent);
			textTF.x = balloon.x + (balloon.width/2) - (textTF.width/2);
			textTF.y = balloonBound.y;
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = Colors.getColorByName(Colors.BLACK);
			glow.alpha = .3;
			glow.blurX = 5;
			glow.blurY = 5;
			glow.quality = BitmapFilterQuality.MEDIUM;
			
			balloon.filters=[glow];
			
		}
	
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param offset
		 * 
		 */
		public function arrowOffsetX(offset:Number):void {
			balloon.arrowOffsetX(offset);
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
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
		public function get source():Sprite {
			return _source;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set source(value:Sprite):void {
			_source = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get sourceId():int {	
			return _sourceId;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrowDirection():String {
			return _arrowDirection;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function set arrowDirection(value:String):void {
			_arrowDirection = value;
			balloon.changeArrowOrientation(value);
			
			textTF.y = balloon.y + balloon.y + (balloon.height/2) - (textTF.height/2);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get balloonColor():uint {
			return _balloonColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set balloonColor(value:uint):void{
			_balloonColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get balloonAlpha():Number {
			return _balloonAlpha;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set balloonAlpha(value:Number):void {
			_balloonAlpha = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get textColor():uint {
			return _textColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textColor(value:uint):void {
			_textColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set fontSize(value:uint):void {
			_fontSize = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get fontSize():uint {
			return _fontSize;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set TFWidth(value:Number):void {
			textTF.width = value;
		}

	}
}