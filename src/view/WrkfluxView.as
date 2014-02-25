package view {
	
	//imports
	import com.greensock.TweenLite;
	
	import controller.WrkBuilderController;
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import model.WrkBuilderModel;
	import model.WrkFlowModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.assets.Background;
	
	public class WrkfluxView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var currentView					:AbstractView;
		protected var _background					:Background;
		
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
			
			background = new Background();
			background.alpha = .6;
			this.addChild(background);
			
			var jump:String = ""; //"use","edit","";
			var WFload:int = 1;
			
			
			
			switch (jump) {
				
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
					
					//wrkBuilderView.init(data.id);
					
					TweenLite.to(wrkBuilderView,.3,{onComplete:wrkBuilderView.init, onCompleteParams:[data.id]});
					
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
					
					TweenLite.to(wrkflowView,.3,{onComplete:wrkflowView.init, onCompleteParams:[data.id]});
					
					//wrkflowView.init(data.id);
					
					currentView = wrkflowView;
					
					break;
				
				default:
					
					var initialView:InitialView = new InitialView(this.getController());
					this.addChild(initialView);
					
					TweenLite.to(initialView,.3,{onComplete:initialView.init});
					
					currentView = initialView;
					break;
				
			}
		}

		
		//****************** GETTER AND SETTER ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get background():Background {
			return _background;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set background(value:Background):void {
			_background = value;
		}

		
	}
}