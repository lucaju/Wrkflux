<?php

require_once("DBConn.php");

class Items {

	public function __contruct() {
		
	}
	
	public function selectItemsByWFID($wfid) {
		
		
		//query -Select all docs from a WF
		$query = "SELECT * FROM items WHERE wfid=$wfid";
		
		$dbConn = DBConn::getConnection();
		
		if ($result = $dbConn->query($query)) {
			while ($item = $result->fetch_assoc()) {
				
				//get last log for each item
				$itemUID = $item['uid'];
				$queryLog = "SELECT * FROM items_log WHERE item_uid=$itemUID ORDER BY uid DESC LIMIT 1";
				
				if ($resultLog = $dbConn->query($queryLog)) {
					
					while ($log = $resultLog->fetch_assoc()) {
						//save results
						$item['log'] = $log;
					}
				}
				
				//save results
				$items[] = $item;
			}
			
			return $items;
			
		} else {
			
			return "error";
			
		}
	}
	
}
	
?>