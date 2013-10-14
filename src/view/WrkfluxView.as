package view {
	
	//imports
	import controller.WrkBuilderController;
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import model.WrkBuilderModel;
	import model.WrkFlowModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	public class WrkfluxView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var currentView					:AbstractView;
		
		
		//****************** Constructor ****************** ****************** ******************		
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function WrkfluxView(c:IController) {
			super(c);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
			
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			var jump:String = ""; //"use","edit","";
			var WFload:int = 1;
			
			switch (jump) {
				
				case "edit":
			
					var wrkBuilderModel:WrkBuilderModel = new WrkBuilderModel();
					wrkBuilderModel.addEventListener(WrkfluxEvent.CHANGE_VIEW, changeView);
					
					//Start controler
					var wrkBuilderController:WrkBuilderController = new WrkBuilderController([this.getModel(),wrkBuilderModel]);
					
					//Starting View
					var wrkBuilderView:WrkBuilderView = new WrkBuilderView(wrkBuilderController);
					this.addChild(wrkBuilderView);
					wrkBuilderView.init(WFload);
					
					currentView = wrkBuilderView;
					
					break;
				
				case "use":
					
					var wrkFlowModel:WrkFlowModel = new WrkFlowModel();
					wrkFlowModel.addEventListener(WrkfluxEvent.CHANGE_VIEW, changeView);
					
					//Start controler
					var wrkFlowController:WrkFlowController = new WrkFlowController([this.getModel(),wrkFlowModel]);
					
					//Starting View
					var wrkFlowView:WrkFlowView = new WrkFlowView(wrkFlowController);
					this.addChild(wrkFlowView);
					wrkFlowView.init(WFload);
					
					currentView = wrkFlowView;
					
					break;
			
				default:
					
					//Starting Initial View
					var initialView:InitialView = new InitialView(this.getController());
					this.addChild(initialView);
					initialView.init();
					
					currentView = initialView;
					
					//listeners
					this.getModel().addEventListener(WrkfluxEvent.CHANGE_VIEW, changeView);
					
					break;
			}
			
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function changeView(event:WrkfluxEvent):void {
			
			var data:Object = event.data;
			
			event.stopImmediatePropagation();
			
			currentView.kill();
			this.getController().removeView(currentView);
			currentView = null;
			
			/* BUG: Garbage Collector is not removing VIEW */
			
			switch (data.view) {
				
				case "edit":
					//Start models
					var wrkBuilderModel:WrkBuilderModel = new WrkBuilderModel();
					wrkBuilderModel.addEventListener(WrkfluxEvent.CHANGE_VIEW, changeView);
					
					//Start controler
					var wrkBuilderController:WrkBuilderController = new WrkBuilderController([this.getModel(),wrkBuilderModel]);
					
					//Starting View
					var wrkBuilderView:WrkBuilderView = new WrkBuilderView(wrkBuilderController);
					this.addChild(wrkBuilderView);
					wrkBuilderView.init(data.id);
					
					currentView = wrkBuilderView;
					break;
				
				case "use":
					
					//Start models
					var wrkFlowModel:WrkFlowModel = new WrkFlowModel();
					wrkFlowModel.addEventListener(WrkfluxEvent.CHANGE_VIEW, changeView);
					
					//Start controler
					var wrkFlowController:WrkFlowController = new WrkFlowController([this.getModel(),wrkFlowModel]);
					
					//Starting View
					var wrkflowView:WrkFlowView = new WrkFlowView(wrkFlowController);
					this.addChild(wrkflowView);
					wrkflowView.init(data.id);
					
					currentView = wrkflowView;
					
					break;
				
				default:
					
					var initialView:InitialView = new InitialView(this.getController());
					this.addChild(initialView);
					initialView.init();
					
					currentView = initialView;
					break;
				
			}
		}
		
	}
}