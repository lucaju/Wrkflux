package model.wrkflow {
	
	//imports
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinModel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _uid				:int;
		protected var _title				:String;
		protected var _description		:String;
		
		protected var _log				:Array;
		
		
		//****************** Constructors ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @param title
		 * @param description
		 * 
		 */
		public function PinModel(uid:int, title:String, description:String = "") {
			
			this._uid = uid;
			this._title = title;
			this._description = description;
			
			_log = new Array();
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param wfDate
		 * @return 
		 * 
		 */
		protected function handleDate(pinDate:String):Date {
			
			var pinDateArray:Array = pinDate.split(" ");
			var datePinArray:Array = pinDateArray[0].split("-");
			var timePinArray:Array = pinDateArray[1].split(":");
			
			var year:String = datePinArray[0];
			var month:String = datePinArray[1];
			var day:String = datePinArray[2];
			
			var hour:String = timePinArray[0];
			var minute:String = timePinArray[1];
			var second:String = timePinArray[2];
			
			return new Date(year,month,day,hour,minute,second);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentStep():int {
			var itemLog:PinLogModel = getLastLog();
			if (itemLog) return itemLog.stepUID;
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentFlag():int {
			var itemLog:PinLogModel = getLastLog();
			if (itemLog) {
				return itemLog.flagUID;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLastLog():PinLogModel {
			
			var lastUID:Number = 0;
			for each (var logItem:PinLogModel in log) {
				lastUID = Math.max(logItem.logUID, lastUID);	
			}
			
			var lastLog:PinLogModel = getLog(lastUID);
			return lastLog;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLog(logUID:int):PinLogModel {
			for each (var logItem:PinLogModel in log) {
				if (logItem.logUID == logUID) {
					return logItem;	
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param logUID
		 * @param stepUID
		 * @param flagUID
		 * @param date
		 * 
		 */
		public function addLog(logUID:int, flagUID:int, stepUID:int, date:*):void {
			
			var logDate:Date;
			
			if (date is Date) {
				logDate = date;
			} else {
				logDate = handleDate(date);
			}
			
			//check for duplicates
			var duplicate:Boolean = false;
			for each (var logI:PinLogModel in _log) {
				if (logI.logUID == logUID) {
					duplicate = true;
					break;
				}
			}
			
			if (!duplicate) {
				var logItem:PinLogModel = new PinLogModel(logUID,flagUID,stepUID,logDate);	
				_log.push(logItem);
			}
			
		}
		
		/**
		 * 
		 * @param fullLog
		 * 
		 */
		public function attachFullLog(fullLog:Array):void {
			
			for each (var log:Object in fullLog) {
				
				var logUID:int = log.uid;
				
				//check for duplicates
				var duplicate:Boolean = false;
				for each (var logI:PinLogModel in _log) {
					if (logI.logUID == logUID) {
						duplicate = true;
						break;
					}
				}
				
				if (!duplicate) {
					
					var flagUID:int = log.flag_uid;
					var stepUID:int = log.step_uid;
					var logDate:Date = (log.date is Date) ? log.date : handleDate(log.date);
					
					var logItem:PinLogModel = new PinLogModel(logUID,flagUID,stepUID,logDate);	
					_log.unshift(logItem);
				}
				
			}
			
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
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
		 * @return 
		 * 
		 */
		public function get title():String {
			return _title;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			_title = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get description():String {
			return _description;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set description(value:String):void {
			_description = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get log():Array {
			return _log;
		}


	}
}