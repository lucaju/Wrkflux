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
	$itemUID = $jData['itemUID'];
	$flagUID = $jData['flagUID'];
	$stepUID = $jData['stepUID'];
	
	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;

	//query - Insert new item log	
	$query = "INSERT INTO items_log (item_uid, flag_uid, step_uid, date) VALUES ('$itemUID', '$flagUID', '$stepUID', '$dateTime')";
	if ($dbConn->query($query)) {
		
		$logUID = $dbConn->insert_id;
		
		$data["uid"] = $logUID;
		$data["itemUID"] = $itemUID;
		$data["flagUID"] = $flagUID;
		$data["stepUID"] = $stepUID;
		$data["date"] = $dateTime;
		
	}
	
	//Convert to JSON and print
	print json_encode($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>