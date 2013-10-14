package view.workflow.flow.pin {
	
	//imports
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.utils.Timer;
	
	import events.WrkfluxEvent;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.TapGesture;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class GestouchInput extends InputAdpter {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var tap					:TapGesture					//mutltitouch gestures
		protected var longPress				:LongPressGesture				//mutltitouch gestures
		protected var timer					:Timer;							//Timer between single and double click
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param _source
		 * 
		 */
		public function GestouchInput(source:PinView) {
			
			trace ("??")
			
			this.source = source;
			
			tap = new TapGesture(source.shape);
			longPress = new LongPressGesture(source.shape);
			
			//setup timer
			timer = new Timer(400,1);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * Add Scroll Event Listeners
		 * 
		 */
		override public function addEvents():void {
			
			source.shape.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			
			tap.addEventListener(GestureEvent.GESTURE_RECOGNIZED, tapEvent);
			longPress.addEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
			
		}
		
		/**
		 * Remove Scroll Event Listeners
		 * 
		 */
		override public function removeEvents():void {
			
			source.shape.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			
			tap.removeEventListener(GestureEvent.GESTURE_RECOGNIZED, tapEvent);
			longPress.removeEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function tapEvent(event:GestureEvent):void {
			source.changeStatus("selected");
			
			//Dispatch Event
			var data:Object = {};
			data.id = source.uid;
			data.status = source.status;
			
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data, source.status));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function longPressBeganEvent(event:GestureEvent):void {
			
			//trace ("longPress");
			
			source.shape.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			source.shape.removeEventListener(TouchEvent.TOUCH_END, touchMoveEnd);
			source.shape.removeEventListener(TouchEvent.TOUCH_OUT, touchMoveOut);
			
			source.changeStatus("edit");
			
			//Dispatch Event
			var data:Object = {};
			data.id = source.uid;
			data.status = source.status;
			
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT, data, source.status));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchBegin(event:TouchEvent):void {
			
			//trace ("touch Begin")
			
			//dragging
			source.startTouchDrag(event.touchPointID);
			
			//move to front
			source.parent.setChildIndex(source,source.parent.numChildren-1);
			
			if (source.bigPin) {
				source.shape.addEventListener(TouchEvent.TOUCH_END, touchMoveEndBigPin);
			} else {
				
				//save position
				source._originalPosition = {x:source.x, y:source.y};
				
				//Start pinTrail
				if (!source.pinTrail) source.pinTrail.start();;
				
				source.shape.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
				source.shape.addEventListener(TouchEvent.TOUCH_END, touchMoveEnd);
				source.shape.addEventListener(TouchEvent.TOUCH_OUT, touchMoveOut);
				
				source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "start"));
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchMove(event:TouchEvent):void {
			
			if (timer.running) timer.reset();
			
			//listeners
			longPress.removeEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
			
			//dispatch event
			
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "update"));
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchMoveEnd(event:TouchEvent):void {
			//	trace ("TouchEndMOve")
			touchEnd(event.touchPointID);
			
			if (timer.running) timer.reset();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchMoveOut(event:TouchEvent):void {
			//trace ("TouchMoveOUT");
			var touchId:int = event.touchPointID;
			
			if (!timer.running) {
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeOut);
				timer.start();
			}
			
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "update"));
			
			function timeOut(event:TimerEvent):void {
				//trace ("endOutiside")
				
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timeOut);
				timer.reset();
				
				source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "update"));
				
				touchEnd(touchId);
			}
		}
		
		/**
		 * 
		 * @param touchID
		 * 
		 */
		protected function touchEnd(touchID:int):void {
			
			//trace ("TouchendFinal")
			
			//stopDrag
			source.stopTouchDrag(touchID);
			
			//stop pinTrail
			if (!source.pinTrail) source.pinTrail.stop();
			
			//listeners
			longPress.addEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
			
			source.shape.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			source.shape.removeEventListener(TouchEvent.TOUCH_END, touchMoveEnd);
			source.shape.removeEventListener(TouchEvent.TOUCH_OUT, touchMoveOut);
			
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "end"));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchMoveEndBigPin(event:TouchEvent):void {
			source.stopTouchDrag(event.touchPointID);
		}
		
	}
}