<?php

if($_POST['wdata']) {
	
	//required
	require_once("DBConn.php");
	require_once("Flags.php");
	require_once("Steps.php");
	
	//mysql
	$dbConn = DBConn::getConnection();
	
	//get data
	$wdata = stripslashes($_POST['wdata']);
	
	//JSON decode
	$jData = json_decode($wdata,true);
	
	//save data - Workflow
	$title = $jData['title'];
	$author = $jData['author'];
	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;
	
	//query - Insert new Workflow
	$query = "INSERT INTO workflow (title, author, created_date, modified_date) VALUES ('$title', '$author', '$dateTime', '$dateTime')";
	if ($dbConn->query($query)) {
		
		$wfid = $dbConn->insert_id;
		
		$data["id"] = $wfid;
		$data["title"] = $title;
		$data["author"] = $author;
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