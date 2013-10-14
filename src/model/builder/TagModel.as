package model.builder {
	
	//imports
	import flash.geom.Point;
	
	public class TagModel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _tempUID			:String;
		protected var _uid				:int;
		protected var _label			:String;
		protected var _position			:Point
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @param label
		 * @param position
		 * 
		 */
		public function TagModel(uid:int, label:String, position:*) {
			this.uid = uid;
			this.label = label;
			
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
		public function get tempUID():String {
			return _tempUID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tempUID(value:String):void {
			_tempUID = value;
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
		public function get label():String {
			return _label;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			_label = value;
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