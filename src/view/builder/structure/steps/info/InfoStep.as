package view.builder.structure.steps.info {
	
	//impors
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import controller.WrkBuilderController;
	
	import events.WrkfluxEvent;
	
	import model.builder.StepModel;
	
	import mvc.IController;
	
	import util.Colors;
	import util.Directions;
	
	import view.forms.AbstractForm;
	import view.forms.TextFormField;
	import view.forms.assets.WindowShape;
	import view.forms.list.slider.HorizontalSliderFormField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InfoStep extends AbstractForm {
		
		//****************** Properties ****************** ****************** ******************
		
		internal var _stepID				:*;
		
		protected var content				:Sprite;
		protected var titleField			:TextFormField;
		protected var abbreviationField		:TextFormField;
		protected var shapeField			:HorizontalSliderFormField;
		protected var linksField			:Links;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * @param id
		 * 
		 */
		public function InfoStep(c:IController, id:*) {
			super(c);
			this._stepID = id;
			
			this.addEventListener(MouseEvent.CLICK, infoClick);
			
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//data
			var stepData:StepModel = WrkBuilderController(this.getController()).getStepData(stepID);
			var stepConnections:Array = WrkBuilderController(this.getController()).getConnectionsInfoByStep(stepID);
			
			//content
			content = new Sprite();
			this.addChild(content);
			
			// FIELDS
			
			//1. Title
			titleField = new TextFormField();
			titleField.maxChars = 20;
			titleField.maxWidth = 140;
			titleField.required = true;
			content.addChild(titleField);
			titleField.init("title");
			
			titleField.setValue(stepData.title);
			
			titleField.x = gap;
			titleField.y = gap;
			
			fieldCollection.push(titleField);
			
			//2. Abbreviation
			abbreviationField = new TextFormField();
			abbreviationField.maxChars = 5;
			abbreviationField.maxWidth = 45;
			abbreviationField.required = true;
			content.addChild(abbreviationField);
			abbreviationField.init("abbr");
			
			abbreviationField.x = titleField.x + titleField.width + gap;
			abbreviationField.y = gap;
			
			abbreviationField.setValue(stepData.abbreviation);
			
			fieldCollection.push(abbreviationField);
			
			//2.1 division
			var line1:Sprite = new Sprite();
			line1.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
			line1.graphics.lineTo(200,0);
			line1.y = titleField.y + titleField.height + gap;
			content.addChild(line1);
			
			//3. Shape
			var shapeData:Array = new Array({id:0, label:"Rectangle"},
											{id:1, label:"Circle"},
											{id:2, label:"Hexagon"},
											{id:3, label:"Pentagon"});
			
			shapeField = new HorizontalSliderFormField();
			shapeField.maxWidth = 190;
			shapeField.required = true;
			shapeField.data = shapeData;
			content.addChild(shapeField);
			shapeField.init("shape");
			shapeField.x = gap;
			shapeField.y = titleField.y + titleField.height + gap;
			
			fieldCollection.push(shapeField);
			
			//3.1 division
			var line2:Sprite = new Sprite();
			line2.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
			line2.graphics.lineTo(200,0);
			line2.y = shapeField.y + shapeField.height + gap;
			content.addChild(line2);
			
			//4. Links
			linksField = new Links(this,stepConnections);
			linksField.maxWidth = 190;
			content.addChild(linksField);
			linksField.init("links");
			
			linksField.x = gap;
			linksField.y = shapeField.y + shapeField.height + gap;
			
			fieldCollection.push(linksField);
			
			//window
			var windowHeight:Number = content.height + (2 * gap);
			this.windowColor = Colors.getColorByName(Colors.WHITE);
			this.drawWindow(200,windowHeight,WindowShape.BALLOON);
			
			//positions
			window.x = -window.width/2;
			window.y = -window.height - 5;
			
			content.x = window.x;
			content.y = window.y;
			
			//listeners
			
			titleField.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			abbreviationField.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			abbreviationField.addEventListener(Event.CHANGE, textChange);
			shapeField.addEventListener(Event.SELECT, shapeSelected);
			linksField.addEventListener(WrkfluxEvent.SELECT, linksSelected);
		}
		

		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function infoClick(event:MouseEvent):void {
			event.stopPropagation();
		}
		
		/**
		 * 
		 * 
		 */
		protected function changeLabel(target:TextFormField):void {
			
			if (target.getInput() == "") {
				target.setValue(target.currentValue);
			} else {
				target.currentValue = target.getInput();
			}
			
			var data:Object = new Object();
			data.action = "changeLabel";
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT,data));
			
		}
		
		/**
		 * 
		 * @param target
		 * 
		 */
		protected function changeText(target:TextFormField):void {
			this.dispatchEvent(new Event(Event.CHANGE,true));
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function shapeSelected(event:Event):void {
			var data:Object = new Object();
			data.action = "changeShape";
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT,data));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function focusOut(event:FocusEvent):void {
			if (event.currentTarget is TextFormField);
			changeLabel(event.currentTarget as TextFormField);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function textChange(event:Event):void {
			if (event.currentTarget is TextFormField);
			changeText(event.currentTarget as TextFormField);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function linksSelected(event:WrkfluxEvent):void{
			//trace (event.data.action, event.data.uid, event.data.direction);
		}	
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param link
		 * 
		 */
		public function addNewLink(link:*):void {
			var stepConnection:Object = WrkBuilderController(this.getController()).getConnectionInfo(link);
			if ((stepID == stepConnection.source || stepID == stepConnection.sourceTempUID) ||
				(stepID == stepConnection.target || stepID == stepConnection.targetTempUID)) {
				
				linksField.addLink(stepConnection);
			}
		}
		
		public function changeOrientation(value:String):void {
			this.changeArrowOrientation(value);
			
			//positions
			window.y = 5;
			content.y = window.y + (2*gap);
		}
		
		/**
		 * 
		 * 
		 */
		override public function resize():void {
			
			maxHeight = content.height + (4 * gap);
			super.resize();
			
			//positions
			if (orientation == Directions.BOTTOM) {
				window.x = -window.width/2;
				window.y = -window.height - 5;
				
				content.x = window.x;
				content.y = window.y;
			} else if (orientation == Directions.TOP) {
				
				window.y = 5;
				content.y = window.y + (2*gap);
			}
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get stepID():* {
			return _stepID;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set stepID(value:*):void {
			_stepID = value
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return titleField.getInput();
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			titleField.setValue(value);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get abbreviation():String {
			return abbreviationField.getInput();
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set abbreviation(value:String):void {
			abbreviationField.setValue(value);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selectedShape():int {
			return shapeField.getSelectedOption();
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set selectedShape(value:int):void {
			shapeField.setSelectedItem(value);
		}


	}
}