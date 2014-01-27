<?php

//if($_POST['title']) {

	require_once("DBConn.php");
	$dbConn = DBConn::getConnection();
	
	$wfid = 5;
	$title = "start";
	$color = 2;
	$ordering = 1;
	
	//collect information
	if ($_POST['title'] != "") {
		$title = addslashes($_POST['title']);
	}
	
	//query
	$query = "INSERT INTO flags (wfid, title, color, ordering) VALUES ('$wfid', '$title', '$color', '$ordering')";
	if ($dbConn->query($query)) {
		
		$data["uid"] = $dbConn->insert_id;
		$data["wfid"] = $wfid;
		$data["title"] = $title;
		$data["color"] = $color;
		$data["ordering"] = $ordering;
		
		print json_encode($data);
		
	} else {
		echo "error";
	}
	
	/* close connection */
	$dbConn->close();

//}

?>