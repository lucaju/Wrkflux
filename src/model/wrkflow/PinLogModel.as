package model.wrkflow {
	
	//imports
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinLogModel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _logUID				:int;
		protected var _stepUID				:int;
		protected var _flagUID				:int;
		protected var _date					:Date;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param logUID
		 * @param stepUID
		 * @param flagUID
		 * @param date
		 * 
		 */
		public function PinLogModel(logUID:int, flagUID:int, stepUID:int, date:Date) {
			
			this._logUID = logUID;
			this._stepUID = stepUID;
			this._flagUID = flagUID;
			this._date = date;
			
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get logUID():int {
			return _logUID;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get stepUID():int {
			return _stepUID;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flagUID():int {
			return _flagUID;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get date():Date {
			return _date;
		}

	}
}