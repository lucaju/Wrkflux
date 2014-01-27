package model {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.events.ErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import events.WrkfluxEvent;
	
	import model.PHPGateWay;
	import model.initial.WorkflowItemModel;
	
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkfluxModel extends Observable {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _currentView				:String = "initial";
		protected var _workflowCollection		:Array;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function WrkfluxModel() {
			super();
			
			//define name
			this.name = "wrkflux";
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function changeView(view:String, id:int = 0):void {
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.CHANGE_VIEW,{view:view,id:id}));
			_currentView = view;
		}
		
		/**
		 * 
		 * 
		 */
		public function getWorkflows():void {
			var request:URLRequest = new URLRequest(PHPGateWay.getWorkflows());
			var data:URLVariables = new URLVariables();
			data.action = "getWorkflows";
			data.id = "";
			request.data = data;
			request.method = URLRequestMethod.POST;
			
			var dataLoader:DataLoader = new DataLoader(request, {name:"getWorkflows", estimatedBytes:200, onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			dataLoader.load();
		
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function progressHandler(event:LoaderEvent):void {
			//trace("progress: " + event.target.progress);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function completeHandler(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			
			_workflowCollection = new Array();
			var workflows:Object = JSON.parse(LoaderMax.getContent("getWorkflows"));
			
			
			
			for each (var workflow:Object in workflows) {
				var wfProject:WorkflowItemModel = new WorkflowItemModel(workflow.id,
																			  workflow.title,
																			  workflow.author,
																			  workflow.created_date,
																			  workflow.modified_date);
				
				_workflowCollection.push(wfProject);
				
			}
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, workflowCollection));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandler(event:LoaderEvent):void {
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,event.text));
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentView():String {
			return _currentView;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get workflowCollection():Array {
			return _workflowCollection.concat();
		}

		
	}
}