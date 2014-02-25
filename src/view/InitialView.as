package view {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import controller.WrkfluxController;
	
	import events.WrkfluxEvent;
	
	import font.HelveticaNeue;
	
	import model.Session;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	import util.MessageType;
	
	import view.assets.menu.MenuDirection;
	import view.forms.MessageWindow;
	import view.initial.Brand;
	import view.initial.LoginScreen;
	import view.initial.WFListFrame;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InitialView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var brand				:Brand;
		protected var wfListFrame		:WFListFrame;
		protected var loginScreen		:LoginScreen;
		protected var credits			:TextField;
		protected var greeting			:TextField;
		protected var topBar			:TopBar;
		
		protected var messageWindow		:MessageWindow;
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param c
		 * 
		 */
		public function InitialView(c:IController) {
			super(c);
			this.name = "initialView";
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//1.brand
			brand = new Brand();
			brand.x = this.stage.stageWidth/2;
			brand.y = 120;
			this.addChild(brand);
			
			TweenLite.from(brand,.6,{y:"-40",autoAlpha: 0});
			
			//2. add credits
			this.addCredits();
			
			//3. Workflow list
			wfListFrame = new WFListFrame(this);
			wfListFrame.y = 400;
			this.addChild(wfListFrame);
			wfListFrame.init();		
			
			TweenLite.from(wfListFrame,.6,{y:"40",autoAlpha: 0});
			
			//4. login form
			if (Session.userID == 0) {
				showNonUserView();
			} else {
				showUserView();
			}
			
			//listener
			WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(WrkfluxEvent.COMPLETE, loadCompleted);
			this.stage.addEventListener(Event.RESIZE, resize);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function addCredits():void {
			
			//1. Style
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.LIGHT;
			style.size = 12;
			style.color = Colors.getColorByName(Colors.DARK_GREY);
			
			//2. textfields	
			credits = new TextField();
			credits.selectable = false;
			credits.mouseEnabled = false;
			credits.embedFonts = true;
			credits.autoSize = TextFieldAutoSize.RIGHT;
			credits.antiAliasType = AntiAliasType.ADVANCED;
			credits.text = "Developed by: Luciano Frizzera and The INKE Team (www.inke.ca). 2014 (beta).";
			credits.setTextFormat(style);
			
			credits.x = this.stage.stageWidth/2 - credits.width/2;
			credits.y = this.stage.stageHeight - credits.height - 1;
			this.addChild(credits);
			
			//listeners
			WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
		}
		
		/**
		 * 
		 * 
		 */
		protected function showUserView():void {
			if (loginScreen) removeLoginForm();
			addGreeting(Session.userFirstName);
			addTopBar();
			wfListFrame.addUserOptions();
			TweenMax.to(brand,.6,{y:150, scaleX:1, scaleY:1});
			brand.removeTipo();
			brand.spin(2);
		}
		
		/**
		 * 
		 * 
		 */
		protected function showNonUserView():void {
			if (topBar) removeTopBar();
			if (greeting) removeGreeting();
			addLoginForm();
			wfListFrame.removeUserOptions();
		}
		
		/**
		 * 
		 * 
		 */
		protected function addLoginForm():void {
			if (!loginScreen) {
				loginScreen = new LoginScreen(this);
				loginScreen.y = 270;
				this.addChild(loginScreen);
				
				//animation
				TweenMax.from(loginScreen,1,{alpha:0, delay:1});
				
				//listeners
				loginScreen.addEventListener(MouseEvent.CLICK, loginClick);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeLoginForm():void {
			TweenMax.to(loginScreen,.6,{y:loginScreen.y+50, autoAlpha:0, onComplete:removeChild, onCompleteParams:[loginScreen]});
			loginScreen.removeEventListener(MouseEvent.CLICK, loginClick);
			loginScreen.kill();
			loginScreen = null;
			
			TweenMax.to(brand,.6,{y:150, scaleX:1, scaleY:1});
			brand.removeTipo();
			brand.spin(2);
		}
		
		/**
		 * 
		 * 
		 */
		protected function addGreeting(userName:String):void {
			if (!greeting) {
				//1. Style
				var style:TextFormat = new TextFormat();
				style.font = HelveticaNeue.THIN;
				style.size = 52;
				style.color = Colors.getColorByName(Colors.DARK_GREY);
				
				//2. textfields	
				greeting = new TextField();
				greeting.selectable = false;
				greeting.mouseEnabled = false;
				greeting.embedFonts = true;
				greeting.autoSize = TextFieldAutoSize.RIGHT;
				greeting.antiAliasType = AntiAliasType.ADVANCED;
				greeting.text = "Hello "+userName+"!";
				greeting.setTextFormat(style);
				
				greeting.x = this.stage.stageWidth/2 - greeting.width/2;
				greeting.y = 230;
				this.addChild(greeting);
				
				TweenMax.from(greeting,1,{y:greeting.y - 10, autoAlpha:0, delay:1});
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeGreeting():void {
			if (greeting) {
				TweenMax.to(greeting,.6,{autoAlpha:0, onComplete:removeChild, onCompleteParams:[greeting]});
				greeting = null;
				
				brand.addTipo();
				TweenMax.to(brand,.6,{y:120});
				brand.spin(-1);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function addTopBar():void {
			if (!topBar) {
				topBar = new TopBar();
				this.addChild(topBar);
				topBar.backgroundColor = Colors.getColorByName(Colors.WHITE);
				topBar.titleColor = Colors.getColorByName(Colors.DARK_GREY);
				topBar.init();
				
				topBar.label = "Wrkflux";
				topBar.addMenu([{label:"Sign Out"}],MenuDirection.RIGHT);
				
				//animation
				TweenLite.from(topBar,.6,{y:-topBar.hMax,delay:.6});
				
				//listenerts
				topBar.addEventListener(WrkfluxEvent.SELECT, topBarActions);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeTopBar():void {
			if (topBar) {
				TweenLite.to(topBar,.6,{y:-topBar.hMax,delay:.3, onComplete:removeChild, onCompleteParams:[topBar]});
				topBar.removeEventListener(WrkfluxEvent.SELECT, topBarActions);
				topBar.kill();
				topBar = null;
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
				
				this.addChild(messageWindow);
				
				messageWindow.sendMessage(message, type);
				
				messageWindow.x = (this.stage.stageWidth/2) - (messageWindow.width/2);
				messageWindow.y = topBar ? topBar.height - 2: 0;
				
				TweenMax.from(messageWindow,.6,{y:"-60", autoAlpha: 0, delay:.6});
				
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
			messageWindow.kill();
			messageWindow = null;
		}
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			
			wfListFrame.kill();
			
			WrkfluxController(this.getController()).getModel("wrkflux").removeEventListener(WrkfluxEvent.COMPLETE, loadCompleted);
			WrkfluxController(this.getController()).getModel("wrkflux").removeEventListener(WrkfluxEvent.FORM_FEEDBACK, formFeedback);
			if (loginScreen) if (loginScreen.hasEventListener(MouseEvent.CLICK)) loginScreen.removeEventListener(MouseEvent.CLICK, loginClick);
			if (topBar) if (topBar.hasEventListener(WrkfluxEvent.SELECT)) topBar.removeEventListener(WrkfluxEvent.SELECT, topBarActions);
			this.stage.removeEventListener(Event.RESIZE, resize);

			this.parent.removeChild(this);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function loginClick(event:MouseEvent):void {
			TweenMax.to(brand,.6,{y:80, scaleX:.8, scaleY:.8});
			TweenMax.to(loginScreen,.6,{y:180});
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function formFeedback(event:WrkfluxEvent):void {
			switch (event.data.action) {
				
				case "signIn":
					if (event.data.success) showUserView();
					break;
				
				case "signUp":
					if (event.data.success) showUserView();
					break;
					
				case "signOut":
					showNonUserView()
					break;
					
				case "forgotPass":
					if (event.data.success) loginScreen.removeForgotPassForm();
					break;
				
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function loadCompleted(event:WrkfluxEvent):void {
			switch (event.data.action) {
				case "delete":
					event.stopImmediatePropagation();
					if (event.data.result) {
						this.showMessage("Workflow deleted successfully.",MessageType.SUCCESS);
					} else {
						this.showMessage("An error occurred.",MessageType.ERROR);
					}
					
					break;	
			}	
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			
			brand.x = this.stage.stageWidth/2;
			
			credits.x = this.stage.stageWidth/2 - credits.width/2;
			credits.y = this.stage.stageHeight - credits.height - 1;
			
			if (loginScreen) loginScreen.resize();
			
			if (greeting) greeting.x = this.stage.stageWidth/2 - greeting.width/2;
			
			if (topBar) topBar.resize();
			
			wfListFrame.resize();
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
				
				case "sign out":
					WrkfluxController(this.getController()).closeSession();
					break;
				
			}
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			
			if (loginScreen) {
				loginScreen.kill()
				TweenLite.to(loginScreen,.6,{y:"-100",alpha:0});
			}
			
			if (topBar) {
				topBar.kill();
				TweenLite.to(topBar,.6,{y:-topBar.height,alpha:0});
			}
			
			if (greeting) TweenLite.to(greeting,.6,{y:"-100",alpha:0});
			
			if (wfListFrame) {
				wfListFrame.kill();
				TweenLite.to(wfListFrame,.6,{y:"100",alpha:0});
			}
			
			if (messageWindow) {
				messageWindow.kill()
				TweenLite.to(messageWindow,.3,{autoAlpha: 0});
			}
			
			TweenMax.to(brand,.6,{y:0, alpha:0, onComplete:killView});
		}
				
	}
	
}