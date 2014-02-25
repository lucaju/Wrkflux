<?php

header('Content-type: application/json');

if($_POST['action']) {

	//required
	require_once("DBConn.php");
	require_once("functions.php");
	
	//mysql
	$dbConn = DBConn::getConnection();
	
	//save data - Workflow ID
	$wfID = $_POST['id'];
	
	$data['id'] = $wfID;
	
	//-------------- Select Items
	$query = "SELECT * FROM items WHERE wfid = $wfID";
	
	if ($selectResult = $dbConn->query($query)) {
		
		while ($item = $selectResult->fetch_assoc()) {
		
			$itemUID = $item["uid"];
			
			//-------------- delete item	logs	
			
			$queryLog = "DELETE FROM items_log WHERE item_uid = $itemUID";
			
			if ($dbConn->query($queryLog)) {
				$result = "Success";
			} else {
				$result = "Error";
			}
		
		}
		
	} else {
		$result = "error";
	}
	
	$data['logs'] = $result;
	
	//-------------- delete items	
	$query = "DELETE FROM items WHERE wfid = $wfID";
	
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	$data['items'] = $result;

	
	//-------------- delete tags
	$query = "DELETE FROM tags WHERE wfid = $wfID";
	
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	$data['tags'] = $result;
	
	//-------------- delete flags
	$query = "DELETE FROM flags WHERE wfid = $wfID";
	
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	$data['flags'] = $result;
	
	//-------------- delete Step Connections
	$query = "DELETE FROM step_connections WHERE wfid = $wfID";
	
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	$data['connections'] = $result;
	
	//-------------- delete Steps
	$query = "DELETE FROM steps WHERE wfid = $wfID";
	
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	$data['steps'] = $result;
		
	//-------------- delete Workflow	
	$query = "DELETE FROM workflow WHERE id = $wfID";
	
	if ($dbConn->query($query)) {
		$result = "success";
	} else {
		$result = "error";
	}
	
	$data['workflow'] = $result;
		
	//-------------- final result
	$data['result'] = $result;
	
	//Convert to JSON and print
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>