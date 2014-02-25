<?php

//require
require_once("DBConn.php");


class Steps {

	//****************** Properties ****************** ****************** ******************
	
	public $wfid;
	protected $query;


	//****************** Constructor ****************** ****************** ******************
	
	public function __contruct() {
		
	}
	
	
	//****************** PUBLIC METHODS ****************** ****************** ******************
	
	public function insertMultipleSteps($steps) {
		
		//step to add loop
		foreach ($steps as $step) {
			
			$wfid = $this->wfid;
			$title = utf8_decode($step['title']);
			$abbreviation = utf8_decode($step['abbreviation']);
			$shape = $step['shape'];
			$position = $step['position'];
			
			//position;
			$px = $position['x'];
			$py = $position['y'];
			$positionString = $px.",".$py;
			
			
			$query = "INSERT INTO steps (wfid, title, abbreviation, shape, position) VALUES ('$wfid', '$title', '$abbreviation', '$shape', '$positionString')";
			
			//query
			$dbConn = DBConn::getConnection();
			
			if ($result = $dbConn->query($query)) {
				$step['uid'] = $dbConn->insert_id;
				$addedSteps[] = $step;
			}
		}
		
		//end loop and send info back
		if ($addedSteps) {
			return 	$addedSteps;
		} else {
			return "error";	
		}
				
	}
	
	public function deleteMultipleSteps($steps) {
		
		//steps to add loop
		foreach ($steps as $step) {
	
			$uid = $step["uid"];
			
			$query = "DELETE FROM steps WHERE uid = $uid";
			
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
	
	public function updateMultipleSteps($steps) {
		
		//steps to add loop
		foreach ($steps as $step) {
			
			$wfid = $this->wfid;
			$uid = $step["uid"]; 
			$title = utf8_decode($step['title']);
			$abbreviation = utf8_decode($step['abbreviation']);
			$shape = $step['shape'];
			$position = $step['position'];
			
			//position;
			$px = $position['x'];
			$py = $position['y'];
			$positionString = $px.",".$py;
			
			$query = "UPDATE steps SET title='$title', abbreviation='$abbreviation', shape='$shape', position='$positionString' WHERE uid=$uid";
			
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
	
	public function selectStepsByWFID($wfid) {
		$query = "SELECT * FROM steps WHERE wfid=$wfid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			
			while ($step = $result->fetch_assoc()) {
				$step['title'] = utf8_encode($step['title']);
				$step['abbreviation'] = utf8_encode($step['abbreviation']);
				$stepResults[] = $step;
			}
			
			return $stepResults;
		
		} else {
			
			return "error";	
			
		}
	}
	
	public function selectStepByUID($uid) {
		$query = "SELECT * FROM steps WHERE uid=$uid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			return $result;
		} else {
			return "error";	
		}
	}
	
}
	
?>