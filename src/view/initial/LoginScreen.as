package view.initial {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import controller.WrkfluxController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	
	import util.Colors;
	
	import view.assets.buttons.Button;
	import view.initial.login.ForgotPasswordForm;
	import view.initial.login.SignInForm;
	import view.initial.login.SignUpForm;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class LoginScreen extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target					:AbstractView;
		
		protected var signInForm				:SignInForm;
		protected var signUpForm				:SignUpForm;
		protected var forgotPasswordForm		:ForgotPasswordForm;
		
		protected var signInBT					:Button;
		protected var signUpBT					:Button;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function LoginScreen(_target:AbstractView) {
			
			target = _target;
			
			//1. Sign In Button
			signInBT = this.getButton();;
			this.addChild(signInBT);
			signInBT.textColor = Colors.getColorByName(Colors.BLUE);
			signInBT.toggleColor = Colors.getColorByName(Colors.BLUE);
			signInBT.init("Sign In");
			
			//2. Sign Up Button
			signUpBT = this.getButton();
			this.addChild(signUpBT);
			signUpBT.textColor = Colors.getColorByName(Colors.GREEN);
			signUpBT.toggleColor = Colors.getColorByName(Colors.GREEN);
			signUpBT.init("Sign Up");
			signUpBT.x = signInBT.width + 5;
			
			this.x = target.stage.stageWidth/2 - this.width/2;
			
			signInBT.addEventListener(MouseEvent.CLICK, optionClick);
			signUpBT.addEventListener(MouseEvent.CLICK, optionClick);
			
		}
		
		//****************** PRIVATE METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param objs
		 * 
		 */
		private function removeObjects(objs:Array):void {
			for each (var obj:Sprite in objs) {
				if (this.contains(obj)) this.removeChild(obj);
			}
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
	
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function getButton():Button {
			
			var bt:Button = new Button();
			
			bt.maxWidth = 200;
			bt.maxHeight = 40;
			
			bt.color = Colors.getColorByName(Colors.LIGHT_GREY);
			bt.colorAlpha = .4;
			bt.line = true;
			bt.lineColor = Colors.getColorByName(Colors.DARK_GREY);
			
			bt.textSize = 18;
			
			return bt;
		}
		
		/**
		 * 
		 * 
		 */
		protected function addSignInForm():void {
			
			if (!signInForm) {
				
				signInForm = new SignInForm(target.getController());
				this.addChild(signInForm);
				
				signInForm.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
				signInForm.windowColor = Colors.getColorByName(Colors.WHITE_ICE);
				
				signInForm.init();
				
				//mask
				var mask:Sprite = this.drawMask(signInForm);
				this.addChild(mask);
				
				//animation
				TweenMax.from(mask,.6,{height:0});
				TweenMax.to(signInBT,.6,{autoAlpha:0});
				TweenMax.to(this,.6,{x:this.stage.stageWidth/2 - signInForm.width/2});
				
				//listeners
				signInForm.addEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
				
				
			}
				
		}
		
		/**
		 * 
		 * 
		 */
		protected function addSignUpForm():void {
			if (!signUpForm) {
				
				signUpForm = new SignUpForm(target.getController());
				this.addChild(signUpForm);
				
				signUpForm.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
				signUpForm.windowColor = Colors.getColorByName(Colors.WHITE_ICE);
				
				signUpForm.init();
				
				//mask
				var mask:Sprite = this.drawMask(signUpForm);
				this.addChild(mask);
				
				//animation
				TweenMax.from(mask,.6,{height:0});
				TweenMax.to(signUpBT,.6,{autoAlpha:0});
				TweenMax.to(this,.6,{x:this.stage.stageWidth/2 - signUpForm.width/2});
				TweenMax.to(signInBT,.6,{x:signUpForm.x - signInBT.width - 5});
				
				//listeners
				signUpForm.addEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
				
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function addForgotPassForm():void {
			
			if (!forgotPasswordForm) {
				
				forgotPasswordForm = new ForgotPasswordForm(target.getController());
				this.addChild(forgotPasswordForm);
				
				forgotPasswordForm.windowLineColor = Colors.getColorByName(Colors.LIGHT_GREY);
				forgotPasswordForm.windowColor = Colors.getColorByName(Colors.WHITE_ICE);
				
				forgotPasswordForm.init();
				
				//mask
				var mask:Sprite = this.drawMask(forgotPasswordForm);
				this.addChild(mask);
				
				//animation
				TweenMax.from(mask,.6,{height:0});
				TweenMax.to(this,.6,{x:this.stage.stageWidth/2 - forgotPasswordForm.width/2});
				TweenMax.to(signInBT,.6,{autoAlpha:1, x:forgotPasswordForm.x - signInBT.width - 5});
				
				//listeners
				forgotPasswordForm.addEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
				
				//remove sign up form
				removeSignInForm();
			}
			
		}
		
		/**
		 * 
		 * @param target
		 * @return 
		 * 
		 */
		protected function drawMask(target:Sprite):Sprite {
			
			var mask:Sprite = new Sprite();
			
			mask.graphics.clear();
			mask.x = target.x;
			mask.y = target.y;
			
			mask.graphics.beginFill(0x000000);
			mask.graphics.drawRect(-1,-1,target.width+2,target.height+2);
			mask.graphics.endFill();
			
			target.mask = mask;
			
			return mask;
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeSignInForm():void {
			if (signInForm) {
				TweenMax.to(signInForm.mask,.6,{height:0, onComplete:removeObjects, onCompleteParams:[[signInForm.mask, signInForm]]});
				TweenMax.to(signInBT,.6,{autoAlpha:1,delay:.3});
				signInForm.kill();
				signInForm = null;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeSignUpForm():void {
			if (signUpForm) {
				TweenMax.to(signUpForm.mask,.6,{height:0, onComplete:removeObjects, onCompleteParams:[[signUpForm.mask, signUpForm]]});
				TweenMax.to(signUpBT,.6,{autoAlpha:1,delay:.3});
				signUpForm.kill();
				signUpForm = null;
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function removeForgotPassForm():void {
			if (forgotPasswordForm) {
				TweenMax.to(forgotPasswordForm.mask,.6,{height:0, onComplete:removeObjects, onCompleteParams:[[forgotPasswordForm.mask, forgotPasswordForm]]});
				forgotPasswordForm.kill();
				forgotPasswordForm = null;
				
				TweenMax.to(signInBT,.3,{autoAlpha:1, x:0});
				TweenMax.to(signUpBT,.3,{x:signInBT.width + 5});
				
				TweenMax.to(this,.6,{x:target.stage.stageWidth/2 - (signUpBT.x + signUpBT.width)/2});
			}
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function optionClick(event:MouseEvent):void {
			
			//remove forms
			if (signInForm) removeSignInForm();
			if (signUpForm) removeSignUpForm();
			if (forgotPasswordForm) removeForgotPassForm();
			
			if (event.target.name == "Sign In") {
				this.addSignInForm();
			} else {
				this.addSignUpForm();
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function formEvent(event:WrkfluxEvent):void {
			switch (event.data.name) {
				case "SignInForm": 
					
					if (event.data.action == "submit") {
						WrkfluxController(target.getController()).register(event.data);
					} else if (event.data.action == "forgotPassword") {
						addForgotPassForm();
					}
					
					break;
				
				case "SignUpForm":
					WrkfluxController(target.getController()).register(event.data);
					break;
				
				case "forgotPassForm":
					WrkfluxController(target.getController()).forgotPass(event.data);
					break;
			}
		}
		
		
		/**
		 * 
		 * 
		 */
		public function resize():void {
			if (signInForm) {
				this.x = this.stage.stageWidth/2 - signInForm.width/2;
			} else if (signUpForm) {
				this.x = this.stage.stageWidth/2 - signUpForm.width/2;
			} else if (forgotPasswordForm) {
				this.x = this.stage.stageWidth/2 - forgotPasswordForm.width/2;
			} else {
				this.x = target.stage.stageWidth/2 - this.width/2;
			}
		}
		
		
		//****************** PUBLIC METHODS METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			signInBT.removeEventListener(MouseEvent.CLICK, optionClick);
			signUpBT.removeEventListener(MouseEvent.CLICK, optionClick);
			
			if (signInForm) {
				signInForm.kill();
				signInForm.removeEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
			}
			if (signUpForm) {
				signUpForm.kill();
				signUpForm.removeEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
			}
			if (forgotPasswordForm) {
				forgotPasswordForm.kill();
				forgotPasswordForm.removeEventListener(WrkfluxEvent.FORM_EVENT, formEvent);
			}
		}
	}
		
}