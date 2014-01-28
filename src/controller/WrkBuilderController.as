package controller {
	
	//imports
	import flash.geom.Point;
	
	import model.WrkfluxModel;
	import model.WrkBuilderModel;
	import model.builder.StepModel;
	
	import mvc.AbstractController;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkBuilderController extends AbstractController {
		
		//****************** Properties ****************** ****************** ******************
		
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param modelList
		 * 
		 */
		public function WrkBuilderController(modelList:Array) {
			super(modelList);
		}
		
		
		//****************** MAIN METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function closeBuilder():void {
			WrkfluxModel(this.getModel("wrkflux")).changeView("initial");
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function useStructure(id:int):void {
			WrkfluxModel(this.getModel("wrkflux")).changeView("use",id);
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function loadWorkflow(id:int):void {
			WrkBuilderModel(this.getModel("wrkbuilder")).loadWorkflow(id);
		}
		
		/**
		 * 
		 * @param tile
		 * @param author
		 * 
		 */
		public function createWorkflow(title:String, author:String):void {
			WrkBuilderModel(this.getModel("wrkbuilder")).createWorkflow(title,author);
		}
		
		/**
		 * 
		 * 
		 */
		public function save():Boolean {
			return WrkBuilderModel(this.getModel("wrkbuilder")).save();
		}
		
		
		//****************** TOP BAR METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLabel():String {
			return WrkBuilderModel(this.getModel('wrkbuilder')).getLabel();
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
					return WrkBuilderModel(this.getModel('wrkbuilder')).menuLeft;
					break;
				
				case "right":
					return WrkBuilderModel(this.getModel('wrkbuilder')).menuRight;
					break;
				
				default:
					return null;
			}
			
		}
		
		//****************** FLAGS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addFlag():Object {
			var flag:Object = WrkBuilderModel(this.getModel("wrkbuilder")).addFlag();
			return flag;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlagsPreset(limit:int = 0):Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getFlagsPreset(limit);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getflags():Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getFlags();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeFlag(id:*):Boolean {
			var flag:Object = WrkBuilderModel(this.getModel("wrkbuilder")).removeFlag(id);
			return flag;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function updateFlag(id:*,data:Object):Boolean {
			var flag:Object = WrkBuilderModel(this.getModel("wrkbuilder")).updateFlag(id,data);
			return flag;
		}
		
		//****************** STRUCTURE ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function addStep(position:Point):Object {
			var step:Object = WrkBuilderModel(this.getModel("wrkbuilder")).addStep(position);
			return step;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepsPreset(limit:int = 0):Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getStepsPreset(limit);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSteps():Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getSteps();
		}
		
		/**
		 * 
		 * @param uid
		 * @return 
		 * 
		 */
		public function getStepData(uid:*):StepModel {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getStepData(uid);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeStep(id:*):Boolean {
			var Step:Object = WrkBuilderModel(this.getModel("wrkbuilder")).removeStep(id);
			return Step;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function updateStep(id:*,data:Object):Boolean {
			var Step:Object = WrkBuilderModel(this.getModel("wrkbuilder")).updateStep(id,data);
			return Step;
		}
		
		//****************** NETWORK CONNECTION ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addConnection(data:Object):Object {
			var connection:Object = WrkBuilderModel(this.getModel("wrkbuilder")).addConnection(data);
			return connection;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeConnection(id:*):Boolean {
			var Step:Object = WrkBuilderModel(this.getModel("wrkbuilder")).removeConnection(id);
			return Step;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnections():Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getConnections();
		}
		
		/**
		 * 
		 * @param uid
		 * @return 
		 * 
		 */
		public function getConnectionsByStep(uid:*):Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getConnectionsByStep(uid);
		}
		
		/**
		 * 
		 * @param uid
		 * @return 
		 * 
		 */
		public function getConnectionsInfoByStep(uid:*):Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getConnectionsInfoByStep(uid);
		}
		
		/**
		 * 
		 * @param uid
		 * @return 
		 * 
		 */
		public function getConnectionInfo(uid:*):Object {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getConnectionInfo(uid);
		}
		
		
		//****************** TAGS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function addTag(data:Object):Object {
			var tag:Object = WrkBuilderModel(this.getModel("wrkbuilder")).addTag(data);
			return tag;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getTags():Array {
			return WrkBuilderModel(this.getModel("wrkbuilder")).getTags();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeTag(id:*):Boolean {
			var tag:Object = WrkBuilderModel(this.getModel("wrkbuilder")).removeTag(id);
			return tag;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function updateTag(id:*,data:Object):Boolean {
			var tag:Object = WrkBuilderModel(this.getModel("wrkbuilder")).updateTag(id,data);
			return tag;
		}
		
		
	}
}