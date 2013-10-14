package model.builder {
	
	//imports
	import flash.geom.Point;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StepModel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _tempID				:String;
		protected var _uid					:int;
		protected var _title				:String;
		protected var _abbreviation			:String;
		protected var _shape				:int;
		protected var _position				:Point;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @param title
		 * @param abbreviation
		 * @param shape
		 * @param position
		 * 
		 */
		public function StepModel(uid:int, title:String, abbreviation:String, shape:int, position:*) {

			//save properties
			this._uid = uid;
			this._title = title;
			this._abbreviation = abbreviation;
			this._shape = shape;
			
			if (position is String) {
				var potionArray:Array = position.split(",");
				this._position = new Point(potionArray[0],potionArray[1]);
			} else if (position is Point) {
				this._position = position;
			} else if (position is Object) {
				this._position = new Point(position.x,position.y)
			}
			
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
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
		public function get abbreviation():String {
			return _abbreviation;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set abbreviation(value:String):void {
			_abbreviation = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shape():int {
			return _shape;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shape(value:int):void {
			_shape = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get position():Point {
			return _position;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set position(value:Point):void {
			_position = value;
		}
		
		
	}
}