package view.workflow.flow.pin.big.panels {
	
	//imports
	import com.greensock.TweenMax;
	import model.Session;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import settings.Settings;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Slice extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _uid						:int;
		protected var _color					:uint;
		protected var _label					:String;
		
		protected var radius					:Number = 70;
	
		protected var _selected					:Boolean = false;			//Whether button is selected or not
		protected var _hasIcon					:Boolean = true;
		
		protected var shape						:Shape;
		protected var _icon						:Sprite;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param label_
		 * 
		 */
		public function Slice(flag:Object) {
			this._uid = flag.uid;
			this._color = flag.color;
			this._label = flag.label;
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param starPos
		 * @param arcLength
		 * 
		 */
		public function init(starPos:Number, arcLength:Number):void {
			
			shape = new Shape();
			this.addChildAt(shape,0);
				
			//draw the slice
			drawArc(0, 0, radius, starPos/360, arcLength/360, 40);

			//
			if (Session.credentialCheck()) {
				this.buttonMode = true;
				
				this.addEventListener(MouseEvent.ROLL_OVER, over,false,0,true);
				this.addEventListener(MouseEvent.ROLL_OUT, out,false,0,true);
			}
		}
		
	
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param centerX
		 * @param centerY
		 * @param radius
		 * @param startAngle
		 * @param arcAngle
		 * @param steps
		 * 
		 */
		protected function drawArc(centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, steps:Number):void {
			
			//line
			shape.graphics.lineStyle(2, Colors.getColorByName(Colors.DARK_GREY));
			shape.graphics.beginGradientFill("radial",[color,color],[1,1],[100,240]);
			
			// Rotate the point of 0 rotation 1/4 turn counter-clockwise.
			var iAngle:Number = startAngle;
			iAngle -= .25;
			//
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			var xx:Number = centerX + Math.cos(iAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(iAngle * twoPI) * radius;
			var angle:Number = 0;
			
			//draw arch
			shape.graphics.lineTo(xx, yy);
			for(var i:Number=1; i<=steps; i++){
				angle = iAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				shape.graphics.lineTo(xx, yy);
				
				//icon position
				if (_icon) {
					if(i == steps/2) {
						_icon.x = centerX + Math.cos(angle * twoPI) * (radius-24);
						_icon.y = centerY + Math.sin(angle * twoPI) * (radius-24);
						_icon.rotation = (startAngle + (arcAngle/2)) * 360;
					}
				}
			}
			shape.graphics.lineTo(0, 0);
			shape.graphics.endFill();
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _iconComplete(event:Event):void {
			
			//icon size
			//event.target.content.width = event.target.content.height = 16;
			
			if (Settings.platformTarget == "mobile") {
				event.target.content.scaleX = event.target.content.scaleY = .5;
			}
			
			//icon position
			event.target.content.x = -event.target.content.width/2;
			event.target.content.y = -event.target.content.height/2;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function over(event:MouseEvent):void {
			highlight(true);
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function out(event:MouseEvent):void {
			highlight(false);
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function highlight(value:Boolean):void {
			
			if (value != selected) {
				
				selected = value;
				
				if (selected) {
					//TweenMax.to(this.parent, 1, {glowFilter:{color:color, alpha:1, blurX:20, blurY:20,strength:1}});
					//TweenMax.to(shape, .5, {glowFilter:{color:Colors.getColorByName(Colors.DARK_GREY), alpha:.6, blurX:10, blurY:10,strength:3,inner:true}});
					//TweenMax.to(shape, 1, {scaleX:1.05, scaleY:1.05});	
					
					//TweenMax.to(shape, .5, {colorTransform:{tint:color, tintAmount:0.6}});
					
					if (_icon) {
						if (color == Colors.getColorByName(Colors.WHITE)) {
							TweenMax.to(_icon, 1, {tint:Colors.getColorByName(Colors.BLACK)});
						} else {
							TweenMax.to(_icon, 1, {tint:Colors.getColorByName(Colors.WHITE)});
						}
					} 
					
				} else {
					//TweenMax.to(this.parent, 1, {glowFilter:{color:color, alpha:0, blurX:0, blurY:0,strength:0,remove:true}});
					//TweenMax.to(shape, .5, {glowFilter:{color:Colors.getColorByName(Colors.DARK_GREY), alpha:.6, blurX:0, blurY:0,strength:1,inner:true}});
					//TweenMax.to(shape, .5, {removeTint:true});
					
					//TweenMax.to(shape, 1, {scaleX:1, scaleY:1});
					if (_icon) TweenMax.to(_icon, 1, {removeTint:true});
				}
			}
		}
		
		//****************** GETTERS ****************** ****************** ******************
		
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
		public function get label():String {
			return _label;
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
		 * @return 
		 * 
		 */
		public function get hasIcon():Boolean {
			return _hasIcon;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hasIcon(value:Boolean):void {
			_hasIcon = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set icon(value:String):void {
			_icon = new Sprite();
			this.addChild(_icon);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _iconComplete,false,0,true)
			loader.load(new URLRequest(value));
			_icon.addChild(loader)
		}

	}
}