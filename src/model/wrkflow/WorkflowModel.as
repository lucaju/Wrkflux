package model.wrkflow {
	
	// imports
	import model.FlagModel;
	import model.WrkFlowModel;
	import model.builder.StepConnection;
	import model.builder.StepModel;
	import model.builder.TagModel;
	import model.builder.TagsManager;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WorkflowModel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id					:int
		protected var _title				:String;
		protected var _authorID				:int;
		internal var _flags					:Array;
		internal var _steps					:Array;
		internal var _connections			:Array;
		internal var _flow					:Array;
		internal var _tags					:Array;
		
		internal var _source				:WrkFlowModel;
		
		
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
		public function WorkflowModel(id:int,
									  title:String,
									  authorID:int,
									  flags:Array = null,
									  steps:Array = null,
									  connections:Array = null,
									  flow:Array = null,
									  tags:Array = null) {
			
			
			_id = id;
			_title = title;
			_authorID = authorID;
			
			//flag
			_flags = new Array();
			if (flags) this.initialFlagsHandle(flags);
			
			//steps
			_steps = new Array();
			if (steps) this.initialStepsHandle(steps);
			
			//connections
			_connections = new Array();
			if (connections) this.initialConnectionHandle(connections);
			
			//flow
			_flow = new Array();
			if (flow) this.initialFlowHandle(flow);
			
			//tags
			_tags = new Array();
			if (tags) this.initialTagsHandle(tags);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param flags
		 * 
		 */
		protected function initialFlagsHandle(flags:Array):void {
			
			var flagModel:FlagModel;
			
			for each (var flagObject:Object in flags) {
				flagModel = new FlagModel(flagObject.uid,flagObject.title,flagObject.color,"",flagObject.ordering);
				_flags.push(flagModel);
			}
			
		}
		
		/**
		 * 
		 * @param steps
		 * 
		 */
		protected function initialStepsHandle(steps:Array):void {
			
			var stepModel:model.builder.StepModel;
			
			for each (var stepObject:Object in steps) {
				stepModel = new StepModel(stepObject.uid, stepObject.title, stepObject.abbreviation, stepObject.shape, stepObject.position);
				_steps.push(stepModel);
			}
		}
		
		/**
		 * 
		 * @param steps
		 * 
		 */
		protected function initialConnectionHandle(connections:Array):void {
		
			var stepConnection:StepConnection;
			
			for each (var connectionObject:Object in connections) {
				stepConnection = new StepConnection(connectionObject.uid, connectionObject.source, connectionObject.target);
				_connections.push(stepConnection);
			}
		}
		
		/**
		 * 
		 * @param steps
		 * 
		 */
		protected function initialFlowHandle(flow:Array):void {
			
			var pin:PinModel;
			
			for each (var pinObject:Object in flow) {
				this.addItem(pinObject.uid, pinObject.title, pinObject.log, pinObject.description);
			}
		}
		
		/**
		 * 
		 * @param tags
		 * 
		 */
		protected function initialTagsHandle(tags:Array):void {
			
			var tag:TagModel;
			
			for each (var tagObject:Object in tags) {
				tag = new TagModel(tagObject.uid, tagObject.label, tagObject.position);
				_tags.push(tag);
			}
			
			TagsManager.numUniqueTags = tags.length;
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @param title
		 * @param log
		 * @param description
		 * @return 
		 * 
		 */
		public function addItem(uid:int, title:String, log:*, description:String = ""):PinModel {
			
			//item
			var pin:PinModel = new PinModel(uid,title,description);
			
			//log
			if (log is Object) {

				pin.addLog(log.uid, log.flag_uid, log.step_uid, log.date);
		
			} else if (log is Array) {
				
				for each(var logObject:Object in log) {
					pin.addLog(logObject.uid, logObject.flag_uid, logObject.step_uid, logObject.date);
				}
				
			}
			
			_flow.push(pin);
			
			pin.log.sortOn("logUID");
			
			return pin;
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeDoc(uid:int):Boolean {
			for each (var pinModel:PinModel in _flow) {
				if (pinModel.uid == uid) {
					_flow.splice(_flow.indexOf(pinModel),1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDoc(uid:int):PinModel {
			for each (var pinModel:PinModel in _flow) {
				if (pinModel.uid == uid) return pinModel;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDocTitle(uid:int):String {
			var pinModel:PinModel = getDoc(uid);
			return pinModel.title;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDocDetails(uid:int):Object {
			var pinModel:PinModel = getDoc(uid);
			var data:Object = new Object();
			
			data.uid = pinModel.uid;
			data.title = pinModel.title;
			data.description = pinModel.description;
			data.currentFlag = pinModel.currentFlag;
			data.flagTitle = this.getFlagTitle(pinModel.currentFlag);
			data.currentStep = pinModel.currentStep;
			data.stepAbbreviation = this.getStepAbbreviation(pinModel.currentStep);
			data.stepTitle = this.getStepTitle(pinModel.currentStep);
			data.log = pinModel.log;
			
			return data;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLastLog(uid:int):Object {
			var pinModel:PinModel = getDoc(uid);
			return pinModel.getLastLog();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlag(flagUID:int):FlagModel {
			for each (var flag:FlagModel in _flags) {
				if (flag.uid == flagUID) return flag;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDefaultFlagUID():int {
			return flags[0].uid;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlagColor(flagUID:int):uint {
			for each (var flag:FlagModel in flags) {
				if (flag.uid == flagUID) return flag.color;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlagTitle(flagUID:int):String {
			for each (var flag:FlagModel in flags) {
				if (flag.uid == flagUID) return flag.title;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepTitle(stepUID:int):String {
			for each (var step:StepModel in steps) {
				if (step.uid == stepUID) return step.title;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepAbbreviation(stepUID:int):String {
			for each (var step:StepModel in steps) {
				if (step.uid == stepUID) return step.abbreviation;
			}
			return null;
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
		public function get flags():Array {
			return _flags;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get steps():Array {
			return _steps;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get connections():Array {
			return _connections;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flow():Array {
			return _flow;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get source():WrkFlowModel {
			return _source;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set source(value:WrkFlowModel):void {
			_source = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tags():Array {
			return _tags;
		}


	}
}