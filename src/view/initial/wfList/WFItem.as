package view.initial.wfList {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.HelveticaNeue;
	
	import model.Session;
	
	import util.Colors;
	
	import view.assets.graphics.LockIcon;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	
	public class WFItem extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _newX				:Number;
		protected var _newY				:Number;
		
		protected var _id				:int;
		protected var _authorID			:int;
		
		protected var shape				:Sprite;
		protected var shapeMask			:Sprite;
		
		protected var titleTF			:TextField;
		protected var authorTF			:TextField;
		protected var dateTF			:TextField;
		
		protected var currentWidth		:Number = 240;
		protected var currentHeight		:Number = 55;
		protected var gap				:int	= 5;
		
		protected var visibilityIcon	:LockIcon;
		
		protected var options			:WFItemOptions;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param title
		 * @param author
		 * @param date
		 * 
		 */
		public function WFItem(id:int, authorID:int, title:String, author:String, date:Date, visibility:Boolean) {
			
			//1. data
			_id = id;
			_authorID = authorID;
			
			if (author == null) author = " ";
			
			//2. style
			var styleTitle:TextFormat = new TextFormat();
			styleTitle.font = HelveticaNeue.LIGHT;
			styleTitle.size = 18;
			
			var styleDate:TextFormat = new TextFormat();
			styleDate.font = HelveticaNeue.LIGHT;
			styleDate.size = 11;
			styleDate.color = Colors.getColorByName(Colors.DARK_GREY);
			
			var styleAuthor:TextFormat = new TextFormat();
			styleAuthor.font = HelveticaNeue.LIGHT;
			styleAuthor.size = 12;
			styleAuthor.color = Colors.getColorByName(Colors.DARK_GREY);

			//3. textfields	
			
			//3.1 author
			authorTF = createTextfield();
			authorTF.text = author;
			authorTF.setTextFormat(styleAuthor);
			
			authorTF.x = gap;
			authorTF.y = gap - 2;
			this.addChild(authorTF);
			
			//3.2 title
			titleTF = createTextfield();
			//titleTF.border = true;
			titleTF.width = currentWidth - 2*(gap);
			titleTF.wordWrap = true;
			titleTF.multiline = true;
			titleTF.text = title;
			titleTF.setTextFormat(styleTitle);
			
			titleTF.x = gap;
			
			titleTF.y = authorTF ? authorTF.y + authorTF.height + gap : gap;
			
			this.addChild(titleTF);
			
			//3.3 date
			dateTF = createTextfield();
			dateTF.text =  dateHandler(date);
			dateTF.setTextFormat(styleDate);
			
			dateTF.x = currentWidth - dateTF.width - gap;
			dateTF.y = gap;
			
			
			//3.3.1 date bg
			var dateBG:Sprite = new Sprite();
			dateBG.graphics.beginFill(0xEFEFEF);
			dateBG.graphics.drawRect(0,0,dateTF.width+gap-1,dateTF.height);
			dateBG.graphics.endFill();
			dateBG.x = dateTF.x;
			dateBG.y = dateTF.y;
			this.addChild(dateBG)
			
			this.addChild(dateTF);
			
			//trace (currentHeight, this.height)
			if (currentHeight < this.height - 6) currentHeight = this.height + (2*gap) - 1;
			
			//3. shape
			shape = this.drawBaseShape();
			shape.mouseEnabled = false;
			this.addChildAt(shape,0);
			
			//4. add visibiity info
			if (!visibility) {
				visibilityIcon = new LockIcon();
				this.addChild(visibilityIcon);
				visibilityIcon.maxHeight = visibilityIcon.maxWidth = 8;
				visibilityIcon.init();
				
				visibilityIcon.x = dateBG.x - visibilityIcon.maxWidth - 2;
				visibilityIcon.y = dateBG.y + dateBG.height/2 - visibilityIcon.maxHeight/2;
			}

			
			//5. interaction
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			
		}
		
		
		//****************** PROTECTED METHOD ****************** ****************** ******************
		
		/**
		 * 
		 * @param date
		 * @return 
		 * 
		 */
		protected function dateHandler(date:Date):String {
			var months:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			return date.date + " " + months[date.month] + " " + date.fullYear;			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function drawBaseShape():Sprite {
			
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
			s.graphics.beginFill(Colors.getColorByName(Colors.WHITE));
			s.graphics.drawRoundRect(0,0,currentWidth,currentHeight,4);
			s.graphics.endFill();
			
			return s;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function createTextfield():TextField {
			
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.embedFonts = true;
			tf.autoSize = TextFieldAutoSize.RIGHT;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			
			return tf;
		}
		
		/**
		 * 
		 * 
		 */
		protected function addOptions():void {
			
			if (options) {
				
				TweenMax.killTweensOf(options);
				TweenMax.to(options, .4, {x:shape.width - options.maxWidth});
				
			} else {
				
				var fullOption:Boolean = false;
				if (Session.userID == 0) {
					
					for each (var wfID:int in Session.workflowsCreated) {
						if (wfID == this.id) {
							fullOption = true;
							break;
						}
					}
					
				} else if (Session.userID == this.authorID) {
					fullOption = true;
				} else {
					fullOption = false;
				}
				
				//options
				options = new WFItemOptions();
				this.addChild(options);
				options.init(fullOption);
				options.x = shape.width - options.maxWidth;
				
				//Mask
				shapeMask = this.drawBaseShape();
				this.addChildAt(shapeMask,0);
				
				options.mask = shapeMask;
				
				//animation
				TweenMax.from(options, .4, {x:shape.width});
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeOptions():void {
			
			if (options) TweenMax.to(options, .4, {x:shape.width, onComplete:deleteOption});
			
			function deleteOption():void {
				options.kill();
				options.parent.removeChild(options);
				options.kill();
				options = null;
				shapeMask = null;
			}
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param children
		 * 
		 */
		private function removeChildren(children:Array):void {
			for each (var obj:DisplayObject in children) {
				if (this.contains(obj)) this.removeChild(obj);
			}
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOver(event:MouseEvent):void {
			TweenMax.to(shape,.4,{colorTransform:{tint:Colors.getColorByName(Colors.BLUE), tintAmount:0.1}});
			this.addOptions();
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOut(event:MouseEvent):void {
			TweenMax.to(shape,.6,{removeTint:true});
			this.removeOptions();
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			if (options) options.kill();
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouseOut);
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get newX():Number {
			return _newX;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set newX(value:Number):void {
			_newX = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get newY():Number {
			return _newY;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set newY(value:Number):void {
			_newY = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get authorID():int {
			return _authorID;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return titleTF.text;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get visibility():Boolean {
			if (visibilityIcon) return true;
			return false;
		}


	}
}