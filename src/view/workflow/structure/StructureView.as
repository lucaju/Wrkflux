package view.workflow.structure {
	
	//imports
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.workflow.structure.network.StructureNetwork;
	import view.workflow.structure.steps.Step;
	import view.workflow.structure.steps.StructureList;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var structureList		:StructureList;
		protected var structureNetwork	:StructureNetwork;
		
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
			
			//list
			var strucutureData:Array = WrkFlowController(this.getController()).getSteps();
			
			structureList = new StructureList(this,strucutureData);
			structureList.x = 5;
			structureList.y = 5;
			this.addChild(structureList);
			
			//network
			var strucutureNetworkData:Array = WrkFlowController(this.getController()).getConnections();
			
			structureNetwork = new StructureNetwork(this);
			structureNetwork.structureList = structureList;
			structureNetwork.x = 5;
			structureNetwork.y = 5;
			structureNetwork.init(strucutureNetworkData);
			this.addChildAt(structureNetwork,0);
			
			structureList.network = structureNetwork;
			
			//listeners
			structureList.addEventListener(WrkfluxEvent.SELECT, updateStructure);
			
		}		
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updateStructure(event:WrkfluxEvent):void {
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param stepUID
		 * @return 
		 * 
		 */
		public function getStep(stepUID:int):Step {
			return structureList.getStep(stepUID);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getAllSteps():Array {
			return structureList.itemCollection
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

	}
}