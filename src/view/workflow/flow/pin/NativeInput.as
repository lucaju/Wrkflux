package view.workflow.flow.pin {
	
	//imports
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import events.WrkfluxEvent;
	
	import model.Session;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class NativeInput extends InputAdpter {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var clickCount				:int = 0;						//Count click number [0 - stop drag // 1 - single click // 2 -double click]
		protected var timer						:Timer;							//Timer between single and double click
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param _source
		 * 
		 */
		public function NativeInput(source:PinView) {
			this.source = source;
			
			//setup timer
			timer = new Timer(400,1);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * Add Event Listeners
		 * 
		 */
		override public function addEvents():void {
			source.shape.addEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
		}
		
		/**
		 * Remove Event Listeners
		 * 
		 */
		override public function removeEvents():void {
			source.shape.removeEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function controlMouseDown(event:MouseEvent):void {
			
			//test for movement
			if (Session.credentialCheck()) source.addEventListener(MouseEvent.MOUSE_MOVE, pinStartDrag);
			
			source.addEventListener(MouseEvent.MOUSE_UP, pinClick);
			
			//bring to front
			source.parent.setChildIndex(source,source.parent.numChildren-1);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function pinStartDrag(e:MouseEvent):void {
			
			//save position
			source._originalPosition = {x:source.x, y:source.y};
			clickCount = 0;
			
			//dragging
			source.startDrag(true);
			
			//Start pinTrail
			if (!source.pinTrail) source.pinTrail.start();;
			
			//listeners
			source.removeEventListener(MouseEvent.MOUSE_MOVE, pinStartDrag);
			source.removeEventListener(MouseEvent.MOUSE_UP, pinClick);
			
			source.addEventListener(MouseEvent.MOUSE_MOVE, pinMoving);
			source.addEventListener(MouseEvent.MOUSE_UP, pinEndDrag);
			
			//dispatch event
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "start"));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinMoving(event:MouseEvent):void {
			//dispatch event
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "update"));	
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function pinEndDrag(e:MouseEvent):void {
			//stop draggin
			source.stopDrag();
			
			//stop pinTrail
			if (!source.pinTrail) source.pinTrail.stop();
			
			//listeners
			source.removeEventListener(MouseEvent.MOUSE_MOVE, pinMoving);
			source.removeEventListener(MouseEvent.MOUSE_UP, pinEndDrag);
			
			//dispatch event
			source.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.DRAG_PIN, null, "end"));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinClick(event:MouseEvent):void {
			
			//test for single or double click
			if (!timer.running) {
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, testforMultipleClicks);
				timer.start();
			}
			
			//add to click count
			clickCount++;
			
			//listeners
			source.removeEventListener(MouseEvent.MOUSE_MOVE, pinStartDrag);
			source.removeEventListener(MouseEvent.MOUSE_UP, pinClick);
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function testforMultipleClicks(e:TimerEvent):void {
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, testforMultipleClicks);
			timer.reset();
			
			switch(clickCount) {
				case 1:
					source.changeStatus("selected");
					break;
				case 2:
					source.changeStatus("edit");
					break;
			}
			
			//reset clickCount
			clickCount = 0;
			
		}
	}
	
}