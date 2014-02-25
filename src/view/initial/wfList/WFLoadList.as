package view.initial.wfList {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import controller.WrkfluxController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.MessageType;
	
	import view.forms.MessageField;
	import view.util.progressBar.ProgressBar;
	import view.util.scroll.Scroll;
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WFLoadList extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var listWorkflows			:WFList;
		protected var listMask				:Sprite;
		
		protected var bg					:Sprite;
		
		protected var _maxWidth				:Number;
		protected var _maxHeight			:Number;
		
		protected var scroll				:Scroll;
		
		protected var progressBar			:ProgressBar;
		protected var errorMessage			:MessageField;
		
		
		//****************** Construtor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function WFLoadList(c:IController) {
			super(c);
			
			this.maxWidth = 800;
			this.maxHeight = 80;
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//bg
			bg = new Sprite();
			bg.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY),.5);
			bg.graphics.drawRect(0,0,this.maxWidth,this.maxHeight);
			bg.graphics.endFill();
			bg.alpha = .5;
			this.addChild(bg);
			
			//load existed workflows
			WrkfluxController(this.getController()).getWorkflows();
			
			if (!progressBar) this.addProgressBar();
			
			//listener
			WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(WrkfluxEvent.COMPLETE, loadCompleted);
			WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(ErrorEvent.ERROR, errorHandle);
		}	
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		protected function loadItems(data:Array):void {
			//remove progress bar
			if (progressBar) removeProgressBar();
			
			//define max height
			TweenMax.to(bg,1,{height:this.maxHeight});
			
			//create list
			if (!listWorkflows) {
				
				//1.add List
				this.addListWorkflows(data);
				
				//2. add mask 
				this.addListMask();
				
				//3.test scroll
				this.testForScroll();
				
				//initiate
				listWorkflows.show();
				
			}
			
			//dispatch
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			//listener
			listWorkflows.addEventListener(Event.CHANGE, onListChange);
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		protected function addListWorkflows(data:Array):void {
			listWorkflows = new WFList(this);
			this.addChild(listWorkflows);
			listWorkflows.init(data);
			
			listWorkflows.addEventListener(Event.SELECT, workflowActivate);
		}
		
		/**
		 * 
		 * 
		 */
		protected function addListMask():void {
			listMask = new Sprite();
			listMask.graphics.beginFill(0x999999,.2);
			listMask.graphics.drawRect(0, 0, this.stage.stageWidth, this.maxHeight);
			listMask.graphics.endFill();
			listMask.y = 1;
			
			this.addChild(listMask);
			
			listWorkflows.mask = listMask;
		}
		
		/**
		 * 
		 * 
		 */
		protected function testForScroll():void {
			
			//if list exists
			if (listWorkflows) {
				
				//if scroll doesn't exists
				if (!scroll) {
				
					// if needs scroll, create one
					if (listWorkflows.height > maxHeight) this.addScroll();
				
				} else {
				
					//if scroll exists
					
					//if doesn't need scroll anymore
					if (listWorkflows.height <= maxHeight)  {
						scroll.kill();
						scroll = null;
						
					} else {
						//update - mask width and height
						scroll.update();
					}
					
				}
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function addScroll():void {
			scroll = new Scroll();
			scroll.rollVisible = true;
			scroll.target = listWorkflows;
			scroll.x = stage.stageWidth - 6;
			scroll.maskContainer = listMask;
			this.addChild(scroll);
		}
		
		/**
		 * 
		 * 
		 */
		protected function addProgressBar():void {
			progressBar = new ProgressBar();
			progressBar.x = this.maxWidth/2;
			progressBar.y = this.maxHeight/2;
			this.addChild(progressBar);
			
			TweenMax.from(progressBar,1,{alpha:0});
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeProgressBar():void {
			this.removeChild(progressBar);
			progressBar = null;
		}
	
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function loadCompleted(event:WrkfluxEvent):void {
		
			switch (event.data.action) {		
				case "load":
					event.stopImmediatePropagation();
					loadItems(event.data.data);
					break;
			}
			
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandle(event:ErrorEvent):void {
			
			//remove progress bar
			if (progressBar) this.removeProgressBar();
			
			if (!errorMessage) {
				
				errorMessage = new MessageField();
				errorMessage.sendMessage("Error. Please try again.", MessageType.ERROR);
				errorMessage.x = (maxWidth/2) - (errorMessage.width/2);
				errorMessage.y = (maxHeight/2) - (errorMessage.height/2);
				this.addChild(errorMessage);
			
			} else {
				errorMessage.sendMessage("Error. Please try again.", MessageType.ERROR);
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function workflowActivate(event:Event):void {
			
			switch (listWorkflows.selectedItemAction) {
				
				case "view":
					WrkfluxController(this.getController()).loadWorkflow(listWorkflows.selectedItem, "use");
					break;
				
				case "use":
					WrkfluxController(this.getController()).loadWorkflow(listWorkflows.selectedItem, listWorkflows.selectedItemAction);
					break;
				
				case "edit":
					WrkfluxController(this.getController()).loadWorkflow(listWorkflows.selectedItem, listWorkflows.selectedItemAction);
					break;
				
				case "delete":
					listWorkflows.removeItem(listWorkflows.selectedItem);
					WrkfluxController(this.getController()).deleteWorkflow(listWorkflows.selectedItem);
					break;
				
				case "new":
					WrkfluxController(this.getController()).newWorkflow();
					break;
			}
			
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onListChange(event:Event):void {
			testForScroll();
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function filter(userID:int = 0):void {
			listWorkflows.filter(userID);
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			this.maxWidth = stage.stageWidth;
			
			bg.width = this.maxWidth;
			bg.height = this.maxHeight;
			
			if (listMask) {
				listMask.width = this.maxWidth;
				listMask.height = this.maxHeight;
			}
			
			if (listWorkflows) listWorkflows.resize();
			
			testForScroll();
			
			if (scroll) {
				scroll.x = listMask.width - scroll.width - 2;
				if (listWorkflows.y != 0) listWorkflows.y = -listWorkflows.height/2 + this.listMask.height/2 + 10;
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			WrkfluxController(this.getController()).getModel("wrkflux").removeEventListener(WrkfluxEvent.COMPLETE, loadCompleted);
			WrkfluxController(this.getController()).getModel("wrkflux").removeEventListener(ErrorEvent.ERROR, errorHandle);
			
			if (listWorkflows) {
				listWorkflows.removeEventListener(Event.CHANGE, onListChange);
				listWorkflows.removeEventListener(Event.SELECT, workflowActivate);
				listWorkflows.kill();
			}
			
			if (errorMessage) errorMessage.kill();
			
			if (scroll) scroll.kill();
			scroll = null;
		}
		
		
		//****************** GETTER AND SETTER ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():Number {
			return _maxWidth;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxWidth(value:Number):void {
			_maxWidth = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxHeight():Number {
			return _maxHeight;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
		}

	}
}