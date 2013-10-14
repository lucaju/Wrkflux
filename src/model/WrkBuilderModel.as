package model {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	
	import flash.events.ErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import events.WrkfluxEvent;
	
	import model.builder.FlagsPreset;
	import model.builder.StepModel;
	import model.builder.StepsPreset;
	import model.builder.WorkflowModel;
	
	import mvc.Observable;
	
	import util.MessageType;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkBuilderModel extends Observable {
		
		//****************** Properties ****************** ****************** ******************
		
		public const label					:String = "Wrkflux [Build Mode]";
		
		public const menuRight				:Array = [{label:"Close"}];
		public const menuLeft				:Array = [{label:"Save"}, {label:"Use"}];
		
		protected var workflowModel			:WorkflowModel;
		protected var flagsPresets			:FlagsPreset;
		protected var stepsPresets			:StepsPreset;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function WrkBuilderModel() {
			super();
			
			//define name
			this.name = "wrkbuilder";
			
		}
		
		
		//****************** PUBLIC MAIN WORKFLOW METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param tile
		 * @param author
		 * 
		 */
		public function createWorkflow(title:String, author:String):void {
			
			//get data
			var wfData:Object = new Object();
			wfData.title = title;
			wfData.author = author;
			wfData.flags = this.getFlagsPreset(3); //preset
			wfData.steps = this.getStepsPreset(1);
			
			//convert to Json
			var Jdata:String = JSON.stringify(wfData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest("http://labs.fluxo.art.br/wrkflux/insertWorkflow.php");
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
													   {name:"create",
														estimatedBytes:200,
														onProgress:progressHandler,
														onComplete:completeHandler,
														onError:errorHandler});
			dataLoader.load();
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function loadWorkflow(wfID:int):void {
			var request:URLRequest = new URLRequest("http://labs.fluxo.art.br/wrkflux/getWorkflowBuildInfo.php");
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
		
		
		//****************** PUBLIC FLAGS METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addFlag():Object {
			if (workflowModel) {
				var flag:Object = workflowModel.addFlag();
				return flag;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlagsPreset(limit:int = 0):Array {
			if (!flagsPresets) flagsPresets = new FlagsPreset();
			return flagsPresets.getFlagsPreset(limit);
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
		public function removeFlag(id:*):Boolean {
			return workflowModel.removeFlag(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function updateFlag(id:*,data:Object):Boolean {
			var flag:Object = workflowModel.updateFlag(id,data);
			return flag;
		}
		
		
		//****************** PUBLIC STEPS METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addStep(position:Point):Object {
			if (workflowModel) {
				var step:Object = workflowModel.addStep(position);
				return step;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepsPreset(limit:int = 0):Array {
			if (!stepsPresets) stepsPresets = new StepsPreset();
			return stepsPresets.getStepsPreset(limit);
		}
		
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
		 * @param uid
		 * @return 
		 * 
		 */
		public function getStepData(uid:*):model.builder.StepModel {
			if (workflowModel) return workflowModel.stepsManager.getStepData(uid);
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeStep(id:*):Boolean {
			return workflowModel.removeStep(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function updateStep(id:*,data:Object):Boolean {
			var step:Object = workflowModel.updateStep(id,data);
			return step;
		}
		
		//****************** PUBLIC NETWORK CONNECTIONS METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addConnection(data:Object):Object {
			if (workflowModel) {
				var step:Object = workflowModel.addConnection(data);
				return step;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeConnection(id:*):Boolean {
			return workflowModel.removeConnection(id);
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
		public function getConnectionsByStep(uid:*):Array {
			if (workflowModel) return workflowModel.connectionsManager.getConnectionsByStep(uid);
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnectionsInfoByStep(uid:*):Array {
			if (workflowModel) return workflowModel.connectionsManager.getConnectionsInfoByStep(uid);
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnectionInfo(uid:*):Object {
			if (workflowModel) return workflowModel.connectionsManager.getConnectionInfo(uid);
			return null;
		}
		
		
		//****************** PUBLIC TAGSMETHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addTag(data:Object):Object {
			if (workflowModel) {
				var tag:Object = workflowModel.addTag(data);
				return tag;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getTags():Array {
			if (workflowModel) return workflowModel.tags;
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeTag(id:*):Boolean {
			return workflowModel.removeTag(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function updateTag(id:*,data:Object):Boolean {
			var tag:Object = workflowModel.updateTag(id,data);
			return tag;
		}
		

		
		
		//****************** MAIN WORKFLOW METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function save():Boolean {
			
			//get data
			var wfData:Object = new Object();
			wfData.action = "updateWorkflowBuild";
			wfData.id = workflowModel.id;
			//wfData.title = workflowProjectModel.title;
			//wfData.author = workflowProjectModel.author;
			
			//flags
			if (workflowModel.flagsManager.hasFlagsAdded) 	wfData.added_flags = workflowModel.flagsManager.getFlagsAdded();
			if (workflowModel.flagsManager.hasFlagsUpdated) wfData.updated_flags = workflowModel.flagsManager.getFlagsUpdated();
			if (workflowModel.flagsManager.hasFlagsRemoved) wfData.removed_flags = workflowModel.flagsManager.getFlagsRemoved();
			
			//steps
			if (workflowModel.stepsManager.hasStepsAdded) wfData.added_steps = workflowModel.stepsManager.getStepsAdded();
			if (workflowModel.stepsManager.hasStepsUpdated) wfData.updated_steps = workflowModel.stepsManager.getStepsUpdated();
			if (workflowModel.stepsManager.hasStepsRemoved) wfData.removed_steps = workflowModel.stepsManager.getStepsRemoved();
			
			//Conenctions
			if (workflowModel.connectionsManager.hasConnectionsAdded) wfData.added_connections = workflowModel.connectionsManager.getConnectionsAdded();
			if (workflowModel.connectionsManager.hasConnectionsRemoved) wfData.removed_connections = workflowModel.connectionsManager.getConnectionsRemoved();
			
			//tags
			if (workflowModel.tagsManager.hasTagsAdded) wfData.added_tags = workflowModel.tagsManager.getTagsAdded();
			if (workflowModel.tagsManager.hasTagsUpdated) wfData.updated_tags = workflowModel.tagsManager.getTagsUpdated();
			if (workflowModel.tagsManager.hasTagsRemoved) wfData.removed_tags = workflowModel.tagsManager.getTagsRemoved();
			
			//convert to Json
			var Jdata:String = JSON.stringify(wfData);
			
			//Load to urlVariables
			var variables:URLVariables = new URLVariables();
			variables.wdata = Jdata;
			
			//define request url
			var request:URLRequest = new URLRequest("http://labs.fluxo.art.br/wrkflux/updateWorkflowBuild.php");
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			//send data
			var dataLoader:DataLoader = new DataLoader(request,
				{name:"update",
					estimatedBytes:200,
					onProgress:progressHandler,
					onComplete:updateHandler,
					onError:errorHandler});
				dataLoader.load();
			
			return true;
		}
		
		
		//****************** MAIN WORKFLOW EVENTS ****************** ****************** ******************
		
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
															workflowData.author,
															workflowData.created_date,
															workflowData.modified_date,
															workflowData.flags,
															workflowData.steps,
															workflowData.connections,
															workflowData.tags);
			
			workflowModel.source = this;
			
			var data:Object = {id:workflowData.id};
			data.messageType = MessageType.SUCCESS;
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE,data,dataLoader.name));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updateHandler(event:LoaderEvent):void {
			
			//get feedback
			var dataLoader:DataLoader = DataLoader(event.target);
			trace (dataLoader.content);
			var workflowData:Object = JSON.parse(dataLoader.content);
			
			//update uid in recently added flags and steps
			var data:Object = new Object();
			data.flagsAdded = workflowModel.flagsManager.registerAddedFlags(workflowData.added_flags);
			data.stepAdded = workflowModel.stepsManager.registerAddedSteps(workflowData.added_steps);
			data.connectionsAdded = workflowModel.connectionsManager.registerAddedConnections(workflowData.added_connections);
			data.tagsAdded = workflowModel.tagsManager.registerAddedTags(workflowData.added_tags);
			
			data.message = "Workflow Saved.";
			data.messageType = MessageType.SUCCESS;
			
			//dispatch event
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.CHANGE, data));
			
			//delete previous flags changes
			workflowModel.flagsManager.dumpFlagsAdded();
			workflowModel.flagsManager.dumpFlagsUpdated();
			workflowModel.flagsManager.dumpFlagsRemoved();
			
			//delete previous flags changes
			workflowModel.stepsManager.dumpStepsAdded();
			workflowModel.stepsManager.dumpStepsUpdated();
			workflowModel.stepsManager.dumpStepsRemoved();
			
			//delete previous flags changes
			workflowModel.connectionsManager.dumpConnectionsAdded();
			workflowModel.connectionsManager.dumpConnectionsRemoved();
			
			//delete previous flags changes
			workflowModel.tagsManager.dumpTagsAdded();
			workflowModel.tagsManager.dumpTagsUpdated();
			workflowModel.tagsManager.dumpTagsRemoved();
			
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