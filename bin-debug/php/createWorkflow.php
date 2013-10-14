<?php

if($_POST['title']) {

	require_once("DBConn.php");
	$dbConn = DBConn::getConnection();
	
	//collect information
	if ($_POST['title'] != "") {
		$title = addslashes($_POST['title']);
	}
	
	if ($_POST['author'] != "")	{
		$author =  addslashes($_POST['author']);
	}
	
	//date
	$date = getDateNow();
	$time = getTimeNow();
	$dateTime = $date." ".$time;
	
	//query
	$query = "INSERT INTO workflow (title, author, created_date, modified_date) VALUES ('$title', '$author', '$dateTime', '$dateTime')";
	if ($dbConn->query($query)) {
		
		$data["id"] = $dbConn->insert_id;
		$data["title"] = $title;
		$data["author"] = $author;
		$data["created_date"] = $dateTime;
		$data["modified_date"] = $dateTime;
		
		print json_encode($data);
		
	}
	
	/* close connection */
	$dbConn->close();

}

function getDateNow() {
	$date = getDate();
	$today = $date['year']."-".$date['mon']."-".$date['mday'];
	return $today;
}

function getTimeNow() {
	$date = getDate();
	$time = $date['hours'].":".$date['minutes'].":".$date['seconds'];
	return $time;
}
?>