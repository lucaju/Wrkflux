package model {
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class Session {
		
		//****************** Properties ****************** ****************** ******************
		
		static protected var _userID				:int;
		static protected var _userFirstName			:String;
		static protected var _userLastName			:String;
		
		static protected var _workflowActive		:Object;
		static protected var _workflowsCreated		:Array;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param userID
		 * @param userFirtName
		 * @param userLastName
		 * 
		 */
		public function Session(userID:int, userFirtName:String, userLastName:String = "") {	
			this.open(userID,userFirtName,userLastName);
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param userID
		 * @param userFirtName
		 * @param userLastName
		 * 
		 */
		public function open(userID:int, userFirtName:String = "", userLastName:String = ""):Boolean {	
			if (_userID == 0) {
				
				_userID = userID;
				_userFirstName = userFirtName;
				_userLastName = userLastName;
				return true;
				
			} else {
				return false;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function close():Boolean {
			if (_userID != 0) {
				
				_userID = 0;
				_userFirstName = null;
				_userLastName = null;
				
				_workflowActive = null;
				_workflowsCreated = null;
				
				return true;
			
			} else {
				return false;
			}
		}
		
		/**
		 * 
		 * @param id
		 * @param authorID
		 * @return 
		 * 
		 */
		static public function setActiveWorkflow(id:int, authorID:int):Object {
			_workflowActive = new Object();
			workflowActive.id = id;
			workflowActive.authorID = authorID;
			return workflowActive;
		}
		
		/**
		 * 
		 * 
		 */
		static public function closeActiveWorkflow():void {
			_workflowActive = null;	
		}
		
		/**
		 * 
		 * 
		 */
		static public function addToWorkflowCreated(wfID:int):void {
			if (!_workflowsCreated) _workflowsCreated = new Array();
			_workflowsCreated.push(wfID);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function credentialCheck():Boolean {
			if (Session.userID == 0) {
				
				for each (var wfID:int in Session.workflowsCreated) {
					if (wfID == Session.activeWorkflowID) return true;
				}
				
			} else if (Session.userID == Session.activeWorkflowAuthorID) {
				return true;
			}
			
			return false;
		}
		
		//****************** GETTERS AND SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get userID():int {
			return _userID;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get userFirstName():String {
			return _userFirstName;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get userLastName():String {
			return _userLastName;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get userFullName():String {
			return _userFirstName + " " + _userLastName;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get workflowActive():Object {
			return protected::_workflowActive;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get activeWorkflowID():int {
			return workflowActive.id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get activeWorkflowAuthorID():int {
			return workflowActive.authorID;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get workflowsCreated():Array {
			return _workflowsCreated;
		}


	}
}