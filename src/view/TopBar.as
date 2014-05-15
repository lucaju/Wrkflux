package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import font.HelveticaNeue;
	
	import settings.Settings;
	
	import util.Colors;
	
	import view.assets.buttons.AbstractButton;
	import view.assets.graphics.LockIcon;
	import view.assets.logo.Logo;
	import view.assets.menu.Menu;
	import view.assets.menu.MenuDirection;
	import view.assets.menu.MenuOrientation;
	import view.assets.menu.MenuType;
	import view.profile.ProfileTopBar;
	
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
		
		protected var _type						:String;
		
		protected var _titleColor				:uint;
		
		protected var _hMax						:Number = 30;
		
		protected var bg						:Shape;
		protected var line						:Shape;
		
		protected var logo						:Logo;
		protected var style						:TextFormat;
		protected var titleTF					:TextField;
		protected var _label						:String;
		
		protected var menuLeft					:Menu;
		protected var menuRight					:Menu;
		
		protected var profile					:ProfileTopBar;
		protected var profileMenu				:Menu;
		
		protected var visibilityIcon			:LockIcon;
		
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
			
			_type = "initial";
			
			style = new TextFormat();
			style.font = HelveticaNeue.LIGHT;
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
			
			if (type == "build") {
				TweenMax.to(logo,0,{tint:Colors.getColorByName(Colors.WHITE)});
			} else {
				TweenMax.to(logo,0,{tint:Colors.getColorByName(Colors.DARK_GREY)});
			}
			
			
			this.addChild(logo);
			
			//4.Title
			
			style.color = _titleColor;
			
			titleTF = new TextField();
			
			if (type == "build") {
				titleTF.type = TextFieldType.INPUT;
				titleTF.selectable = true;
			} else {
				titleTF.type = TextFieldType.DYNAMIC;
				titleTF.selectable = false;
			}
			
			titleTF.autoSize = TextFieldAutoSize.LEFT;
			titleTF.embedFonts = true;
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.defaultTextFormat = style;
			titleTF.x = logo.x + logo.width/2;
			this.addChild(titleTF);
			
			if (type == "build") titleTF.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
				
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function addProfileMenu():void {
			profileMenu = new Menu();
			profileMenu.orientation = MenuOrientation.VERTICAL;
			profileMenu.direction = MenuDirection.TOP;
			profileMenu.name = "profileMenu";
			profileMenu.type = MenuType.NONE;
			this.addChildAt(profileMenu,0);
			
			profileMenu.abstractBt.toggleColor = Colors.getColorByName(Colors.PURPLE);
			profileMenu.abstractBt.toggleColorAlpha = .5;
			
			profileMenu.add("Edit Profile");
			profileMenu.add("Sign Out");
			
			profileMenu.y = 31;
			profileMenu.x = stage.stageWidth - profileMenu.width;
			
			profileMenu.addEventListener(MouseEvent.ROLL_OUT, profileMenuRollOut);
			profileMenu.addEventListener(MouseEvent.CLICK, profileMenuClick);
			
			TweenMax.from(profileMenu, .7, {x: stage.stageWidth});
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeProfileMenu():void {
			if (profileMenu) TweenMax.to(profileMenu, .5, {x: stage.stageWidth, onComplete:removeChild, onCompleteParams:[profileMenu]});
			profileMenu = null;
		}
		
		/**
		 * 
		 * 
		 */
		protected function changeTitle():void {	
			if (titleTF.text == "") {
				titleTF.text = this.label;
			} else {
				this.label = titleTF.text;
				this.dispatchEvent(new Event(Event.CHANGE)); 
			}
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function focusOut(event:FocusEvent):void {
			event.stopImmediatePropagation();
			changeTitle();
		}
		
		//****************** PUBLIC EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function showProfileMenu(event:MouseEvent):void {
			profileMenu ? removeProfileMenu() : addProfileMenu();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function profileMenuClick(event:MouseEvent):void {
			removeProfileMenu();
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function profileMenuRollOut(event:MouseEvent):void {
			event.stopPropagation();
			removeProfileMenu();
		}		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addProfile():void {
			profile = new ProfileTopBar();
			profile.x = stage.stageWidth - profile.width;
			this.addChild(profile);
			
			profile.addEventListener(MouseEvent.CLICK, showProfileMenu);
		}
		
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
				
				//setting buttons in this menu
				menu.abstractBt.shapeAlpha = 0;
				menu.abstractBt.toggleColor = Colors.getColorByName(Colors.PURPLE);
				
				if (type == "build") {
					menu.abstractBt.toggleAlpha = .8;
					menu.abstractBt.color = Colors.getColorByName(Colors.DARK_GREY);
					menu.abstractBt.textColor = Colors.getColorByName(Colors.WHITE);
					menu.abstractBt.toggleColorAlpha = 1;
				} else {
					menu.abstractBt.toggleAlpha = .4;
					menu.abstractBt.toggleColorAlpha = .5;
				}
				
				//adding buttons to this menu
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
					menu.x = profile ? stage.stageWidth - profile.width : stage.stageWidth;
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
		public function updateProfileImage():void {
			if (profile) profile.update();
		}
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			if (hasBackground) bg.width = stage.stageWidth;
			if (hasBottomLine) line.width = stage.stageWidth;
			if (profile) profile.x = stage.stageWidth - profile.width;
			if (profileMenu) profileMenu.x = stage.stageWidth - profileMenu.width;
			if (menuRight) menuRight.x = profile ? stage.stageWidth - profile.width : stage.stageWidth;
			
			titleTF.x = logo.x + logo.width/2;
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			if (menuRight) menuRight.kill();
			if (menuLeft) menuLeft.kill();
			if (profileMenu) profileMenu.kill();
			if (profile) {
				if (this.contains(profile)) this.removeChild(profile);
				profile = null;
			}
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function showVisibility(value:Boolean):void {
			if (value == true) {
				visibilityIcon = new LockIcon();
				this.addChild(visibilityIcon);
				visibilityIcon.init();
				
				visibilityIcon.x = titleTF.x + titleTF.width + 5;
				visibilityIcon.y = this.height/2 - visibilityIcon.maxHeight/2;
			}
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
		public function get type():String {
			return _type;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set type(value:String):void {
			_type = value;
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
			titleTF.text = _label;
		}

		
	}
}