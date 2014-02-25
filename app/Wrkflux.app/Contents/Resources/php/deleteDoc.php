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
	
	//result
	$data['itemUID'] = $itemUID;
	
	//query - delete item	logs	
	$query = "DELETE FROM items_log WHERE item_uid = $itemUID";
	if ($dbConn->query($query)) {
		$result = "success";
		$data['log'] = "Removed Success";
	} else {
		$result = "error";
	}
	
	//query - delete item	
	$query = "DELETE FROM items WHERE uid = $itemUID";
	if ($dbConn->query($query)) {
		$result = "success";
		$data['item'] = "Removed Success";
	} else {
		$result = "error";
	}
	
	
	//Convert to JSON and print
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>