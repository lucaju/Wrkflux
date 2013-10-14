package model.builder {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StepsPreset {

		//****************** Properties ****************** ****************** ******************
		
		protected var collection		:Array;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function StepsPreset() {
			
			collection = new Array();
			collection[0] = new StepModel(0,"Start", "Start",0,"80,300");
			
		}
		
		//****************** Public Methods ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepsPreset(limit:int = 0):Array {
			if (limit == 0) {
				return collection.concat();
			} else {
				return collection.slice(0,limit);	
			}
		}
	}
}