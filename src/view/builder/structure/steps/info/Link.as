package view.builder.structure.steps.info {
	
	//imports
	import flash.events.MouseEvent;
	
	import util.Colors;
	
	import view.assets.Arrow;
	import view.assets.buttons.RemoveRedButton;
	import view.forms.checkbox.CheckboxItem;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Link extends CheckboxItem {
		
		//****************** Properties ****************** ****************** ******************\
		
		protected var icon				:*;
		protected var _direction		:String;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param label
		 * 
		 */
		public function Link(id:*, label:String, direction = "right") {
			super(id, true, label);
			this._direction = direction;
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function init():void {
			
			super.init();
			
			//.Icon
			icon = new Arrow(labelTF.height/3,labelTF.height/2);
			icon.direction = direction;
			icon.draw();
			icon.x = icon.width;
			icon.y = labelTF.height/2;
			this.addChild(icon);
			
			//label x
			labelTF.x = icon.x + icon.width;
			
			//background
			this.addBackground(Colors.getColorByName(Colors.LIGHT_GREY));
			bg.alpha = .3;
			
			//listeners
			labelTF.mouseEnabled = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			bg.addEventListener(MouseEvent.CLICK, click);
			icon.addEventListener(MouseEvent.CLICK, iconClick);
		}
				
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		protected function showRemoveButton(value:Boolean):void {
			
			this.removeChild(icon);
			
			if (value) {
			
				icon = new RemoveRedButton();
				icon.scaleX = .9;
				icon.scaleY = .9;
				icon.x = icon.width/4;
				icon.y = (labelTF.height/2) - (icon.height/2);
				
			} else {
				
				icon = new Arrow(labelTF.height/3,labelTF.height/2);
				icon.direction = direction;
				icon.draw();
				icon.x = icon.width;
				icon.y = labelTF.height/2;
				
			}
			
			this.addChild(icon);
			icon.addEventListener(MouseEvent.CLICK, iconClick);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOver(event:MouseEvent):void {
			bg.alpha = .7;
			showRemoveButton(true);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOut(event:MouseEvent):void {
			bg.alpha = .3;
			showRemoveButton(false);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function click(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function iconClick(event:MouseEvent):void {
			event.stopImmediatePropagation();
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get direction():String {
			return _direction;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set direction(value:String):void {
			_direction = value;
		}

		
	}
}