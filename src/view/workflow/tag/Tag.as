package view.workflow.tag {
	
	//imports
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Tag extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _tempUID			:String;
		protected var _uid				:int;
		protected var _label			:String;
		
		protected var shape				:Sprite;
		protected var textTF			:TextField;
		protected var style				:TextFormat;
		
		
		//****************** Properties ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @param label
		 * 
		 */
		public function Tag(uid:int, label:String = "") {
			//initial
			this._uid = uid;
			
			if (label == "") {
				this._label = "Add Tag";
			} else {
				this._label = label;
			}	
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//text
			style = new TextFormat();
			style.font = FontFreightSans.MEDIUM;
			style.color = Colors.getColorByName(Colors.BLACK);
			style.size = 13;
			
			textTF = new TextField();
			textTF.selectable = false;
			textTF.embedFonts = true;
			textTF.antiAliasType = AntiAliasType.ADVANCED;
			textTF.autoSize = TextFieldAutoSize.LEFT;
			textTF.type = TextFieldType.INPUT;
			textTF.defaultTextFormat = style;
			
			textTF.text = this.label;
			
			this.addChild(textTF);
			
			//tab
			var tab:Sprite = new Sprite();
			tab.mouseEnabled = false;
			tab.graphics.beginFill(Colors.getColorByName(Colors.DARK_GREY));
			//tab.graphics.drawRoundRectComplex(0,0,textTF.height/2,textTF.height,textTF.height/4,0,textTF.height/4,0);
			tab.graphics.drawRoundRect(0,0,textTF.height/2,textTF.height,textTF.height/4);
			tab.graphics.endFill();
			
			this.addChildAt(tab,0);
			
			//shape
			shape = new Sprite();
			shape.mouseEnabled = false;
			shape.x = tab.width;
			shape.graphics.beginFill(Colors.getColorByName(Colors.WHITE));
			shape.graphics.drawRect(0,0,textTF.width+textTF.height/4,textTF.height);
			shape.graphics.endFill();
			
			this.addChildAt(shape,0);
			
			textTF.x = tab.width;
			
			//glow
			var glow:GlowFilter = new GlowFilter();
			glow.color = Colors.getColorByName(Colors.BLACK);
			glow.alpha = .3;
			glow.blurX = 5;
			glow.blurY = 5;
			glow.quality = BitmapFilterQuality.MEDIUM;
			
			this.filters=[glow];
			
		}

		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get uid():int {
			return _uid;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set uid(value:int):void {
			_uid = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tempUID():String {
			return _tempUID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tempUID(value:String):void {
			_tempUID = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		
	}
}