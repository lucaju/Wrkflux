<?php

	//$db_pipeline = mysql_pconnect('localhost', 'dosreisf', '42Ds(40e');
	$db_pipeline = mysql_pconnect('localhost', 'fluxoart_inke', 'inkians');
	$success = mysql_select_db('fluxoart_wrkflux2');
	
	if(!$success) echo "<p>An error occurred!</p>";
	
?>