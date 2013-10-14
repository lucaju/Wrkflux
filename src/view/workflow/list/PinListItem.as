package view.workflow.list {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import events.WrkfluxEvent;
	
	import font.FontFreightSans;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.workflow.assets.Ball;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinListItem extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _uid							:int;
		protected var _title						:String;
		protected var _flagUID						:int;
		protected var _color						:uint;
		
		protected var _maxWidth						:Number;
		
		protected var titleStyle					:TextFormat;
		protected var titleSelectedStyle			:TextFormat;
		protected var titleStyleStart				:TextFormat;
		
		protected var titleTF						:TextField;
		
		protected var background					:Sprite;
		protected var ball							:Ball;
		
		protected var gap							:Number = 5;
		
		protected var _highlighted					:Boolean = false;
		
		protected var timer							:Timer;
		
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param uid
		 * 
		 */
		public function PinListItem(uid:int) {
			this._uid = uid;
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//ball
			ball = new Ball(color);
			ball.radius = 7;
			ball.init();
			this.addChild(ball);
			
			ball.x = gap + (ball.width/2);
			ball.y = gap + (ball.height/2) + 3;
			
			//styles
			titleStyle = new TextFormat();
			titleStyle.font = FontFreightSans.MEDIUM;
			titleStyle.size = 13;
			titleStyle.color = Colors.getColorByName(Colors.DARK_GREY);
			
			titleSelectedStyle = new TextFormat();
			titleSelectedStyle.font = FontFreightSans.MEDIUM;
			titleSelectedStyle.size = 12;
			titleSelectedStyle.color = Colors.getColorByName(Colors.WHITE);
			
			//TitleTF
			titleTF = new TextField();
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.selectable = false;
			titleTF.embedFonts = true;
			titleTF.multiline = true;
			titleTF.wordWrap = true;
			titleTF.autoSize =  TextFieldAutoSize.LEFT;
			
			titleTF.defaultTextFormat = titleStyle;
			
			titleTF.text = this.title;
			
			this.addChild(titleTF);
			
			titleTF.y = gap;
			titleTF.x = ball.width + (2*gap);
			titleTF.width = maxWidth - titleTF.x - (2*gap);
			
			//background
			background = new Sprite();
			background.graphics.beginFill(color);
			background.graphics.drawRect(0,0,maxWidth,this.height + (2* gap));
			background.graphics.endFill();
			background.alpha = 0;
			this.addChildAt(background,0);
				
			//interaction
			this.mouseChildren = false;
			this.buttonMode = true;
			this.doubleClickEnabled = true;
			
			//listeners
			if (Settings.platformTarget == "mobile") {
				//var tap:TapGesture = new TapGesture(this);
				//tap.addEventListener(GestureEvent.GESTURE_RECOGNIZED, touchEvent);
				
				
				//var swipe:SwipeGesture = new SwipeGesture(this);
				//swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, swipeEvent);
				//swipe.direction = SwipeGestureDirection.HORIZONTAL;
				
			} else {
				this.addEventListener(MouseEvent.CLICK, OnClick);
				this.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClick);
			}
		}	
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
	
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function changeColor(value:uint):void {
			
			//ball
			if (!highlighted) ball.changeColor(value);
			
			//text
			if (highlighted) {
				if (value == Colors.getColorByName(Colors.WHITE)) {
					titleTF.setTextFormat(titleStyle);
				} else {
					titleTF.setTextFormat(titleSelectedStyle); 
				}
			}
			
			//bg
			var currentColor:Object = {color:this.color};
			TweenMax.to(currentColor,.8,{hexColors:{color:value}, onUpdate:updateColor, onUpdateParams:[background,currentColor]});
			
			//save
			color = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function updateColor(target:DisplayObject, value:Object):void {
			var vAlpha:Number = (highlighted) ? 1 : 0;
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = value.color;
			target.transform.colorTransform = colorTransform;
			target.alpha = vAlpha;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function highlight(value:Boolean):void {
			
			//set new status
			_highlighted = value;
			
			if (highlighted) {
				
				TweenLite.to(background,.4,{alpha:1});
				
				if (color != Colors.getColorByName(Colors.WHITE)) {
					titleTF.setTextFormat(titleSelectedStyle);
					TweenLite.to(ball,.4,{alpha:.8});
					ball.changeColor(Colors.getColorByName(Colors.WHITE));
				}
				
			} else {
				
				TweenLite.to(background,.4,{alpha:0});
				titleTF.setTextFormat(titleStyle);
				TweenLite.to(ball,.4,{alpha:1});
				ball.changeColor(color);
				
			}
			
		}
		
		/**
		 * 
		 * @param flagColor
		 * 
		 */
		public function updateFlag(flagColor:uint):void {
			changeColor(flagColor);
		}
		
		/**
		 * 
		 * @param flagColor
		 * 
		 */
		public function updateTitle(value:String):void {
			this.title = value;
			titleTF.text = this.title;
			
			if (!highlighted) {
				titleTF.setTextFormat(titleStyle);
			} else {
				titleTF.setTextFormat(titleSelectedStyle);
			}
			
			background.height = this.height + (2* gap);
		}
		
		//****************** MOUSE EVENTS ****************** ****************** ******************

		/**
		 * 
		 * @param event
		 * 
		 */
		protected function OnClick(event:MouseEvent):void {
			timer = new Timer(250,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
			timer.start();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function OnDoubleClick(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			// 2 CLICKS
			if (timer != null) {
				
				//stop timer
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
				timer = null;
				
				
				//change status
				if (this.highlighted) {
					this.highlight(false);
				} else {
					this.highlight(true);
				}
				
				//send event
				var data:Object = new Object();
				data.open = this.highlighted;
				data.pinUID = this.uid;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data));
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.ACTIVATE_PIN, data));
			}
		}
		
		/**
		 * 
		 * @param eevent
		 * 
		 */
		protected function OnTimerComplete(event:TimerEvent ):void {
			// 1 CLICK
			
			var data:Object = new Object();
			
			if (this.highlighted) {
				
				this.highlight(false);
				
				//send event
				
				data.open = this.highlighted;
				data.pinUID = this.uid;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data));
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.ACTIVATE_PIN, data));
				
			} else {
				
				//send event
				data.open = this.highlighted;
				data.pinUID = this.uid;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data));
			}
			
		}
		
		
		//****************** TOUCH EVENTS ****************** ****************** ******************
		
		/*
		protected function touchEvent(event:GestureEvent):void {
			
			// 1 CLICK
			//change status
			if (status == "deselected") {
				highlight("selected");
			} else {
				highlight("deselected");
			}
			
			//send event
			var data:Object = {};
			data.id = this.uid;
			data.status = this.status;
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data));
		}
		
		protected function swipeEvent(event:GestureEvent):void {
			var swipeGesture:SwipeGesture = event.target as SwipeGesture;
			
			var changed:Boolean = false;
			
			if (swipeGesture.offsetX > 0) {
				if (_status != "edit") {
					highlight("edit");
					changed = true;
				}
				
			} else {
				if (_status != "deselected") {
					highlight("deselected");
					changed = true;
				}
			}
			
			if (changed) {
				//send event
				var data:Object = {};
				data.id = this.uid;
				data.status = this.status;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data));
			}
			
		}	
		*/
		
		//****************** GETTERS // SETTERS  ****************** ****************** ******************
		
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
		public function get title():String {
			return _title;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			if (titleTF) titleTF.text = value;
			_title = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flagUID():int {
			return _flagUID;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set flagUID(value:int):void {
			_flagUID = value;
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
			_color = value;
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
		public function get highlighted():Boolean {
			return _highlighted;
		}


	}
}