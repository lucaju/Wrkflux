package model.builder {
	
	//imports
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StepConnection {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _tempUID				:String;
		protected var _sourceTempUID		:String;
		protected var _targetTempUID		:String;
		
		protected var _uid					:int;
		protected var _source				:int;
		protected var _target				:int;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @param source
		 * @param target
		 * 
		 */
		public function StepConnection(uid:int, source:int, target:int) {
			this._uid = uid;
			this._source = source;
			this._target = target;
		}
		
		//****************** GETTERS / SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tempUID():String {
			return _tempUID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tempUID(value:String):void {
			_tempUID = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get sourceTempUID():String {
			return _sourceTempUID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set sourceTempUID(value:String):void {
			_sourceTempUID = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get targetTempUID():String {
			return _targetTempUID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set targetTempUID(value:String):void {
			_targetTempUID = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get uid():int {
			return _uid;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set uid(value:int):void {
			_uid = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get source():int {
			return _source;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set source(value:int):void {
			_source = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get target():int {
			return _target;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set target(value:int):void {
			_target = value;
		}


	}
}