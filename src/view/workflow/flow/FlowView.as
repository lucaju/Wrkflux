package view.workflow.flow {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import model.Session;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	
	import view.tooltip.ToolTipManager;
	import view.workflow.flow.pin.PinView;
	import view.workflow.structure.StructureView;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlowView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var flowList				:FlowList;
		protected var addButton				:CrossButton;
		protected var _removeButton			:CrossButton;
		
		protected var _structureView		:StructureView;
		
		protected var addForm				:AddForm;
		protected var removeForm			:RemoveForm;
		
		protected var toolTipManager		:ToolTipManager;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function FlowView(c:IController) {
			super(c);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//FLOW
			var flowData:Array = WrkFlowController(this.getController()).getFlow();
			
			flowList = new FlowList(this,flowData);
			flowList.x = 5;
			flowList.y = 5;
			this.addChild(flowList);
			flowList.addEventListener(WrkfluxEvent.SELECT, manageToolTip);
			
			if (Session.credentialCheck()) {
				
				//add button
				addButton = new CrossButton();
				addButton.color = Colors.getColorByName(Colors.WHITE);
				addButton.highlightedColor = Colors.getColorByName(Colors.GREEN);
				addButton.crossColor = Colors.getColorByName(Colors.GREEN);
				addButton.lineThickness = 2;
				addButton.lineColor = Colors.getColorByName(Colors.GREEN);
				addButton.init();
				addButton.buttonMode = true;
				addButton.x = (stage.stageWidth/2) - this.x;
				addButton.y = stage.stageHeight - (addButton.height * 2);
				this.addChild(addButton);
			
				//listeners
				this.addButton.addEventListener(MouseEvent.CLICK, addButtonClick);
			
				//delete button
				_removeButton = new CrossButton();
				removeButton.rotation = 45;
				removeButton.init();
				removeButton.x = (stage.stageWidth/2) - this.x;
				removeButton.y = stage.stageHeight;
				removeButton.mouseEnabled = false;
				this.addChild(removeButton);
				removeButton.visible = false;
			}
			
			//tooltip
			toolTipManager = new ToolTipManager(this);
			stage.addEventListener(MouseEvent.CLICK, ToolTipManager.removeAll);
			
		}
			
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		
		/**
		 * 
		 * @param object
		 * 
		 */
		protected function removeObject(object:DisplayObject):void {
			this.removeChild(object);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function addButtonClick(event:MouseEvent):void {
			showAddForm(true);
		}

		/**
		 * 
		 * @param event
		 * 
		 */
		protected function formEvent(event:WrkfluxEvent):void {
			
			event.stopImmediatePropagation();
			
			switch (event.data.action) {
				
				case "addCanceled":
					showAddForm(false);
					break;
					
				case "removeCanceled":
					showRemoveForm(false);
					flowList.sendPinBack(event.data.uid);
					break;
				
				case "addItem":
					WrkFlowController(this.getController()).addDoc(event.data);
					break;
				
				case "removeItem":
					WrkFlowController(this.getController()).removeDoc(event.data.uid);
					break;
			
			}
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function switchAddRemoveButton(value:String):void {
			
			if (addButton && removeButton) {
			
				switch (value) {
					
					case "add":
						TweenLite.to(addButton,.4,{y:stage.stageHeight - addButton.height*2, autoAlpha:1});
						TweenLite.to(removeButton,.4,{y:stage.stageHeight, autoAlpha:0});
						break;
					
					
					case "remove":
						TweenLite.to(addButton,.4,{y:stage.stageHeight, autoAlpha:0});
						TweenLite.to(removeButton,.4,{y:stage.stageHeight - removeButton.height*2, autoAlpha:1});
						break
					
				}
				
			}
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function showAddForm(value:Boolean):void {
			
			if (value) {
				
				addForm = new AddForm(this.getController());
				this.addChild(addForm);
				addForm.init();
				
				var pos:Point = new Point(this.stage.stageWidth/2,this.stage.stageHeight);
				pos = this.globalToLocal(pos);
				
				addForm.x = pos.x - (addForm.maxWidth/2);
				addForm.y = pos.y - addForm.height - 5;
				
				addForm.addEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
				
				TweenLite.from(addForm,.6,{y:this.stage.stageHeight});
				
			} else {
				addForm.removeEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
				addForm.mouseChildren = false;
				TweenLite.to(addForm,.6,{y:this.stage.stageHeight, onComplete:removeObject, onCompleteParams:[addForm]});
				addForm = null;
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function showRemoveForm(value:Boolean, itemUID:int = 0):void {
			
			if (value) {
				
				removeForm = new RemoveForm(this.getController(), itemUID);
				this.addChild(removeForm);
				
				var pos:Point = new Point(this.stage.stageWidth/2,this.stage.stageHeight);
				pos = this.globalToLocal(pos);
				
				removeForm.x = pos.x - (removeForm.maxWidth/2);
				removeForm.y = pos.y - removeForm.height - 5;
				
				removeForm.addEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
				
				TweenLite.from(removeForm,.6,{y:this.stage.stageHeight});
				
			} else {
				removeForm.removeEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
				removeForm.mouseChildren = false;
				TweenLite.to(removeForm,.6,{y:this.stage.stageHeight, onComplete:removeObject, onCompleteParams:[removeForm]});
				removeForm = null;
			}
		}
		
		/**
		 * 
		 * @param uid
		 * 
		 */
		public function showWarningRemoveItem(uid:int):void {
			showRemoveForm(true,uid)
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */
		public function addItem(data:Object):void {
			flowList.addItem(data);
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */
		public function removeItem(uid:int):void {
			flowList.removeItem(uid);
		}
		
		/**
		 * 
		 * @param pinUID
		 * @param state
		 * 
		 */
		public function activatePin(pinUID:int, state:Boolean):void {
			flowList.activatePin(pinUID, state);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getOpenedItems():Array {
			return flowList.openedItems;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlowItems():Array {
			return flowList.itemCollection;
		}
		
		/**
		 * 
		 * 
		 */
		public function closeAllOpenedPins():void {
			flowList.closeAllOpenedPins();			
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			if (addButton) {
				addButton.x = stage.stageWidth/2 - this.x;
				addButton.y = stage.stageHeight - addButton.height * 2;
			}
			
			if (removeButton) {
				removeButton.x = stage.stageWidth/2 - this.x;
				removeButton.y = stage.stageHeight;
			}
			
			var pos:Point = new Point(this.stage.stageWidth/2,this.stage.stageHeight);
			pos = this.globalToLocal(pos);
			
			if  (addForm) {
				addForm.x = pos.x - (addForm.maxWidth/2);
				addForm.y = pos.y - addForm.height - 5;
			}
			
			if  (removeForm) {
				removeForm.x = pos.x - (removeForm.maxWidth/2);
				removeForm.y = pos.y - removeForm.height - 5;
			}
		}
		
		//****************** EVENTS - TOOLTIP ****************** ****************** ******************
		
		/**
		 * Add or remove tooltip depending on the pinView status
		 * 
		 * @param pin
		 * @param status
		 * 
		 */
		public function manageToolTip(event:WrkfluxEvent):void {

			if (!ToolTipManager.hasToolTip(event.data.pinUID)) {
				var pin:PinView = flowList.getItem(event.data.pinUID);
				
				if (!pin.bigView && !(event.data.open)) {
				
					pin.pulse();
					
					var data:Object = new Object();
					data.position = new Point(pin.x,pin.y);
					data.source = pin;
					data.id = pin.uid;
					data.info = WrkFlowController(this.getController()).getDocTitle(pin.uid);
					
					ToolTipManager.addToolTip(data);
				}
			
			} else {
				ToolTipManager.removeToolTip(event.data.pinUID);
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			
			if (addButton) {
				addButton.kill();
				addButton.removeEventListener(MouseEvent.CLICK, addButtonClick);
			}
			
			if (removeButton) removeButton.kill();
			
			stage.removeEventListener(MouseEvent.CLICK, ToolTipManager.removeAll);
			
			if (addForm) {
				addForm.kill();
				addForm.removeEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
			}
			
			if (removeForm) {
				removeForm.kill();
				removeForm.removeEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
			}
			
			if (flowList) {
				flowList.removeEventListener(WrkfluxEvent.SELECT, manageToolTip);
				flowList.kill();
			}
			
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get removeButton():CrossButton {
			return _removeButton;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get structureView():StructureView {
			return _structureView;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set structureView(value:StructureView):void {
			if (!_structureView) _structureView = value;
		}

	}
}