<?php

require_once("DBConn.php");
require_once("Steps.php");

class StepConnections {
	
	public $wfid;
	public $stepsAdded;
	protected $query;

	public function __contruct() {
		
	}
	
	public function getStepID($tempStepID) {
		foreach ($this->stepsAdded as $step) {
			$tempID = $step['tempID'];
			if ($tempID == $tempStepID) return $stepUID = $step['uid'];
		}
	}
	
	public function insertMultipleStepConnections($stepConnections) {
		
		//Connections to add loop
		foreach ($stepConnections as $stepConnection) {
			
			$wfid = $this->wfid;
			$source = $stepConnection['source'];
			$target = $stepConnection['target'];
			
			//check if connections has temp attributes
			if ($source == 0) {
				$sourceTemp = $stepConnection['sourceTempUID'];
				$source = $this->getStepID($sourceTemp);
				$stepConnection['source'] = $source;
			}
			
			if ($target == 0) {
				$targetTemp = $stepConnection['targetTempUID'];
				$target = $this->getStepID($targetTemp);
				$stepConnection['target'] = $target;
			}
			
			$query = "INSERT INTO step_connections (wfid, source, target) VALUES ('$wfid','$source', '$target')";
			
			//query
			$dbConn = DBConn::getConnection();
			
			if ($result = $dbConn->query($query)) {
				$stepConnection['uid'] = $dbConn->insert_id;
				$addedConnections[] = $stepConnection;
			}
		}
		
		//end loop and send info back
		if ($addedConnections) {
			return 	$addedConnections;
		} else {
			return "error";	
		}
				
	}
	
	public function deleteMultipleStepConnections($stepConnections) {
		
		//steps to add loop
		foreach ($stepConnections as $stepConnection) {
	
			$uid = $stepConnection["uid"];
			
			$query = "DELETE FROM step_connections WHERE uid = $uid";
			
			//query
			$dbConn = DBConn::getConnection();
			
			if ($dbConn->query($query)) {
				$result = "success";
			} else {
				$result = "error";
			}
		}
		
		//end loop and send info back
		return $result;
				
	}
	
	public function selectStepConnectionsByWFID($wfid) {
		$query = "SELECT * FROM step_connections WHERE wfid=$wfid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			while ($stepConnection = $result->fetch_assoc()) {
				$stepConnections[] = $stepConnection;
			}
			return $stepConnections;
		} else {
			return "error";	
		}
	}
	
	public function selectStepConnectionsByStep($wfid,$stepID) {
		$query = "SELECT * FROM step_connections WHERE wfid=$wfid AND (source=$stepID OR target=$stepID)";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			while ($stepConnection = $result->fetch_assoc()) {
				$stepConnections[] = $stepConnection;
			}
			return $stepConnections;
		} else {
			return "error";	
		}
	}
	
	public function selectStepConnectionsByUID($uid) {
		$query = "SELECT * FROM step_connections WHERE uid=$uid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			return $result;
		} else {
			return "error";	
		}
	}
	
}
	
?>