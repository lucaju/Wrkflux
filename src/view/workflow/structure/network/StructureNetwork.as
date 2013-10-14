package view.workflow.structure.network {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	import model.builder.StepConnection;
	
	import view.workflow.structure.StructureView;
	import view.workflow.structure.steps.Step;
	import view.workflow.structure.steps.StructureList;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureNetwork extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var numConnections		:int = 0;
		
		protected var target				:StructureView
		
		protected var _structureList		:StructureList;
		
		internal var itemCollection			:Array;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * @param data
		 * 
		 */
		public function StructureNetwork(target:StructureView) {
			//initial
			this.target = target;
			
		}
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		public function init(data:Array = null):void {
			
			itemCollection = new Array();
			
			//loop
			itemCollection = new Array();
			var connection:Connection;
			var i:int = 1;
			
			data.sortOn("uid",Array.NUMERIC);
			
			for each (var item:StepConnection in data) {
				
				//check for complementary
				var comp:Connection = checkComplementaryConnection(item.source,item.target);
				
				if (comp) {
		
					comp.addComplement(item.uid);
					
				} else {
					
					connection = new Connection(item.uid, item.source, item.target);
					
					var sourceStep:Step = structureList.getStep(connection.sourceID);
					var targetStep:Step = structureList.getStep(connection.targetID);
					
					connection.x = sourceStep.x;
					connection.y = sourceStep.y;
					this.addChild(connection);
					
					connection.draw(targetStep.x, targetStep.y);
					
					itemCollection.push(connection);
					
					//animation
					TweenLite.from(connection,.6,{scaleX:0, scaleY:0, delay:.6+(i*.3)});
					i++;
					
				}
				
			}
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param source
		 * @param target
		 * @return 
		 * 
		 */
		protected function checkComplementaryConnection(source:*, target:*):Connection {
			for each (var connection:Connection in itemCollection) {
				if (connection.sourceID == target && connection.targetID == source) return connection;
			}
			return null;
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		
		//****************** PUBLIC METHOS ****************** ****************** ******************
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get structureList():StructureList {
			return _structureList;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set structureList(value:StructureList):void {
			_structureList = value;
		}
		
	}
}