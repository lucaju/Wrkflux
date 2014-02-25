package view.workflow.structure.steps {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import controller.WrkBuilderController;
	
	import model.builder.StepModel;
	
	import view.workflow.structure.StructureView;
	import view.workflow.structure.network.StructureNetwork;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureList extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target				:StructureView;
		
		protected var _network				:StructureNetwork;
		
		private var _itemCollection			:Array;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * @param data
		 * 
		 */
		public function StructureList(target:StructureView, data:Array = null) {
			
			//initial
			this.target = target;
			
			//checking data
			if (!data) data = WrkBuilderController(target.getController()).getStepsPreset(1);
			
			//loop
			_itemCollection = new Array();
			var step:Step;
			
			var i:int = 0;
			
			for each (var item:StepModel in data) {
				
				step = new Step(item.uid, item.abbreviation, item.shape);
				
				if (item.abbreviation == "") step.label = "Step"+itemCollection.length;
				
				step.x = item.position.x;
				step.y = item.position.y;
				this.addChild(step);
				step.init();
				
				itemCollection.push(step);
				
				//animation
				TweenLite.from(step,.6,{alpha:0, delay:i * 0.05});
				i++;
				
			}
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeObject(value:DisplayObject):void {
			this.removeChild(value);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getStep(uid:*):Step {
			for each (var step:Step in itemCollection) {
				if (step.id == uid) return step;
			}
			return null;
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get network():StructureNetwork {
			return _network;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set network(value:StructureNetwork):void {
			_network = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get itemCollection():Array {
			return _itemCollection;
		}


	}
}