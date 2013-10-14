package view.builder.structure.network {
	
	//imports
	import flash.display.Sprite;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Connection extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _tempID			:String;
		
		protected var _sourceTempID		:String;
		protected var _targetTempID		:String;
		
		protected var _uid				:int;
		
		protected var _sourceID			:int;
		protected var _targetID			:int;
		
		protected var line				:Sprite;
		protected var arrows			:Arrows;
		
		protected var _complementUID		:*;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @param sourceID
		 * 
		 */
		public function Connection(uid:int, sourceID:int, targetID:int = 0) {
			
			this._uid = uid;
			this._sourceID = sourceID;
			this._targetID = targetID;
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param x
		 * @param y
		 * 
		 */
		public function draw(x:Number, y:Number):void {
			if (!line) {
				line = new Sprite();
				this.addChild(line);
			}
			
			var dX:Number = x - this.x;
			var dY:Number = y - this.y;
			
			line.graphics.clear();
			line.graphics.lineStyle(6,Colors.getColorByName(Colors.DARK_GREY));
			line.graphics.lineTo(dX,dY);
			
			//angle
			var rad:Number = (Math.atan2(dY,dX))
			var angleInDegrees:Number = rad * 180/Math.PI;

			//arrow			
			if (!arrows) {
				arrows = new Arrows();
				this.addChild(arrows);
			}
			
			arrows.x = dX/2;
			arrows.y = dY/2;
			arrows.rotation = angleInDegrees;
			
		}
		
		/**
		 * 
		 * 
		 */
		public function addComplement(value:*):void {
			_complementUID = value;
			arrows.addComplement();
		}
		
		/**
		 * 
		 * 
		 */
		public function removeComplement():void {
			_complementUID = null;
			arrows.removeComplement();
		}
		
		/**
		 * 
		 * 
		 */
		public function removePrincipal():void {
			
			//invert UID
			if (complementUID is int) {
				this.uid = complementUID;
				this.tempID = "";
			} else {
				this.tempID = complementUID;
				this.uid = 0;
			}
			
			//invert SOURCE AND TARGET
			
			var principalSourceID:int = this.sourceID;
			var principalTempSourceID:String = this.sourceTempID;
			
			this.sourceID = this.targetID;
			this.sourceTempID = this.targetTempID;
			
			this.targetID = principalSourceID;
			this.targetTempID = principalTempSourceID;
			
			_complementUID = null;
			arrows.removeComplement();
			
			//invert arrow
			///trace (this.x, this.y, line.width, line.height, line.getBounds(this))
			//this.x = line.height;
			//this.y = line.width;
			//this.draw(-line.width, -line.height);
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
		public function get sourceTempID():String {
			return _sourceTempID;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set sourceTempID(value:String):void {
			_sourceTempID = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get targetTempID():String {
			return _targetTempID;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set targetTempID(value:String):void {
			_targetTempID = value;
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
		public function get sourceID():int {
			return _sourceID;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set sourceID(value:int):void {
			_sourceID = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get targetID():int {
			return _targetID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set targetID(value:int):void {
			_targetID = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get complementUID():* {
			return _complementUID;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasComplement():Boolean {	
			return (complementUID) ? true : false;
		}
		

	}
}