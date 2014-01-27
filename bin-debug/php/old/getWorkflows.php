<?php

if($_POST['action']) {

	require_once("DBConn.php");
	$dbConn = DBConn::getConnection();

	$query = "SELECT * FROM workflow ORDER BY id DESC";
	
	if ($result = $dbConn->query($query)) {
	 	
	 	while ($row = $result->fetch_assoc()) {
			$rows[] = $row;
		}
		
		print json_encode($rows);
		
		
		/* free result set */
		$result->close();
	}
	
	/* close connection */
	$dbConn->close();

   

}

?>