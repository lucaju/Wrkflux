package view {
	
	//imports
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.FontFolio;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.assets.menu.Menu;
	import view.assets.menu.MenuDirection;
	import view.assets.menu.MenuOrientation;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TopBar extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var titleTF					:TextField;
		protected var style						:TextFormat;
		protected var fontFolio					:Font;
		
		protected var hMax						:Number = 30;
		protected var bg						:Shape;
		
		protected var menuLeft					:Menu;
		protected var menuRight					:Menu;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function TopBar() {
			
			style = new TextFormat();
			style.font = FontFolio.BOLD_CONDENSED;
			style.color = 0XFFFFFF;
			style.size = 20;
			
			if (Settings.platformTarget == "mobile") {
				hMax = 60;
				style.size = 40;
			}
			
		}
		
		
		//****************** Intialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//1.background
			
			bg = new Shape();
			bg.graphics.beginFill(0x111111,.7);
			bg.graphics.drawRect(0,0,stage.stageWidth,hMax);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//2.Title
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.autoSize = TextFieldAutoSize.CENTER;
			titleTF.embedFonts = true;
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.defaultTextFormat = style;
			titleTF.y = (hMax/2) - (titleTF.height/2);
			
			this.addChild(titleTF);
			
			
			//3.menu left
			/*
			var optionsMenuLeft:Array = [
				{title:"list"}
			];
			*/
			
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		private function killChild(value:DisplayObject):void {
			this.removeChild(value);	
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param options
		 * @param direction
		 * @param orientation
		 * @return 
		 * 
		 */
		public function addMenu(options:Array, direction:String = MenuDirection.LEFT, orientation:String = MenuOrientation.HORIZONTAL):Boolean {
			
			var menu:Menu;
			
			switch (direction) {
				
				case MenuDirection.LEFT:
					menu = menuLeft;
					break;
				
				case MenuDirection.RIGHT:
					menu = menuRight;
					break;
				
			}
			
			if (!menu) {
				
				menu = new Menu();
				menu.orientation = orientation;
				menu.direction = direction;
				menu.name = direction;
				this.addChild(menu);
				
				
				for each (var option:Object in options) {
					menu.add(option.label, Colors.WHITE);
				}
				
				if (direction == MenuDirection.LEFT) {
					menu.x = 5;	
				} else if (direction == MenuDirection.RIGHT) {	
					menu.x = this.width - menu.width - 5;
				}
				
				menu.y = (hMax/2) - (menu.height/2);
				
				return true;
				
			} else {
				return false;
			}
			
		}
		
		/**
		 * 
		 * @param name
		 * 
		 */
		public function getMenu(name:String):Menu {
			
			switch (name) {
				
				case MenuDirection.LEFT:
					return menuLeft;
					break;
				
				case MenuDirection.RIGHT:
					return menuRight;
					break;
				
			}
			
			return null
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			titleTF.text = value;
			titleTF.x = (this.width/2) - (titleTF.width/2);
			titleTF.y = (hMax/2) - (titleTF.height/2);
		}

	}
}