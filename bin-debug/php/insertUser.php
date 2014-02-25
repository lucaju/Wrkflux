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
	$firstName = utf8_decode($jData['firstName']);
	$lastName = utf8_decode($jData['lastName']);
	$email = utf8_decode($jData['email']);
	$password = utf8_decode($jData['password']);
	
	//query - Insert new item
	$query = "INSERT INTO users (first_name, last_name, email, password) VALUES ('$firstName', '$lastName', '$email', AES_ENCRYPT('$password', SHA1('wrkflux')))";
	
	if ($dbConn->query($query)) {
		
		$data["success"] = true;
		
		$data["userID"] = $dbConn->insert_id;
		$data["firstName"] = utf8_encode($firstName);
		$data["lastName"] = utf8_encode($lastName);
		
		
	} else {
	
		$data["success"] = false;
		
		$data["error"] = $dbConn->error;
		$data["errno"] = $dbConn->errno;
	
	}
		
	//Convert to JSON and print
	//print json_encode($data);
	print jsonRemoveUnicodeSequences($data);
	
	/* close connection */
	$dbConn->close();
	
}

?>