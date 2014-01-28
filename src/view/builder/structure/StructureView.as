package view.builder.structure {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import controller.WrkBuilderController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.builder.structure.network.ConnectionPen;
	import view.builder.structure.network.StructureNetwork;
	import view.builder.structure.steps.Step;
	import view.builder.structure.steps.StructureList;
	import view.builder.structure.steps.info.InfoStep;
	import view.builder.tag.Tags;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var structureList		:StructureList;
		protected var structureNetwork	:StructureNetwork;
		
		protected var _background		:Background;
		protected var _deleteButton		:RemoveButton;
		
		protected var _pen				:ConnectionPen;
		
		protected var tags				:Tags;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function StructureView(c:IController) {
			super(c);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//Background
			background = new Background();
			background.x = 5;
			background.y = 5;
			this.addChild(background);
			
			//list
			var strucutureData:Array = WrkBuilderController(this.getController()).getSteps();
			
			structureList = new StructureList(this,strucutureData);
			structureList.x = 5;
			structureList.y = 5;
			this.addChild(structureList);
			
			//network
			var strucutureNetworkData:Array = WrkBuilderController(this.getController()).getConnections();
			
			structureNetwork = new StructureNetwork(this);
			structureNetwork.structureList = structureList;
			structureNetwork.x = 5;
			structureNetwork.y = 5;
			structureNetwork.init(strucutureNetworkData);
			this.addChildAt(structureNetwork,1);
			
			structureList.network = structureNetwork;
			
			//tags
			var tagData:Array = WrkBuilderController(this.getController()).getTags();
			
			tags = new Tags(this);
			this.addChild(tags);
			tags.init(tagData);
			
			//delete button
			deleteButton = new RemoveButton();
			deleteButton.x = background.x + background.width - (deleteButton.width/2);
			deleteButton.y = background.y + background.height - (deleteButton.height/2) + 40;
			this.addChild(deleteButton);
			deleteButton.visible = false;
			
			//listeners
			structureList.addEventListener(WrkfluxEvent.ADD, addConnection);
			structureList.addEventListener(Event.CLOSING, removeStep);	
			structureList.addEventListener(WrkfluxEvent.SELECT, updateStructure);
			structureNetwork.addEventListener(WrkfluxEvent.COMPLETE, networkActionComplete);
			tags.addEventListener(WrkfluxEvent.COMPLETE, tagActionComplete);
			
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function removeStep(event:Event):void {
			event.stopImmediatePropagation();
			
			if (event.target is Step) {
				var selectedStep:Step = event.target as Step;
				var id:* = (selectedStep.tempID) ? selectedStep.tempID : selectedStep.id;
				
				structureNetwork.removeConnections(id);
				
				WrkBuilderController(this.getController()).removeStep(id);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updateStructure(event:WrkfluxEvent):void {
			
			var data:Object = new Object();
			var selectedStep:Step;
			var selectedStepInfo:InfoStep;
			var id:*;
			
			switch (event.data.action) {
				
				case "changePosition":
					
					selectedStep = event.target as Step;
					
					id = (selectedStep.tempID) ? selectedStep.tempID : selectedStep.id;
					
					data.position = new Point(selectedStep.x, selectedStep.y);
					
					WrkBuilderController(this.getController()).updateStep(id,data);
					
					break;
				
				
				case "changeLabel":
					
					selectedStepInfo = event.target as InfoStep;
					
					id = selectedStepInfo.stepID;
					
					data.title = selectedStepInfo.title;
					data.abbreviation = selectedStepInfo.abbreviation;
					
					WrkBuilderController(this.getController()).updateStep(id,data);
					
					break;
				
				case "changeShape":
					
					selectedStepInfo = event.target as InfoStep;
					
					id = selectedStepInfo.stepID;
					
					data.title = selectedStepInfo.title;
					data.abbreviation = selectedStepInfo.abbreviation;
					data.shape = selectedStepInfo.selectedShape;
					
					WrkBuilderController(this.getController()).updateStep(id,data);
					
					break;
				
				case "removeInfoLink":
					
					structureNetwork.removeConnection(event.data.uid);
					WrkBuilderController(this.getController()).removeConnection(event.data.uid);
					
					break;
				
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function addConnection(event:WrkfluxEvent):void {
			if (event.data.action == "addConnection") {
				structureNetwork.newConnection(event.data.sourceID);
				showDelete(true);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function networkActionComplete(event:WrkfluxEvent):void {
			
			var connection:Object;
			var createdConnection:Object
			
			if (event.data.action == "createNewConnection") {
				
				connection = event.data.connection;
				
				//create networkline
				createdConnection = WrkBuilderController(this.getController()).addConnection(connection);
					
				//update networkline temp uid
				structureNetwork.updateCurrentConnectionTempUID(createdConnection);
				
				//update infoStep
				structureList.updateInfoStep(createdConnection.tempUID);
				
			}
			
			else if (event.data.action == "createNewStep") {
				
				connection = event.data.connection;
				var stepPostion:Point = event.data.position;
				
				var newStep:Object = WrkBuilderController(this.getController()).addStep(event.data.position);
				if (newStep) {
					
					//update network info
					structureNetwork.updateCurrentConnectionTarget(newStep);
					
					connection.targetID = newStep.uid;
					connection.targetTempID = newStep.tempID;
					
					//create networkline
					createdConnection = WrkBuilderController(this.getController()).addConnection(connection);
					
					//update networkline temp uid
					structureNetwork.updateCurrentConnectionTempUID(createdConnection);
					
					//add step
					structureList.addStep(newStep);
					
					//update infoStep
					structureList.updateInfoStep(createdConnection.tempUID);
				}
				
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function tagActionComplete(event:WrkfluxEvent):void {
			
			var tID:*;
			
			switch (event.data.action) {
				
				case "createNewTag":
					WrkBuilderController(this.getController()).addTag(event.data);
					break;
				
				case "updateTag":
					tID = (event.data.uid != 0) ? event.data.uid : event.data.tempUID;
					WrkBuilderController(this.getController()).updateTag(tID,event.data);
					break;
				
				case "removeTag":
					tID = (event.data.uid != 0) ? event.data.uid : event.data.tempUID;
					WrkBuilderController(this.getController()).removeTag(tID);
					break;
			}
		}	
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function showTags():void {
			tags.visible = !tags.visible;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function showDelete(value:Boolean):void {
			if (value) {
				TweenLite.to(deleteButton,.4,{y:background.y + background.height - (deleteButton.height/2), autoAlpha:.8});
			} else {
				TweenLite.to(deleteButton,.4,{y:background.y + background.height - (deleteButton.height/2) + 40, autoAlpha:0});
				deleteButton.highlight(false);
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function updateStepsUID(recentAddedSteps:Array):void {
			structureList.updateStepsUID(recentAddedSteps);
		}
		
		/**
		 * 
		 * 
		 */
		public function updateConnectionsUID(recentAddedConnections:Array):void {
			structureNetwork.updateConnectionsUID(recentAddedConnections);
		}
		
		/**
		 * 
		 * 
		 */
		public function updateTagsUID(recentAddedTags:Array):void {
			tags.updateTagsUID(recentAddedTags);
		}
		
		/**
		 * 
		 * 
		 */
		public function checkStrucutureOverlap():Boolean {
			return structureList.checkStrucutureOverlap();
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get deleteButton():RemoveButton {
			return _deleteButton;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set deleteButton(value:RemoveButton):void {
			_deleteButton = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get pen():ConnectionPen {
			return _pen;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set pen(value:ConnectionPen):void {
			_pen = value;
		}


	}
}