package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlagModel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _tempID		:String;
		protected var _uid			:int;
		protected var _order		:int;
		protected var _title		:String;
		protected var _color		:uint;
		protected var _icon			:String;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param name
		 * @param color
		 * @param icon
		 * 
		 */
		public function FlagModel(uid:int, title:String, color:uint, icon:String = "", order:int = 0) {
			this.uid = uid;
			this.title = title;
			this.color = color;
			this.icon = icon;
			this.order = order;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get uid():int {
			return _uid;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set uid(value:int):void {
			_uid = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get order():int {
			return _order;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set order(value:int):void {
			_order = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return _title;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			_title = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get color():uint {
			return _color;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void {
			_color = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get icon():String {
			return _icon;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set icon(value:String):void {
			_icon = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tempID():String {
			return _tempID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tempID(value:String):void {
			_tempID = value;
		}

		
	}
}