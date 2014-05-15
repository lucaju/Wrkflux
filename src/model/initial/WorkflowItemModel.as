package model.initial {
	
	// imports
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WorkflowItemModel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id					:int
		protected var _title				:String;
		protected var _authorID				:int;
		protected var _author				:String;
		protected var _createdDate			:Date;
		protected var _modifiedDate			:Date;
		protected var _visibility			:uint;
		
		//****************** Properties ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param title
		 * @param author
		 * @param createdDate
		 * @param modifiedDate
		 * @param flags
		 * @param steps
		 * 
		 */
		public function WorkflowItemModel(id:int,
									  title:String,
									  authorID:int,
									  author:String,
									  createdDate:String,
									  modifiedDate:String = "",
									  visibility = 1) {
			
			
			
			if (modifiedDate == "") modifiedDate = createdDate;
			
			_id = id;
			_authorID = authorID;
			_title = title;
			_author = author;
			_createdDate = handleDate(createdDate);
			_modifiedDate = handleDate(modifiedDate);
			_visibility = visibility;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param wfDate
		 * @return 
		 * 
		 */
		protected function handleDate(wfDate:String):Date {
			
			var wfDateArray:Array = wfDate.split(" ");
			var dateWFArray:Array = wfDateArray[0].split("-");
			var timeWFArray:Array = wfDateArray[1].split(":");
			
			var year:int = dateWFArray[0];
			var month:int = dateWFArray[1]-1;
			var day:String = dateWFArray[2];
			
			var hour:int = timeWFArray[0];
			var minute:int = timeWFArray[1];
			var second:int = timeWFArray[2];
			
			return new Date(year,month,day,hour,minute,second);
		}
		
		
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
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
		 * @return 
		 * 
		 */
		public function get authorID():int {
			return _authorID;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get author():String {
			return _author;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get createdDate():Date {
			return _createdDate;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get modifiedDate():Date {
			return _modifiedDate;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get visibility():uint {
			return _visibility;
		}
		
	}
}

