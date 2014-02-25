<?php

header('Content-type: application/json');

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
	$itemUID = $jData['uid'];
	$title = utf8_decode($jData['title']);
	$description = utf8_decode($jData['description']);
	
	//query - Update item
	$query = "UPDATE items SET title='$title', description='$description' WHERE uid=$itemUID";
	
	if ($dbConn->query($query)) {
		
		$data["uid"] = $itemUID;
		$data["title"] = utf8_encode($title);
		$data["description"] = utf8_encode($description);
		
	}
	
	//Convert to JSON and print
	//print json_encode($data);
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>