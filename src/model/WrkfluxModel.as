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
		protected var _session					:Session;
		
		public const menuRight					:Array = [{label:"Sign Out"}];
		
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
		 * @param data
		 * 
		 */
		public function signIn(data:Object):void {
			//get data
			var wfData:Object = new Object();
			wfData.email = data.email.toLowerCase();
			wfData.password = data.password;
			
			//convert to Json
			var Jdata:String = JSON.stringify(wfData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest(PHPGateWay.signIn());
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
													{name:"signIn",
														estimatedBytes:200,
														onProgress:progressHandler,
														onComplete:signInComplete,
														onError:errorHandler});
			dataLoader.load();
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function signUp(data:Object):void {
			//get data
			var wfData:Object = new Object();
			wfData.firstName = data.firstname;
			wfData.lastName = data.lastname;
			wfData.email = data.email.toLowerCase();;
			wfData.password = data.password;
			
			//convert to Json
			var Jdata:String = JSON.stringify(wfData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest(PHPGateWay.signUp());
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
														{name:"signUp",
															estimatedBytes:200,
															onProgress:progressHandler,
															onComplete:signUpComplete,
															onError:errorHandler});
			dataLoader.load();
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function forgotPass(data:Object):void {
			//get data
			var wfData:Object = new Object();
			wfData.email = data.email;
			
			//convert to Json
			var Jdata:String = JSON.stringify(wfData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest(PHPGateWay.forgotPass());
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
														{name:"forgotPass",
															estimatedBytes:200,
															onProgress:progressHandler,
															onComplete:forgotPassComplete,
															onError:errorHandler});
			dataLoader.load();
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
			
			var dataLoader:DataLoader = new DataLoader(request, {name:"getWorkflows", estimatedBytes:200, onProgress:progressHandler, onComplete:getWorkflowsComplete, onError:errorHandler});
			dataLoader.load();
		
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function deleteWorkflow(id:int):void {
			
			var request:URLRequest = new URLRequest(PHPGateWay.deleteWorkflow());
			var data:URLVariables = new URLVariables();
			data.action = "deleteWorkflow";
			data.id = id;
			request.data = data;
			request.method = URLRequestMethod.POST;
			
			var dataLoader:DataLoader = new DataLoader(request, {name:"deleteWorkflow", estimatedBytes:200, onProgress:progressHandler, onComplete:deleteWorkflowComplete, onError:errorHandler});
			dataLoader.load();
			
		}
		
		/**
		 * 
		 * 
		 */
		public function closeSession():void {
			if (Session.userID) {
				_session.close();
				
				var data:Object = new Object();
				data.action = "signOut";
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_FEEDBACK, data));
			}
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
		protected function getWorkflowsComplete(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			
			_workflowCollection = new Array();
			var workflows:Object = JSON.parse(LoaderMax.getContent("getWorkflows"));
			
			for each (var workflow:Object in workflows) {
				var wfProject:WorkflowItemModel = new WorkflowItemModel(workflow.id,
																		workflow.title,
																		workflow.user_id,
																		workflow.author,
																		workflow.created_date,
																		workflow.modified_date);
				
				_workflowCollection.push(wfProject);
			}
			
			
			var data:Object = new Object();
			data.action = "load";
			data.data = workflowCollection;
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, data));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function deleteWorkflowComplete(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			var workflow:Object = JSON.parse(LoaderMax.getContent("deleteWorkflow"));
			
			var result:Boolean = false;
			
			for each (var wf:WorkflowItemModel in _workflowCollection) {
				if (wf.id == workflow.id) {
					_workflowCollection.splice(_workflowCollection.indexOf(wf),1);
					result = true;
					break;
				}
			}
			
			var data:Object = new Object();
			data.action = "delete";
			data.result = result;
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, data));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function signInComplete(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			var data:Object = JSON.parse(LoaderMax.getContent("signIn"));
			
			if (data.success) _session = new Session(data.userID, data.firstName, data.lastName);
			
			data.action = "signIn";
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_FEEDBACK, data));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function forgotPassComplete(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			var data:Object = JSON.parse(LoaderMax.getContent("forgotPass"));
			
			trace (LoaderMax.getContent("forgotPass"))
			data.action = "forgotPass";
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_FEEDBACK, data));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function signUpComplete(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			var data:Object = JSON.parse(LoaderMax.getContent("signUp"));
			
			if (data.success) _session = new Session(data.userID, data.firstName, data.lastName);
			
			data.action = "signUp";
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.FORM_FEEDBACK, data));
			
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