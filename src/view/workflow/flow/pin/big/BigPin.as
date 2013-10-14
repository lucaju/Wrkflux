package view.workflow.flow.pin.big {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.workflow.flow.CrossButton;
	import view.workflow.flow.pin.PinView;
	import view.workflow.flow.pin.Star;
	import view.workflow.flow.pin.big.knob.Knob;
	import view.workflow.flow.pin.big.knob.KnobInputs;
	import view.workflow.flow.pin.big.knob.KnobType;
	import view.workflow.flow.pin.big.panels.AbstractPanel;
	import view.workflow.flow.pin.big.panels.PanelFactory;
	import view.workflow.flow.pin.big.panels.SlicePanel;
	import view.workflow.flow.pin.big.panels.Window;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class BigPin {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _source					:PinView;					//target
		
		protected var pinControlPanel			:SlicePanel;				//Control panel for the big view
		protected var _infoPanel				:AbstractPanel;				//Info panel for the big view
		
		protected var window					:Window
		
		protected var knob						:Knob;
		
		protected var closeBT					:CrossButton
		
		//protected var bigPinTap				:TapGesture;
		//protected var bigPinLongPress			:LongPressGesture;
		
		
		//****************** Constructor ****************** ******************  ******************		
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		public function BigPin(pin:PinView) {
			_source = pin;
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//bring to front
			source.parent.setChildIndex(source,source.parent.numChildren-1);
			
			//add the control panel
			pinControlPanel = new SlicePanel(this);
			source.addChildAt(pinControlPanel,0);
			
			//add windows
			window = new Window(source.getController());
			window.maxWidth = 220;
			window.init(source.uid);
			window.x = pinControlPanel.width/4;
			window.y = - pinControlPanel.height/2;
			source.addChildAt(window,0);
			
			//add info Panel to window
			_infoPanel = PanelFactory.addPanel(source.getController(),"info");
			window.addPanel(_infoPanel);
			
			
			//star
			/*if(!source.tagged) {
				var color:uint = 0xFFFFFF;
				if (source.currentColor == color) color = 0x666666;
				
				source.star = new Star(source.shapeSize,color);
				source.addChild(source.star);
				
			} else {
				TweenMax.to(source.star,2,{alpha:1});
			}*/
			
			
			
			//close button
			closeBT = new CrossButton();
			closeBT.rotation = 45;
			source.addChild(closeBT);
			closeBT.init();
			
			closeBT.buttonMode = true;
			closeBT.mouseChildren = false;
			
			//change shape
			drawShape(source.currentColor);
			
			
			//animation
			TweenMax.from(closeBT,1,{scaleX:0, scaleY:0, ease:Back.easeOut});
			TweenMax.from(window,1,{x:0, alpha:0, delay: 1, ease:Back.easeOut, onUpdate:alignPanels, onComplete:addEvents});
			TweenMax.from(source.shape,1,{width:45, height:45});
			TweenMax.from(pinControlPanel,1,{scaleX:0, scaleY:0, rotation:90, ease:Back.easeOut, onComplete:startKnobSystem});
			//TweenMax.to(source.star,1,{width:45, height:45, ease:Back.easeOut});

		}				
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		protected function addEvents():void {
			//listeners
			if (Settings.platformTarget == "mobile") {
				
				/*bigPinTap = new TapGesture(target.shape);
				bigPinTap.addEventListener(GestureEvent.GESTURE_RECOGNIZED, biPinTapEvent);
				
				bigPinLongPress = new LongPressGesture(target.shape);
				bigPinLongPress.addEventListener(GestureEvent.GESTURE_BEGAN, bigPinLongPressBeganEvent);*/
				
			} else {
				pinControlPanel.addEventListener(WrkfluxEvent.SELECT, controlPanelSelect,false,0,true);
				closeBT.addEventListener(MouseEvent.CLICK, closeBTHandler,false,0,true);
				//source.shape.addEventListener(MouseEvent.CLICK, tagIt,false,0,true);
				source.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				source.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function startKnobSystem():void {
			
			//knob
			knob = new Knob(50, 50);
			knob.stylePathAlpha = 0;
			knob.styleHandleAlpha = 0;
			
			if (knob.type == KnobType.OUTTER) knob.styleHandleSize = 90;
			
			source.addChild(knob);
			knob.init();
			
			//events
			if (Settings.platformTarget == "mobile") var knobInputs:KnobInputs = new KnobInputs(this,knob);
			
			//turn knob to the right position
			turnKnob();
			
		}
		
		
		/**
		 * 
		 * 
		 */
		protected function turnKnob():void {
			//Get control data
			var numOptions:int = pinControlPanel.getOptionsNum();
			
			var controlCurrentPosition:int = pinControlPanel.getIndexPosition(source.currentFlag);
			var rotation:Number = (controlCurrentPosition/numOptions)*360;
			
			switch (knob.type) {
				
				case KnobType.INNER:
					TweenMax.to(knob,2,{shortRotation:{value:rotation}, ease:Back.easeOut});
					TweenMax.to(source.shape,2,{shortRotation:{rotation:rotation}, ease:Back.easeOut});
					break;
				
				case KnobType.OUTTER:
					//rotation CCW
					rotation = (rotation - 360) * -1;
					TweenMax.to(pinControlPanel,2,{shortRotation:{rotation:rotation}, ease:Back.easeOut});
					break;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function knobShape(active:Boolean):void {
			
			if (active) {
				drawShape(source.currentColor)
			} else {
				//circle
				source.shape.graphics.clear();
				source.shape.graphics.lineStyle(1,Colors.getColorByName(Colors.DARK_GREY),1,false,"none");
				source.shape.graphics.beginFill(source.currentColor);
				source.shape.graphics.drawCircle(0,0,source.shapeSize);
				source.shape.graphics.endFill();
				source.shape.blendMode = "multiply";
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		public function drawShape(color:uint):void {
			source.shape.graphics.clear();
			
			source.shape.graphics.beginFill(color);
			
			source.shape.graphics.lineStyle(1.7,Colors.getColorByName(Colors.DARK_GREY));
			source.shape.graphics.moveTo(10,-48);
			source.shape.graphics.lineTo(0,-63);
			source.shape.graphics.lineTo(-10,-48);
			source.shape.graphics.cubicCurveTo(-32,-43,-48,-23,-48,0);
			source.shape.graphics.cubicCurveTo(-48,26,-26,48,0,48);
			source.shape.graphics.cubicCurveTo(27,48,49,26,49,0);
			source.shape.graphics.cubicCurveTo(49,-24,32,-43,10,-48);
			
			source.shape.graphics.endFill();
		}
		
		
		/**
		 * 
		 * 
		 */
		protected function alignPanels():void {
			
			//get bounds
			var outsideBounds:Rectangle = source.getBounds(source.parent);
			outsideBounds.height = outsideBounds.height - window.height;
			var offset:int = 35;
			var diff:Number;
			
			var params:Object = new Object();
			
			//top 
			if (outsideBounds.y < offset) params.y = source.y - outsideBounds.y + offset;
			
			//left
			if (outsideBounds.x < offset) params.x = source.x - outsideBounds.x + offset;
			
			//right
			if (outsideBounds.x + outsideBounds.width > source.stage.stageWidth - offset) {
				diff = (outsideBounds.x + outsideBounds.width) - source.stage.stageWidth + offset;
				params.x = source.x - diff;
			}
			
			//bottom
			if (outsideBounds.y + outsideBounds.height > source.stage.stageHeight) {
				diff = (outsideBounds.y + outsideBounds.height) - source.stage.stageHeight + offset;
				params.y = source.y - diff;
			}
			
			
			//animation
			TweenMax.to(source,1,params);
			
		}
		
		/**
		 * 
		 * @param optionLabel
		 * 
		 */
		public function saveOption(optionSelected:int):void {
			
			source.setFlag(optionSelected);
			
			var data:Object = new Object();
			data.itemUID = source.uid;
			data.stepUID = source.currentStep;
			data.flagUID = source.currentFlag;
			
			turnKnob();
			
			WrkFlowController(source.getController()).addLog(data);
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */
		protected function removeItem(item:DisplayObject):void {
			source.removeChild(item);
		}
		
		//****************** EVENTS ****************** ******************  ****************** 
		
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function tagIt(e:MouseEvent):void {
			source.tagged = !source.tagged;
			source.star.active = source.tagged;
			
			//send to model
			//WrkFlowController(target.getController()).tagPin(target.uid,target.tagged);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function controlPanelSelect(event:Event):void {
			if (source.currentFlag != pinControlPanel.selectedItem) {
				event.stopImmediatePropagation();
				saveOption(pinControlPanel.selectedItem);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function closeBTHandler(event:MouseEvent):void {
			source.changeStatus("deselected");
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseDown(event:MouseEvent):void {
			source.startDrag();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseUp(event:MouseEvent):void {
			source.stopDrag();
		}
		
		
		//****************** EVENTS GESTURE/TOUCH ****************** ******************  ******************
		
		/*protected function biPinTapEvent(event:GestureEvent):void {
			target.tagged = !target.tagged;
			//target.star.active = target.tagged;
			
			//send to model
			WorkflowController(target.getController()).tagPin(target.uid,target.tagged);
		}	
		
		protected function bigPinLongPressBeganEvent(event:GestureEvent):void {
			source.closeBigView();
		}*/
		
	
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getController():WrkFlowController {
			return WrkFlowController(source.getController());
		}
		
		/**
		 * 
		 * 
		 */
		public function close():void {
			
			//kill previous animation
			TweenMax.killTweensOf(window);
			TweenMax.killTweensOf(pinControlPanel);
			TweenMax.killTweensOf(closeBT);
			TweenMax.killTweensOf(source.shape);
			TweenMax.killTweensOf(source);
			
			if (Settings.platformTarget == "mobile") {
				/*bigPinTap.removeEventListener(GestureEvent.GESTURE_RECOGNIZED, biPinTapEvent);
				bigPinTap = null;
				bigPinLongPress.removeEventListener(GestureEvent.GESTURE_BEGAN, bigPinLongPressBeganEvent);
				bigPinLongPress = null*/;
			} else {
				source.shape.removeEventListener(MouseEvent.CLICK, tagIt);
			}
			
			//knob off
			knobShape(false);
			if (knob) source.removeChild(knob);
			
			//anim
			TweenMax.to(source,2,{x:source.originalPosition.x, y:source.originalPosition.y, ease:Back.easeOut});
			TweenMax.from(source.shape,2,{width:source.shapeSize*2, height:source.shapeSize*2, ease:Back.easeOut});
			
			//star
			if (source.tagged) {
				TweenMax.to(source.star,2,{width:source.shapeSize*2, height:source.shapeSize*2, alpha:.5, ease:Back.easeOut});
			} else {
				//source.removeChild(source.star)
			}
			
			//remove panels
			TweenMax.to(pinControlPanel,.4,{scaleX:0, scaleY:0, onComplete:removeItem, onCompleteParams:[pinControlPanel]});
			TweenMax.to(window,.4,{scaleX:0, scaleY:0, x:closeBT.x, y: closeBT.y, alpha:0, onComplete:removeItem, onCompleteParams:[window]});
			TweenMax.to(closeBT,.4,{scaleX:0, scaleY:0, onComplete:removeItem, onCompleteParams:[closeBT]});
			
			window.killPanels();
			
			pinControlPanel.removeEventListener(WrkfluxEvent.SELECT, controlPanelSelect);
			closeBT.removeEventListener(MouseEvent.CLICK, closeBTHandler);
			
			pinControlPanel = null;
			window = null;
			closeBT = null;
			
		}
		
		//****************** GETTERS // SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get source():PinView {
			return _source;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get infoPanel():AbstractPanel {
			return _infoPanel;
		}


	}
}