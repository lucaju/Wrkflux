package view.workflow.structure.steps {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.assets.StepShape;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Step extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id					:int;
		protected var _label				:String;
		protected var labelTF				:TextField;
		protected var _shape				:int;
		protected var shapeSS				:StepShape;
		
		protected var _highlighted			:Boolean;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param abbvr
		 * 
		 */
		public function Step(id:int, abbvr:String, shape:int = 0) {
			
			//initial
			this._id = id
			this._label = abbvr;
			this._shape = shape;
			
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 */
		public function init():void {
			
			//shape
			shapeSS = new StepShape(shape);
			this.addChild(shapeSS);
			
			//label
			var style:TextFormat = new TextFormat();
			style.font = FontFreightSans.MEDIUM;
			style.size = 16;
			style.color = Colors.getColorByName(Colors.WHITE);
			
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.mouseEnabled = false;
			labelTF.autoSize = TextFieldAutoSize.CENTER;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.embedFonts = true;
			
			labelTF.defaultTextFormat = style;
			labelTF.text = this.label;
			
			labelTF.x = - (labelTF.width/2);
			labelTF.y = shapeSS.stripe.y;
			
			this.addChild(labelTF);
			
			//listeners
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeObject(value:DisplayObject):void {
			this.removeChild(value);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		

		/**
		 * 
		 * @param value
		 * 
		 */
		public function highlight(value:Boolean):void {
			if (value && !highlighted) {
				_highlighted = value;
				
				var glow:GlowFilter = new GlowFilter();
				glow.color = 0x999999;
				glow.alpha = 1; 
				glow.blurX = 5; 
				glow.blurY = 5; 
				glow.quality = BitmapFilterQuality.MEDIUM;
				
				shapeSS.filters = [glow];
				
			} else if (!value && highlighted) {
				_highlighted = value;
				shapeSS.filters = [];
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addGlow(value:Boolean):void {
			if (value) {
				
				var glow:GlowFilter = new GlowFilter();
				glow.color = 0x999999;
				glow.alpha = 1; 
				glow.blurX = 5; 
				glow.blurY = 5; 
				glow.quality = BitmapFilterQuality.MEDIUM;
				
				shapeSS.filters = [glow];
				
			} else {
				shapeSS.filters = [];
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPositionForPin():Rectangle {
			var bounds:Rectangle = this.getBounds(this.parent);
			bounds.height = bounds.height - shapeSS.stripe.height;
			return bounds;
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
		 * @param value
		 * 
		 */
		public function set id(value:int):void {
			_id = value;
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
			labelTF.text = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shape():int {
			return _shape;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shape(value:int):void {
			_shape = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get highlighted():Boolean {
			return _highlighted;
		}


	}
}