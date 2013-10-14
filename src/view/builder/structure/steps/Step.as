package view.builder.structure.steps {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
	import view.assets.StepShape;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Step extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _tempID				:String;
		
		protected var _id					:int;
		protected var _label				:String;
		protected var labelTF				:TextField;
		protected var _shape				:int;
		protected var shapeSS				:StepShape;
		
		protected var optionsBTCollection	:Array;
		protected var plusButton			:PlusButton;
		protected var infoButton			:InfoButton;
		
		protected var _positionChanged	:Boolean = false;
		
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
			
			optionsBTCollection = new Array();
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
			this.buttonMode = true;
			this.addRollMouseListeners();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param show
		 * 
		 */
		protected function showPlusButton(show:Boolean):void {
			
			if(show && !plusButton) {
				plusButton = new PlusButton();
				plusButton.x = (shapeSS.width/2);
				this.addChildAt(plusButton, 0);
				
				TweenMax.from(plusButton,.3,{x:0});
				
			} else if (!show && plusButton) {
				TweenMax.to(plusButton,.3,{x:0, onComplete:removeObject, onCompleteParams:[plusButton]});
				plusButton = null;
			}
			
		}
		
		/**
		 * 
		 * @param show
		 * 
		 */
		protected function showInfoButton(show:Boolean):void {

			if(show && !infoButton) {
				infoButton = new InfoButton();
				this.addChild(infoButton);
				
				infoButton.addEventListener(MouseEvent.CLICK, infoButtonCLick);
				TweenMax.from(infoButton,.3,{scaleX:0,scaleY:0, alpha:0});
				
			} else if (!show && infoButton) {
				TweenMax.to(infoButton,.3,{scaleX:0,scaleY:0, alpha:0, onComplete:removeObject, onCompleteParams:[infoButton]});
				infoButton.removeEventListener(MouseEvent.CLICK, infoButtonCLick);
				infoButton = null;
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeObject(value:DisplayObject):void {
			this.removeChild(value);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOver(event:MouseEvent):void {
			showOptions(true);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOut(event:MouseEvent):void {
			showOptions(false);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function infoButtonCLick(event:MouseEvent):void {
			var infoButtonEvent:Event = event.clone();
			event.stopImmediatePropagation();
			this.dispatchEvent(infoButtonEvent);
			
			infoButton.removeEventListener(MouseEvent.CLICK, infoButtonCLick);
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseDown(event:MouseEvent):void {
			if (!(event.target is PlusButton)) {
				event.stopPropagation();
				this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseUp(event:MouseEvent):void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
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
		 * 
		 */
		public function addRollMouseListeners():void {
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		/**
		 * 
		 * @param show
		 * @param option
		 * 
		 */
		public function showOptions(show:Boolean, option:String = ""):void {
			
			switch (option) {
				
				case "plus":
					this.showPlusButton(show);
					break;
				
				case "info":
					this.showInfoButton(show);
					break;
				
				default:
					this.showPlusButton(show);
					this.showInfoButton(show);
					break;
				
			}
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function changeShape(value:int):void {
			shape = value;
			shapeSS.drawShape(value);
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
		public function get tempID():String {
			return _tempID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tempID(value:String):void {
			_tempID = value;
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
		public function get positionChanged():Boolean {
			return _positionChanged;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set positionChanged(value:Boolean):void {
			_positionChanged = value;
		}


	}
}