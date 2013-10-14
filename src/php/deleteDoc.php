<?php

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
	
	//query - delete item	
	$query = "DELETE FROM items WHERE uid = $itemUID";
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	//query - delete item	logs	
	$query = "DELETE FROM items_log WHERE item_uid = $itemUID";
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	//result
	$data['itemUID'] = $itemUID;
	
	//Convert to JSON and print
	if ($result == "success") {
		print json_encode($data);
	} else {
		print json_encode($result);
	}
	
	/* close connection */
	$dbConn->close();
	
}

?>