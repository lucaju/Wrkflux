<?php

header('Content-type: application/json');

if($_POST['wdata']) {

	require_once("DBConn.php");
	require_once("functions.php");
	
	$dbConn = DBConn::getConnection();
	
	//get data
	$wdata = stripslashes($_POST['wdata']);
	
	//JSON decode
	$jData = json_decode($wdata,true);
	
	//save data - Workflow
	$email = utf8_decode($jData['email']);
	$password = utf8_decode($jData['password']);
	
	$query = "SELECT id, first_name, last_name, email, AES_DECRYPT(password, SHA1('wrkflux')) FROM users WHERE email = '$email' LIMIT 1";
	
	if ($result = $dbConn->query($query)) {
	
		if ($dbConn->affected_rows == 1) {
		
			$row = $result->fetch_assoc();
			
			//test password
			$cryptPass = $row["AES_DECRYPT(password, SHA1('wrkflux'))"];
			
			if ($password === $cryptPass) {
			
				$data["success"] = true;
				
				$data['userID'] = $row['id'];	
				$data['firstName'] = utf8_encode($row['first_name']);
				$data['lastName'] = utf8_encode($row['last_name']);
		
			
			} else {
			
				$data["success"] = false;
				$data['error'] = "Invalid password";
				$data["errno"] = $dbConn->errno;
			
			}
		
		
		} else {
		
			$data["success"] = false;
			$data['error'] = "Invalid username";
			$data["errno"] = $dbConn->errno;
		
		}
		
		//print json_encode($rows);
		print jsonRemoveUnicodeSequences($data);
		
		
		/* free result set */
		$result->close();
	
	} else {
	
		echo "error";
	
	}
	
	/* close connection */
	$dbConn->close();


}

?>