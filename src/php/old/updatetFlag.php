<p>&nbsp;</p>
<p>&nbsp;</p>
<?php

//if($_POST['title']) {

	require_once("DBConn.php");
	$dbConn = DBConn::getConnection();
	
	$uid = 21;
	$wfid = 5;
	$title = "start";
	$color = 2;
	$ordering = 1;
	
	//collect information
	if ($_POST['title'] != "") {
		$title = addslashes($_POST['title']);
	}
	
	//query
	$query = "UPDATE flags SET title = '$title', color = '$color', ordering = '$ordering' WHERE wfid = '$wfid' AND $uid = '$uid'";
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