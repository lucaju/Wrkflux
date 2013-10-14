package view.builder.flags {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
	import view.assets.buttons.RemoveRedButton;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Flag extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _tempID			:String;
		
		protected var _id				:int;
		protected var _order			:int;
		protected var _label			:String;
		protected var _labelTF			:TextField;
		protected var shape				:Shape;
		protected var ball				:Ball;
		protected var _color			:uint;
		protected var _removeButtun		:RemoveRedButton;
		protected var colorOptions		:FlagColorsOption;
		
		protected var marginX			:Number = 2;
		
		protected var _removable		:Boolean = true;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param label
		 * @param color
		 * 
		 */
		public function Flag(id:int, label = "", color:* = null) {
			
			this._id = id;
			this.label = label;
			
			this.name = label;
			
			//color
			if (color is String) {
				this._color = Colors.getColorByName(color);
				if (!this._color) color = Colors.getColorByName(Colors.WHITE);
				
			} else if (color is uint) {
				this._color = color;
			} else {
				this._color = Colors.getColorByName(Colors.WHITE);
			}
		}
			
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//shape
			shape = new Shape();
			shape.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY));
			shape.graphics.drawRect(0,0,110,30);
			shape.graphics.endFill();
			shape.alpha = 0;
			shape.x = -5;
			this.addChild(shape);
			
			//ball
			ball = new Ball(color);
			ball.radius = 8;
			ball.init();
			ball.x = ball.width/2 + marginX;
			ball.y = shape.height/2;
			
			this.addChild(ball);
			
			//label
			var style:TextFormat = new TextFormat();
			style.font = FontFreightSans.MEDIUM;
			style.size = 13;
			
			_labelTF = new TextField();
			labelTF.autoSize = TextFieldAutoSize.LEFT;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.type = TextFieldType.INPUT;
			labelTF.embedFonts = true;
			labelTF.maxChars = 11;
			
			labelTF.defaultTextFormat = style;
			labelTF.text = this.label;
			
			labelTF.x = ball.width + marginX;
			labelTF.y = (shape.height/2) - (labelTF.height/2);
			
			this.addChildAt(labelTF,1);
			
			//listener
			addListeners();
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * 
		 */
		protected function showColorOptions():void {
			labelTF.visible = false;
			labelTF.mouseEnabled = false;
			
			if (removeButtun) {
				removeButtun.visible = false;
				removeButtun.mouseEnabled = false;
			}
			
			if (!colorOptions) {
				colorOptions = new FlagColorsOption(this.color);
				colorOptions.x = ball.x + ball.width + marginX;
				colorOptions.y = shape.height/2;
				this.addChildAt(colorOptions,1);
				colorOptions.addEventListener(MouseEvent.CLICK, colorOptionClick);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeColorOptions():void {
			colorOptions.kill();
			colorOptions = null;
			
			labelTF.visible = true;
			labelTF.mouseEnabled = true;
			
			if (removeButtun) {
				removeButtun.visible = true;
				removeButtun.mouseEnabled = true;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function changeLabel():void {
			if (labelTF.text == "") {
				labelTF.text = this.label;
			} else {
				this.label = labelTF.text;
			}
			
			this.dispatchEvent(new Event(Event.SELECT,true));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function changeColor(target:Object):void {
			if (target is Ball) ball.changeColor(Ball(target).color);
			this.color = ball.color;
			this.removeColorOptions();
			
			this.dispatchEvent(new Event(Event.SELECT,true));
		}
		
		/**
		 * 
		 * 
		 */
		protected function remove():void {
			this.parent.removeChild(this);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOver(event:MouseEvent):void {
			if (removable && !removeButtun) {
				_removeButtun = new RemoveRedButton();
				removeButtun.x = this.width - removeButtun.width - marginX - 10;
				removeButtun.y = (this.height/2) - (removeButtun.height/2);
				this.addChild(removeButtun);
				removeButtun.addEventListener(MouseEvent.CLICK, removeClick);
			}
			
			
			TweenLite.to(shape, .6, {alpha:.6});
			
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOut(event:MouseEvent):void {
			if (removeButtun) {
				removeButtun.removeEventListener(MouseEvent.CLICK, removeClick);
				this.removeChild(removeButtun);
				_removeButtun = null;
			}
				
			TweenLite.to(shape, .6, {alpha:0});
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function removeClick(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			removeButtun.addEventListener(MouseEvent.CLICK, removeClick);
			this.removeChild(removeButtun);
			_removeButtun = null;
			
			this.dispatchEvent(new Event(Event.CLOSING,true));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function ballClick(event:MouseEvent):void {
			(colorOptions) ? removeColorOptions() : showColorOptions();
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function colorOptionClick(event:MouseEvent):void {
			changeColor(event.target);
		}
				
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function focusOut(event:FocusEvent):void {
			changeLabel();
		}
		
		//****************** PUBLIC EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addListeners():void {
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			ball.addEventListener(MouseEvent.CLICK, ballClick);
			labelTF.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			this.mouseChildren = true;
		}
		
		/**
		 * 
		 * 
		 */
		public function removeListeners():void {
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			ball.removeEventListener(MouseEvent.CLICK, ballClick);
			labelTF.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			this.mouseChildren = false;
			if (removeButtun) removeButtun.visible = false;
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			TweenLite.to(this, .4, {x:-this.width, ease:Expo.easeIn, onComplete:remove});
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

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
		public function get order():int {
			return _order;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set order(value:int):void {
			_order = value;
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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get color():uint {
			return _color;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void {
			if (ball) ball.changeColor(value);
			_color = ball.color;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get labelTF():TextField {
			return _labelTF;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get removeButtun():RemoveRedButton {
			return _removeButtun;
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
		public function get removable():Boolean {
			return _removable;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set removable(value:Boolean):void {
			_removable = value;
		}


	}
}