package model.builder {
	
	//imports
	import model.FlagModel;
	import settings.Settings;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlagsManager {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var numUniqueFlags		:int = 0;
		
		protected var source					:WorkflowModel;
		
		protected var flagsAdded			:Array;
		protected var flagsUpdated			:Array;
		protected var flagsRemoved			:Array;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function FlagsManager(model:WorkflowModel) {
			this.source = model;
		}
		
		
		//****************** PROTECTED FLAG METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeRegisteredFlag(selectedFlag:FlagModel):void {
			
			var flag:FlagModel;
			
			//Remove from Main list
			for each (flag in source.flags) {
				if (flag == selectedFlag) {
					source._flags.splice(source.flags.indexOf(flag),1);
					break;
				}
			}
			
			//remove from update list
			if (flagsUpdated) {
				for each (flag in flagsUpdated) {
					if (flag == selectedFlag) {
						flagsUpdated.splice(flagsUpdated.indexOf(flag),1);
						break;
					}
				}
			}
			
			//add to removed list
			if (!flagsRemoved) flagsRemoved = new Array();
			flagsRemoved.push(selectedFlag);
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeUnregistedFlag(selectedFlag:FlagModel):void {
			
			var flag:FlagModel;
			
			//remove from added list
			for each (flag in flagsAdded) {
				if (flag == selectedFlag) {
					flagsAdded.splice(flagsAdded.indexOf(flag),1);
					break;
				}
			}
			
			//remove from main list
			for each (flag in source.flags) {
				if (flag == selectedFlag) {
					source._flags.splice(source.flags.indexOf(flag),1);
					break;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateRegisteredFlag(selectedFlag:FlagModel):void {
			var add:Boolean = true;
			if (!flagsUpdated) flagsUpdated = new Array();
			
			//check if it is on update list
			for each (var flag:FlagModel in flagsUpdated) {
				
				//replace
				if (selectedFlag.uid == flag.uid) {
					add = false;
					flagsUpdated.splice(flagsUpdated.indexOf(flag),1,selectedFlag);
					break;
				} else {
					add = true;
				}
			}
			
			//add
			if (add) flagsUpdated.push(selectedFlag);
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateUnregisteredFlag(selectedFlag:FlagModel):void {
			
			//remove from add list
			for each (var flag:FlagModel in flagsAdded) {
				if (selectedFlag.tempID == flag.tempID) {
					flagsAdded.splice(flagsAdded.indexOf(flag),1,selectedFlag);
					break;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function outputFlags():void {
			
			var output:String = "mainFlags: " + source.flags.length;
			if (this.flagsAdded) output += " - " + "addedFlags: " + this.flagsAdded.length;
			if (this.flagsRemoved) output += " - " + "removedFlags: " + this.flagsRemoved.length;
			if (this.flagsUpdated) output += " - " + "updateFlags: " + this.flagsUpdated.length;
			
			trace (output);
			
		}
		
		
		//****************** INTERNAL FLAG METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		internal function addFlag():FlagModel {
			
			if (source.flags.length < Settings.maxFlags) {
				
				//check for unused preet
				var presetFlags:Array = source.source.getFlagsPreset(0);
				var presetUnused:FlagModel;
				
				for each (var preset:FlagModel in presetFlags) {
					
					for each (var flag:FlagModel in source.flags) {
						
						
						
						if (flag.color == preset.color) {
							presetUnused = null;
							break;
						} else {
							presetUnused = preset;
						}
						
					}
					
					if (presetUnused) break;
					
				}
				
				//create a new flag
				var flagModel:FlagModel = new FlagModel(0,presetUnused.title,presetUnused.color,"",source.flags.length);
				flagModel.tempID = "f_"+numUniqueFlags;
				source._flags.push(flagModel);	
				numUniqueFlags++;
				
				//Add to save list
				if (!flagsAdded) flagsAdded = new Array();
				flagsAdded.push(flagModel);
				
				//this.output();
				
				//return new Flag;
				return flagModel;
				
			}
			
			return null;
			
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		internal function removeFlag(id:*):Boolean {
			
			var selectedFlag:FlagModel
			
			if (id is int) {	//Registered flags
				
				selectedFlag = getRegistedFlag(id);		//get flag
				this.removeRegisteredFlag(selectedFlag);	//remove registered Flag
				
			} else {			//not registered flag
				
				selectedFlag = getUnregisteredFlag(id);		//get flag
				this.removeUnregistedFlag(selectedFlag);	//remove unregistered Flag
				
			}
			
			//this.output();
			
			return true;
		}
		
		/**
		 * 
		 * @param id
		 * @param data
		 * @return 
		 * 
		 */
		internal function updateFlag(id:*,data:Object):Boolean {
			
			var selectedFlag:FlagModel
			
			if (id is int) {	//Registered flags
				selectedFlag = getRegistedFlag(id);		//get flag
			} else {			//not registered flag
				selectedFlag = getUnregisteredFlag(id);		//get flag
			}
			
			//update flags
			if (selectedFlag) {
				if (selectedFlag.color != data.color) selectedFlag.color = data.color;
				if (selectedFlag.title != data.label) selectedFlag.title = data.label;
				if (selectedFlag.order != data.order) selectedFlag.order = data.order;
				
				//add registered flags to flagsUpdate
				if (id is int) {
					updateRegisteredFlag(selectedFlag);
				} else {
					updateUnregisteredFlag(selectedFlag);
				}
				
				//this.output();
				
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRegistedFlag(requestedUID:int):FlagModel {
			for each (var flag:FlagModel in source.flags) {
				if (flag.uid == requestedUID) return flag;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRegistedFlagByTempId(requestedTempID:String):FlagModel {
			for each (var flag:FlagModel in source.flags) {
				if (flag.tempID == requestedTempID) return flag;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getUnregisteredFlag(requestedTempID:String):FlagModel {
			for each (var flag:FlagModel in flagsAdded) {
				if (flag.tempID == requestedTempID) return flag;
			}
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasFlagsAdded():Boolean {
			if (flagsAdded) if (flagsAdded.length > 0) return true;
			return false;;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasFlagsUpdated():Boolean {
			if (flagsUpdated) if (flagsUpdated.length > 0) return true;
			return false;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasFlagsRemoved():Boolean {
			if (flagsRemoved) if (flagsRemoved.length > 0) return true;
			return false;;
		}
		
		/**
		 * 
		 * 
		 */
		public function getFlagsAdded():Array {
			if (flagsAdded) return flagsAdded;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function getFlagsUpdated():Array {
			if (flagsUpdated) return flagsUpdated;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function getFlagsRemoved():Array {
			if (flagsRemoved) return flagsRemoved;
			return null;
		}
		
		/**
		 * 
		 * @param addedFlags
		 * @return 
		 * 
		 */
		public function registerAddedFlags(addedFlags:Array):Array {
			var item:Object;
			var flag:FlagModel;
			
			//loop to update uid in recently added flags
			for each (item in addedFlags) {
				flag = this.getRegistedFlagByTempId(item.tempID);
				flag.uid = item.uid;
			}
			
			return flagsAdded;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpFlagsAdded():Boolean {
			//removing temp information
			for each (var flag:FlagModel in source.flags) {
				flag.tempID = "";
			}
			
			flagsAdded = null;
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpFlagsUpdated():Boolean {
			flagsUpdated = null;
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpFlagsRemoved():Boolean {
			flagsRemoved = null;
			return true;
		}
		
		
	}
}