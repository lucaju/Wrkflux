package view.workflow.flow.pin {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.tooltip.ToolTipManager;
	import view.workflow.flow.pin.NativeInput;
	import view.workflow.flow.pin.big.BigPin;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinView extends AbstractView {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _uid						:int;							//Pin UID: Relatated to the doc
		
		protected var _status					:String = "deselected";			//pin Status
		
		protected var _currentStep				:int;							//current step
		protected var _currentFlag				:int;							//Current Flag
		protected var _currentColor				:uint;							//Current Color
		
		internal var _originalPosition			:Object;						//Save position to go back if the drop target is not valid
		protected var _ratioPos					:Object; 						//**
		
		protected var _shape					:Sprite;						//Pin Shape Object
		protected var _shapeSize				:int = 12;						//pinsize
		
		protected var _star						:Star;							//star tag
		protected var _tagged					:Boolean = false;				//Pin Tagged
		
		internal var bigPin						:BigPin;					//Control Class for big Pin View
		protected var _bigView					:Boolean = false;				//Switch between small and big view
		
		internal var pinTrail					:PinTrail						//trail during movement
		
		protected var input						:InputAdpter;
		protected var _inputType				:String;
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param c
		 * @param uid
		 * 
		 */
		public function PinView(c:IController, uid:int) {
			
			super(c);
			
			//save properties
			_uid = uid;
			
			//trails
			if (Settings.pinTrail) pinTrail = new PinTrail(this);
			
			_inputType = "native";
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			if (Settings.platformTarget == "mobile") shapeSize = 18;
			
			//flag
			if (!currentFlag) currentFlag = WrkFlowController(this.getController()).getDefaultFlagUID();			
			currentColor =  WrkFlowController(this.getController()).getFlagColor(currentFlag);
			
			//shape
			shape = new Sprite();
			this.drawShape();
			this.addChild(shape);
			
			
			//tagged
			if (tagged) {
				var color:uint = Colors.getColorByName(Colors.WHITE);
				if (currentColor == color) color = Colors.getColorByName(Colors.LIGHT_GREY);
				
				star = new Star(shapeSize,color);
				this.addChild(star);
			}	
			
			//add listeners
			this.addListeners();
			
			
		}		
		
		//****************** PROTECTED METHODS ****************** ******************  ******************
	
		/**
		 * 
		 * 
		 */
		protected function addListeners():void{
			
			shape.buttonMode = true;
			
			switch (inputType) {
				
				case "native":
					input = new NativeInput(this);
					break;
				
				case "gestouch":
					//input = new GestouchInput(this);
					break;
				
			}
			
			//add listeners
			input.addEvents();
		}
		
		/**
		 * 
		 * @param flagColor
		 * 
		 */
		protected function drawShape(flagColor:Object = null):void {

			var pinColor:uint;
			
			if (flagColor == null) {
				pinColor = currentColor;
			} else {
				pinColor = flagColor.color;
			}
			
			if (bigView) {
				
				bigPin.drawShape(pinColor);
				
			} else {
				
				shape.graphics.clear();
				shape.graphics.lineStyle(1,Colors.getColorByName(Colors.DARK_GREY),1,false,"none");
				
				if (currentColor == Colors.getColorByName(Colors.WHITE)) {
					shape.blendMode = BlendMode.NORMAL;
					shape.graphics.beginFill(pinColor,.75);
				} else {
					shape.blendMode = BlendMode.MULTIPLY;
					shape.graphics.beginFill(pinColor);
				}
				
				shape.graphics.drawCircle(0,0,shapeSize);
				shape.graphics.endFill();
				
			}
			
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
		
		
		//****************** PUBLIC METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function changeStatus(value:String):void {
			
			var data:Object = new Object();
			_status = value;
			
			switch (value) {
				
				case "deselected":
					if (bigView) closeBigView();
					
					//data
					data = new Object();
					data.open = false;
					data.pinUID = this.uid;
					
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.ACTIVATE_PIN, data));
					
					break;
				
				case "selected":
					if (bigView) closeBigView();
					
					//Dispatch Event
					data = new Object();
					data.pinUID = this.uid;
					data.select = true;
					
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data));
					
					break;
				
				case "edit":
					if (!bigView) {
						openBigView();
						ToolTipManager.removeToolTip(this.uid);
						
						//data
						data = new Object();
						data.open = true;
						data.pinUID = this.uid;
						this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.ACTIVATE_PIN, data));
					}
					break;
			}
			
		}
		
		/**
		 * 
		 * @param flagUID
		 * 
		 */
		public function setFlag(flagUID:int = 0):void {
			
			//new current flag
			
			if (flagUID == 0) {
				this.currentFlag = WrkFlowController(this.getController()).getDefaultFlagUID();
			} else {
				this.currentFlag = flagUID;
			}
			
			//new color
			var newColor:uint =  WrkFlowController(this.getController()).getFlagColor(currentFlag);
			var currentFlagColor:Object = {color:currentColor}
			var newFlag:Object = {color:newColor};
			currentColor = newColor;
			
			//animation
			TweenMax.to(currentFlagColor,.8,{hexColors:{color:newFlag.color}, onUpdate:drawShape, onUpdateParams:[currentFlagColor]});
		
			//star
			if (star) {
				var color:uint = Colors.getColorByName(Colors.WHITE);
				if (currentColor == color) color = Colors.getColorByName(Colors.LIGHT_GREY);
				TweenMax.to(star,.5,{tint:color});
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		public function updatePosition(newX:Number, newY:Number):void {
			_originalPosition = {x:newX, y:newY};
		}
		
		/**
		 * 
		 * 
		 */
		public function pulse():void {
			var pulse:Shape = new Shape();
			pulse.graphics.beginFill(this.currentColor,1);
			pulse.graphics.drawCircle(0,0,this.shapeSize);
			pulse.graphics.endFill();
			
			if (currentColor != Colors.getColorByName(Colors.WHITE)) pulse.blendMode = BlendMode.MULTIPLY;
			
			this.addChildAt(pulse,0);
			TweenMax.to(pulse,2,{scaleX:2, scaleY:2, alpha: 0, repeat:2, onComplete:removeChild, onCompleteParams:[pulse]})
		}
		
		//****************** BIG PIN METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * 
		 */
		public function openBigView():void {
			
			bigView = !bigView;
			
			_status = "edit";
			
			//Save Position
			this._originalPosition = {x:this.x, y:this.y};
			
			//change behavior
			input.removeEvents();
			
			//change blendMode
			shape.blendMode = BlendMode.NORMAL;
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(Colors.getColorByName(Colors.DARK_GREY), .3);
			fxs.push(fxGlow);
			this.filters = fxs;
			
			bigPin = new BigPin(this);
			bigPin.init();	
	
		}
		
		/**
		 * 
		 * 
		 */
		public function closeBigView():void {
			//Change behavior back
			bigView = !bigView;
			
			_status = "deselected";
			
			bigPin.close();
			bigPin = null;
			
			//change visual
			if (currentColor == Colors.getColorByName(Colors.WHITE)) {
				shape.blendMode = BlendMode.NORMAL;
			} else {
				shape.blendMode = BlendMode.MULTIPLY;
			}
			this.filters = [];
			
			//change behavior
			input.addEvents();
				
		}
		
		
		//****************** GETTERS // SETTER ****************** ******************  ****************** 
		
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
		 * @return 
		 * 
		 */
		public function get shapeSize():int {
			return _shapeSize;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shapeSize(value:int):void {
			_shapeSize = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shape():Sprite {
			return _shape;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shape(value:Sprite):void {
			_shape = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentStep():int {
			return _currentStep;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentStep(value:int):void {
			_currentStep = value;
			this.updatePosition(this.x,this.y);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get originalPosition():Object {
			return _originalPosition;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentFlag():int {
			return _currentFlag;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentFlag(value:int):void {
			_currentFlag = value;
		}
		
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentColor():uint {
			return _currentColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentColor(value:uint):void {
			_currentColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get star():Star {
			return _star;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set star(value:Star):void {
			_star = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tagged():Boolean {
			return _tagged;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tagged(value:Boolean):void {
			_tagged = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get status():String {
			return _status;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get ratioPos():Object {
			return _ratioPos;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set ratioPos(value:Object):void {
			if(!_ratioPos) _ratioPos = new Object;
			_ratioPos = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bigView():Boolean {
			return _bigView;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set bigView(value:Boolean):void {
			_bigView = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get inputType():String {
			return _inputType;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set inputType(value:String):void {
			_inputType = value;
		}

	}
}