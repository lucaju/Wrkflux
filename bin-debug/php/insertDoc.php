<?php
//header('Content-Type: text/html; charset=utf-8');

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
	$title = $jData['title'];
	$flagID = $jData['flagID'];
	$stepID = $jData['stepID'];
	$description = $jData['description'];
	
	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;
	
	
	//query - Insert new item
	$query = "INSERT INTO items (wfid, title, description) VALUES ('$wfID', '$title', '$description')";
	if ($dbConn->query($query)) {
		
		$itemUID = $dbConn->insert_id;
		
		$data["uid"] = $itemUID;
		$data["wfID"] = $wfID;
		$data["title"] = $title;
		$data["description"] = $description;
		
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
	print json_encode($data);
	
	/* close connection */
	$dbConn->close();
	
}

function getDateNow() {
	$date = getDate();
	$today = $date['year']."-".$date['mon']."-".$date['mday'];
	return $today;
}

function getTimeNow() {
	$date = getDate();
	$time = $date['hours'].":".$date['minutes'].":".$date['seconds'];
	return $time;
}

?>