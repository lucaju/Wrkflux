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
	
	$query = "SELECT first_name, last_name, email, AES_DECRYPT(password, SHA1('wrkflux')) FROM users WHERE email = '$email' LIMIT 1";
	
	if ($result = $dbConn->query($query)) {
	
		if ($dbConn->affected_rows == 1) {
		
			$row = $result->fetch_assoc();
					
			$firstName = utf8_encode($row['first_name']);
			$lastName = utf8_encode($row['lastName']);
			$email = $row['email'];
			$password = $row["AES_DECRYPT(password, SHA1('wrkflux'))"];
			
			
			///--------- EMAIL
			$to      = $email;
			$subject = '[Wrkflux] - Password recovery';
			
			$headers = 'From: Wrkflux' . "\r\n" .
			    'Reply-To: dosreis@ualberta.ca' . "\r\n" .
			    'X-Mailer: PHP/' . phpversion();
			    
			$message = "Hello $firstName $lastName. \n\n".
						"You resquest to recover you Wrkflux password. \n\n".
						"username: $email \n".
						"password: $password";
			
			if (mail($to, $subject, $message, $headers)) {
				$data["success"] = true;
			} else {
				$data["success"] = false;
			}
			
			
			//----------
		
		
		} else {
		
			$data["success"] = false;
			$data['error'] = "Invalid email";
			$data["errno"] = $dbConn->errno;
		
		}
		
		
		//print json_encode($rows);
		print jsonRemoveUnicodeSequences($data);
		
		
		/* free result set */
		$result->close();
	
	} else {
	
		$data["success"] = false;
		$data['error'] = $dbConn->error;
		$data["errno"] = $dbConn->errno;
	
	}
	
	/* close connection */
	$dbConn->close();


}

?>