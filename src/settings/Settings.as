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
		private static var _webPath						:String;			//url path
		private static var _platformTarget				:String;			//["air","mobile","web"]
		private static var _debug						:Boolean;			//Debug
		
		//flags
		private static var _maxFlags					:int				//Color Options
		private static var _statusFlags					:Array				//Color Options
		
		//pins
		private static var _pinTrail					:Boolean;			//Turn on and Off pin trail
		
		//pin list
		private static var _pinListVisibility			:Boolean;
		
		//tags
		private static var _tagsVisibility				:Boolean;
		
		//groups
		private static var _contractableGroups			:Boolean;			//Whether groups can or cannot contracts
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//--------default values
			
			//-- General
			_webPath = "http://labs.fluxo.art.br/wrkflux/";
			_platformTarget = "air";
			_debug = false;
			
			//-- Pins
			_pinTrail = true;
			
			//--flags
			_maxFlags = 6;
			
			//pin list
			_pinListVisibility = false;
			
			//tags
			_tagsVisibility	= false;
			
			//--groups
			_contractableGroups = false;
			
		}
		
		//****************** GETTERS & SETTERS - GENERAL ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get webPath():String {
			return _webPath;
		}
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
		
		
		//****************** GETTERS & SETTERS - PIN LIST ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get pinListVisibility():Boolean {
			return _pinListVisibility;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set pinListVisibility(value:Boolean):void {
			_pinListVisibility = value;
		}
		
		
		//****************** GETTERS & SETTERS - TAGS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get tagsVisibility():Boolean {
			return _tagsVisibility;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set tagsVisibility(value:Boolean):void {
			_tagsVisibility = value;
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