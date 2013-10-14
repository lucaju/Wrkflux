package model.builder {
	
	//imports
	import flash.geom.Point;
	
	import model.builder.StepModel;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StepsManager {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var numUniqueSteps		:int = 0;
		
		protected var source					:WorkflowModel;
		
		protected var stepsAdded				:Array;
		protected var stepsUpdated				:Array;
		protected var stepsRemoved				:Array;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function StepsManager(model:WorkflowModel) {
			this.source = model;
		}
		
		
		//****************** PROTECTED STEP METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeRegisteredStep(selectedStep:StepModel):void {
			
			var step:StepModel;
			
			//Remove from Main list
			for each (step in source.steps) {
				if (step == selectedStep) {
					source._steps.splice(source.steps.indexOf(step),1);
					break;
				}
			}
			
			//remove from update list
			if (stepsUpdated) {
				for each (step in stepsUpdated) {
					if (step == selectedStep) {
						stepsUpdated.splice(stepsUpdated.indexOf(step),1);
						break;
					}
				}
			}
			
			//add to removed list
			if (!stepsRemoved) stepsRemoved = new Array();
			stepsRemoved.push(selectedStep);
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeUnregistedStep(selectedStep:StepModel):void {
			
			var step:StepModel;
			
			//remove from added list
			for each (step in stepsAdded) {
				if (step == selectedStep) {
					stepsAdded.splice(stepsAdded.indexOf(step),1);
					break;
				}
			}
			
			//remove from main list
			for each (step in source.steps) {
				if (step == selectedStep) {
					source._steps.splice(source.steps.indexOf(step),1);
					break;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateRegisteredStep(selectedStep:StepModel):void {
			var add:Boolean = true;
			if (!stepsUpdated) stepsUpdated = new Array();
			
			//check if it is on update list
			for each (var step:StepModel in stepsUpdated) {
				
				//replace
				if (selectedStep.uid == step.uid) {
					add = false;
					stepsUpdated.splice(stepsUpdated.indexOf(step),1,selectedStep);
					break;
				} else {
					add = true;
				}
			}
			
			//add
			if (add) stepsUpdated.push(selectedStep);
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateUnregisteredStep(selectedStep:StepModel):void {
			
			//remove from add list
			for each (var step:StepModel in stepsAdded) {
				if (selectedStep.tempID == step.tempID) {
					stepsAdded.splice(stepsAdded.indexOf(step),1,selectedStep);
					break;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function output():void {
			
			var output:String = "mainSteps: " + source.steps.length;
			if (this.stepsAdded) output += " - " + "addedSteps: " + this.stepsAdded.length;
			if (this.stepsRemoved) output += " - " + "removedSteps: " + this.stepsRemoved.length;
			if (this.stepsUpdated) output += " - " + "updateSteps: " + this.stepsUpdated.length;
			
			//trace (output);
			
		}
		
		
		//****************** INTERNAL STEP METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		internal function addStep(position:Point):StepModel {
			
			//create a new step
			var stepModel:StepModel = new StepModel(0,"step "+numUniqueSteps, "STEP"+numUniqueSteps,0,position);
			stepModel.tempID = "s_"+numUniqueSteps;
			source._steps.push(stepModel);	
			numUniqueSteps++;
			
			//Add to save list
			if (!stepsAdded) stepsAdded = new Array();
			stepsAdded.push(stepModel);
			
			this.output();
			
			return stepModel;
			
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		internal function removeStep(id:*):Boolean {
			
			var selectedStep:StepModel
			
			if (id is int) {	//Registered step
				
				selectedStep = getRegistedStep(id);		//get step
				this.removeRegisteredStep(selectedStep);	//remove registered step
				
			} else {			//not registered flag
				
				selectedStep = getUnregisteredStep(id);		//get flag
				this.removeUnregistedStep(selectedStep);	//remove unregistered step
				
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
		internal function updateStep(id:*,data:Object):Boolean {
			
			var selectedStep:StepModel
			
			if (id is int) {	//Registered step
				selectedStep = getRegistedStep(id);		//get step
			} else {			//not registered step
				selectedStep = getUnregisteredStep(id);		//get step
			}
			
			//update step
			if (selectedStep) {
				
				if (data.title && selectedStep.title != data.title) 						selectedStep.title = data.title;
				if (data.abbreviation && selectedStep.abbreviation != data.abbreviation) 	selectedStep.abbreviation = data.abbreviation;
				if (data.shape >=0  && selectedStep.shape != data.shape) 					selectedStep.shape = data.shape;
				if (data.position && selectedStep.position != data.position) 				selectedStep.position = data.position;
				
				//add registered step to stepUpdate
				if (id is int) {
					updateRegisteredStep(selectedStep);
				} else {
					updateUnregisteredStep(selectedStep);
				}
				
				this.output();
				
				return true;
			} else {
				return false;
			}
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getStepData(requestedUID:*):StepModel {
			
			if (requestedUID is int) {
				return getRegistedStep(requestedUID);
			} else if (requestedUID is String) {
				return getRegistedStepByTempId(requestedUID);
			}
			
			return null
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getStepTitle(id:*):String {
			return this.getStepData(id).title;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getStepAbbreviation(id:*):String {
			return this.getStepData(id).abbreviation;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRegistedStep(requestedUID:int):StepModel {
			
			for each (var step:StepModel in source.steps) {
				if (step.uid == requestedUID) return step;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRegistedStepByTempId(requestedTempID:String):StepModel {
			for each (var step:StepModel in source.steps) {
				if (step.tempID == requestedTempID) return step;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getUnregisteredStep(requestedTempID:String):StepModel {
			for each (var step:StepModel in stepsAdded) {
				if (step.tempID == requestedTempID) return step;
			}
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasStepsAdded():Boolean {
			if (stepsAdded) if (stepsAdded.length > 0) return true;
			return false;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasStepsUpdated():Boolean {
			if (stepsUpdated) if (stepsUpdated.length > 0) return true;
			return false;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasStepsRemoved():Boolean {
			if (stepsRemoved) if (stepsRemoved.length > 0) return true;
			return false;;
		}
		
		/**
		 * 
		 * 
		 */
		public function getStepsAdded():Array {
			if (stepsAdded) return stepsAdded;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function getStepsUpdated():Array {
			if (stepsUpdated) return stepsUpdated;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function getStepsRemoved():Array {
			if (stepsRemoved) return stepsRemoved;
			return null;
		}
		
		/**
		 * 
		 * @param addedFlags
		 * @return 
		 * 
		 */
		public function registerAddedSteps(addedSteps:Array):Array {
			var item:Object;
			var step:StepModel;
			
			//loop to update uid in recently added flags
			for each (item in addedSteps) {
				step = this.getRegistedStepByTempId(item.tempID);
				step.uid = item.uid;
			}
			
			return stepsAdded;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpStepsAdded():Boolean {
			//removing temp information
			for each (var step:StepModel in source.steps) {
				step.tempID = "";
			}
			
			stepsAdded = null;
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpStepsUpdated():Boolean {
			stepsUpdated = null;
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpStepsRemoved():Boolean {
			stepsRemoved = null;
			return true;
		}
		
		
	}
}