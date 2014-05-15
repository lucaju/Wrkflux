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
	$userID = utf8_decode($jData['userID']);
	if (isset($jData['firstName'])) $firstName = utf8_decode($jData['firstName']);
	if (isset($jData['lastName'])) $lastName = utf8_decode($jData['lastName']);
	if (isset($jData['password'])) $password = utf8_decode($jData['password']);
	if (isset($jData['profileImage'])) $profile_image = utf8_decode($jData['profileImage']);

	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;


	if(isset($profile_image)) if ($profile_image == "remove") removeFile($userID);	
	
	//query - Insert new item

	$multiple = false;

	$query = "UPDATE users SET ";
	if ($firstName) $query .= "first_name='$firstName', ";
	if ($lastName) $query .= "last_name='$lastName', ";
	if ($password) $query .= "password=AES_ENCRYPT('$password', SHA1('wrkflux')), ";
	
	if($profile_image) {
		if($profile_image == "remove") {
			$query .= "profile_image='', ";
		} else {
			$query .= "profile_image='$profile_image', ";
		}
	}

	$query .= "modified_date = '$dateTime' ";
	$query .= "WHERE id = $userID";

	//Send query
	if ($dbConn->query($query)) {

		$data["success"] = true;
		
		if ($firstName) $data["firstName"] = utf8_encode($firstName);
		if ($lastName) $data["lastName"] = utf8_encode($lastName);
		if ($profile_image) $data["profileImage"] = utf8_encode($profile_image);
		

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


function removeFile($userID) {

	$dbConn2 = DBConn::getConnection();
	
	$query2 = "SELECT id, profile_image FROM users WHERE id = $userID";

	if ($result = $dbConn2->query($query2)) {

		if ($dbConn2->affected_rows == 1) {

			$PATH = "../users/profile_image/";
			$row = $result->fetch_assoc();
			$fileName = $row["profile_image"];

			if (file_exists($PATH  . $fileName)) {
				unlink($PATH  . $fileName);
			} else {
				$data['message'] = "Cant' delete profile image. File not found.";
			}
			

		}
	}
	
}

?>