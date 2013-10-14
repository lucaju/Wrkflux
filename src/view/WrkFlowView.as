package view {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TweenProxy;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
	import view.assets.menu.MenuDirection;
	import view.forms.MessageWindow;
	import view.tooltip.ToolTipManager;
	import view.util.progressBar.ProgressBar;
	import view.util.scroll.Scroll;
	import view.util.scroll.ScrollEvent;
	import view.workflow.assets.Background;
	import view.workflow.flow.FlowView;
	import view.workflow.flow.pin.PinView;
	import view.workflow.list.PinListView;
	import view.workflow.structure.StructureView;
	import view.workflow.structure.steps.Step;
	
	import view.workflow.InterfaceSuport;
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkFlowView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var id						:int;
		
		protected var background				:Background
		
		protected var topBar					:TopBar
		
		protected var structureView				:view.workflow.structure.StructureView;
		protected var structureViewMask			:Sprite;
		protected var structureViewScroll		:Scroll;
		
		protected var pinListView				:PinListView;
		protected var flowView					:FlowView;
		
		protected var messageWindow				:MessageWindow;
		
		protected var progressBar				:ProgressBar;
		
		protected var minScale					:Number;
		protected var maxScale					:Number;
		
		protected var offsetX					:Number;
		protected var offsetY					:Number;
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param c
		 * 
		 */
		public function WrkFlowView(c:IController) {
			super(c);
			
			minScale = 1;
			maxScale = 6;
			offsetX = 110;
			//offsetY will be defined after topbar is instanciated
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init(wfID:int = 0):void {
			
			//Background
			background = new Background();
			this.addChild(background);
			
			background.doubleClickEnabled = true;
			
			//action
			if (wfID != 0) {
				this.id = wfID;
				WrkFlowController(this.getController()).loadWorkflow(wfID)
			}
			
			//1. top bar
			topBar = new TopBar();
			this.addChild(topBar);
			topBar.init();
			
			topBar.label = WrkFlowController(this.getController()).getLabel();
			topBar.addMenu(WrkFlowController(this.getController()).getMenuOptions("right"),MenuDirection.RIGHT);
			
			TweenLite.from(topBar,.6,{y:-topBar.height,delay:.6});
			
			//listenerts
			topBar.addEventListener(WrkfluxEvent.SELECT, topBarActions);
			
			var contr:WrkFlowController = WrkFlowController(this.getController());
			contr.getModel("wrkflow").addEventListener(WrkfluxEvent.COMPLETE, processComplete);
			contr.getModel("wrkflow").addEventListener(WrkfluxEvent.ADD, pinAdded);
			contr.getModel("wrkflow").addEventListener(WrkfluxEvent.UPDATE_PIN, pinUpdated);
			contr.getModel("wrkflow").addEventListener(WrkfluxEvent.REMOVE, pinRemoved);
			contr.getModel("wrkflow").addEventListener(WrkfluxEvent.CHANGE, updateComplete);
			contr.getModel("wrkflow").addEventListener(ErrorEvent.ERROR, errorHandle);
			
			this.doubleClickEnabled = true;
			//this.addEventListener(MouseEvent.CLICK, click);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, click)
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			this.addEventListener(ScrollEvent.INERTIA, pinSemanticZoomUpdate);
			this.addEventListener(ScrollEvent.SCROLL, pinSemanticZoomUpdate);
			
			offsetY = topBar.height;
			
		}
		
		
		//****************** PROTECTED METHODS - INTERFACE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function buildInterface():void {
			
			//add structure view
			structureView = new view.workflow.structure.StructureView(this.getController());
			structureView.x = offsetX//offset
			structureView.y = topBar.height;
			structureView.blendMode = BlendMode.MULTIPLY;
			this.addChild(structureView);
			
			structureView.init();
			
			TweenMax.from(structureView,.6,{autoAlpha: 0});
			
			InterfaceSuport.structureView = structureView;
			InterfaceSuport.structureViewOffsetX = offsetX;
			InterfaceSuport.structureViewOffsetY = offsetY;
			
			
			//scroll system
			//mask for container
			structureViewMask = new Sprite();
			structureViewMask.graphics.beginFill(0xFFFFFF,0);
			structureViewMask.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(structureViewMask);
			structureView.mask = structureViewMask
			
			//add scroll system
			structureViewScroll = new Scroll();
			if (Settings.platformTarget == "mobile") structureViewScroll.gestureInput = "gestouch";
			structureViewScroll.direction = "both";
			structureViewScroll.target = structureView;
			structureViewScroll.maskContainer = structureViewMask;
			structureViewScroll.friction = .92;
			this.addChild(structureViewScroll);
			structureViewScroll.init();
			structureViewScroll.enable = false;
			
			//add flow
			flowView = new FlowView(this.getController());
			flowView.x = offsetX //offset
			flowView.y = topBar.height;
			this.addChild(flowView);
			
			flowView.structureView = structureView;
			
			flowView.init();
			
			TweenMax.from(flowView,.6,{autoAlpha: 0, delay:1});
			
			flowView.addEventListener(WrkfluxEvent.ACTIVATE_PIN, pinSelected);
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function showPinlist():void {
			
			if (!pinListView) {
				
				pinListView = new PinListView(this.getController());
				pinListView.y = topBar.height;
				pinListView.maxHeight = stage.stageHeight - topBar.height;
				this.addChild(pinListView);
				pinListView.init(flowView.getOpenedItems());
				TweenMax.from(pinListView,.6,{x:-pinListView.width});
				
				pinListView.addEventListener(WrkfluxEvent.ACTIVATE_PIN, pinSelected);
				pinListView.addEventListener(WrkfluxEvent.SELECT, flowView.manageToolTip);
				
			} else {
				
				pinListView.removeEventListener(WrkfluxEvent.ACTIVATE_PIN, pinSelected);
				pinListView.addEventListener(WrkfluxEvent.SELECT, flowView.manageToolTip);
				TweenMax.to(pinListView,.6,{x:-pinListView.width, onComplete:killChild, onCompleteParams:[pinListView]});
				pinListView = null;
				
			}
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param show
		 * 
		 */
		protected function lockPanels(enable:Boolean):void {
			
			//lock & unlock
			enableEvents(!enable);
			
			//progrress Bar
			if (enable && !progressBar) {
				progressBar = new ProgressBar();
				progressBar.x = this.width/2;
				progressBar.y = this.height/2;
				this.addChild(progressBar);
				
			} else if (!enable && progressBar) {
				this.removeChild(progressBar);
				progressBar = null;
			}
			
		}
		
		/**
		 * 
		 * @param enable
		 * 
		 */
		protected function enableEvents(enable:Boolean):void {
			if (enable) {
				//flagsView.mouseChildren = true;
			} else {
				//flagsView.mouseChildren = false;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function showMessage(message:String, type:String):void {
			//Add message
			messageWindow = new MessageWindow(this.getController());
			messageWindow.maxWidth = 110;
			messageWindow.maxHeight = 17;
			messageWindow.init();
			
			this.addChild(messageWindow);
			
			messageWindow.sendMessage(message, type);
			
			messageWindow.x = (this.stage.stageWidth/2) - (messageWindow.width/2);
			messageWindow.y = topBar.height + 10;
			
			TweenMax.from(messageWindow,.6,{y:"60", autoAlpha: 0});
			TweenMax.to(messageWindow,1,{autoAlpha: 0, delay:3, onComplete:killMessageWindow});
		}
		
		/**
		 * 
		 * @param object
		 * 
		 */
		protected function killChild(object:DisplayObject):void {
			this.removeChild(object);
		}
		
		/**
		 * 
		 * 
		 */
		protected function killMessageWindow():void {
			if (messageWindow) {
				this.removeChild(messageWindow);
				messageWindow = null;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			this.parent.removeChild(this);
		}
		
		
		//****************** PROTECTED EVENT ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function click(event:MouseEvent):void {
			//click in the background clear selection
			if (event.target is Background) {
				event.stopImmediatePropagation();
				flowView.closeAllOpenedPins();
				if (pinListView) pinListView.closeAllOpenedPins();
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function processComplete(event:WrkfluxEvent):void {
			
			if (event.data.action == "workflowLoaded") {
			
				var message:String;
				
				message = "Workflow loaded."
				
				topBar.label = WrkFlowController(this.getController()).getLabel();
				topBar.addMenu(WrkFlowController(this.getController()).getMenuOptions("left"),"left");
				
				this.buildInterface();
				
				showMessage(message, event.data.messageType);
				
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinAdded(event:WrkfluxEvent):void {
			var message:String;
			message = "Item added."
			
			if (pinListView) pinListView.addItem(event.data.pin);
			flowView.showAddForm(false);
			flowView.addItem(event.data.pin);
			
			showMessage(message, event.data.messageType);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinRemoved(event:WrkfluxEvent):void {
			var message:String;
			message = "Item removed."
			
			if (pinListView) pinListView.removeItem(event.data.itemUID);
			flowView.showRemoveForm(false);
			flowView.removeItem(event.data.itemUID);
			
			showMessage(message, event.data.messageType);
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinUpdated(event:WrkfluxEvent):void {
			var message:String;
			message = "Item updated."
			
			if (pinListView) pinListView.updateItem(event.data.item);
			
			showMessage(message, event.data.messageType);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updateComplete(event:WrkfluxEvent):void {
			lockPanels(false);
			
			//update recently added flags
			showMessage(event.data.message, event.data.messageType);
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandle(event:ErrorEvent):void {
			//if (titleForm) titleForm.sendMessage("Error. Please try again.", MessageType.ERROR);
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinSelected(event:WrkfluxEvent):void {
			event.stopImmediatePropagation()
				
			if (event.currentTarget is FlowView) {
				if (pinListView) pinListView.highlightItem(event.data.pinUID,event.data.open)
			} else if (event.currentTarget is PinListView) {
				flowView.activatePin(event.data.pinUID, event.data.open);
			}
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			TweenMax.to(topBar,.8,{y:-topBar.height, onComplete:killView});
			if (structureView) TweenLite.to(structureView,.7,{x:"60",autoAlpha: 0});
			if (messageWindow) TweenLite.to(messageWindow,.3,{autoAlpha: 0});
			if (flowView) TweenLite.to(flowView,.3,{x:"30",autoAlpha: 0});
			if (pinListView) TweenLite.to(pinListView,.3,{x:"-60",autoAlpha: 0});
			
		}
		
		//****************** TOP BAR ACTIONS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function topBarActions(event:WrkfluxEvent):void {
			event.stopImmediatePropagation();
			var data:Object = event.data;
			
			switch (data.clickedItem.toLowerCase()) {
				
				case "close":
					WrkFlowController(this.getController()).close();
					break;
				
				case "edit":
					WrkFlowController(this.getController()).editStructure(this.id);
					break;
				
				case "list":
					showPinlist();
					break;
			}
		}
		
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function zoom(event:TransformGestureEvent):void {
			var myProxy:TweenProxy = TweenProxy.create(structureView);	
			var currentScale:Number;;
			
			switch (event.phase) {
				
				case "begin":
					myProxy.registration = new Point(event.stageX, event.stageY);
					currentScale = myProxy.scale;
					break;
				
				case "update":
					myProxy.scale *= event.scaleX;
					currentScale = myProxy.scale;
					pinSemanticZoomUpdate();
					break;
				
				case "end":
					
					currentScale = myProxy.scale;
					
					//prevent smaller then scale min scale
					if (myProxy.scaleX < minScale) {
						structureViewScroll.enable = false;	//disable pan
						TweenMax.to(myProxy, 1, {scaleX:minScale, scaleY:minScale, onUpdate:disptachEnertiaUpdate});
						TweenMax.to(structureView, 1, {x:offsetX, y:offsetY});
						currentScale = minScale;
					}
					
					//prevent bigger then scale max scale
					if (myProxy.scaleX > maxScale) {
						TweenMax.to(myProxy, 1, {scaleX:maxScale, scaleY:maxScale, onUpdate:disptachEnertiaUpdate})
						currentScale = maxScale;
					}
					
					//enable pan
					if (myProxy.scaleX < maxScale && myProxy.scaleX > minScale) if (!structureViewScroll.enable) structureViewScroll.enable = true;
					
					pinSemanticZoomUpdate();
					break;
			}
			
			//Step semantic zoom 
			//changeStepsAppearence(currentScale);
		}
		
		/**
		 * 
		 * 
		 */
		protected function disptachEnertiaUpdate():void {
			this.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"update", structureView.x, structureView.y));
		}
		
		/**
		 * 
		 * 
		 */
		protected function pinSemanticZoomUpdate(event:ScrollEvent = null):void {
			
			var pinCollection:Array = flowView.getFlowItems();
			
			//for each pin
			for each(var pinView:PinView in pinCollection) {
				
				//------Get step ounds
				var stepBounds:Rectangle;
				
				var stepContainer:Step = structureView.getStep(pinView.currentStep);
				stepBounds = stepContainer.getPositionForPin();
				
				//for retina display
				if (Settings.platformTarget == "mobile") { 
					stepBounds.width = stepBounds.width * 2;
					stepBounds.height = stepBounds.height * 2;
				}
				
				//calculate relative position
				var pinPosRatio:Object = pinView.ratioPos;
				var xR:Number = stepBounds.x + pinView.shapeSize/2 + (pinPosRatio.w * (stepBounds.width - pinView.shapeSize));
				var yR:Number = stepBounds.y + pinView.shapeSize/2 + (pinPosRatio.h * (stepBounds.height - pinView.shapeSize));
				
				//transform from local to global
				var pLocal:Point = new Point(xR,yR)
				var pGlobal:Point = structureView.localToGlobal(pLocal);
				
				pGlobal.x = pGlobal.x - offsetX;
				pGlobal.y = pGlobal.y - offsetY;
				
				//update pin position
				pinView.updatePosition(pGlobal.x,pGlobal.y);
				
				//new position
				if (pinView.status != "edit") {
					pinView.x = pGlobal.x;
					pinView.y = pGlobal.y;
				}
				
				//update tooltip position
				ToolTipManager.moveToolTips(pinView.uid,pGlobal.x,pGlobal.y);
				
			}	
			
		}
		
	}
}