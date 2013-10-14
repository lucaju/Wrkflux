<?php
header('Content-Type: text/html; charset=utf-8');

if($_POST['wdata']) {
	
	//required
	require_once("DBConn.php");
	
	//mysql
	$dbConn = DBConn::getConnection();
	
	/*
	if (!$dbConn->set_charset('utf8')) {
		printf("Error loading character set utf8: %s\n", $dbConn->error);
	} else {
		printf("Current character set: %s\n", $dbConn->character_set_name());
	}
	*/
	
	
	//get data
	$wdata = stripslashes($_POST['wdata']);
	
	//JSON decode
	$jData = json_decode($wdata,true);
	
	//save data - Workflow
	$wfID = $jData['wfid'];
	
	//query -Select all docs from a WF
	$query = "SELECT * FROM items WHERE wfid=$wfID";
	
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
	}
	
	//add log to returning data
	$data["items"] = $items;
	
	//Convert to JSON and print
	print json_encode($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>