package view {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TweenProxy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import model.Session;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.menu.Menu;
	import view.assets.menu.MenuDirection;
	import view.forms.MessageWindow;
	import view.tooltip.ToolTipManager;
	import view.util.progressBar.ProgressBar;
	import view.util.scroll.Scroll;
	import view.util.scroll.ScrollEvent;
	import view.workflow.InterfaceSuport;
	import view.workflow.flow.FlowView;
	import view.workflow.flow.pin.PinView;
	import view.workflow.list.PinListView;
	import view.workflow.structure.StructureView;
	import view.workflow.structure.steps.Step;

	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkFlowView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var id						:int;
	
		protected var topBar					:TopBar
		
		protected var structureView				:StructureView;
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
			
			//action
			if (wfID != 0) {
				this.id = wfID;
				WrkFlowController(this.getController()).loadWorkflow(wfID);
			}
			
			//top bar
			topBar = new TopBar();
			this.addChild(topBar);
			topBar.type = "use";
			topBar.backgroundColor = Colors.getColorByName(Colors.WHITE);
			topBar.titleColor = Colors.getColorByName(Colors.DARK_GREY);
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
			
			this.stage.addEventListener(Event.RESIZE, resize);
			
			offsetY = topBar.height;
			
		}
		
		
		//****************** PROTECTED METHODS - INTERFACE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function buildInterface():void {
			
			//top bar
			topBar.label = WrkFlowController(this.getController()).getLabel();
			topBar.showVisibility(WrkFlowController(this.getController()).getVisibility());
			var topMenu:Menu = topBar.getMenu("right");
			
			//add menu Options
			if (Session.credentialCheck()) topMenu.add("Edit");
			
			var tagBT:AbstractButton = topMenu.add("Tags");
			tagBT.togglable = true;
			
			var listBT:AbstractButton = topMenu.add("List");
			listBT.togglable = true;
			
			//add structure view
			structureView = new StructureView(this.getController());
			structureView.x = offsetX
			structureView.y = topBar.height;
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
			
			if (Settings.pinListVisibility) this.showPinlist();
			
			//move top bar to top layer
			this.setChildIndex(topBar, this.numChildren-1);
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
				pinListView.removeEventListener(WrkfluxEvent.SELECT, flowView.manageToolTip);
				pinListView.kill();
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
		 * @param message
		 * @param type
		 * 
		 */
		protected function showMessage(message:String, type:String):void {
			//Add message
			if (!messageWindow) {
				messageWindow = new MessageWindow(this.getController());
				messageWindow.maxWidth = 160;
				messageWindow.maxHeight = 17;
				messageWindow.windowColor = Colors.getColorByName(Colors.LIGHT_GREY);
				messageWindow.windowColorAlpha = .9;
				messageWindow.windowLine = true;
				messageWindow.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
				messageWindow.windowLineThickness = 1;
				messageWindow.init();
				
				this.addChildAt(messageWindow, this.numChildren-2);
				
				messageWindow.sendMessage(message, type);
				
				messageWindow.x = (this.stage.stageWidth/2) - (messageWindow.width/2);
				messageWindow.y = topBar ? topBar.height - 1: 0;
				
				TweenMax.from(messageWindow,.6,{y:"-60", autoAlpha: 0, delay:.6});
				//TweenMax.to(messageWindow,1,{autoAlpha: 0, delay:3.6, onComplete:killMessageWindow});
				
			} else {
				TweenMax.to(messageWindow,1,{y: topBar ? topBar.height - 2: 0});
				messageWindow.sendMessage(message, type);
			}
			
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
			var contr:WrkFlowController = WrkFlowController(this.getController());
			contr.getModel("wrkflow").removeEventListener(WrkfluxEvent.COMPLETE, processComplete);
			contr.getModel("wrkflow").removeEventListener(WrkfluxEvent.ADD, pinAdded);
			contr.getModel("wrkflow").removeEventListener(WrkfluxEvent.UPDATE_PIN, pinUpdated);
			contr.getModel("wrkflow").removeEventListener(WrkfluxEvent.REMOVE, pinRemoved);
			contr.getModel("wrkflow").removeEventListener(WrkfluxEvent.CHANGE, updateComplete);
			contr.getModel("wrkflow").removeEventListener(ErrorEvent.ERROR, errorHandle);
			
			//this.removeEventListener(MouseEvent.CLICK, click);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, click)
			this.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			this.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			this.removeEventListener(ScrollEvent.INERTIA, pinSemanticZoomUpdate);
			this.removeEventListener(ScrollEvent.SCROLL, pinSemanticZoomUpdate);
			
			this.stage.removeEventListener(Event.RESIZE, resize);
			
			topBar.removeEventListener(WrkfluxEvent.SELECT, topBarActions);
			
			contr = null
		}
		
		
		//****************** PROTECTED EVENT ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function click(event:MouseEvent):void {
			//click in the background clear selection
			/*if (event.target is Background) {
				event.stopImmediatePropagation();
				flowView.closeAllOpenedPins();
				if (pinListView) pinListView.closeAllOpenedPins();
			}
			*/
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function processComplete(event:WrkfluxEvent):void {
			
			if (event.data.action == "workflowLoaded") {
			
				Session.setActiveWorkflow(this.id, event.data.authorID);	
				this.buildInterface();
				
				var message:String;
				message = "Workflow loaded."
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
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			if (topBar) topBar.resize();
			if (pinListView) {
				pinListView.maxHeight = stage.stageHeight - topBar.height;
				pinListView.resize();
			}
			
			if (flowView) flowView.resize();
			
			//yet to resize the working area
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			
			TweenLite.to(topBar,.6,{y:-topBar.height, onComplete:killView});
			topBar.kill();
			
			if (messageWindow) TweenLite.to(messageWindow,.3,{autoAlpha: 0});
			
			if (structureView) {
				TweenLite.to(structureView,.6,{autoAlpha: 0});
				structureView.kill();
			}
			
			if (flowView) {
				flowView.removeEventListener(WrkfluxEvent.ACTIVATE_PIN, pinSelected);
				TweenLite.to(flowView,.6,{autoAlpha: 0});
				flowView.kill();
			}
			
			if (pinListView) {
				pinListView.removeEventListener(WrkfluxEvent.ACTIVATE_PIN, pinSelected);
				pinListView.removeEventListener(WrkfluxEvent.SELECT, flowView.manageToolTip);
				pinListView.kill();
				TweenLite.to(pinListView,.3,{x:-pinListView.width,autoAlpha: 0});
			}
			
			
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
				
				case "tags":
					structureView.showTags();
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