<?php

require_once("DBConn.php");

class Flags {
	
	public $wfid;
	protected $query;

	public function __contruct() {
		
	}
	
	public function insertMultipleFlags($flags) {
		
		//flags to add loop
		foreach ($flags as $flag) {
			
			$wfid = $this->wfid;
			$title = $flag['title'];
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
			$title = $flag['title'];
			$color = $flag['color'];
			$ordering = $flag['order'];
			
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
			$title = $flag['title'];
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
	
	/************************************/
	
	protected function insertFlags($flags) {
		
		$this->query = "";
		$this->query .= "INSERT INTO flags (wfid, title, color, ordering) VALUES ";
		
		$flagsLenght = count($flags);
		$i = 1;
		
		foreach ($flags as $flag) {
			
			$wfid = $this->wfid;
			$title = $flag['title'];
			$color = $flag['color'];
			$ordering = $flag['order'];
			
			if ($i == $flagsLenght) {
				$this->query .= "('$wfid', '$title', '$color', '$ordering')";	
			} else {
				$this->query .= "('$wfid', '$title', '$color', '$ordering'),";
			}
			
			$i++;
			
		}
		
	}
	
	protected function removeFlags($flags) {
		$this->query = "";
		$this->query .= "DELETE FROM flags [WHERE Clause]";
		
		$flagsLenght = count($flags);
		$i = 1;
		
		foreach ($flags as $flag) {
			
			$wfid = $this->wfid;
			$title = $flag['title'];
			$color = $flag['color'];
			$ordering = $flag['order'];
			
			if ($i == $flagsLenght) {
				$this->query .= "('$wfid', '$title', '$color', '$ordering')";	
			} else {
				$this->query .= "('$wfid', '$title', '$color', '$ordering'),";
			}
			
			$i++;
			
		}
		
	}
	
	protected function selectByWFID() {
		$this->query = "";
		$this->query = "SELECT * FROM flags WHERE wfid=$this->wfid";
	}
	
	protected function selectByUID($uid) {
		$this->query = "";
		$this->query = "SELECT * FROM flags WHERE uid=$uid";
	}
	
	protected function updateAllFlagsbyWFid($flags) {
		$this->query = "";
		$this->query = "UPDATE flags SET ";
		
		$flagsLenght = count($flags);
		$i = 1;
		
		foreach ($flags as $flag) {
			
			$wfid = $this->wfid;
			$title = $flag['title'];
			$color = $flag['color'];
			$ordering = $flag['order'];
			
			if($title != "") {
				$query .= "title = '$title' ";
			}
			
			if($color != "") {
				$query .= "color = '$color' ";
			}
			
			if($ordering != "") {
				$query .= "ordering = '$ordering' ";
			}
			
			$query .= "WHERE id = $wfID";
			
			if ($i != $flagsLenght) {
				$this->query .= ", ";
			}
			
			$i++;
			
		}
	}
	
	public function query($type, $data = null) {
		
		//create query;
		switch ($type) {
			case "insert":
				$this->insertFlags($data);
				break;
				
			case "selectByWFID":
				$this->selectByWFID();
				break;
				
			case "selectByUID":
				$this->selectByUID($data);
				break;
				
			case "updateAllFlagsbyWFid":
				$this->updateAllFlagsbyWFid($data);
				break;
				
			case "remove":
				$this->removeFlags($data);
				break;
		
		}
		
		//query
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($this->query)) {
			return $result;
		} else {
			return "error";	
		}
		
	}
}
	
?>