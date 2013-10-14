package view.workflow.flow {
	
	//imports
	import com.coreyoneil.collision.CollisionList;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import view.workflow.flow.pin.PinView;
	import view.workflow.structure.steps.Step;
	import view.workflow.InterfaceSuport;
	import settings.Settings;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlowList extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target				:FlowView;
		protected var collisionList			:CollisionList;
		internal var itemCollection			:Array;
		
		protected var _openedItems			:Array;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * @param data
		 * 
		 */
		public function FlowList(target:FlowView, data:Array = null) {
			
			this.target = target;
			
			//array
			itemCollection = new Array();
			_openedItems = new Array();
			
			//loop
			if (data) {
				
				var pinView:PinView;		
				var posY:Number = 0;
				var posX:Number = 0;
				var i:int = 0;
				
				for each (var doc:Object in data) {
					
					pinView = new PinView(target.getController(),doc.uid);
					
					pinView.currentFlag = doc.currentFlag;
					pinView.tagged = false//data.isTagged;
					pinView.currentStep = doc.currentStep;
					
					this.addChild(pinView);
					pinView.init();
					
					itemCollection.push(pinView);
					
					//------Pin position and step count box
					InterfaceSuport.calculateRelativePinPosition(pinView);
					
					/*var stepBounds:Rectangle;
					
					var stepContainer:Step = target.structureView.getStep(pinView.currentStep);
					stepBounds = stepContainer.getPositionForPin();
					
					//for retina display
					if (Settings.platformTarget == "Mobile") { 
						stepBounds.width = stepBounds.width * 2;
						stepBounds.height = stepBounds.height * 2;
						pinView.scaleX = pinView.scaleY = 2;
					}
					
					var ratioX:Number = Math.random(); // **
					var ratioY:Number = Math.random(); // **
					
					pinView.ratioPos = {w:ratioX, h:ratioY};
					
					//random position inside the step active area.
					var xR:Number = stepBounds.x + pinView.width/2 + (ratioX * (stepBounds.width - pinView.width));
					var yR:Number = stepBounds.y + pinView.height/2 + (ratioY * (stepBounds.height - pinView.height));
					
					pinView.x = xR;
					pinView.y = yR;*/
						
					TweenMax.from(pinView,1.5,{alpha:0, scaleX:0, scaleY:0, delay:1+(i*.05), ease:Back.easeOut});
					
					i++;
				}
				
			}
			
			
			this.addEventListener(WrkfluxEvent.DRAG_PIN, hitTest);
			this.addEventListener(WrkfluxEvent.ACTIVATE_PIN, pinOpened);
			this.addEventListener(WrkfluxEvent.SELECT, pinSelected);
			
		}		
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param pin
		 * @param stepCollided
		 * 
		 */
		protected function updatePinStep(pin:PinView, stepCollided:Step):void {
			//update info
			pin.currentStep = stepCollided.id;
			pin.setFlag();
			
			//update position
			pin.updatePosition(pin.x,pin.y);
			
			//update supporting position info
			var stepBounds:Rectangle = stepBounds = stepCollided.getPositionForPin();
			
			var globalP:Point = new Point(pin.x, pin.y); 
			var localP:Point = stepCollided.globalToLocal(globalP);
			
			var xR:Number = localP.x/stepBounds.width;
			var yR:Number = localP.y/stepBounds.height;
			
			pin.ratioPos = {w:xR, h:yR};
				
			//broadcast update
			var data:Object = new Object();
			data.itemUID = pin.uid;
			data.stepUID = pin.currentStep;
			data.flagUID = pin.currentFlag;
			
			WrkFlowController(target.getController()).addLog(data);
		}	
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function addToOpenedPins(pinUID:int):void {
			var pin:PinView = this.getItem(pinUID);
			_openedItems.push(pin);
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeFromOpenedPins(pinUID:int):void {
			for each (var pin:PinView in _openedItems) {
				if (pin.uid == pinUID) {
					_openedItems.splice(_openedItems.indexOf(pin),1);
					break;
				}
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
		protected function pinOpened(event:WrkfluxEvent):void {
			if (event.data.open) {
				this.addToOpenedPins(event.data.pinUID);
			} else {
				this.removeFromOpenedPins(event.data.pinUID);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function hitTest(event:WrkfluxEvent):void {
			
			var step:Step;
			var collisions:Array;
			var collision:Object;
			var stepCollided:Step;
			var pin:PinView = event.target as PinView;
			var structureElements:Array = target.structureView.getAllSteps();
			
			
			switch (event.phase) {
				
				
				case "start":
					
					//button
					target.switchAddRemoveButton("remove")
				
					//define collission set
					collisionList = new CollisionList(pin);
					for each (step in structureElements) {
						collisionList.addItem(step);
					}
					
					break;
				
				case "update":
					
					//delete button
					target.removeButton.highlight(target.removeButton.hitTestObject(pin));
					
					//highlight step
					for each(step in structureElements) {
						step.highlight(false);
					}
					
					//step  collissions
					collisions = collisionList.checkCollisions();
					if (collisions.length) {
						collision = collisions[0];
						
						if (collision.overlapping.length > 200) { //threshold
							stepCollided = collision.object2 as Step;
							
							if (stepCollided.id != pin.currentStep) stepCollided.highlight(true);
						}
					}
					
					
					break;
				
				case "end":
					
					//Change buttons
					target.removeButton.highlight(false);
					target.switchAddRemoveButton("add");
					
					//delete
					if (target.removeButton.hitTestObject(pin)) {
						var pos:Point = new Point(this.stage.stageWidth/2,this.stage.stageHeight);
						pos = this.globalToLocal(pos);
						TweenMax.to(pin, .5, {x:pos.x, y:pos.y + pin.height})
						target.showWarningRemoveItem(pin.uid);
						break;
						break;
					}
					
					//Step highlight
					for each(step in structureElements) {
						step.highlight(false);
					}
					
					//collissio
					collisions = collisionList.checkCollisions();
					if (collisions.length) {
						collision = collisions[0];
						
						if (collision.overlapping.length > 200) {	//threshold
							stepCollided = collision.object2 as Step;
							
							if (stepCollided.id != pin.currentStep) this.updatePinStep(pin,stepCollided)
							
						}
						
					} else {
						//no colisison: Go back
						TweenMax.to(pin,1,{x:pin.originalPosition.x, y:pin.originalPosition.y, ease:Back.easeOut});
					}
					
					collisions = null;
					
					break;
				
				
			}
			
		}	
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function addItem(data:Object):void{
			
			var pinView:PinView = new PinView(target.getController(),data.uid);
			
			pinView.currentFlag = data.currentFlag;
			pinView.tagged = false//data.isTagged;
			pinView.currentStep = data.currentStep;
			
			this.addChild(pinView);
			pinView.init();
			
			itemCollection.push(pinView);
			
			//------Pin position and step count box
			InterfaceSuport.calculateRelativePinPosition(pinView);
			/*
			var stepBounds:Rectangle;
			
			var stepContainer:Step = target.structureView.getStep(pinView.currentStep);
			stepBounds = stepContainer.getPositionForPin();
			
			//for retina display
			if (Settings.platformTarget == "mobile") { 
				stepBounds.width = stepBounds.width * 2;
				stepBounds.height = stepBounds.height * 2;
				pinView.scaleX = pinView.scaleY = 2;
			}
			
			var ratioX:Number = Math.random(); // **
			var ratioY:Number = Math.random(); // **
			
			pinView.ratioPos = {w:ratioX, h:ratioY};
			
			//random position inside the step active area.
			var xR:Number = stepBounds.x + pinView.width/2 + (ratioX * (stepBounds.width - pinView.width));
			var yR:Number = stepBounds.y + pinView.height/2 + (ratioY * (stepBounds.height - pinView.height));
			
			//transform from local to global
			var pLocal:Point = new Point(xR,yR);
			trace (stepContainer.parent.parent)
			var pGlobal:Point = stepContainer.parent.parent.localToGlobal(pLocal);
			
			pGlobal.x = pGlobal.x// - offsetX;
			pGlobal.y = pGlobal.y// - offsetY;
			
			pinView.x = pGlobal.x;
			pinView.y = pGlobal.y;*/
			
			//animation
			TweenMax.from(pinView,1.5,{x:this.stage.stageWidth/2, y:this.stage.stageWidth/2, ease:Back.easeOut});
			
		}
		
		/**
		 * 
		 * @param uid
		 * 
		 */
		public function getItem(uid:int):PinView {
			for each (var pin:PinView in itemCollection) {
				if (pin.uid == uid) return pin;
			}
 			return null
		}
		
		/**
		 * 
		 * @param uid
		 * 
		 */
		public function removeItem(uid:int):Boolean {
			for each (var pin:PinView in itemCollection) {
				if (pin.uid == uid) {
					itemCollection.splice(itemCollection.indexOf(pin),1);
					this.removeChild(pin);
					return true;
					break;
				}
			}
			return false;
		}
		
		/**
		 * 
		 * @param uid
		 * 
		 */
		public function sendPinBack(uid:int):void {
			var pin:PinView = getItem(uid);
			TweenMax.to(pin,1,{x:pin.originalPosition.x, y:pin.originalPosition.y, ease:Back.easeOut});
		}
		
		/**
		 * 
		 * @param pinUID
		 * @param state
		 * 
		 */
		public function activatePin(pinUID:int, state:Boolean):void {
			var pin:PinView = this.getItem(pinUID);
			if (state) {
				pin.openBigView();
				this.addToOpenedPins(pinUID);
			} else {
				pin.closeBigView();
				this.removeFromOpenedPins(pinUID);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		public function closeAllOpenedPins():void {
			if (_openedItems.length > 0) {
				var openned:Array = _openedItems.concat();
				for each (var pin:PinView in openned) {
					pin.closeBigView();
					removeFromOpenedPins(pin.uid);
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinSelected(event:Event):void {
			//trace ("oi")
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get openedItems():Array {
			return _openedItems.concat();
		}

	}
}