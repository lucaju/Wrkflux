<?php

header('Content-type: application/json');

if($_POST['action']) {

	require_once("DBConn.php");
	require_once("functions.php");
	
	$dbConn = DBConn::getConnection();

	//define query based on the user ID	
	if (isset($_POST['userID'])) {
		$userID = $_POST['userID'];
		$query = "SELECT * FROM workflow WHERE user_id='$userID' ORDER BY id DESC";
	} else {
		$query = "SELECT * FROM workflow WHERE visibility='1' ORDER BY id DESC";
	}
	
	if ($result = $dbConn->query($query)) {
	 	
	 	while ($row = $result->fetch_assoc()) {
	 		
	 		//check authorship
	 		$userID = $row['user_id'];
	 		
	 		if ($userID == 0) {
		 		$author = "Annonymous";
	 		} else {
	 		
		 		$queryAuthor = "SELECT id, first_name, last_name FROM users WHERE id = '$userID'";
		 		
		 		if ($resultAuthor = $dbConn->query($queryAuthor)) {

		 			$authorInfo = $resultAuthor->fetch_assoc();
		 			$author = $authorInfo['first_name']." ".$authorInfo['last_name'];
		 			
		 		}
		 		
	 		}
	 		
	 		//save info to send
	 	
	 		$row['title'] = utf8_encode($row['title']);
	 		$row['author'] = utf8_encode($author);
	 		
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