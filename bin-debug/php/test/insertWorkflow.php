<?php

header('Content-type: application/json');

if($_POST['wdata']) {
	
	//required
	require_once("DBConn.php");
	require_once("Flags.php");
	require_once("Steps.php");
	require_once("functions.php");
	
	//mysql
	$dbConn = DBConn::getConnection();
	
	//get data
	$wdata = stripslashes($_POST['wdata']);
	
	//JSON decode
	$jData = json_decode($wdata,true);
	
	//save data - Workflow
	$title = utf8_decode($jData['title']);
	$author = utf8_decode($jData['author']);
	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;
	
	//query - Insert new Workflow
	$query = "INSERT INTO workflow (title, author, created_date, modified_date) VALUES ('$title', '$author', '$dateTime', '$dateTime')";
	
	if ($dbConn->query($query)) {
		
		$wfid = $dbConn->insert_id;
		
		$data["id"] = $wfid;
		$data["title"] = utf8_encode($title);
		$data["author"] = utf8_encode($author);
		$data["created_date"] = $dateTime;
		$data["modified_date"] = $dateTime;
		
	}
	
	//add preset flags
	$flags = $jData["flags"];
	$flagsClass = new Flags();
	$flagsClass->wfid = $wfid;
	$flagAddedResults = $flagsClass->insertMultipleFlags($flags);
	
	$data["flags"] = $flagAddedResults;
	
	//add preset Steps
	$steps = $jData["steps"];
	$stepClass = new Steps();
	$stepClass->wfid = $wfid;
	$stepAddedResults = $stepClass->insertMultipleSteps($steps);
	
	$data["steps"] = $stepAddedResults;
	
	//Convert to JSON and print
	//print json_encode($data);
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>