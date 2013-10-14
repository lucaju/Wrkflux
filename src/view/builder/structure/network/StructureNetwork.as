package view.builder.structure.network {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import events.WrkfluxEvent;
	
	import model.builder.StepConnection;
	
	import view.builder.structure.StructureView;
	import view.builder.structure.steps.Step;
	import view.builder.structure.steps.StructureList;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureNetwork extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var numConnections		:int = 0;
		
		protected var target				:StructureView;
		
		protected var _structureList		:StructureList;
		
		internal var itemCollection			:Array;
		
		protected var _currentConnection	:Connection;
		
		protected var selectedConnections	:Array;
		
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
		protected function checkDuplicateConnection(source:*, target:*):Connection {
			
			for each (var connection:Connection in itemCollection) {
				
				if ((connection.sourceID == source || connection.sourceTempID == source) &&
					(connection.targetID == target || connection.targetTempID == target)) {
					
					return connection;
					
				}
		
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param source
		 * @param target
		 * @return 
		 * 
		 */
		protected function checkComplementaryConnection(source:*, target:*):Connection {
			
			for each (var connection:Connection in itemCollection) {
				
				if ((connection.sourceID == target || connection.sourceTempID == target) &&
					(connection.targetID == source || connection.targetTempID == source)) {
			
					return connection;
					
				}
				
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function addLink():void {
			
			var cancel:Boolean;
			
			//last update
			target.pen.x = this.mouseX;
			target.pen.y = this.mouseY;
			
			//hide delete button
			target.showDelete(false)
			
			//get pen source and target
			var penSourceID:* = (currentConnection.sourceID != 0) ? currentConnection.sourceID : currentConnection.sourceTempID;
			var penTargetID:* = structureList.stepHitTest(target.pen, currentConnection.sourceID);
			
			//test against delete button
			cancel = target.pen.hitTestObject(target.deleteButton);
			
			//Remove pen
			target.removeChild(target.pen);
			target.pen.removeEventListener(Event.ENTER_FRAME, move);
			target.pen.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			Mouse.show();
			
			//test against other stage
			if (!cancel && penTargetID) {
				
				cancel = (penTargetID == currentConnection.sourceID || penTargetID == currentConnection.sourceTempID);
				
				//check for duplicates
				if (!cancel) cancel = this.checkDuplicateConnection(penSourceID,penTargetID);
				
				//check for complementary connections
				var complementarConnection:Connection;
				if (!cancel) complementarConnection = this.checkComplementaryConnection(penSourceID,penTargetID);
				
			}
			
			//---- Cancel 
			if (cancel) {
				
				this.removeChild(currentConnection);
				currentConnection = null;
				return;
			} 
			
			//---- ADD
			var stepTarget:Step;
			var data:Object = new Object();
			
			//---- ---- Complement
			if (complementarConnection) {
				
				complementarConnection.addComplement(currentConnection.tempID);
				
				stepTarget = structureList.getStep(penTargetID);
				
				if (penTargetID is int) {
					currentConnection.targetID = stepTarget.id;
				} else if (penTargetID is String) {
					currentConnection.targetTempID = stepTarget.tempID;
				}
				
				this.removeChild(currentConnection);
				
				data.action = "createNewConnection";
				
				//---- ---- NEW
			} else {
				
				
				//---- ---- ---- CONNECTION
				if (penTargetID) {
					stepTarget = structureList.getStep(penTargetID);
					currentConnection.draw(stepTarget.x, stepTarget.y);
					itemCollection.push(currentConnection);
					
					if (penTargetID is int) {
						currentConnection.targetID = stepTarget.id;
					} else if (penTargetID is String) {
						currentConnection.targetTempID = stepTarget.tempID;
					}
					
					data.action = "createNewConnection";
					
					//---- ---- ---- STEP AND CONNECTION
				} else {
					
					currentConnection.draw(this.mouseX, this.mouseY);
					itemCollection.push(currentConnection);
					
					data.action = "createNewStep"
					data.position = new Point(this.mouseX, this.mouseY);
				}
				
			}
			
			//dispatch data
			data.connection = currentConnection;
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, data));
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeLink(connection:Connection):void {
			var a:Connection = itemCollection[itemCollection.indexOf(connection)];
			itemCollection.splice(itemCollection.indexOf(connection),1);
			this.removeChild(connection);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function move(event:Event):void {
			target.pen.x = this.mouseX;
			target.pen.y = this.mouseY;
			
			currentConnection.draw(this.mouseX, this.mouseY);
			
			//test against delete button
			target.deleteButton.highlight(target.pen.hitTestObject(target.deleteButton));
			
			//test against other stage
			structureList.stepHitTest(target.pen, currentConnection.sourceID);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseUp(event:MouseEvent):void {
			this.addLink();
		}
		
		//****************** PUBLIC METHOS ****************** ****************** ******************
		
		/**
		 * 
		 * @param sourceID
		 * 
		 */
		public function newConnection(sourceID:*):void {
			var step:Step = structureList.getStep(sourceID);
			
			//connection
			currentConnection = new Connection(0,step.id);
			currentConnection.tempID = "c_"+numConnections;
			numConnections++;
			
			if (step.id == 0) currentConnection.sourceTempID = step.tempID;
			currentConnection.x = step.x;
			currentConnection.y = step.y;
			this.addChild(currentConnection);
			currentConnection.draw(this.mouseX, this.mouseY);
			
			//pen
			if (!target.pen) target.pen = new ConnectionPen();
			target.pen.x = this.mouseX;
			target.pen.y = this.mouseY;
			target.addChildAt(target.pen,target.getChildIndex(target.deleteButton));
			
			Mouse.hide();
			
			//Listeners
			target.pen.addEventListener(Event.ENTER_FRAME, move);
			target.pen.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		/**
		 * 
		 * @param position
		 * 
		 */
		public function updateConnectionLine(activeStep:Step):void {
			
			for each (var connection:Connection in selectedConnections) {
				
				if ((activeStep.id > 0 && connection.sourceID == activeStep.id) || (activeStep.tempID && connection.sourceTempID == activeStep.tempID)) {
					connection.x = activeStep.x;
					connection.y = activeStep.y;
					
					var connectionTargetID:* = (connection.targetID != 0) ? connection.targetID : connection.targetTempID;
					var targetStep:Step = structureList.getStep(connectionTargetID);
					
					connection.draw(targetStep.x, targetStep.y);
					
				} else if ((activeStep.id > 0 && connection.targetID == activeStep.id) || (activeStep && connection.targetTempID == activeStep.tempID)) {
					connection.draw(activeStep.x, activeStep.y);
				}
			}
		}
		
		/**
		 * 
		 * @param sourceID
		 * 
		 */
		public function selectConnections(stepID:*):void {
			selectedConnections = new Array();
			var conection:Connection;
			
			if (stepID is int) {
				for each (conection in itemCollection) {
					if (conection.sourceID == stepID || conection.targetID == stepID) {
						selectedConnections.push(conection);
					}
				}
			} else if (stepID is String) {
				
				for each (conection in itemCollection) {
					if (conection.sourceTempID == stepID || conection.targetTempID == stepID) {
						selectedConnections.push(conection);
					}
				}
			}
			
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getConnection(id:*):Connection {
			for each (var conection:Connection in itemCollection) {
				if (conection.uid == id || conection.tempID == id) return conection;
			}
			return null;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getConnectionByComplement(id:*):Connection {
			
			var conection:Connection;
			
			for each (conection in itemCollection) {
				if (conection.complementUID == id) return conection;
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getConnectionBySource(id:*):Connection {
			
			var conection:Connection;
			
			if (id is int) {
				for each (conection in itemCollection) {
					if (conection.sourceID == id) return conection;
				}
			} else if (id is String) {
				for each (conection in itemCollection) {
					if (conection.sourceTempID == id) return conection;
				}
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getConnectionByTarget(id:*):Connection {
			
			var conection:Connection;
			
			if (id is int) {
				for each (conection in itemCollection) {
					if (conection.targetID == id) return conection;
				}
			} else if (id is String) {
				for each (conection in itemCollection) {
					if (conection.targetID == id) return conection;
				}
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function updateCurrentConnectionTarget(data:Object):void {
			(data.uid != 0) ? currentConnection.targetID = data.uid : currentConnection.targetTempID = data.tempID;
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function updateCurrentConnectionTempUID(data:Object):void {
			if (data.uid != 0) currentConnection.tempID = data.tempUID;
		}
		
		/**
		 * 
		 * @param recentAddedFlags
		 * 
		 */
		public function updateConnectionsUID(recentAddedConnections:Array):void {
			
			for each (var recentAddedConnection:StepConnection in recentAddedConnections) {
				
				for each (var connection:Connection in itemCollection) {
					if (recentAddedConnection.tempUID == connection.tempID) {
						connection.uid = recentAddedConnection.uid;
						connection.sourceID = recentAddedConnection.source;
						connection.targetID = recentAddedConnection.target;
						
						connection.tempID = "";
						connection.sourceTempID = "";
						connection.targetTempID = "";
						break;
					}
					
				}
				
			}
			
		}
		
		/**
		 * 
		 * @param source
		 * @param target
		 * @return 
		 * 
		 */
		public function removeConnections(stepID:*):Array {
			
			var removedConnections:Array = new Array();
			
			for each (var connection:Connection in itemCollection) {
				
				if ((connection.sourceID == stepID || connection.sourceTempID == stepID) ||
					(connection.targetID == stepID || connection.targetTempID == stepID)) {
					
					var id:* = (connection.tempID) ? connection.tempID : connection.uid;
					
					//TweenLite.to(connection,.3,{alpha:0, onComplete:removeObject, onCompleteParams:[connection]});
					TweenLite.to(connection,.3,{scaleX:0, scaleY:0, onComplete:removeLink, onCompleteParams:[connection]});
					
					removedConnections.push(id);
					
					
					
				}
				
			}
			
			return removedConnections;
		}
		
		/**
		 * 
		 * @param stepID
		 * @return 
		 * 
		 */
		public function removeConnection(connectionUID:*):Boolean {
			
			//find connection
			var complement:String;
			var selectedConnection:Connection = this.getConnection(connectionUID);
			
			//check for complementarity
			if (selectedConnection) {
				
				complement = "solo";
				
				if (selectedConnection.hasComplement) complement = "have";
				
			} else {				//check for inverted relationship
				selectedConnection = getConnectionByComplement(connectionUID);
				if (selectedConnection) complement = "is";
			}
			
			//Action
			switch (complement) {
				
				case "have":
					selectedConnection.removePrincipal();
					
					var sID:* = (selectedConnection.sourceID != 0) ? selectedConnection.sourceID : selectedConnection.sourceTempID;
					var tID:* = (selectedConnection.targetID != 0) ? selectedConnection.targetID : selectedConnection.targetTempID;
					
					var sourceStep:Step = structureList.getStep(sID);
					var targetStep:Step = structureList.getStep(tID);
					
					selectedConnection.x = sourceStep.x;
					selectedConnection.y = sourceStep.y;
					
					selectedConnection.draw(targetStep.x, targetStep.y);
					
					return true;
					break;
				
				
				case "is":
					selectedConnection.removeComplement();
					return true;
					break;
				
				case "solo":
					TweenLite.to(selectedConnection,.3,{alpha:0, onComplete:removeLink, onCompleteParams:[selectedConnection]});
					return true;
					break;
			
			}
			
			return null;
		}
		
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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentConnection():Connection {
			return _currentConnection;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentConnection(value:Connection):void {
			_currentConnection = value;
		}

		
	}
}