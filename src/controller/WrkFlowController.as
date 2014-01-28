package controller {
	
	//imports
	import model.FlagModel;
	import model.WrkBuilderModel;
	import model.WrkFlowModel;
	import model.WrkfluxModel;
	
	import mvc.AbstractController;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkFlowController extends AbstractController {
		
		//****************** Properties ****************** ****************** ******************
		
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param modelList
		 * 
		 */
		public function WrkFlowController(modelList:Array) {
			super(modelList);
		}
		
		
		//****************** MAIN METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function close():void {
			WrkfluxModel(this.getModel("wrkflux")).changeView("initial");
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function editStructure(id:int):void {
			WrkfluxModel(this.getModel("wrkflux")).changeView("edit",id);
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function loadWorkflow(id:int):void {
			WrkFlowModel(this.getModel("wrkflow")).loadWorkflow(id);
		}
		
		
		//****************** TOP BAR METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLabel():String {
			return WrkFlowModel(this.getModel('wrkflow')).getLabel();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getMenuOptions(value:String):Array {
			
			switch (value) {
				
				case "left":
					return WrkFlowModel(this.getModel('wrkflow')).menuLeft;
					break;
				
				case "right":
					return WrkFlowModel(this.getModel('wrkflow')).menuRight;
					break;
				
				default:
					return null;
			}
			
		}
		
		//****************** STRUCTURE ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlags():Array {
			return WrkFlowModel(this.getModel("wrkflow")).getFlags();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlag(flagUID:int):FlagModel {
			return WrkFlowModel(this.getModel("wrkflow")).getFlag(flagUID);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDefaultFlagUID():int {
			return WrkFlowModel(this.getModel("wrkflow")).getDefaultFlagUID();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlagColor(flagUID:int):uint {
			return WrkFlowModel(this.getModel("wrkflow")).getFlagColor(flagUID);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSteps():Array {
			return WrkFlowModel(this.getModel("wrkflow")).getSteps();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepAbbreviation(stepUID:int):String {
			return WrkFlowModel(this.getModel("wrkflow")).getStepAbbreviation(stepUID);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnections():Array {
			return WrkFlowModel(this.getModel("wrkflow")).getConnections();
		}
		
		
		//****************** FLOW ****************** ****************** ******************

		/**
		 * 
		 * 
		 */
		public function addDoc(data:Object):void {
			WrkFlowModel(this.getModel("wrkflow")).addDocument(data);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlow():Array {
			return WrkFlowModel(this.getModel("wrkflow")).getFlow();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDocTitle(uid:int):String {
			return WrkFlowModel(this.getModel("wrkflow")).getDocTitle(uid);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDocData(uid:int):Object {
			return WrkFlowModel(this.getModel("wrkflow")).getDocData(uid);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLastLog(uid:int):Object {
			return WrkFlowModel(this.getModel("wrkflow")).getLastLog(uid);
		}
		
		/**
		 * 
		 * 
		 */
		public function addLog(data:Object):void {
			WrkFlowModel(this.getModel("wrkflow")).addLog(data);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function loadDocLog(uid:int):void {
			WrkFlowModel(this.getModel("wrkflow")).loadDocLog(uid);
		}
		
		/**
		 * 
		 * 
		 */
		public function removeDoc(uid:int):void {
			WrkFlowModel(this.getModel("wrkflow")).removeDoc(uid);
		}
		
		//****************** TAGS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getTags():Array {
			return WrkFlowModel(this.getModel("wrkflow")).getTags();
		}
		
	}
}