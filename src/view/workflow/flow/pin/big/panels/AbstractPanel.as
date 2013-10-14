package view.workflow.flow.pin.big.panels {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import events.WrkfluxEvent;
	
	import font.FontFreightSans;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.util.scroll.Scroll;
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractPanel extends AbstractView {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var pinUID					:int;					//pinId;
		
		protected var margin					:uint = 3;				//Margins
		protected var _maxWidth					:int = 180;				//Max Width
		protected var _maxHeight				:int = 200;				//Max Height
		
		protected var itemCollection			:Array;					//collection
		
		protected var panelShape				:Shape;					//Panel shape
		protected var titleTF					:TextField;
		
		protected var scrolledArea				:Sprite;
		protected var container					:Sprite;
		protected var containerMask				:Sprite;
		protected var scroll					:Scroll;
		
		protected var panelTitleStyle			:TextFormat;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function AbstractPanel(c:IController) {

			super(c);
			
			//styles
			panelTitleStyle = new TextFormat();
			panelTitleStyle.font = FontFreightSans.MEDIUM;
			panelTitleStyle.size = 14;
			panelTitleStyle.color = Colors.getColorByName(Colors.DARK_GREY);
			panelTitleStyle.align = TextFormatAlign.CENTER;
			
			//panel Shape
			panelShape = new Shape();
			
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function init(id:int = 0):void {
			//to override
		}

		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function createTF():TextField {
			var TFGeneric:TextField = new TextField();
			TFGeneric.antiAliasType = AntiAliasType.ADVANCED;
			TFGeneric.embedFonts = true;
			TFGeneric.autoSize = TextFieldAutoSize.LEFT;
			TFGeneric.selectable = false;
			return TFGeneric;
		}
		
		// fx
		/**
		 * 
		 * @param colorValue
		 * @param a
		 * @return 
		 * 
		 */
		protected function getBitmapFilter(colorValue:uint, a:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = a;
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 2;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}
		
		
		/**
		 * 
		 * @param contructor
		 * @param diff
		 * 
		 */
		protected function testForScroll(contructor:Boolean = true):void {
			
			if(!scroll) {
				if (container.height > maxHeight) {
					
					//mask for container
					containerMask = new Sprite();
					containerMask.graphics.beginFill(0xFFFFFF,0);
					containerMask.graphics.drawRect(container.x, container.y, maxWidth, maxHeight);
					this.addChild(containerMask);
					container.mask = containerMask;
					
					//add scroll system
					scroll = new Scroll();
					scroll.target = container;
					scroll.maskContainer = containerMask;
					scroll.hasRoll = false;
					this.addChild(scroll);
					scroll.init();
					
					//create background
					container.graphics.clear();
					container.graphics.beginFill(0xFFFFFF,0);
					container.graphics.drawRect(0,0,container.width,container.height);
					container.graphics.endFill();
					
					//shape
					panelShape.graphics.clear();
					
					//draw bg
					this.graphics.beginFill(0xFF0000,0);
					this.graphics.drawRect(0,0,containerMask.width,containerMask.height);
					this.graphics.endFill();
				}
			
			} else {
				TweenMax.to(container,.4,{y:0});
			}
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		public function updatePanel(event:WrkfluxEvent):void {
			//to override
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		public function removeEvents():void {
			//to override
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get panelShapeHeight():int {
			return panelShape.height;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():int {
			return _maxWidth;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxWidth(value:int):void {
			_maxWidth = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxHeight():int {
			return _maxHeight;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxHeight(value:int):void {
			_maxHeight = value;
		}

	}
}