package view.forms {
	
	//imports
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	import util.Directions;
	import util.MessageType;
	
	import view.assets.Balloon;
	import view.forms.assets.AbstractWindow;
	import view.forms.assets.RectBox;
	import view.forms.assets.RoundBox;
	import view.forms.assets.WindowShape;
	import view.util.progressBar.ProgressBar;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractForm extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var window					:AbstractWindow;
		protected var gap						:Number	= 5;
		
		protected var _windowAlpha				:Number;
		protected var _windowColor				:uint;
		protected var _windowColorAlpha			:Number;
			
		protected var _windowLine				:Boolean;
		protected var _windowLineColor			:uint;
		protected var _windowLineThickness		:int;
		
		protected var _windowGlow				:Boolean;
		protected var _windowShape				:String;
		protected var _isWndowScale9Grid		:Boolean;
		protected var _orientation				:String;
		
		protected var _maxWidth					:Number;
		protected var _maxHeight				:Number;
			
		protected var fieldCollection			:Array;
		
		protected var messageFieldHeight		:Number	= 15;
		
		protected var progressBar				:ProgressBar;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function AbstractForm(c:IController) {
			super(c);
			
			fieldCollection = new Array();
			
			_windowAlpha = 1;
			_windowColor = Colors.getColorByName(Colors.LIGHT_GREY);
			_windowColorAlpha = 1;
			_windowLine = true;
			_windowLineColor = Colors.getColorByName(Colors.DARK_GREY);
			_windowLineThickness = 1;
			_windowGlow = false;
			_windowShape = WindowShape.ROUND_RECTANGLE;
			
			_isWndowScale9Grid = true;
			
			_maxWidth = 200;
			_maxHeight = 35;
			
			this.addEventListener(MouseEvent.CLICK, formClick);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param w
		 * @param h
		 * 
		 */
		protected function drawWindow(width:Number,height:Number,type:String = WindowShape.ROUND_RECTANGLE):void {
			
			windowShape = type;
			
			maxWidth = width;
			maxHeight = height;
			
			//draw
			switch (type) {
				
				case WindowShape.BALLOON:
					window = new Balloon();
					
					window.isScale9Grid = this.isWndowScale9Grid;
					window.line = this.windowLine;
					if (this.windowLine) {
						window.lineColor = this.windowLineColor;
						window.lineThickness = this.windowLineThickness;
					}
					orientation = Directions.BOTTOM;
					
					break;
				
				case WindowShape.RECTANGLE:
					window = new RectBox();
					
					if (this.windowLine) {
						window.lineColor = this.windowLineColor;
						window.lineThickness = this.windowLineThickness;
					}
					window.isScale9Grid = false;
					
					break;
				
				default:
					window = new RoundBox();
					
					if (this.windowLine) {
						window.lineColor = this.windowLineColor;
						window.lineThickness = this.windowLineThickness;
					}
					window.isScale9Grid = this.isWndowScale9Grid;
					
					break;
					
			}
			
			window.color = this.windowColor;
			window.alphaColor = this.windowColorAlpha;
			window.alpha = this.windowAlpha;
			window.init(this.maxWidth,this.maxHeight);
			
			this.addChildAt(window,0);
			
			//glow
			if (windowGlow) {
				var glow:GlowFilter = new GlowFilter();
				glow.color = Colors.getColorByName(Colors.BLACK);
				glow.alpha = .3;
				glow.blurX = 5;
				glow.blurY = 5;
				glow.quality = BitmapFilterQuality.MEDIUM;
				
				window.filters=[glow];
			}
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function formClick(event:MouseEvent):void {
			//to override
		}
		
		/**
		 * 
		 * 
		 */
		protected function addProgressBar():void {
			if (!progressBar) {
				progressBar = new ProgressBar();
				progressBar.x = this.maxWidth/2 + progressBar.width/2;
				progressBar.y = this.height/2 + progressBar.height/2;
				this.addChild(progressBar);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeProgressBar():void {
			if (progressBar) {
				this.removeChild(progressBar);
				progressBar = null;
			}
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param messsage
		 * @param type
		 * 
		 */
		public function sendMessage(messsage:String, type:String = MessageType.NONE, textArea:Boolean = false):void {
			//to override
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			window.width = maxWidth;
			window.height = maxHeight;
		}
		
		/**
		 * 
		 * @param offset
		 * 
		 */
		public function arrowOffsetX(offset:Number):void {
			if (windowShape == WindowShape.BALLOON) window.arrowOffsetX(offset);
		}
		
		/**
		 * 
		 * @param offset
		 * 
		 */
		public function changeArrowOrientation(value:String):void {
			if (windowShape == WindowShape.BALLOON) {
				orientation = value;
				window.changeArrowOrientation(value);
			}
		}
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			this.removeProgressBar();
			this.removeEventListener(MouseEvent.CLICK, formClick);
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowAlpha():Number {
			return _windowAlpha;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowAlpha(value:Number):void {
			_windowAlpha = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowColor():uint {
			return _windowColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowColor(value:uint):void {
			_windowColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowColorAlpha():Number {
			return _windowColorAlpha;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowColorAlpha(value:Number):void {
			_windowColorAlpha = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowLine():Boolean {
			return _windowLine;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowLine(value:Boolean):void {
			_windowLine = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowLineThickness():int {
			return _windowLineThickness;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowLineThickness(value:int):void {
			_windowLineThickness = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowLineColor():uint {
			return _windowLineColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowLineColor(value:uint):void {
			_windowLineColor = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowGlow():Boolean {
			return _windowGlow;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowGlow(value:Boolean):void {
			_windowGlow = value;
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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxHeight():Number {
			return _maxHeight;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get windowShape():String {
			return _windowShape;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set windowShape(value:String):void {
			_windowShape = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get orientation():String {
			return _orientation;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set orientation(value:String):void {
			_orientation = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get isWndowScale9Grid():Boolean {
			return _isWndowScale9Grid;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set isWndowScale9Grid(value:Boolean):void {
			_isWndowScale9Grid = value;
		}
		
	}
}