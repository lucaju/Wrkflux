package mvc {
	
	//imports
	import flash.events.EventDispatcher;
	
	/**
	 * @author lucaju
	 * Provides basic services for the "controller" of
	 * a Model/View/Controller triad.
	 */
	public class AbstractController extends EventDispatcher implements IController {
		
		//****************** Properties ****************** ****************** ******************
		
		private var modelArray			:Array;
		private var model				:Observable;
		
		private var viewArray			:Array;
		private var view				:IView;
		
		
		//****************** Construct ****************** ****************** ******************
		
		/**
		 * Constructor
		 *
		 * @param: Either a model or a List of models this controller's view is observing.
		 */
		public function AbstractController(param:*) {
			
			//intial
			modelArray = new Array();
			viewArray = new Array();
			
			if (param is Observable) {
				
				this.addModel(param);
				
			} else {
				
				for (var i:int = 0; i < param.length; i++) {
					if (param[i] is Observable) this.addModel(param[i]);
				}
				
			}

		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		//****************** MODEL ****************** ****************** ******************
		
		/**
		 * Adds a model to this controller.
		 * @param m
		 * 
		 */
		public function addModel(m:Observable):void {
			modelArray.push(m);
		}
		
		/**
		 * Removes a model from this controller.
		 * @param param
		 * 
		 */
		public function removeModel(param:*):Boolean {
			
			//test the parameters
			//if Observable, remove it
			//else if String than search by name
			//else, it is Number. Search by index position
			
			if(param is Observable) {
				
				//loop
				for each(var model:Observable in modelArray) {
					if (model == param) {
						modelArray.splice(modelArray.indexOf(model),1);
						return true;
					}
				}
				
			} else if(param is String) {
				var name:String = param;
				
				//loop
				for each(var m:Observable in modelArray) {
					if (m.name == name) {
						modelArray.splice(modelArray.indexOf(m),1);
						return true;
					}
				}
				
			} else {
				var index:int = param;
				modelArray.splice(index,1);
				return true;
			}
			
			
			//if not found anything
			return false;
		}
		
		/**
		 * Returns a model for this controller.
		 * @param param
		 * @return 
		 * 
		 */
		public function getModel(param:*):Observable {
			
			//test the parameters
			//If String than search by name
			//else, it is Number. Search by index position
			if(param is String) {
				var name:String = param;
				
				//loop
				for each(var m:Observable in modelArray) {
					if (m.name == name) return m;
				}
				
			} else {
				var index:int = param;
				return modelArray[index];
			}
			
			
			//if not found anything
			return null;
		}
		
		
		//****************** VIEW ****************** ****************** ******************
		
		/**
		 * Adds a view that this controller is servicing.
		 * @param v
		 * 
		 */
		public function addView(v:IView):void {
			viewArray.push(v);
		}
		
		/**
		 * Remove a view that this controller is servicing.
		 * @param v
		 * 
		 */
		public function removeView(param:*):Boolean {
			//test the parameters
			//if Observable, remove it
			//else if String than search by name
			//else, it is Number. Search by index position
			
			if(param is AbstractView) {
				
				//loop
				for each(var view:AbstractView in viewArray) {
					if (view == param) {
						viewArray.splice(viewArray.indexOf(view),1);
						return true;
					}
				}
				
			} else if(param is String) {
				var name:String = param;
				
				//loop
				for each(var v:AbstractView in viewArray) {
					if (v.name == name) {
						viewArray.splice(viewArray.indexOf(v),1);
						return true;
					}
				}
				
			} else {
				var index:int = param;
				viewArray.splice(index,1);
				return true;
			}
			
			
			//if not found anything
			return false;
		}
		
		/**
		 * Returns a controller's view.
		 */
		public function getView(param:*):AbstractView {
			//test the parameters
			//If String than search by name
			//else, it is Number. Search by index position
			
			if(param is String) {
				var name:String = param;
				
				//loop
				for each(var v:AbstractView in viewArray) {
					if (v.name == name) return v;
				}
				
			} else {
				var index:int = param;
				return viewArray[index];
			}
			
			//if not found anything
			return null;
		}
	}
}