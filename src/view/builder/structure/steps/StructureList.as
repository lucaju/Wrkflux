package view.builder.structure.steps {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import controller.WrkBuilderController;
	
	import events.WrkfluxEvent;
	
	import model.builder.StepModel;
	
	import util.Directions;
	
	import view.builder.structure.StructureView;
	import view.builder.structure.network.StructureNetwork;
	import view.builder.structure.steps.info.InfoStep;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureList extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target				:StructureView;
		
		protected var _network				:StructureNetwork;
		
		internal var itemCollection			:Array;
		protected var activeStep			:Step;
		protected var infoStep				:InfoStep;
		
		protected var timer					:Timer;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * @param data
		 * 
		 */
		public function StructureList(target:StructureView, data:Array = null) {
			
			//initial
			this.target = target;
			
			//checking data
			if (!data) data = WrkBuilderController(target.getController()).getStepsPreset(1);
			
			//loop
			itemCollection = new Array();
			var step:Step;
			
			var i:int = 0;
			
			for each (var item:StepModel in data) {
				
				step = new Step(item.uid, item.abbreviation, item.shape);
				
				if (item.abbreviation == "") step.label = "Step"+itemCollection.length;
				
				step.x = item.position.x;
				step.y = item.position.y;
				this.addChild(step);
				step.init();
				
				itemCollection.push(step);
				
				//animation
				TweenLite.from(step,.6,{alpha:0, delay:i * 0.05});
				i++;
			}
			
			//listeners
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param source
		 * 
		 */
		protected function showInfo(show:Boolean, source:Step = null):void {
			
			if (show && source) {
				
				var sID:* = (source.id != 0) ? sID = source.id : source.tempID;
				
				infoStep =  new InfoStep(target.getController(), sID);
				this.addChild(infoStep);
				infoStep.init();
				
				infoStep.selectedShape = activeStep.shape;	
				
				//position
				infoStep.x = source.x;
				infoStep.y = source.y - (source.height/2);
				
				//check off screen X
				if (infoStep.x + (infoStep.maxWidth/2) > target.background.width) {
					var offsetX:Number = (infoStep.x + (infoStep.maxWidth/2)) - target.background.width;
					infoStep.x = infoStep.x - offsetX;
					infoStep.arrowOffsetX(offsetX);
				}
				
				//check off screen Y
				var infoStepBounds:Rectangle = infoStep.getBounds(target);
				if (infoStepBounds.y < -20) {
					infoStep.changeOrientation(Directions.TOP);
					infoStep.y = source.y + (source.height/2);
				}
				
				TweenMax.from(infoStep,.6,{y:"10", alpha:0, onComplete:addStageCleanListener});
				
				infoStep.addEventListener(WrkfluxEvent.SELECT, infoStepSelect);
				infoStep.addEventListener(Event.CHANGE, textChange);
				
			
			} else if (!show) {
				
				if (infoStep) {
					TweenMax.to(infoStep,.3,{y:"10", alpha:0, onComplete:removeObject, onCompleteParams:[infoStep]});
					infoStep.removeEventListener(WrkfluxEvent.SELECT, infoStepSelect);
					infoStep.removeEventListener(Event.CHANGE, textChange);
					
					var step:Step = this.getStep(infoStep.stepID);
					step.addRollMouseListeners();
					infoStep = null;
				}
				
				if (stage) stage.removeEventListener(MouseEvent.CLICK, hideStepInfo);
				
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function addStageCleanListener():void {
			stage.addEventListener(MouseEvent.CLICK, hideStepInfo);
		}
		
		/**
		 * 
		 * 
		 */
		protected function changeStepShape():void {
			var step:Step = this.getStep(infoStep.stepID);
			if (step.shape != infoStep.selectedShape) step.changeShape(infoStep.selectedShape);
		}
		
		/**
		 * 
		 * 
		 */
		protected function changeAbbreviation():void {
			var step:Step = this.getStep(infoStep.stepID);
			if (step.label != infoStep.abbreviation) step.label = infoStep.abbreviation;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeObject(value:DisplayObject):void {
			this.removeChild(value);
		}
		
		/**
		 * 
		 * @param step
		 * 
		 */
		protected function removeStep(selectedStep:Step):void {
			
			//Adnimation
			TweenLite.to(selectedStep, .6, {y: this.stage.stageHeight + 100, onComplete:removeObject, onCompleteParams:[selectedStep]});
			
			//remove selected flag from the list
			for each (var step:Step in itemCollection) {
				if (step.id == selectedStep.id) {
					itemCollection.splice(itemCollection.indexOf(selectedStep),1);
					break;
				}
			}
			
			selectedStep.dispatchEvent(new Event(Event.CLOSING,true));
		}
		
		/**
		 * 
		 * 
		 */
		protected function testForMovement():void {
			timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER, moveStep);
			timer.start();
		}
		
		/**
		 * 
		 * 
		 */
		protected function moveStep(event:TimerEvent):void {
			
			//lift
			TweenLite.to(activeStep,.2,{scaleX:1.05, scaleY:1.05});
			activeStep.addGlow(true);
			
			activeStep.positionChanged = true;
			
			//limits
			var limits:Rectangle = new Rectangle(target.background.x, target.background.y, target.background.width, target.background.height);
			
			//refine limits
			limits.x += (activeStep.width/2) - 10;
			limits.y += activeStep.height/2;
			limits.width -= activeStep.width - 10;
			limits.height -= activeStep.height;
			
			//select network lines
			var id:* = (activeStep.id != 0) ? activeStep.id : activeStep.tempID;
			network.selectConnections(id);
			
			//drag
			activeStep.startDrag(false,limits);
			
			//hide options
			activeStep.showOptions(false);
			if (infoStep) this.showInfo(false);
			
			//show delete button
			if (itemCollection.length != 1) target.showDelete(true);
			
			//listeners
			activeStep.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function hideStepInfo(event:MouseEvent):void {
			showInfo(false);
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function infoStepSelect(event:Event):void {
			changeStepShape();
			changeAbbreviation();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function textChange(event:Event):void {
			changeAbbreviation();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseDown(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			if (event.target is Step) {
				
				activeStep = event.target as Step;
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				activeStep.addEventListener(MouseEvent.ROLL_OUT, activeStepRollOut);
				testForMovement();
				
			} else if (event.target is PlusButton) {
				
				var step:Step = event.target.parent as Step; 
				
				var data:Object = new Object();
				data.action = "addConnection";
				data.sourceID = (step.id != 0) ? step.id : step.tempID;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.ADD,data));
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseMove(event:MouseEvent):void {
			if (event.currentTarget == activeStep) {
				
				//update network lines
				network.updateConnectionLine(activeStep);
				
				//If it is not the only step
				if (itemCollection.length != 1) {
					
					//test agains delete button
					target.deleteButton.highlight(activeStep.hitTestObject(target.deleteButton));
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseUp(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			if (timer) {
				timer.stop();
				timer = null;
			}

			var wasMoving:Boolean = false;
			if (activeStep.scaleX > 1) wasMoving = true;
			
			//Was moving
			if (wasMoving) {
				activeStep.stopDrag();
			
				//hide delete button
				target.showDelete(false);
			
				//delete or show info
				if (activeStep.hitTestObject(target.deleteButton)) {
					removeStep(activeStep);
				} else {
					if (activeStep.positionChanged) {
						var data:Object = new Object();
						data.action = "changePosition";
						activeStep.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT,data));
					}
					activeStep.positionChanged = false;
				}
				
				//show options
				activeStep.showOptions(true);
				
				//drop
				TweenLite.to(activeStep,.2,{scaleX:1, scaleY:1});
				activeStep.addGlow(false);
				
				//listeners
				activeStep.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			} else {
				
				//Was NOT moving
				
				//info step checking
				if (!infoStep) {
					showInfo(true,activeStep);
				} else {

					if (infoStep.stepID != activeStep.id) {
						showInfo(false);
						showInfo(true,activeStep);
					} else {
						showInfo(false);
					}
					
				}
				
				//step options
				if (infoStep) {
					activeStep.showOptions(false,"info");
					activeStep.showOptions(true,"plus");
				} else {
					activeStep.showOptions(true);
				}
				
			}
			
			//clean
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			activeStep.removeEventListener(MouseEvent.ROLL_OUT, activeStepRollOut);
			activeStep = null;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function activeStepRollOut(event:MouseEvent):void {
			if (timer) {
				timer.stop();
				timer = null;
			}
			
			activeStep.removeEventListener(MouseEvent.ROLL_OUT, activeStepRollOut);
			
			var wasMoving:Boolean = false;
			if (activeStep.scaleX > 1) wasMoving = true;
			if (!wasMoving) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				activeStep = null;
			}
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param position
		 * 
		 */
		public function addStep(item:Object):void {
			
			var sModel:StepModel = item as StepModel;
			
			var step:Step = new Step(sModel.uid, sModel.abbreviation, sModel.shape);
			step.tempID = sModel.tempID;
			step.x = sModel.position.x;
			step.y = sModel.position.y;
			this.addChild(step);
			step.init();
			
			itemCollection.push(step);
			
			//animation
			TweenLite.from(step,.6,{alpha:0});
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getStep(id:*):Step {
			
			var step:Step;
			
			if (id is int) {
				for each (step in itemCollection) {
					if (step.id == id) return step;
				}
			} else if (id is String) {
				for each (step in itemCollection) {
					if (step.tempID == id) return step;
				}
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getActiveStepUID():int {
			return activeStep.id;
		}
		
		/**
		 * 
		 * @param recentAddedFlags
		 * 
		 */
		public function updateStepsUID(recentAddedSteps:Array):void {
			
			for each (var recentAddedStep:StepModel in recentAddedSteps) {
				
				for each (var step:Step in itemCollection) {
					if (recentAddedStep.tempID == step.tempID) {
						step.id = recentAddedStep.uid;
						step.tempID = "";
						break;
					}
					
				}
				
			}
			
		}
		
		/**
		 * 
		 * @param pen
		 * @param source
		 * @return 
		 * 
		 */
		public function stepHitTest(pen:Sprite, source:int):* {
			for each (var step:Step in itemCollection) {
				if (step.hitTestObject(pen)) {
					if (step.id != source) step.addGlow(true);
					return (step.id != 0) ? step.id : step.tempID;
				} else {
					step.addGlow(false);
				}
			}
		}
		
		/**
		 * 
		 * @param connectionUID
		 * 
		 */
		public function updateInfoStep(connectionUID:*):void {
			if (infoStep) {
				infoStep.addNewLink(connectionUID);
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function checkStrucutureOverlap():Boolean {
			for each (var step:Step in itemCollection) {
				if (itemCollection[itemCollection.indexOf(step)-1]) {
					if (step.hitTestObject(itemCollection[itemCollection.indexOf(step)-1])) return true;
				}
			}
			
			return false;
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get network():StructureNetwork {
			return _network;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set network(value:StructureNetwork):void {
			_network = value;
		}

	}
}