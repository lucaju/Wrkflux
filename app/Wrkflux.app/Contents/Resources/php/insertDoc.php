<?php

header('Content-type: application/json');

if($_POST['wdata']) {
	
	//required
	require_once("DBConn.php");
	require_once("functions.php");
	
	//mysql
	$dbConn = DBConn::getConnection();
	
	//get data
	$wdata = stripslashes($_POST['wdata']);
	
	//JSON decode
	$jData = json_decode($wdata,true);
	
	//save data - Workflow
	$wfID = $jData['wfid'];
	$title = utf8_decode($jData['title']);
	$flagID = $jData['flagID'];
	$stepID = $jData['stepID'];
	$description = utf8_decode($jData['description']);
	
	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;
	
	
	//query - Insert new item
	$query = "INSERT INTO items (wfid, title, description) VALUES ('$wfID', '$title', '$description')";
	if ($dbConn->query($query)) {
		
		$itemUID = $dbConn->insert_id;
		
		$data["uid"] = $itemUID;
		$data["wfID"] = $wfID;
		$data["title"] = utf8_encode($title);
		$data["description"] = utf8_encode($description);
	}
	
	
	//query - Insert new item log	
	$query = "INSERT INTO items_log (item_uid, flag_uid, step_uid, date) VALUES ('$itemUID', '$flagID', '$stepID', '$dateTime')";
	if ($dbConn->query($query)) {
		
		$logUID = $dbConn->insert_id;
		
		$log["uid"] = $logUID;
		$log["flag_uid"] = $flagID;
		$log["step_uid"] = $stepID;
		$log["date"] = $dateTime;
		
	}
	
	//add log to returning data
	$data["log"] = $log;
	
	//Convert to JSON and print
	//print json_encode($data);
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>