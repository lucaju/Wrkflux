package model.builder {
	
	// imports

	import flash.geom.Point;
	
	import model.FlagModel;
	import model.WrkBuilderModel;
	
	
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
		protected var _createdDate			:Date;
		protected var _modifiedDate			:Date;
		protected var _visibility			:uint;
		
		protected var _flagsManager			:FlagsManager;
		protected var _stepsManager			:StepsManager;
		protected var _connectionsManager	:ConnectionsManager;
		protected var _tagsManager			:TagsManager;
		
		internal var _flags					:Array;
		internal var _steps					:Array;
		internal var _connections			:Array;
		internal var _tags					:Array;
		
		internal var _source				:WrkBuilderModel;
		
		
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
									  createdDate:String,
									  modifiedDate:String = "",
									  visibility = 1,
									  flags:Array = null,
									  steps:Array = null,
									  connections:Array = null,
									  tags:Array = null) {
			
			
			if (modifiedDate == "") modifiedDate = createdDate;
			
			_id = id;
			_title = title;
			_authorID = authorID;
			_createdDate = handleDate(createdDate);
			_modifiedDate = handleDate(modifiedDate);
			_visibility = visibility;
			
			//Start managers
			_flagsManager = new FlagsManager(this);
			_stepsManager = new StepsManager(this);
			_connectionsManager = new ConnectionsManager(this);
			_tagsManager = new TagsManager(this);
			
			//flag
			_flags = new Array();
			if (flags) this.initialFlagsHandle(flags);
			
			//steps
			_steps = new Array();
			if (steps) this.initialStepsHandle(steps);
			
			//connections
			_connections = new Array();
			if (connections) this.initialConnectionHandle(connections);
			
			//tags
			_tags = new Array();
			if (tags) this.initialTagsHandle(tags);
			
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
			
			var year:String = dateWFArray[0];
			var month:String = dateWFArray[1];
			var day:String = dateWFArray[2];
			
			var hour:String = timeWFArray[0];
			var minute:String = timeWFArray[1];
			var second:String = timeWFArray[2];
			
			return new Date(year,month,day,hour,minute,second);
		}
		
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
			
			FlagsManager.numUniqueFlags = flags.length;
		}
		
		/**
		 * 
		 * @param steps
		 * 
		 */
		protected function initialStepsHandle(steps:Array):void {
			
			var stepModel:StepModel;
			
			for each (var stepObject:Object in steps) {
				stepModel = new StepModel(stepObject.uid, stepObject.title, stepObject.abbreviation, stepObject.shape, stepObject.position);
				_steps.push(stepModel);
			}
			
			StepsManager.numUniqueSteps = steps.length;
		}
		
		/**
		 * 
		 * @param connections
		 * 
		 */
		protected function initialConnectionHandle(connections:Array):void {
		
			var stepConnection:StepConnection;
			
			for each (var connectionObject:Object in connections) {
				stepConnection = new StepConnection(connectionObject.uid, connectionObject.source, connectionObject.target);
				_connections.push(stepConnection);
			}
			
			StepsManager.numUniqueSteps = steps.length;
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
		
		
		//****************** PUBLIC FLAG METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addFlag():FlagModel {
			return flagsManager.addFlag();
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function removeFlag(id:*):Boolean {
			return flagsManager.removeFlag(id);
		}
		
		/**
		 * 
		 * @param id
		 * @param data
		 * @return 
		 * 
		 */
		public function updateFlag(id:*,data:Object):Boolean {
			return flagsManager.updateFlag(id,data);
		}
		
		
		//****************** PUBLIC STEP METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addStep(position:Point):StepModel {
			return stepsManager.addStep(position);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function removeStep(id:*):Boolean {
			connectionsManager.removeStepConnections(id);
			return stepsManager.removeStep(id);
		}
		
		/**
		 * 
		 * @param id
		 * @param data
		 * @return 
		 * 
		 */
		public function updateStep(id:*,data:Object):Boolean {
			return stepsManager.updateStep(id,data);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getStepLabel(id:*):String {
			return stepsManager.getStepTitle(id);
		}
		
		//****************** PUBLIC STEP CONNECTION METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addConnection(data:Object):StepConnection {
			return connectionsManager.addConnection(data);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function removeConnection(id:*):Boolean {
			return connectionsManager.removeConnection(id);
		}
		
		//****************** PUBLIC TAGS METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * @return 
		 * 
		 */
		public function addTag(data:Object):TagModel {
			return tagsManager.addTag(data);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function removeTag(id:*):Boolean {
			return tagsManager.removeTag(id);
		}
		
		/**
		 * 
		 * @param id
		 * @param data
		 * @return 
		 * 
		 */
		public function updateTag(id:*,data:Object):Boolean {
			return tagsManager.updateTag(id,data);
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
		public function get authorID():int {
			return _authorID;
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
		 * @param value
		 * 
		 */
		public function set modifiedDate(value:Date):void {
			_modifiedDate = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get visibility():uint {
			return _visibility;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set visibility(value:uint):void {
			_visibility = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flags():Array {
			return _flags.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get steps():Array {
			return _steps.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get connections():Array {
			return _connections.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tags():Array {
			return _tags;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get source():WrkBuilderModel {
			return _source;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set source(value:WrkBuilderModel):void {
			_source = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flagsManager():FlagsManager {
			return _flagsManager;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get stepsManager():StepsManager {
			return _stepsManager;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get connectionsManager():ConnectionsManager {
			return _connectionsManager;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tagsManager():TagsManager {
			return _tagsManager;
		}


	}
}