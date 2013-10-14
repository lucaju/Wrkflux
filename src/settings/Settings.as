package settings {
	import model.FlagModel;
	
	import util.DeviceInfo;
	
	/**
	 * Settings.
	 * This class holds configuration settings of this app.
	 * 
	 * @author lucaju
	 * 
	 */
	public class Settings {
		
		//****************** Properties ****************** ****************** ******************
		
		//general
		private static var _platformTarget				:String;			//["air","mobile","web"]
		private static var _debug						:Boolean;			//Debug
		
		//flags
		private static var _maxFlags					:int				//Color Options
		private static var _statusFlags					:Array				//Color Options
		
		//pins
		private static var _pinTrail					:Boolean			//Turn on and Off pin trail
		
		//groups
		private static var _contractableGroups			:Boolean			//Whether groups can or cannot contracts
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//--------default values
			
			//-- General
			_platformTarget = "air";
			_debug = false;
			
			//-- Pins
			_pinTrail = true;
			
			//--flags
			_maxFlags = 6;
			
			//--groups
			_contractableGroups = false;
			
		}
		
		//****************** GETTERS & SETTERS - GENERAL ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get platformTarget():String {
			return _platformTarget;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get debug():Boolean {
			return _debug;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set platformTarget(value:String):void {
			_platformTarget = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set debug(value:Boolean):void {
			_debug = value;
		}

		
		//****************** GETTERS & SETTERS - PIN ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get pinTrail():Boolean {
			return _pinTrail;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set pinTrail(value:Boolean):void {
			_pinTrail = value;
		}
		
		
		//****************** GETTERS & SETTERS - FLAG ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get maxFlags():int {
			return _maxFlags;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set maxFlags(value:int):void {
			_maxFlags = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get statusFlags():Array {
			return _statusFlags.concat();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public static function getFlagByName(value:String):FlagModel {
			
			for each (var sf:FlagModel in statusFlags) {
				if (sf.title.toLowerCase() == value.toLowerCase()) {
					return sf;
				}
			}
			
			return null;
		}
		
		
		//****************** GETTERS & SETTERS - STRUCTURE ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get contractableGroups():Boolean {
			return _contractableGroups;
		}

		
	}
}