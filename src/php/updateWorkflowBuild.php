<?php

header('Content-type: application/json');

if($_POST['wdata']) {
	
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
	$wdata = stripslashes($_POST['wdata']);
	
	//JSON decode
	$jData = json_decode($wdata,true);
	
	//save data - Workflow
	$wfID = $jData['id'];
	if ($jData['title']) $title = utf8_encode($jData['title']);
	if ($jData['author']) $author = utf8_encode($jData['author']);
	if (isset($jData['visibility'])) $visibility = $jData['visibility'];
	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;

	//Update Workflow Info
	$query = "UPDATE workflow SET ";
	
	if($title ) $query .= "title = '$title', ";
	if($author) $query .= "author = '$author', ";
	if(isset($jData['visibility'])) $query .= "visibility = '$visibility', ";
	$query .= "modified_date = '$dateTime' ";
	$query .= "WHERE id = $wfID";
	
	//send query
	if ($result = $dbConn->query($query)) {
		/* free result set */
		//$result->close();
	}
	
	//-------------flags
	if ($jData['added_flags']) $flagsAdded = $jData['added_flags'];
	if ($jData['updated_flags']) $flagsUpdated = $jData['updated_flags'];
	if ($jData['removed_flags']) $flagsRemoved = $jData['removed_flags'];
	
	//Action
	$flagsClass = new Flags();
	$flagsClass->wfid = $wfID;
	if ($flagsRemoved) $flagsClass->deleteMultipleFlags($flagsRemoved);
	if ($flagsUpdated) $flagsClass->updateMultipleFlags($flagsUpdated);
	if ($flagsAdded) $flagAddedResults = $flagsClass->insertMultipleFlags($flagsAdded);
	
	//save flags to send back
	$data["added_flags"] = $flagAddedResults;
	
	
	//-------------steps
	if ($jData['added_steps']) $stepsAdded = $jData['added_steps'];
	if ($jData['updated_steps']) $stepsUpdated = $jData['updated_steps'];
	if ($jData['removed_steps']) $stepsRemoved = $jData['removed_steps'];
	
	//Action
	$stepsClass = new Steps();
	$stepsClass->wfid = $wfID;
	if ($stepsRemoved) $stepsClass->deleteMultipleSteps($stepsRemoved);
	if ($stepsUpdated) $stepsClass->updateMultipleSteps($stepsUpdated);
	if ($stepsAdded) $stepAddedResults = $stepsClass->insertMultipleSteps($stepsAdded);
	
	//save steps to send back
	$data["added_steps"] = $stepAddedResults;
	
	
	//-------------Connections
	if ($jData['added_connections']) $connectionsAdded = $jData['added_connections'];
	if ($jData['removed_connections']) $connectionsRemoved = $jData['removed_connections'];
	
	//Action
	$stepConnectionsClass = new StepConnections();
	$stepConnectionsClass->wfid = $wfID;
	$stepConnectionsClass->stepsAdded = $stepAddedResults;
	if ($connectionsRemoved) $stepConnectionsClass->deleteMultipleStepConnections($connectionsRemoved);
	if ($connectionsAdded) $stepConnectionsAddedResults = $stepConnectionsClass->insertMultipleStepConnections($connectionsAdded);
	
	//save connections to send back
	$data["added_connections"] = $stepConnectionsAddedResults;
	
	//-------------tags
	if ($jData['added_tags']) $tagsAdded = $jData['added_tags'];
	if ($jData['updated_tags']) $tagsUpdated = $jData['updated_tags'];
	if ($jData['removed_tags']) $tagsRemoved = $jData['removed_tags'];
	
	//Action
	$tagsClass = new Tags();
	$tagsClass->wfid = $wfID;
	if ($tagsRemoved) $tagsClass->deleteMultipleTags($tagsRemoved);
	if ($tagsUpdated) $tagsClass->updateMultipleTags($tagsUpdated);
	if ($tagsAdded) $tagAddedResults = $tagsClass->insertMultipleTags($tagsAdded);
	
	//save tags to tags back
	$data["added_tags"] = $tagAddedResults;
	
	//Convert to JSON
	//print json_encode($data);
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();

}

?>