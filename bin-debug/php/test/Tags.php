<?php

//require
require_once("DBConn.php");


class Tags {
	
	//****************** Properties ****************** ****************** ******************
	
	public $wfid;
	protected $query;
	
	
	//****************** Constructor ****************** ****************** ******************

	public function __contruct() {
		
	}
	
	
	//****************** PUBLIC METHODS ****************** ****************** ******************
	
	public function insertMultipleTags($tags) {
		
		//step to add loop
		foreach ($tags as $tag) {
			
			$wfid = $this->wfid;
			$label = utf8_decode($tag['label']);
			$position = $tag['position'];
			
			//position;
			$px = $position['x'];
			$py = $position['y'];
			$positionString = $px.",".$py;
			
			$query = "INSERT INTO tags (wfid, label, position) VALUES ('$wfid', '$label', '$positionString')";
			
			//query
			$dbConn = DBConn::getConnection();
			
			if ($result = $dbConn->query($query)) {
				$tag['uid'] = $dbConn->insert_id;
				$addedTags[] = $tag;
			}
		}
		
		//end loop and send info back
		if ($addedTags) {
			return 	$addedTags;
		} else {
			return "error";	
		}
				
	}
	
	public function deleteMultipleTags($tags) {
		
		//steps to add loop
		foreach ($tags as $tag) {
	
			$uid = $tag["uid"];
			
			$query = "DELETE FROM tags WHERE uid = $uid";
			
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
	
	public function updateMultipleTags($tags) {
		
		//steps to add loop
		foreach ($tags as $tag) {
			
			$wfid = $this->wfid;
			$uid = $tag["uid"]; 
			$label = utf8_decode($tag['label']);
			$position = $tag['position'];
			
			//position;
			$px = $position['x'];
			$py = $position['y'];
			$positionString = $px.",".$py;
			
			$query = "UPDATE tags SET label='$label', position='$positionString' WHERE uid=$uid";
			
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
	
	public function selectTagsByWFID($wfid) {
		$query = "SELECT * FROM tags WHERE wfid=$wfid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
		
			while ($tag = $result->fetch_assoc()) {
				$tag['label'] = utf8_encode($tag['label']);
				$tagResults[] = $tag;
			}
		
			return $tagResults;
		
		} else {
		
			return "error";	
		
		}
	}
	
	public function selectTagByUID($uid) {
		$query = "SELECT * FROM tags WHERE uid=$uid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			return $result;
		} else {
			return "error";	
		}
	}
	
}
	
?>