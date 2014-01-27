<?php

//require
require_once("DBConn.php");


class Flags {

	//****************** Properties ****************** ****************** ******************
	
	public $wfid;
	protected $query;
	
	
	//****************** Constructor ****************** ****************** ******************

	public function __contruct() {
		
	}
	
	
	//****************** PUBLIC METHODS ****************** ****************** ******************
	
	public function insertMultipleFlags($flags) {
		
		//flags to add loop
		foreach ($flags as $flag) {
			
			$wfid = $this->wfid;
			$title = utf8_decode($flag['title']);
			$color = $flag['color'];
			$ordering = $flag['order'];
			
			$query = "INSERT INTO flags (wfid, title, color, ordering) VALUES ('$wfid', '$title', '$color', '$ordering')";
			
			//query
			$dbConn = DBConn::getConnection();
			
			if ($result = $dbConn->query($query)) {
				$flag['uid'] = $dbConn->insert_id;
				$addedFlags[] = $flag;
			}
		}
		
		//end loop and send info back
		if ($addedFlags) {
			return 	$addedFlags;
		} else {
			return "error";	
		}
				
	}
	
	public function deleteMultipleFlags($flags) {
		
		//flags to add loop
		foreach ($flags as $flag) {
			
			$wfid = $this->wfid;
			$uid = $flag["uid"]; 
			//$title = $flag['title'];
			//$color = $flag['color'];
			//$ordering = $flag['order'];
			
			$query = "DELETE FROM flags WHERE uid = $uid";
			
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
	
	public function updateMultipleFlags($flags) {
		
		//flags to add loop
		foreach ($flags as $flag) {
			
			$wfid = $this->wfid;
			$uid = $flag["uid"]; 
			$title = utf8_decode($flag['title']);
			$color = $flag['color'];
			$ordering = $flag['order'];
			
			$query = "UPDATE flags SET title='$title', color='$color', ordering='$ordering' WHERE uid=$uid";
			
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
	
	public function selectFlagsByWFID($wfid) {
		$query = "SELECT * FROM flags WHERE wfid=$wfid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			
			while ($flag = $result->fetch_assoc()) {
				$flag['title'] = utf8_encode($flag['title']);
				$flagResults[] = $flag;
			}
			
			return $flagResults;
			
		} else {
			
			return "error";	
			
		}
	}
	
	public function selectFlagByUID($uid) {
		$query = "SELECT * FROM flags WHERE uid=$uid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			return $result;
		} else {
			return "error";	
		}
	}
	
}
	
?>