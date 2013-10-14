package controller {
	
	//imports
	import model.WrkfluxModel;
	
	import mvc.AbstractController;
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WrkfluxController extends AbstractController {
		
		//****************** Properties ****************** ****************** ******************
		
		private var _model:Observable;			//generic model
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param modelList
		 * 
		 */
		public function WrkfluxController(modelList:Array) {
			super(modelList);
		}
		
		//****************** MAIN METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function newWorkflow():void {
			WrkfluxModel(this.getModel("wrkflux")).changeView("edit");
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function loadWorkflow(id:int, action:String):void {
			WrkfluxModel(this.getModel("wrkflux")).changeView(action,id);
		}
		
		/**
		 * 
		 * 
		 */
		public function getWorkflows():void {
			WrkfluxModel(this.getModel("wrkflux")).getWorkflows();
		}
		
	}
}