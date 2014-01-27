package model {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	
	import flash.events.ErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import events.WrkfluxEvent;
	
	import model.PHPGateWay;
	import model.wrkflow.PinModel;
	import model.wrkflow.WorkflowModel;
	
	import mvc.Observable;
	
	import util.MessageType;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkFlowModel extends Observable {
		
		//****************** Properties ****************** ****************** ******************
		
		public const label					:String = "Wrkflow";
		
		public const menuRight				:Array = [{label:"Close"}, {label:"Edit"},];
		public const menuLeft				:Array = [{label:"List"}];
		
		protected var workflowModel			:model.wrkflow.WorkflowModel;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function WrkFlowModel() {
			super();
			
			//define name
			this.name = "wrkflow";
			
		}
		
		
		//****************** PUBLIC MAIN WORKFLOW METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function loadWorkflow(wfID:int):void {
			var request:URLRequest = new URLRequest(PHPGateWay.getWorkflow());
			var data:URLVariables = new URLVariables();
			data.action = "getWorkflows";
			data.id = wfID;
			request.data = data;
			request.method = URLRequestMethod.POST;
			
			var dataLoader:DataLoader = new DataLoader(request,
												    	{name:"load",
														 estimatedBytes:200,
														 onProgress:progressHandler,
														 onComplete:completeHandler,
														 onError:errorHandler});
			dataLoader.load();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLabel():String {
			if (!workflowModel) {
				return label;
			} else {
				var wfLabel:String = label + " - " + workflowModel.title;	
				return wfLabel;
			}
		}
		
		
		//****************** STRUCTURE PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSteps():Array {
			if (workflowModel) return workflowModel.steps;
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepAbbreviation(stepUID:int):String {
			if (workflowModel) return workflowModel.getStepAbbreviation(stepUID);
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLastLog(uid:int):Object {
			if (workflowModel) return workflowModel.getLastLog(uid);
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnections():Array {
			if (workflowModel) return workflowModel.connections
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlags():Array {
			if (workflowModel) return workflowModel.flags;
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlag(flagUID:int):FlagModel {
			if (workflowModel) return workflowModel.getFlag(flagUID);
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDefaultFlagUID():int {
			if (workflowModel) return workflowModel.getDefaultFlagUID();
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlagColor(flagUID:int):uint {
			if (workflowModel) return workflowModel.getFlagColor(flagUID);
			return null;
		}
		
		
		//****************** PUBLIC DOCS METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param tile
		 * @param author
		 * 
		 */
		public function addDocument(data:Object):void {
			
			//get data
			var docData:Object = data;
			docData.wfid = workflowModel.id;
			
			//convert to Json
			var Jdata:String = JSON.stringify(docData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest(PHPGateWay.addDocument());
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
														{name:"add",
														estimatedBytes:200,
														onProgress:progressHandler,
														onComplete:addDocHandler,
														onError:errorHandler});
			dataLoader.load();
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addLog(data:Object):void {
			//get data
			var docData:Object = data;
			docData.wfid = workflowModel.id;
			
			//convert to Json
			var Jdata:String = JSON.stringify(docData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest(PHPGateWay.addLog());
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
														{name:"addLog",
															estimatedBytes:200,
															onProgress:progressHandler,
															onComplete:addLogDocHandler,
															onError:errorHandler});
			dataLoader.load();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeDoc(uid:int):void {
			//get data
			var docData:Object = new Object();
			docData.itemUID = uid;
			
			//convert to Json
			var Jdata:String = JSON.stringify(docData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest(PHPGateWay.removeDoc());
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
														{name:"remove",
															estimatedBytes:200,
															onProgress:progressHandler,
															onComplete:removeDocHandler,
															onError:errorHandler});
			dataLoader.load();
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function loadDocLog(docUID:int):void {
			//get data
			var docData:Object = new Object();
			docData.itemUID = docUID;
			
			//convert to Json
			var Jdata:String = JSON.stringify(docData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest(PHPGateWay.loadDocLog());
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
														{name:"getDocLog",
															estimatedBytes:200,
															onProgress:progressHandler,
															onComplete:loadDocLogcompleted,
															onError:errorHandler});
			dataLoader.load();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlow():Array {
			if (workflowModel) return workflowModel.flow;
			return null
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDocTitle(uid:int):String {
			if (workflowModel) return workflowModel.getDocTitle(uid);
			return null;
		}
		
		/**
		 * 
		 * @param uid
		 * @return 
		 * 
		 */
		public function getDocData(uid:int):Object {
			if (workflowModel) return workflowModel.getDocDetails(uid);
			return null;
		}
		
		
		//****************** MAIN WORKFLOW METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function addDocHandler(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			trace (dataLoader.content);
			var itemData:Object = JSON.parse(dataLoader.content);
			
			if (workflowModel) {
				var newPin:Object = workflowModel.addItem(itemData.uid,
															itemData.title,
															itemData.log,
															itemData.description);
				
				
				var data:Object = {pin:newPin};
				data.messageType = MessageType.SUCCESS;
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.ADD,data,dataLoader.name));
			}

		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function addLogDocHandler(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			trace (dataLoader.content);
			var itemData:Object = JSON.parse(dataLoader.content);
			
			if (workflowModel) {
				
				var pinModel:PinModel = workflowModel.getDoc(itemData.itemUID)
				pinModel.addLog(itemData.uid, itemData.flagUID, itemData.stepUID, itemData.date);
				
				var data:Object = {item:pinModel};
				data.action = "logAdded";
				data.messageType = MessageType.SUCCESS;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.UPDATE_PIN,data,dataLoader.name));
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function removeDocHandler(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			trace (dataLoader.content);
			var itemData:Object = JSON.parse(dataLoader.content);
			
			if (workflowModel) workflowModel.removeDoc(itemData.itemUID);
				
				
			var data:Object = {itemUID:itemData.itemUID};
			data.messageType = MessageType.SUCCESS;
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.REMOVE,data,dataLoader.name));
			
		}
		
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
			trace (dataLoader.content);
			var workflowData:Object = JSON.parse(dataLoader.content);
			
			workflowModel = new WorkflowModel(workflowData.id,
															workflowData.title,
															workflowData.flags,
															workflowData.steps,
															workflowData.connections,
															workflowData.flow);
			
			workflowModel.source = this;
			
			var data:Object = {id:workflowData.id};
			data.action = "workflowLoaded";
			data.messageType = MessageType.SUCCESS;
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE,data,dataLoader.name));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function loadDocLogcompleted(event:LoaderEvent):void {
			
			var dataLoader:DataLoader = DataLoader(event.target);
			trace (dataLoader.content);
			var itemData:Object = JSON.parse(dataLoader.content);
			
			if (workflowModel) {
				
				var pinModel:PinModel = workflowModel.getDoc(itemData.uid);
				
				pinModel.attachFullLog(itemData.logs);
				
				
				var data:Object = {item:pinModel};
				data.action = "logLoaded";
				data.messageType = MessageType.SUCCESS;
				
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE,data,dataLoader.name));
			}
			
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandler(event:LoaderEvent):void {
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,event.text));
		}
	}
}