<?php

header('Content-type: application/json');

if($_POST['wdata']) {
	
	//required
	require_once("DBConn.php");
	
	//mysql
	$dbConn = DBConn::getConnection();
	
	//get data
	$wdata = stripslashes($_POST['wdata']);
	
	//JSON decode
	$jData = json_decode($wdata,true);
	
	//save data - Workflow
	$itemUID = $jData['itemUID'];
	
	//query -Select all docs from a WF
	$query = "SELECT * FROM items_log WHERE item_uid=$itemUID ORDER BY uid ASC";
	
	if ($result = $dbConn->query($query)) {
		while ($log = $result->fetch_assoc()) {	
			//save results
			$logs[] = $log;
		}
	}
	
	//add log to returning data
	$data["uid"] = $itemUID;
	$data["logs"] = $logs;
	
	//Convert to JSON and print
	print json_encode($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>