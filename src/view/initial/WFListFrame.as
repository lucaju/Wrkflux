package view.initial {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import controller.WrkfluxController;
	
	import events.WrkfluxEvent;
	
	import model.Session;
	
	import mvc.AbstractView;
	
	import util.Colors;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.menu.Menu;
	import view.assets.menu.MenuType;
	import view.initial.wfList.WFLoadList;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class WFListFrame extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target				:AbstractView;
		
		protected var lineTop				:Shape;
		protected var lineMiddle			:Shape;
		protected var lineBottom			:Shape;
		protected var bgMenu				:Shape;
		
		protected var wfLoadList			:WFLoadList;
		protected var menu					:Menu;
		
		//****************** Contructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param _target
		 * 
		 */
		public function WFListFrame(_target:AbstractView) {
			target = _target;
		}
		
		
		//****************** Initialize ****************** ****************** ******************
	
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//backgrounds
			bgMenu = new Shape();
			bgMenu.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY),.25);
			bgMenu.graphics.drawRect(0,0,this.stage.stageWidth,28);
			bgMenu.graphics.endFill();
			this.addChild(bgMenu);
			
			//2. Menu
			menu = new Menu();
			menu.gap = 5;
			menu.type = MenuType.UNIQUE;
			this.addChild(menu);
			
			menu.abstractBt.maxHeight = 28;
			menu.abstractBt.maxWidth = 150;
			menu.abstractBt.color = Colors.getColorByName(Colors.LIGHT_GREY);
			menu.abstractBt.colorAlpha = 0;
			menu.abstractBt.textColor = Colors.getColorByName(Colors.DARK_GREY);
			menu.abstractBt.togglable = true;
			menu.abstractBt.toggleColor = Colors.getColorByName(Colors.LIGHT_GREY);
			menu.abstractBt.toggleColorAlpha = .4;
			
			var publicWorkflow:AbstractButton = menu.add("Public Workflow");
			publicWorkflow.toggle = true;
			menu.lastClickedItem = publicWorkflow;
			
			menu.x = (this.stage.stageWidth/2) - (menu.width/2);
			menu.addEventListener(WrkfluxEvent.SELECT, menuActions);
			
			//list
			wfLoadList = new WFLoadList(target.getController());
			wfLoadList.maxWidth = this.stage.stageWidth;
			wfLoadList.y = menu.height;
			wfLoadList.maxHeight = this.stage.stageHeight - this.y - wfLoadList.y - 20;
			this.addChild(wfLoadList);
			wfLoadList.init();
			
			wfLoadList.addEventListener(Event.COMPLETE, update);
			
			//Boundaries
			lineTop = new Shape();
			lineTop.graphics.lineStyle(2,0x939597);
			lineTop.graphics.lineTo(this.stage.stageWidth,0);
			this.addChild(lineTop);
			
			lineMiddle = new Shape();
			lineMiddle.graphics.lineStyle(1,0xDADBDA);
			lineMiddle.graphics.lineTo(this.stage.stageWidth,0);
			lineMiddle.y = 28;
			this.addChild(lineMiddle);
			
			lineBottom = new Shape();
			lineBottom.graphics.lineStyle(2,0x939597);
			lineBottom.graphics.lineTo(this.stage.stageWidth,0);
			lineBottom.y = wfLoadList.y + wfLoadList.height;
			this.addChild(lineBottom);
			
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function update(event:Event):void {
			TweenMax.to(lineBottom,1,{y:wfLoadList.y + wfLoadList.maxHeight});
			//TweenMax.to(this,1,{y:this.stage.stageHeight - wfLoadList.maxHeight - 28 - 20});
		}
		
		//****************** MENU ACTIONS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function menuActions(event:WrkfluxEvent):void {
			event.stopImmediatePropagation();
			var data:Object = event.data;
			
			switch (data.clickedItem.toLowerCase()) {
				
				case "my workflows":
					WrkfluxController(target.getController()).getUserWorkflows(Session.userID);
					wfLoadList.addProgressBar();
					wfLoadList.filter(Session.userID);
					break;
				
				case "public workflow":
					wfLoadList.filter(0);
					break;
				
			}
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addUserOptions():void {
			menu.add("My Workflows");
			TweenMax.to(menu,.6,{x:this.stage.stageWidth/2 - menu.width/2});
		}
		
		/**
		 * 
		 * 
		 */
		public function removeUserOptions():void {
			
			var publicWorkflow:AbstractButton = menu.getOptionByLabel("My Workflows");
			
			if (publicWorkflow) {
				menu.remove("My Workflows");
				TweenMax.to(menu,.6,{x:this.stage.stageWidth/2 - menu.width/2});
				wfLoadList.filter(0);
				
				publicWorkflow.toggle = true;
				menu.lastClickedItem = publicWorkflow;
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			lineTop.width = this.stage.stageWidth;
			bgMenu.width = this.stage.stageWidth;
			lineMiddle.width = this.stage.stageWidth;
			lineBottom.width = this.stage.stageWidth;
			
			menu.x = (this.stage.stageWidth/2) - (menu.width/2);
			
			wfLoadList.maxHeight = this.stage.stageHeight - this.y - wfLoadList.y - 20;
			wfLoadList.resize();
			
			lineBottom.y =wfLoadList.y + wfLoadList.maxHeight;
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			menu.removeEventListener(WrkfluxEvent.SELECT, menuActions);
			menu.kill();
			wfLoadList.removeEventListener(Event.COMPLETE, update);
			wfLoadList.kill()
		}
	}
}