package view.workflow.structure {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import controller.WrkFlowController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
	import view.workflow.structure.network.StructureNetwork;
	import view.workflow.structure.steps.Step;
	import view.workflow.structure.steps.StructureList;
	import view.workflow.tag.Tags;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var structureList		:StructureList;
		protected var structureNetwork	:StructureNetwork;
		
		protected var tags				:view.workflow.tag.Tags;
		
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
			
			//tags
			if (Settings.tagsVisibility) this.showTags();
			
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
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function showTags():void {
			
			if (!tags) {
				
				var tagData:Array = WrkFlowController(this.getController()).getTags();
				
				tags = new view.workflow.tag.Tags(this);
				this.addChild(tags);
				tags.init(tagData);
			
			} else {
	
				TweenLite.to(tags,1,{y:100, alpha:0, onComplete:this.removeChild, onCompleteParams:[tags]});
				tags = null;
	
			}
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

	}
}