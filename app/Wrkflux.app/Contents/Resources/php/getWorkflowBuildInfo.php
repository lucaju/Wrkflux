<?php

header('Content-type: application/json');

if($_POST['action']) {
	
	//required
	require_once("DBConn.php");
	require_once("Flags.php");
	require_once("Steps.php");
	require_once("StepConnections.php");
	require_once("Tags.php");
	require_once("functions.php");
	
	//MySql
	$dbConn = DBConn::getConnection();
	
	//get data
	$wfID = $_POST['id'];
	
	//get Workflow Info
	$query = "SELECT * FROM workflow WHERE id = $wfID";
	
	if ($result = $dbConn->query($query)) {
			 	
	 	$data = $result->fetch_assoc();
	 	
	 	$data['title'] = utf8_encode($data['title']);
	 	$data['authorID'] = $data['user_id'];
		
		/* free result set */
		//$result->close();
	}
	
	//get Flags info
	$flagsClass = new Flags();
	$flagsClass->wfid = $wfID;
	$flagResults = $flagsClass->selectFlagsByWFID($wfID);
	$data["flags"] = $flagResults;
	
	//get Steps info
	$stepClass = new Steps();
	$stepClass->wfid = $wfID;
	$stepResults = $stepClass->selectStepsByWFID($wfID);
	$data["steps"] = $stepResults;
	
	//get Connections info
	$stepConnectionsClass = new StepConnections();
	$stepConnectionsClass->wfid = $wfID;
	$stepConnectionsResults = $stepConnectionsClass->selectStepConnectionsByWFID($wfID);
	$data["connections"] = $stepConnectionsResults;
	
	//get Tags info
	$tagsClass = new Tags();
	$tagsClass->wfid = $wfID;
	$tagsResults = $tagsClass->selectTagsByWFID($wfID);
	$data["tags"] = $tagsResults;
	
	//Convert to JSON
	//print json_encode($data);
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();

}

?>