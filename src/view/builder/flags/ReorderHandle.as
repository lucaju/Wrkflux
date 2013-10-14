package view.builder.flags {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	internal class ReorderHandle extends EventDispatcher {
		
		//****************** Properties ****************** ****************** ******************
		
		static protected var instance			:ReorderHandle;
		
		static protected var selfStarted		:Boolean;
		
		protected var source					:FlagList;
		protected var target					:Flag;
		
		protected var progress					:Boolean;
		protected var timer						:Timer;
		
		
		//****************** STATIC START ****************** ****************** ******************
		
		/**
		 * 
		 * @param source
		 * @param target
		 * 
		 */
		static public function start(source:FlagList, target:Flag):void {
			selfStarted = !selfStarted;
			instance = new ReorderHandle(source,target);
		}
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param source
		 * @param target
		 * 
		 */
		public function ReorderHandle(source:FlagList, target:Flag) {
			
			if (selfStarted) {
				
				selfStarted = !selfStarted;
				
				this.source = source;
				this.target = target;
				
				source.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
				target.addEventListener(MouseEvent.ROLL_OUT, rollOut);
				
				//start timer
				timer = new Timer(200,1);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
				
			} else {
				throw new Error("You cannot build this class directly. Call the static function 'start' instead.")
			}
			
		}
		
		
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function getInstance():ReorderHandle {
			return instance;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param referenceFlag
		 * 
		 */
		protected function moveFlag(referenceFlag:Flag):void {
			
			//offset - it is moving up or down?
			var offset:Number;
			if (target.order > referenceFlag.order) {
				offset = 1;
			} else {
				offset = -1;
			}
			
			//remove timer templorarily 
			timer.removeEventListener(TimerEvent.TIMER, mouseMove);
			
			//save reference flag order
			var referenceFlagOrder:int = referenceFlag.order;
			
			//reorganize list according to the directions offset
			if (offset == -1) source.itemCollection.sortOn("order", Array.DESCENDING);
			
			//loop - evaluate and change other flags order
			var flag:Flag;
			for each (flag in source.itemCollection) {
				
				///direction 
				switch(offset) {
					
					case 1:	//up - if the flag is in between the target and the reference
						if (flag.order < target.order && flag.order >= referenceFlag.order) {
							flag.order += offset;
						}
						break;
					
					case -1: //down  - if the flag is in between the target and the reference
						if (flag.order > target.order && flag.order <= referenceFlag.order) {
							flag.order += offset;
						}
						
						break;
				}
				
			}
			
			//change target flag order
			target.order = referenceFlagOrder;
			
			//resort list according to the new order
			source.itemCollection.sortOn("order");
			
			//loop - animation
			var posX:Number = 0;
			for each (flag in source.itemCollection) {
				if (flag != target) TweenLite.to(flag, .3, {y:posX, delay:flag.id * 0.02, onComplete:restartListening});
				posX += flag.height + source.gap;
			}
			
			//restart listeners
			function restartListening():void {
				if (timer) timer.addEventListener(TimerEvent.TIMER, mouseMove);
			}
		
		}
		
		/**
		 * 
		 * 
		 */
		protected function endMovement():void {
			
			progress = false;
			
			//stop timer
			timer.removeEventListener(TimerEvent.TIMER, mouseMove);
			
			//move target to the new place
			var location:Number = target.order * (target.height + source.gap)
			TweenLite.to(target, .3, {y:location});
			
			//send final data
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			//Kill
			kill();
		}
		
		/**
		 * 
		 * 
		 */
		protected function kill():void {
			
			//stop listeners
			target.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			timer.removeEventListener(TimerEvent.TIMER, mouseMove);
			source.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			//timer
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
			
			
			//restart actions
			source.restarActions();
			
			//target settings
			target.labelTF.selectable = true;
			
			//garbage
			instance = null;
			target = null;
			source = null;
			
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOut(event:MouseEvent):void {
			this.kill();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onTimer(event:TimerEvent):void {
			
			progress = true;
			
			//remove listeners
			target.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			//timer
			timer = new Timer(350);
			timer.addEventListener(TimerEvent.TIMER, mouseMove);
			timer.start();
			
			//drag
			var limits:Rectangle = new Rectangle(0,0,0,source.currentHeight);
			target.startDrag(false,limits);
			
			source.swapChildren(target,source.getChildAt(source.numChildren-1));
			
			//target settings
			target.labelTF.selectable = false;
			target.mouseChildren = false;
			
			//Stop actions
			source.stopActions()
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseMove(event:TimerEvent):void {
			
			//Evaluate point
			var location:Point = new Point(target.mouseX,target.mouseY)
			location = target.localToGlobal(location);
			
			//objects under the point
			var objects:Array = source.stage.getObjectsUnderPoint(location);
			
			//if there is more then one object underteath.
			if (objects.length > 1) {
				
				//loop
				for each (var object:DisplayObject in objects) {
					
					//different from itself
					if (object.parent != target) {
						
						//that is a Flag
						if (object.parent is Flag) {
							var itemUnder:Flag = object.parent as Flag;
							moveFlag(itemUnder);
							break;
						}
						
					}
					
				}
				
			}
			
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseUp(event:MouseEvent):void {
			target.stopDrag();
			(progress) ? endMovement() : kill();
		}
		
	}
}