package view.initial.wfList {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.FontFreightSans;
	
	import util.Colors;
	
	import view.assets.buttons.Button;
	import view.assets.buttons.ButtonShapeForm;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	
	public class WFItem extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int;
		
		protected var shape				:Shape;
		protected var authorTF			:TextField;
		protected var dateTF			:TextField;
		
		protected var currentWidth		:Number = 350
		protected var gap				:int	= 5;
		
		protected var settingsBT		:Button;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param title
		 * @param author
		 * @param date
		 * 
		 */
		public function WFItem(id:int, title:String, author:String, date:Date) {
			
			//1. data
			_id = id;
			
			//2. style
			var styleTitle:TextFormat = new TextFormat(FontFreightSans.LIGHT,22);
			var style:TextFormat = new TextFormat(FontFreightSans.MEDIUM,14,Colors.getColorByName(Colors.DARK_GREY));

			
			var titleTF:TextField = new TextField();
			titleTF.selectable = false;
			titleTF.mouseEnabled = false;
			titleTF.autoSize = TextFieldAutoSize.LEFT;
			titleTF.embedFonts = true;
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.text = title;
			titleTF.setTextFormat(styleTitle);
			
			titleTF.x = 10;
			titleTF.y = gap;
			this.addChild(titleTF);
			
			authorTF = new TextField();
			authorTF.selectable = false;
			authorTF.mouseEnabled = false;
			authorTF.embedFonts = true;
			authorTF.autoSize = TextFieldAutoSize.RIGHT;
			authorTF.antiAliasType = AntiAliasType.ADVANCED;
			authorTF.text = author;
			authorTF.setTextFormat(style);
			
			authorTF.x = currentWidth - authorTF.width - 10;
			authorTF.y = gap;
			this.addChild(authorTF);
			
			dateTF = new TextField();
			dateTF.selectable = false;
			dateTF.mouseEnabled = false;
			dateTF.embedFonts = true;
			dateTF.antiAliasType = AntiAliasType.ADVANCED;
			dateTF.autoSize = TextFieldAutoSize.RIGHT;
			dateTF.text =  handleDate(date);
			dateTF.setTextFormat(style);
			
			dateTF.x = currentWidth - dateTF.width - 10;
			dateTF.y = authorTF.y + authorTF.height;
			this.addChild(dateTF);
			
			//3. shape
			shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawRect(0,0,currentWidth,this.height + (gap*2));
			shape.graphics.endFill();
			shape.alpha = 0;
			this.addChildAt(shape,0);
			
			//3. line
			var sepLine:Shape = new Shape();
			sepLine.graphics.lineStyle(1,0x6D6E70,.2);
			sepLine.graphics.lineTo(currentWidth,0);
			sepLine.y = this.height;
			this.addChild(sepLine);
			
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
		protected function handleDate(date:Date):String {
			var months:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			return date.date + " " + months[date.month] + " " + date.fullYear;			
		}
		
		/**
		 * 
		 * 
		 */
		protected function addSettingButton():void {
			
			if (!settingsBT) {
				settingsBT = new Button();
				settingsBT.color = Colors.getColorByName(Colors.DARK_GREY);
				settingsBT.shapeForm = ButtonShapeForm.RECT;
				settingsBT.maxHeight = this.height;
				settingsBT.maxWidth = 30;
				settingsBT.init("edit");
				settingsBT.x = currentWidth - settingsBT.width;
				this.addChild(settingsBT);
				
				TweenMax.to(authorTF, .4, {x:currentWidth - authorTF.width - 40});
				TweenMax.to(dateTF, .6, {x:currentWidth - dateTF.width - 40});
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeSettingButton():void {
			if (settingsBT) {
				this.removeChild(settingsBT);
				settingsBT = null;
				
				TweenMax.to(authorTF, .4, {x:currentWidth - authorTF.width - 10});
				TweenMax.to(dateTF, .6, {x:currentWidth - dateTF.width - 10});
			}
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOver(event:MouseEvent):void {
			TweenMax.to(shape,.4,{alpha:.3});
			this.addSettingButton();
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOut(event:MouseEvent):void {
			TweenMax.to(shape,.6,{alpha:0});
			this.removeSettingButton();
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}


	}
}