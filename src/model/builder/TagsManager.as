package model.builder {
	
	//import
	import settings.Settings;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TagsManager {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var numUniqueTags		:int = 0;
		
		protected var source				:WorkflowModel;
		
		protected var tagsAdded				:Array;
		protected var tagsUpdated			:Array;
		protected var tagsRemoved			:Array;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function TagsManager(model:WorkflowModel) {
			this.source = model;
		}
		
		
		//****************** PROTECTED TAG METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeRegisteredTag(selectedTag:TagModel):void {
			
			var tag:TagModel;
			
			//Remove from Main list
			for each (tag in source.tags) {
				if (tag == selectedTag) {
					source._tags.splice(source.tags.indexOf(tag),1);
					break;
				}
			}
			
			//remove from update list
			if (tagsUpdated) {
				for each (tag in tagsUpdated) {
					if (tag == selectedTag) {
						tagsUpdated.splice(tagsUpdated.indexOf(tag),1);
						break;
					}
				}
			}
			
			//add to removed list
			if (!tagsRemoved) tagsRemoved = new Array();
			tagsRemoved.push(selectedTag);
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeUnregistedTag(selectedTag:TagModel):void {
			
			var tag:TagModel;
			
			//remove from added list
			for each (tag in tagsAdded) {
				if (tag == selectedTag) {
					tagsAdded.splice(tagsAdded.indexOf(tag),1);
					break;
				}
			}
			
			//remove from main list
			for each (tag in source.tags) {
				if (tag == selectedTag) {
					source._tags.splice(source.tags.indexOf(tag),1);
					break;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateRegisteredTag(selectedTag:TagModel):void {
			var add:Boolean = true;
			if (!tagsUpdated) tagsUpdated = new Array();
			
			//check if it is on update list
			for each (var tag:TagModel in tagsUpdated) {
				
				//replace
				if (selectedTag.uid == tag.uid) {
					add = false;
					tagsUpdated.splice(tagsUpdated.indexOf(tag),1,selectedTag);
					break;
				} else {
					add = true;
				}
			}
			
			//add
			if (add) tagsUpdated.push(selectedTag);
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateUnregisteredTag(selectedTag:TagModel):void {
			
			//remove from add list
			for each (var tag:TagModel in tagsAdded) {
				if (selectedTag.tempUID == tag.tempUID) {
					tagsAdded.splice(tagsAdded.indexOf(tag),1,selectedTag);
					break;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function output():void {
			
			var output:String = "mainTags: " + source.tags.length;
			if (this.tagsAdded) output += " - " + "addedTags: " + this.tagsAdded.length;
			if (this.tagsRemoved) output += " - " + "removedTags: " + this.tagsRemoved.length;
			if (this.tagsUpdated) output += " - " + "updateTags: " + this.tagsUpdated.length;
			
			trace (output);
			
		}
		
		
		//****************** INTERNAL TAGS METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * @return 
		 * 
		 */
		internal function addTag(data:Object):TagModel {
			
			//create a new tag
			
			var tag:TagModel = new TagModel(0, data.label, data.position);
			tag.tempUID = "t_"+numUniqueTags;
			source._tags.push(tag);	
			numUniqueTags++;
			
			//Add to save list
			if (!tagsAdded) tagsAdded = new Array();
			tagsAdded.push(tag);
			
			this.output();
			
			return tag;
			
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		internal function removeTag(id:*):Boolean {
			
			var selectedTag:TagModel
			
			if (id is int) {	//Registered tas
				
				selectedTag = getRegistedTag(id);			//get tag
				this.removeRegisteredTag(selectedTag);		//remove registered ag
				
			} else {			//not registered tag
				
				selectedTag = getUnregisteredTag(id);		//get tag
				this.removeUnregistedTag(selectedTag);		//remove unregistered tag
				
			}
			
			this.output();
			
			return true;
		}
		
		/**
		 * 
		 * @param id
		 * @param data
		 * @return 
		 * 
		 */
		internal function updateTag(id:*,data:Object):Boolean {
			
			var selectedTag:TagModel
			
			if (id is int) {	//Registered tag
				selectedTag = getRegistedTag(id);		//get tag
			} else {			//not registered tag
				selectedTag = getUnregisteredTag(id);		//get tag
			}
			
			//update tags
			if (selectedTag) {
				
				if (selectedTag.label != data.label) selectedTag.label = data.label;
				if (selectedTag.position != data.position) selectedTag.position = data.position;
				
				//add registered tags to tagsUpdate
				if (id is int) {
					updateRegisteredTag(selectedTag);
				} else {
					updateUnregisteredTag(selectedTag);
				}
				
				this.output();
				
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
		public function getRegistedTag(requestedUID:int):TagModel {
			for each (var tag:TagModel in source.tags) {
				if (tag.uid == requestedUID) return tag;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRegistedTagByTempUID(requestedTempUID:String):TagModel {
			for each (var tag:TagModel in source.tags) {
				if (tag.tempUID == requestedTempUID) return tag;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getUnregisteredTag(requestedTempUID:String):TagModel {
			for each (var tag:TagModel in tagsAdded) {
				if (tag.tempUID == requestedTempUID) return tag;
			}
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasTagsAdded():Boolean {
			if (tagsAdded) if (tagsAdded.length > 0) return true;
			return false;;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasTagsUpdated():Boolean {
			if (tagsUpdated) if (tagsUpdated.length > 0) return true;
			return false;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasTagsRemoved():Boolean {
			if (tagsRemoved) if (tagsRemoved.length > 0) return true;
			return false;;
		}
		
		/**
		 * 
		 * 
		 */
		public function getTagsAdded():Array {
			if (tagsAdded) return tagsAdded;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function getTagsUpdated():Array {
			if (tagsUpdated) return tagsUpdated;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function getTagsRemoved():Array {
			if (tagsRemoved) return tagsRemoved;
			return null;
		}
		
		/**
		 * 
		 * @param addedTags
		 * @return 
		 * 
		 */
		public function registerAddedTags(addedTags:Array):Array {
			var item:Object;
			var tag:TagModel;
			
			//loop to update uid in recently added tags
			for each (item in addedTags) {
				tag = this.getRegistedTagByTempUID(item.tempUID);
				tag.uid = item.uid;
			}
			
			return tagsAdded;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpTagsAdded():Boolean {
			//removing temp information
			for each (var tag:TagModel in source.tags) {
				tag.tempUID = "";
			}
			
			tagsAdded = null;
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpTagsUpdated():Boolean {
			tagsUpdated = null;
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpTagsRemoved():Boolean {
			tagsRemoved = null;
			return true;
		}
		
		
	}
}