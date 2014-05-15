package view.initial.wfList {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import util.Colors;
	
	import view.assets.buttons.Button;
	import view.assets.buttons.ButtonShapeForm;
	
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class WFItemOptions extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _maxWidth			:Number;
		
		protected var container			:Sprite;
		protected var mask				:Sprite;
		
		protected var useBT				:Button
		protected var editBT			:Button
		protected var deleteBT			:Button
		
		protected var deleteYesBT		:Button;
		protected var deleteNoBT		:Button;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function WFItemOptions() {
			
		}
		
		
		//****************** INITIALIZATION ****************** ****************** ******************
		
		/**
		 * 
		 * @param userID
		 * 
		 */
		public function init(userAuthor:Boolean = false):void {
			
			//container
			container = new Sprite();
			container.y = 1;
			this.addChild(container);
			
			container.graphics.lineStyle(1,Colors.getColorByName(Colors.LIGHT_GREY));
			container.graphics.lineTo(0,50);
			
			//use BT
			useBT = createBT();
			useBT.color = Colors.getColorByName(Colors.BLUE);
			useBT.toggleColor = Colors.getColorByName(Colors.WHITE_ICE);
			container.addChild(useBT);
			useBT.x = 1;
			
			
			useBT.init("Use");
			
			
			if (!userAuthor) {
				
				useBT.init("View");
				
			} else {
				
				useBT.init("Use");
				
				
				//Edit BT
				editBT = createBT();
				editBT.color = Colors.getColorByName(Colors.YELLOW);
				editBT.toggleColor = Colors.getColorByName(Colors.WHITE_ICE);
				container.addChild(editBT);
				editBT.init("Edit");
				editBT.x = container.width;
				
				//Delete BT
				deleteBT = createBT();
				deleteBT.color = Colors.getColorByName(Colors.RED);
				deleteBT.toggleColor = Colors.getColorByName(Colors.WHITE_ICE);
				container.addChild(deleteBT);
				deleteBT.init("Delete");
				
				deleteBT.x = container.width;
				
				//mask
				mask = new Sprite();
				mask.graphics.beginFill(0x000000,1);
				mask.graphics.drawRect(0,0,container.width,container.height);
				mask.graphics.endFill();
				this.addChild(mask);
				
				container.mask = mask;
				
				//listener
				deleteBT.addEventListener(MouseEvent.CLICK, deleteClick);
			}
			
			_maxWidth = container.width;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function createBT():Button {
			
			var BT:Button = new Button();
			
			BT.shapeForm = ButtonShapeForm.RECT;
			BT.maxWidth = 40;
			BT.maxHeight = 55;
			BT.colorAlpha = 1;
			
			BT.textSize = 12;
			BT.textColor = Colors.getColorByName(Colors.WHITE);
			
			return BT;
		}
		
		/**
		 * 
		 * 
		 */
		protected function addDeleteOptions():void {
			
			//Yes BT
			deleteYesBT = createBT();
			deleteYesBT.color = Colors.getColorByName(Colors.GREEN);
			deleteYesBT.toggleColor = Colors.getColorByName(Colors.WHITE_ICE);
			deleteYesBT.init("Yes");
			deleteYesBT.x = container.width;
			deleteYesBT.name = "delete";
			container.addChild(deleteYesBT);
			
			
			//No BT
			deleteNoBT = createBT();
			deleteNoBT.color = Colors.getColorByName(Colors.YELLOW);
			deleteNoBT.toggleColor = Colors.getColorByName(Colors.WHITE_ICE);
			deleteNoBT.init("No");
			deleteNoBT.x = container.width;
			
			container.addChild(deleteNoBT);
			
			//listener
			deleteNoBT.addEventListener(MouseEvent.CLICK, deleteClick);
			
			//animation
			TweenMax.to(container,.6,{x:-deleteBT.x});
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeDeleteOptions():void {
			deleteNoBT.removeEventListener(MouseEvent.CLICK, deleteClick);
			TweenMax.to(container,.6,{x:0, onComplete:removeDeleteBTs});
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeDeleteBTs():void {
			container.removeChild(deleteYesBT);
			container.removeChild(deleteNoBT);
			deleteYesBT.kill();
			deleteNoBT.kill()
			deleteYesBT = null;
			deleteNoBT = null;
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function deleteClick(event:MouseEvent):void {
			event.stopImmediatePropagation();
			
			switch (event.target.name) {
				
				case "Delete":
					this.addDeleteOptions();
					break;
				
				case "No":
					this.removeDeleteOptions();
					break;
				
			}
			
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			useBT.kill();
			if (editBT) {
				editBT.kill();
				if (deleteBT.hasEventListener(MouseEvent.CLICK)) deleteBT.removeEventListener(MouseEvent.CLICK, deleteClick);
				deleteBT.kill();
			}
			
			if (deleteYesBT) {
				deleteNoBT.addEventListener(MouseEvent.CLICK, deleteClick);
				
				deleteNoBT.kill();
				deleteYesBT.kill();
			}
			
		}
		
		
		//****************** GETTERS AND SETTERS  ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():Number {
			return _maxWidth;
		}

	}
}