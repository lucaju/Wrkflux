<?php

header('Content-type: application/json');

if ($_POST['userID']) {

	//required
	require_once("DBConn.php");
	require_once("functions.php");

	if ($_FILES["Filedata"]["error"] > 0) {
	  
	 	$data["success"] = "false";
	 	$data["errnoFile"] = $_FILES["Filedata"]["error"];
	 	$data["message"] = "error";

	 	$uploadeSuccess = false;


	} else {

		$userID = $_POST['userID'];

		$data["userID"] = $userID ;

	  	//echo "Upload: " . $_FILES["Filedata"]["name"] . "<br>";
	  	//echo "Type: " . $_FILES["Filedata"]["type"] . "<br>";
	  	//echo "Size: " . ($_FILES["Filedata"]["size"] / 1024) . " kB<br>";


		//check for previous images
		$PATH = "../users/profile_image/";

		$files = scandir($PATH );
		
		foreach($files as $file) {
			$explodedFileName = explode("_", $file);
			$userFileId = substr($explodedFileName[0], 1);

			if ($userFileId == $userID) {
				unlink($PATH . $file);
				$data["replace"] = true;
				break;
			}
		}


	  	//rename file. Add userid. (Ex: file.jpg > u21_file.jpg)
	  	$_FILES["Filedata"]["name"] = "u" . $userID . "_" . $_FILES["Filedata"]["name"];
	   

		if (file_exists($PATH . $_FILES["Filedata"]["name"])) {

	    	$data["success"] = false;
	  		$data["file_path"] = $PATH ;
	  		$data["file_name"] = $_FILES["Filedata"]["name"];
	  		$data["messsage"] = $_FILES["Filedata"]["name"] . " already exists. ";

	  		$uploadeSuccess = false;

	    } else {
	    	
	    	move_uploaded_file($_FILES["Filedata"]["tmp_name"], $PATH . $_FILES["Filedata"]["name"]);
	    	
	    	$uploadeSuccess = true;
	    	$fileName = $_FILES["Filedata"]["name"];

	    	$data["file_path"] = $PATH;
	  		$data["file_name"] = $fileName;

	    }

	}

	if ($uploadeSuccess) {

		//mysql
		$dbConn = DBConn::getConnection();

		$date = getDateNow();
		$time = getTimeNow();
		$dateTime = $date." ".$time;

		$query = "UPDATE users SET ";
		$query .= "modified_date='$dateTime', "; 
		$query .= "profile_image='$fileName' ";
		$query .= "WHERE id=$userID";
		
		if ($result = $dbConn->query($query)) {

			$data["success"] = true;

			
		} else {
			
			$data["success"] = false;
				
			$data["error"] = $dbConn->error;
			$data["errno"] = $dbConn->errno;
			
			
		}


	}

	print jsonRemoveUnicodeSequences($data);

}

?>