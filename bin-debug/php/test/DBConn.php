<?php

class DBConn {
	
	private static $connection;
	
	public static function getConnection() {
	
		//if I have no connection, build one
		if (empty(self::$connection)) {
			self::$connection = new mysqli('localhost', 'fluxoart_inke', 'inkians','fluxoart_wrkflux2');
		}
		
		return self::$connection;
	}
	
}

?>