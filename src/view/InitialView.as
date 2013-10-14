package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	
	import controller.WrkfluxController;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	
	import view.assets.menu.Menu;
	import view.assets.menu.MenuType;
	import view.initial.Brand;
	import view.initial.wfList.WFLoadList;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InitialView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var brand			:Brand;
		protected var menu			:Menu;
		protected var wfLoadList	:WFLoadList;
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param c
		 * 
		 */
		public function InitialView(c:IController) {
			super(c);
			this.name = "initialView"
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			//1.brand
			brand = new Brand();
			this.addChild(brand);
			brand.init();
			
			//2. Menu
			menu = new Menu();
			menu.type = MenuType.INITIAL;
			this.addChild(menu);
			
			menu.add("New",Colors.GREEN);
			menu.add("Load",Colors.BLUE);
			
			menu.x = (this.stage.stageWidth/2) - (menu.width/2);
			menu.y = (this.stage.stageHeight/2) + 50;
			
			TweenMax.from(menu,2,{y: menu.y + 50, alpha:0, delay:2});
			
			//listeneters
			menu.addEventListener(Event.SELECT, menuSelected);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function newWorkflow():void {
			WrkfluxController(this.getController()).newWorkflow();
		}
		
		/**
		 * 
		 * 
		 */
		protected function addWorkflowList():void {
			if (!wfLoadList) {
				wfLoadList = new WFLoadList(this.getController());
				wfLoadList.x = (this.stage.stageWidth/2) - (wfLoadList.width/2);
				wfLoadList.y = menu.y + menu.height + 20;
				wfLoadList.init();
				this.addChild(wfLoadList);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function killView():void {
			this.parent.removeChild(this);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function menuSelected(event:Event):void {
			
			event.stopImmediatePropagation();
			
			switch (menu.clickedItem) {
				
				case "New":
					newWorkflow();
					 break;
				
				case "Load":
					addWorkflowList();
					break;
				
			}
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function kill():void {
			TweenMax.to(brand,.6,{y:0, alpha:0, onComplete:killView});
			TweenMax.to(menu,.6,{autoAlpha:0});
			if (wfLoadList) TweenMax.to(wfLoadList,.6,{y:700, autoAlpha:0});
		}
				
	}
	
}