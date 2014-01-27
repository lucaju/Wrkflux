<?php

if($_POST['action']) {

	require_once("DBConn.php");
	require_once("functions.php");
	
	$dbConn = DBConn::getConnection();

	$query = "SELECT * FROM workflow ORDER BY id DESC";
	
	if ($result = $dbConn->query($query)) {
	 	
	 	while ($row = $result->fetch_assoc()) {
	 		$row['title'] = utf8_encode($row['title']);
	 		$row['author'] = utf8_encode($row['author']);
	 		
			$rows[] = $row;
		}
		
		//print json_encode($rows);
		print jsonRemoveUnicodeSequences($rows);
		
		/* free result set */
		$result->close();
	}
	
	/* close connection */
	$dbConn->close();

   

}

?>