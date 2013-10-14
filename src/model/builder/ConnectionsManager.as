package model.builder {
	
	//imports
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ConnectionsManager {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var numUniqueConnections		:int = 0;
		
		protected var source						:WorkflowModel;
		
		protected var connectionsAdded				:Array;
		protected var connectionsRemoved			:Array;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ConnectionsManager(model:WorkflowModel) {
			this.source = model;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeRegisteredConnection(selectedConnection:StepConnection):void {
			
			var connection:StepConnection;
			
			//Remove from Main list
			for each (connection in source.connections) {
				if (connection == selectedConnection) {
					source._connections.splice(source.connections.indexOf(connection),1);
					break;
				}
			}
			
			//add to removed list
			if (!connectionsRemoved) connectionsRemoved = new Array();
			connectionsRemoved.push(selectedConnection);
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function removeUnregistedConnection(selectedConnection:StepConnection):void {
			
			var connection:StepConnection;
			
			//remove from added list
			for each (connection in connectionsAdded) {
				if (connection == selectedConnection) {
					connectionsAdded.splice(connectionsAdded.indexOf(connection),1);
					break;
				}
			}
			
			//remove from main list
			for each (connection in source.connections) {
				if (connection == selectedConnection) {
					source._connections.splice(source.steps.indexOf(connection),1);
					break;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function output():void {
			
			var output:String = "mainConnections: " + source.connections.length;
			if (this.connectionsAdded) output += " - " + "addedConnections: " + this.connectionsAdded.length;
			if (this.connectionsRemoved) output += " - " + "removedConnections: " + this.connectionsRemoved.length;
			
		//	trace (output);
			
		}
		
		
		//****************** INTERNAL METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		internal function addConnection(data:Object):StepConnection {
			
			//create a new step
			var connection:StepConnection = new StepConnection(0,data.sourceID,data.targetID);
			connection.tempUID = "c_"+numUniqueConnections;
			if (data.sourceID == 0) connection.sourceTempUID = data.sourceTempID;
			if (data.targetID == 0) connection.targetTempUID = data.targetTempID;
			
			source._connections.push(connection);	
			numUniqueConnections++;
			
			//Add to save list
			if (!connectionsAdded) connectionsAdded = new Array();
			connectionsAdded.push(connection);
			
			this.output();
			
			return connection;
			
		}
		
		internal function removeStepConnections(stepID:*):Boolean {
			
			for each (var connection:StepConnection in source.connections) {
				
				if ((stepID > 0 && connection.source == stepID) || connection.sourceTempUID == stepID) {
					(connection.uid != 0) ? this.removeConnection(connection.uid) : this.removeConnection(connection.tempUID);
				} else if ((stepID > 0 && connection.target == stepID) || connection.targetTempUID == stepID) {
					(connection.uid != 0) ? this.removeConnection(connection.uid) : this.removeConnection(connection.tempUID);
				}
				
			}
			
			return true;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		internal function removeConnection(id:*):Boolean {
			
			var selectedConnection:StepConnection;
			
			if (id is int) {	//Registered step
				
				selectedConnection = getRegistedConnection(id);		//get step
				this.removeRegisteredConnection(selectedConnection);	//remove registered step
				
			} else {			//not registered flag
				
				selectedConnection = getUnregisteredConnection(id);		//get flag
				this.removeUnregistedConnection(selectedConnection);	//remove unregistered step
				
			}
			
			this.output();
			
			return true;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getStepConnection(requestedUID:*):StepConnection {	
			if (requestedUID is int) {
				return getRegistedConnection(requestedUID);
			} else if (requestedUID is String) {
				return getRegistedConnectionByTempID(requestedUID);
			}
			
			return null
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRegistedConnection(requestedUID:int):StepConnection {
			for each (var connection:StepConnection in source.connections) {
				if (connection.uid == requestedUID) return connection;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRegistedConnectionByTempID(requestedTempID:String):StepConnection {
			for each (var connection:StepConnection in source.connections) {
				if (connection.tempUID == requestedTempID) return connection;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getUnregisteredConnection(requestedTempID:String):StepConnection {
			for each (var connection:StepConnection in connectionsAdded) {
				if (connection.tempUID == requestedTempID) return connection;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnectionsByStep(stepUID:*):Array {
			
			var links:Array = new Array();
			
			for each (var connection:StepConnection in source.connections) {
				
				if ((stepUID > 0 && connection.source == stepUID) || connection.sourceTempUID == stepUID) {
					links.push(connection);
				} else if ((stepUID > 0 && connection.target == stepUID) || connection.targetTempUID == stepUID) {
					links.push(connection);
				}
				
			}
			
			return links;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnectionsInfoByStep(uid:*):Array {
			
			var connectionInfo:Object; //{uid,tempUID,source,sourceTempUID,sourceLabel,target,targetTempUID,targetLabel}
			
			var links:Array = new Array();
			var stepcConnections:Array = this.getConnectionsByStep(uid);
			
			//get more information from each connection
			for each (var sp:StepConnection in stepcConnections) {
				
				var cID:* = (sp.uid != 0) ? sp.uid : sp.tempUID;
				
				connectionInfo = getConnectionInfo(cID);
				links.push(connectionInfo);
				
			}
			
			return links;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getConnectionInfo(uid:*):Object {
			
			var connectionInfo:Object = new Object(); //{uid,tempUID,source,sourceTempUID,sourceLabel,target,targetTempUID,targetLabel}
			
			var connection:StepConnection = (uid is int) ? this.getRegistedConnection(uid) : this.getUnregisteredConnection(uid);
			
			connectionInfo.uid = connection.uid;
			connectionInfo.tempUID = connection.tempUID;
			connectionInfo.source = connection.source;
			connectionInfo.sourceTempUID = connection.sourceTempUID;
			connectionInfo.target = connection.target;
			connectionInfo.targetTempUID = connection.targetTempUID;
			
			var sID:* = (connection.source != 0) ? connection.source : connection.sourceTempUID;
			var tID:* = (connection.target != 0) ? connection.target : connection.targetTempUID;	
			
			connectionInfo.sourceLabel = source.stepsManager.getStepAbbreviation(sID);
			connectionInfo.targetLabel = source.stepsManager.getStepAbbreviation(tID);
			
			return connectionInfo;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasConnectionsAdded():Boolean {
			if (connectionsAdded) if (connectionsAdded.length > 0) return true;
			return false;
		}
		
		/**
		 * 
		 * 
		 */
		public function get hasConnectionsRemoved():Boolean {
			if (connectionsRemoved) if (connectionsRemoved.length > 0) return true;
			return false;;
		}
		
		/**
		 * 
		 * 
		 */
		public function getConnectionsAdded():Array {
			if (connectionsAdded) return connectionsAdded;
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function getConnectionsRemoved():Array {
			if (connectionsRemoved) return connectionsRemoved;
			return null;
		}
		
		/**
		 * 
		 * @param addedFlags
		 * @return 
		 * 
		 */
		public function registerAddedConnections(addedConnections:Array):Array {
			var item:Object;
			var connection:StepConnection;
			
			//loop to update uid in recently added flags
			for each (item in addedConnections) {
				connection = this.getRegistedConnectionByTempID(item.tempUID);
				
				if (connection) {
					connection.uid = item.uid;
					connection.source = item.source;
					connection.target = item.target;
				}
			}
			
			return connectionsAdded;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpConnectionsAdded():Boolean {
			//removing temp information
			for each (var connection:StepConnection in source.connections) {
				connection.tempUID = "";
				connection.sourceTempUID = "";
				connection.targetTempUID = "";
			}
			
			connectionsAdded = null;
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dumpConnectionsRemoved():Boolean {
			connectionsRemoved = null;
			return true;
		}
		
		
	}
}