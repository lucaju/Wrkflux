package view {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import controller.WrkBuilderController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	import util.MessageType;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.menu.Menu;
	import view.assets.menu.MenuDirection;
	import view.builder.TitleForm;
	import view.builder.flags.FlagsView;
	import view.builder.structure.StructureView;
	import view.forms.MessageWindow;
	import view.util.progressBar.ProgressBar;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkBuilderView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var id				:int;
		
		protected var topBar			:TopBar;
		protected var titleForm			:TitleForm;
		
		protected var flagsView			:FlagsView;
		protected var structureView		:StructureView
		
		protected var messageWindow		:MessageWindow;
		
		protected var progressBar		:ProgressBar;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function WrkBuilderView(c:IController) {
			super(c);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init(wfID:int = 0):void {
			
			//action
			wfID == 0 ? newWorkflow() : loadWorkflow(wfID);
			
			//1. top bar
			topBar = new TopBar();
			this.addChild(topBar);
			topBar.backgroundColor = Colors.getColorByName(Colors.WHITE);
			topBar.titleColor = Colors.getColorByName(Colors.DARK_GREY);
			topBar.init();
			
			topBar.label = WrkBuilderController(this.getController()).getLabel();
			topBar.addMenu(WrkBuilderController(this.getController()).getMenuOptions("right"),MenuDirection.RIGHT);
			
			//animation
			TweenLite.from(topBar,.6,{y:-topBar.height,delay:.6});
			
			//listenerts
			topBar.addEventListener(WrkfluxEvent.SELECT, topBarActions);
			var contr:WrkBuilderController = WrkBuilderController(this.getController());
			contr.getModel("wrkbuilder").addEventListener(WrkfluxEvent.COMPLETE, processComplete);
			contr.getModel("wrkbuilder").addEventListener(WrkfluxEvent.CHANGE, updateComplete);
			contr.getModel("wrkbuilder").addEventListener(ErrorEvent.ERROR, errorHandle);
			
			this.stage.addEventListener(Event.RESIZE, resize);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function newWorkflow():void {
			
			//Add Title Form
			titleForm = new TitleForm(this.getController());
			this.addChild(titleForm);
			
			titleForm.x = (this.stage.stageWidth/2) - (titleForm.maxWidth/2);
			titleForm.y = (this.stage.stageHeight/2) - (titleForm.height/2);
			
			titleForm.addEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
			
			TweenMax.from(titleForm,.6,{y:"30", autoAlpha: 0, delay:1});
		}
		
		/**
		 * 
		 * @param wfID
		 * 
		 */
		protected function loadWorkflow(wfID:int):void {
			WrkBuilderController(this.getController()).loadWorkflow(wfID)
		}
		
		/**
		 * 
		 * 
		 */
		protected function buildInterface():void {
			
			//add flags view
			flagsView = new FlagsView(this.getController());
			flagsView.y = topBar.height;
			this.addChild(flagsView);
			flagsView.init();
			
			//TweenMax.from(flagsView,.6,{x:-flagsView.width/4, autoAlpha: 0});
			
			//add structure view
			structureView = new StructureView(this.getController());
			structureView.x = flagsView.width;
			structureView.y = topBar.height;
			this.addChild(structureView);
			structureView.init();
			
			TweenMax.from(structureView,.6,{tint: Colors.getColorByName(Colors.WHITE_ICE)});
			
		}
		
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
				flagsView.mouseChildren = true;
			} else {
				flagsView.mouseChildren = false;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function checkStrucutureOverlap():void {
			if (structureView.checkStrucutureOverlap()) {
				if (messageWindow) {
					messageWindow.maxWidth = 230;
					
					var overlapMessage:String = "Some elements on the strucuture are overlaping. It can cause error in the Workflow usage."
					messageWindow.sendMessage(overlapMessage, MessageType.WARNING, true);
					
					messageWindow.x = (this.stage.stageWidth/2) - (messageWindow.width/2);
					messageWindow.y = structureView.y + 10;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function showMessage(message:String, type:String):void {
			//Add message
			if (!messageWindow) {
				messageWindow = new MessageWindow(this.getController());
				messageWindow.maxWidth = 160;
				messageWindow.maxHeight = 17;
				messageWindow.windowColor = Colors.getColorByName(Colors.LIGHT_GREY);
				messageWindow.windowColorAlpha = .3;
				messageWindow.windowLine = true;
				messageWindow.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
				messageWindow.windowLineThickness = 1;
				messageWindow.init();
				
				this.addChildAt(messageWindow,0);
				
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
		 * 
		 */
		protected function killMessageWindow():void {
			this.removeChild(messageWindow);
			messageWindow = null;
		}
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			var contr:WrkBuilderController = WrkBuilderController(this.getController());
			contr.getModel("wrkbuilder").removeEventListener(WrkfluxEvent.COMPLETE, processComplete);
			contr.getModel("wrkbuilder").removeEventListener(WrkfluxEvent.CHANGE, updateComplete);
			contr.getModel("wrkbuilder").removeEventListener(ErrorEvent.ERROR, errorHandle);
			this.stage.removeEventListener(Event.RESIZE, resize);
			this.parent.removeChild(this);
			
			contr = null;
		}
		
		
		//****************** PROTECTED EVENT ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function formEvent(event:WrkfluxEvent):void {
			var data:Object = event.data;
			WrkBuilderController(this.getController()).createWorkflow(data.title);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function processComplete(event:WrkfluxEvent):void {
			
			var message:String;
			
			if (event.phase == "create") {
				
				if (titleForm) {
					titleForm.sendMessage("Success.",MessageType.SUCCESS);
					titleForm.kill();
				}
				
				message = "Workflow created."
				
			} else {
				message = "Workflow loaded."
			}
			
			this.id = event.data.id;
			
			topBar.label = WrkBuilderController(this.getController()).getLabel();
			
			var topMenu:Menu = topBar.getMenu("right");
			topMenu.add("Use");
			topMenu.add("Save");
			var tagBT:AbstractButton = topMenu.add("Tags");
			tagBT.togglable = true;
			tagBT.toggle = true;
			
			//topBar.addMenu(WrkBuilderController(this.getController()).getMenuOptions("left"),"left");
			
			this.buildInterface();
			
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
			flagsView.updateFlagsUID(event.data.flagsAdded);
			structureView.updateStepsUID(event.data.stepAdded);
			structureView.updateConnectionsUID(event.data.connectionsAdded);
			structureView.updateTagsUID(event.data.tagsAdded);
			
			showMessage(event.data.message, event.data.messageType);
			checkStrucutureOverlap();
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandle(event:ErrorEvent):void {
			if (titleForm) titleForm.sendMessage("Error. Please try again.", MessageType.ERROR);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			if (topBar) topBar.resize();
			if (titleForm) {
				titleForm.x = (this.stage.stageWidth/2) - (titleForm.maxWidth/2);
				titleForm.y = (this.stage.stageHeight/2) - (titleForm.height/2);
			}
			
			if (flagsView) flagsView.resize();
			
			if (structureView) structureView.resize();
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			TweenLite.to(topBar,.6,{y:-topBar.height, onComplete:killView});
			topBar.kill();
			
			if (titleForm) TweenLite.to(titleForm,.6,{autoAlpha: 0});
			if (flagsView) TweenLite.to(flagsView,.5,{x:-flagsView.width, autoAlpha: 0});
			if (structureView) TweenLite.to(structureView,.6,{tint:Colors.getColorByName(Colors.WHITE_ICE)});
			if (messageWindow) TweenLite.to(messageWindow,.3,{autoAlpha: 0});
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
					WrkBuilderController(this.getController()).closeBuilder();
					break;
				
				case "use":
					WrkBuilderController(this.getController()).useStructure(this.id);
					break;
				
				case "save":
					WrkBuilderController(this.getController()).save();
					lockPanels(true);
					break;
				
				case "tags":
					structureView.showTags();
					break;
			}
		}

		
	}
}