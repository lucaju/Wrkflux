package view.workflow.flow.pin.big.panels {
	
	//imports	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import controller.WrkFlowController;
	
	import font.HelveticaNeue;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Colors;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Window extends AbstractView {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var pinUID					:int;					//pinId;
		
		protected var gap						:uint;					//Margins
		protected var _maxWidth					:int;					//Max Width
		protected var _maxHeight				:int;					//Max Height
		protected var hMargin					:int;
		
		protected var panelContainer			:Sprite;				
		protected var panelCollection			:Array;					//collection
		protected var panelMask					:Sprite;
		
		protected var shape						:Shape;					//shape
		protected var titleTF					:TextField;
		
		protected var pagination				:Pagination;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function Window(c:IController) {
			
			super(c);
			
			//initial
			maxWidth = 300;
			maxHeight = 180;
			hMargin = 40;
			gap = 10;
			
			//panel Shape
			
			
			/*
			if (Settings.platformTarget == "mobile") {
				var swipe:SwipeGesture = new SwipeGesture(this);
				swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, swipeEvent);
			}
			*/
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function init(id:int = 0):void {
			
			pinUID = id;
			
			
			//shape
			shape = new Shape();
			shape.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY),1,true);
			shape.graphics.beginFill(Colors.getColorByName(Colors.WHITE),1);
			shape.graphics.drawRoundRect(0,0,maxWidth,maxHeight,gap);
			shape.graphics.endFill();
			this.addChild(shape);
			
			//title
			var titleStyle:TextFormat = new TextFormat();
			titleStyle.font = HelveticaNeue.CONDENSED_BOLD;
			titleStyle.size = 16;
			titleStyle.letterSpacing = .2;
			titleStyle.leading = 1.5;
			titleStyle.color = Colors.getColorByName(Colors.DARK_GREY);
			titleStyle.align = TextFormatAlign.CENTER;
			
			var title:String = WrkFlowController(this.getController()).getDocTitle(pinUID);
			
			titleTF = new TextField();
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.embedFonts = true;
			titleTF.autoSize = TextFieldAutoSize.CENTER;
			titleTF.selectable = false;
			titleTF.width = maxWidth - 10;
			titleTF.wordWrap = true;
			titleTF.multiline = true;
			titleTF.defaultTextFormat = titleStyle;
			titleTF.text = title;
			
			titleTF.x = gap;
			titleTF.y = gap/2;
			
			titleTF.width = maxWidth - (2*gap);
		
			this.addChild(titleTF);
			
			//title bg
			var titleBG:Sprite = new Sprite();
			titleBG.graphics.beginFill(Colors.getColorByName(Colors.LIGHT_GREY),.5);
			titleBG.graphics.drawRoundRectComplex(0,0,maxWidth,titleTF.height + (gap/2),gap/2,gap/2,0,0);
			titleBG.graphics.endFill();
			this.addChildAt(titleBG,1);
				
			//container
			panelContainer = new Sprite();
			panelContainer.y = titleBG.height;
			this.addChild(panelContainer);
			
			panelMask = new Sprite();
			panelMask.y = panelContainer.y;
			panelMask.graphics.beginFill(0xFFFFFF,0);
			panelMask.graphics.drawRoundRect(0,0,shape.width,shape.height - panelContainer.y ,gap);
			panelMask.graphics.endFill();
			//this.addChild(panelMask);
			
			//panelContainer.mask = panelMask;
			
			panelCollection = new Array();
			
			//paginator
			/*pagination = new Pagination();
			pagination.x = shape.width/2;
			pagination.y = shape.height - 5;;
			this.addChild(pagination);
			pagination.addPage("info");
			pagination.addPage("history");*/
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param source
		 * 
		 */
		public function addPanel(panel:AbstractPanel):void {
			panel.x = hMargin;
			panel.y = (panelCollection.length > 0) ? panelContainer.y + panelContainer.height : 0;
			
			panel.maxWidth = this.maxWidth - hMargin - gap;
			panel.maxHeight = this.maxHeight - panelContainer.y;
			panelContainer.addChild(panel);
			panelCollection.push(panel);
			panel.init(pinUID);
		}
		
		/**
		 * 
		 * 
		 */
		public function killPanels():void {
			for each (var panel:AbstractPanel in panelCollection) {
				panel.removeEvents();
			}
		}
		
		//****************** EVENTS ****************** ******************  ****************** 
		/*
		private function swipeEvent(event:GestureEvent):void {
			
			var swipeGesture:SwipeGesture = event.target as SwipeGesture;
			var direction:Number;
			
			if (swipeGesture.offsetX > 0) {
				direction = 1;
			} else {
				direction = -1;
			}
			
			switch (direction) {
				
				case -1:
					if (pagination.currentPage < pagination.totalPages-1) {
						pagination.changeCurrentpage(pagination.currentPage - direction);
					}
					break;
				
				
				case 1:
					if (pagination.currentPage > 0) {
						pagination.changeCurrentpage(pagination.currentPage - direction);
					}
					break;
				
				
			}
			
			
			TweenMax.to(panelContainer,1,{x:hMax * -pagination.currentPage});
		}

		*/
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get panelShapeHeight():int {
			return shape.height;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():int {
			return _maxWidth;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxWidth(value:int):void {
			_maxWidth = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxHeight():int {
			return _maxHeight;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxHeight(value:int):void {
			_maxHeight = value;
		}
	}
}