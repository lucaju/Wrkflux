package view.util.scroll {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	
	import util.DeviceInfo;
	import settings.Settings;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class NativeInput extends InputAdpter {
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param _source
		 * 
		 */
		public function NativeInput(_source:Scroll) {
			source = _source;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * Add Scroll Event Listeners
		 * 
		 */
		override public function addEvents():void {
			source.target.parent.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);			
			source.target.parent.addEventListener(TransformGestureEvent.GESTURE_PAN, handlePan);
			if (source.roll) source.roll.addEventListener(MouseEvent.MOUSE_DOWN, rollDown);
			if (Settings.platformTarget == "web") source.target.parent.addEventListener(MouseEvent.MOUSE_WHEEL, scrollList); //web browser
		}
		
		/**
		 * Remove Scroll Event Listeners
		 * 
		 */
		override public function removeEvents():void {
			source.target.parent.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);			
			source.target.parent.removeEventListener(TransformGestureEvent.GESTURE_PAN, handlePan);
			if (source.roll) source.roll.removeEventListener(MouseEvent.MOUSE_DOWN, rollDown);
			if (Settings.platformTarget == "web") source.target.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollList); //web browser
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * Manage MouseDown Event
		 *  
		 * @param event:Event
		 * 
		 */
		protected function handleMouseDown(event:MouseEvent):void {
			
			event.stopPropagation();
			
			source.speed.y = 0;
			source.speed.x = 0;
			source.tweenComplete();
			
			//dispatch event
			source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"stop", source.target.x, source.target.y));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollDown(event:MouseEvent):void {
			
			event.stopPropagation();
			
			var limits:Rectangle = new Rectangle(0,0,0,source._hMax - source.height);
			source.roll.startDrag(false,limits);
			
			source.roll.addEventListener(Event.ENTER_FRAME, rollMove);
			source.roll.addEventListener(MouseEvent.MOUSE_UP, rollUp);
			source.roll.addEventListener(MouseEvent.RELEASE_OUTSIDE, rollUp);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollMove(event:Event):void {
			source.target.y = - source.roll.y * source.ratePageY;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollUp(event:MouseEvent):void {
			source.roll.stopDrag();
			
			source.roll.removeEventListener(Event.ENTER_FRAME, rollMove);
			source.roll.removeEventListener(MouseEvent.MOUSE_UP, rollUp);
			source.roll.removeEventListener(MouseEvent.RELEASE_OUTSIDE, rollUp);
		}
		
		/**
		 * Manage Pan Gesture Event
		 * 
		 * @param e:transformGestureEvent
		 * 
		 */
		protected function handlePan(event:TransformGestureEvent):void {
			
			event.stopPropagation();
			
			//1.
			switch (source.direction) {
				
				case "vertical":
					if (DeviceInfo.os() != "Mac") {
						source.target.y += 2 * (event.offsetY);
						if (source.roll) source.roll.y = source.target.y / source.ratePageY;
					} else {
						source.target.y -= 2 * (event.offsetY);
						if (source.roll) {
							if (source.roll.y >= 0) {
								source.roll.y = -source.target.y / source.ratePageY;
							}
						}
					}
					break;
				
				
				case "horizontal":
					if (DeviceInfo.os() != "Mac") {
						source.target.x += 2 * (event.offsetX);
						if (source.roll) source.roll.x = source.target.x / source.ratePageX;
					} else {
						source.target.x -= 2 * (event.offsetX);
						if (source.roll) source.roll.x = -source.target.x / source.ratePageX;
					}
					break;
				
				
				case "both":
					if (DeviceInfo.os() != "Mac") {
						
						source.target.x += 2 * (event.offsetX);
						source.target.y += 2 * (event.offsetY);
						
						if (source.roll) source.roll.x = source.target.x / source.ratePageX;
						if (source.roll) source.roll.y = source.target.y / source.ratePageY;
						
					} else {
						
						source.target.x -= 2 * (event.offsetX);
						source.target.y -= 2 * (event.offsetY);
						
						if (source.roll) source.roll.x = -source.target.x / source.ratePageX;
						if (source.roll) source.roll.y = -source.target.y / source.ratePageY;
					}
					break;
				
			}
			
			//2. Event Phases
			switch (event.phase) {
				
				case "begin":
					source.removeEventListener(Event.ENTER_FRAME, source.throwObject);
					TweenMax.killChildTweensOf(source);
					if (source.roll) source.roll.alpha = 1;
					if (source.track) source.track.alpha = 1;
					
					if (source.speed.x * -event.offsetX <= 0) source.speed.x = 0;
					if (source.speed.y * -event.offsetY <= 0) source.speed.y = 0;
					
					//dispatch event
					source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, event.phase, source.target.x, source.target.y, source.speed.x, source.speed.y));
					
					break;
				
				case "update":
					source.removeEventListener(Event.ENTER_FRAME, source.throwObject);
					
					if (DeviceInfo.os() != "Mac") {
						source.speed.x += event.offsetX;
						source.speed.y += event.offsetY;
					} else {
						
						if (event.offsetX == 0) {
							source.speed.x = 0;
						} else {
							source.speed.x -= event.offsetX;
						}
						
						if (event.offsetY == 0) {
							source.speed.y = 0;
						} else {
							source.speed.y -= event.offsetY;
						}
						
						//dispatch event
						source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, event.phase, source.target.x, source.target.y, source.speed.x, source.speed.y));
					}
					
					break;
				
				case "end":
					//target.parent.mouseChildren = false;
					source.addEventListener(Event.ENTER_FRAME, source.throwObject);
					source.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA, "start", source.target.x, source.target.y, source.speed.x, source.speed.y));
					break;
			}
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function scrollList(event:MouseEvent):void {
			
			event.stopPropagation();
			
			source.removeEventListener(Event.ENTER_FRAME, source.throwObject);
			TweenMax.killChildTweensOf(source);
			
			if (source.roll) source.roll.alpha = 1;
			if (source.track) source.track.alpha = 1;
			
			source.speed.y += event.delta;													//define scroll speed
			
			source.addEventListener(Event.ENTER_FRAME, source.throwObject);
			source.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA, "start", source.target.x, source.target.y, source.speed.x, source.speed.y));
		}
	}
	
}