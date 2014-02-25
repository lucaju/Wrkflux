package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import font.HelveticaNeue;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.logo.Logo;
	import view.assets.menu.Menu;
	import view.assets.menu.MenuDirection;
	import view.assets.menu.MenuOrientation;
	import view.assets.menu.MenuType;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TopBar extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _hasBackground			:Boolean;
		protected var _backgroundColor			:uint;
		protected var _backgroundColorAlpha		:Number;
		
		protected var _hasBottomLine			:Boolean;
		protected var _bottomLineColor			:uint;
		protected var _bottomLineColorAlpha		:Number;
		protected var _bottomLineThickness		:int;
		
		protected var _titleColor				:uint;
		
		protected var _hMax						:Number = 30;
		
		protected var bg						:Shape;
		protected var line						:Shape;
		
		protected var logo						:Logo;
		protected var style						:TextFormat;
		protected var titleTF					:TextField;
		
		protected var menuLeft					:Menu;
		protected var menuRight					:Menu;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function TopBar() {
			
			_hasBackground = true;
			_backgroundColor = 0x111111;
			_backgroundColorAlpha = .7;
			
			_hasBottomLine = true;
			_bottomLineColor = Colors.getColorByName(Colors.DARK_GREY);
			_bottomLineColorAlpha = .5;
			_bottomLineThickness = 1;
			
			_titleColor = 0xFFFFFF;
			
			style = new TextFormat();
			style.font = HelveticaNeue.THIN;
			style.size = 22;
			
			if (Settings.platformTarget == "mobile") {
				hMax = 60;
				style.size = 50;
			}
			
		}
		
		
		//****************** Intialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//1.background
			if (hasBackground) {
				bg = new Shape();
				bg.graphics.beginFill(this.backgroundColor,this.backgroundColorAlpha);
				bg.graphics.drawRect(0,0,stage.stageWidth,hMax);
				bg.graphics.endFill();
				
				this.addChild(bg);
			}
			
			//2.line
			if (hasBottomLine) {
				line = new Shape();
				line.graphics.lineStyle(this.bottomLineThickness,this.bottomLineColor,this.bottomLineColorAlpha);
				line.graphics.lineTo(stage.stageWidth,0);
				line.y = hMax;
				
				this.addChild(line);
			}
			
			//3. logo
			logo = new Logo();
			logo.scaleX = logo.scaleY = .2;
			logo.x = logo.width/2;
			logo.y = this.hMax - logo.height/2;
			TweenMax.to(logo,0,{tint:Colors.getColorByName(Colors.DARK_GREY)});
			this.addChild(logo);
			
			//4.Title
			
			style.color = _titleColor;
			
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.autoSize = TextFieldAutoSize.LEFT;
			titleTF.embedFonts = true;
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.defaultTextFormat = style;
			titleTF.x = logo.x + logo.width/2;
			this.addChild(titleTF);
			
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
			
			if (!menu) {
				
				menu = new Menu();
				menu.orientation = orientation;
				menu.direction = direction;
				menu.name = direction;
				menu.type = MenuType.NONE;
				this.addChild(menu);
				
				menu.abstractBt.toggleColor = Colors.getColorByName(Colors.PURPLE);
				menu.abstractBt.toggleColorAlpha = .5;
				
				for each (var option:Object in options) {
					var bt:AbstractButton = menu.add(option.label);
					if (option.togglable) {
						bt.togglable = option.togglable; 			//togglable
						if (option.toggle) bt.toggle = true;
					}
				}
				
				if (direction == MenuDirection.LEFT) {
					menu.x = 5;	
				} else if (direction == MenuDirection.RIGHT) {	
					menu.x = stage.stageWidth;
				}
				
				menu.y = (hMax/2) - (menu.height/2);
				
				//save
				switch (direction) {
					
					case MenuDirection.LEFT:
						menuLeft = menu;
						break;
					
					case MenuDirection.RIGHT:
						menuRight = menu;
						break;
					
				}
				
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
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			if (hasBackground) bg.width = stage.stageWidth;
			if (hasBottomLine) line.width = stage.stageWidth;
			if (menuRight) menuRight.x = stage.stageWidth;
			titleTF.x = logo.x + logo.width/2;
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			if (menuRight) menuRight.kill();
			if (menuLeft) menuLeft.kill();
		}
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasBackground():Boolean {
			return _hasBackground;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hasBackground(value:Boolean):void {
			_hasBackground = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get backgroundColorAlpha():Number {
			return _backgroundColorAlpha;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set backgroundColorAlpha(value:Number):void {
			_backgroundColorAlpha = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasBottomLine():Boolean {
			return _hasBottomLine;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hasBottomLine(value:Boolean):void {
			_hasBottomLine = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bottomLineColor():uint {
			return _bottomLineColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set bottomLineColor(value:uint):void {
			_bottomLineColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bottomLineColorAlpha():Number {
			return _bottomLineColorAlpha;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set bottomLineColorAlpha(value:Number):void {
			_bottomLineColorAlpha = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bottomLineThickness():int {
			return _bottomLineThickness;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set bottomLineThickness(value:int):void {
			_bottomLineThickness = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get titleColor():uint {
			return _titleColor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set titleColor(value:uint):void {
			_titleColor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hMax():Number {
			return _hMax;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hMax(value:Number):void {
			_hMax = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			titleTF.text = value;
		}
		
	}
}