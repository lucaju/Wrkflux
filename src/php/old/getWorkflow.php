<?php

if($_POST['action']) {
	
	//required
	require_once("DBConn.php");
	require_once("Flags.php");
	require_once("Steps.php");
	require_once("Items.php");
	require_once("StepConnections.php");
	
	//MySql
	$dbConn = DBConn::getConnection();
	
	//get data
	$wfID = $_POST['id'];
	
	//get Workflow Info
	$query = "SELECT * FROM workflow WHERE id = $wfID";
	
	if ($result = $dbConn->query($query)) {
			 	
	 	$data = $result->fetch_assoc();
		
		/* free result set */
		//$result->close();
	}
	
	//get Flags
	$flagsClass = new Flags();
	$flagsClass->wfid = $wfID;
	$flagResults = $flagsClass->selectFlagsByWFID($wfID);
	$data["flags"] = $flagResults;
	
	//get Steps
	$stepClass = new Steps();
	$stepClass->wfid = $wfID;
	$stepResults = $stepClass->selectStepsByWFID($wfID);
	$data["steps"] = $stepResults;
	
	//get Connections
	$stepConnectionsClass = new StepConnections();
	$stepConnectionsClass->wfid = $wfID;
	$stepConnectionsResults = $stepConnectionsClass->selectStepConnectionsByWFID($wfID);
	$data["connections"] = $stepConnectionsResults;
	
	//get Items
	$itemsClass = new Items();
	$ItemResults = $itemsClass->selectItemsByWFID($wfID);
	$data["flow"] = $ItemResults;
	
	//Convert to JSON
	print json_encode($data);
	
	/* close connection */
	$dbConn->close();

}

?>