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
		 * @param action
		 * 
		 */
		public function loadWorkflow(id:int, action:String):void {
			WrkfluxModel(this.getModel("wrkflux")).changeView(action,id);
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function deleteWorkflow(id:int):void {
			WrkfluxModel(this.getModel("wrkflux")).deleteWorkflow(id);
		}
		
		/**
		 * 
		 * 
		 */
		public function getWorkflows():void {
			WrkfluxModel(this.getModel("wrkflux")).getWorkflows();
		}
		
		/**
		 * 
		 * 
		 */
		public function getUserWorkflows(userID:int):void {
			WrkfluxModel(this.getModel("wrkflux")).getUserWorkflows(userID);
		}

		/**
		 * 
		 * @param data
		 * 
		 */
		public function register(data:Object):void {
			if (data.name == "SignInForm") {
				WrkfluxModel(this.getModel("wrkflux")).signIn(data);
			} else {
				WrkfluxModel(this.getModel("wrkflux")).signUp(data);
			}
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function updateProfile(data:Object):void {
			WrkfluxModel(this.getModel("wrkflux")).updateProfile(data);
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function forgotPass(data:Object):void {
			WrkfluxModel(this.getModel("wrkflux")).forgotPass(data);
		}
		
		/**
		 * 
		 * 
		 */
		public function closeSession():void {
			WrkfluxModel(this.getModel("wrkflux")).closeSession();
		}
		
	}
}