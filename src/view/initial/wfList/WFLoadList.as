package view.initial.wfList {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import controller.WrkfluxController;
	
	import events.WrkfluxEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.forms.MessageField;
	import util.MessageType;
	import view.util.progressBar.ProgressBar;
	import view.util.scroll.Scroll;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WFLoadList extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var lineTop				:Shape;
		protected var lineBottom			:Shape;
		
		protected var listWorkflows			:WFList;
		protected var listMask				:Sprite;
		
		protected var maxWidth				:Number = 350;
		protected var maxHeight				:Number = 150;
		
		protected var scroll				:Scroll;
		
		protected var progressBar			:ProgressBar;
		protected var errorMessage			:MessageField;
		
		//****************** Construtor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function WFLoadList(c:IController) {
			super(c);
			
			//Boundaries
			lineTop = new Shape();
			lineTop.graphics.lineStyle(1,0x6D6E70);
			lineTop.graphics.lineTo(maxWidth,0);
			this.addChild(lineTop);
			
			lineBottom = new Shape();
			lineBottom.graphics.lineStyle(1,0x6D6E70);
			lineBottom.graphics.lineTo(maxWidth,0);
			lineBottom.y = maxHeight;
			this.addChild(lineBottom);

		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			
			//load existed workflows
			
			WrkfluxController(this.getController()).getWorkflows();
			
			if (!progressBar) {
				progressBar = new ProgressBar();
				progressBar.x = this.width/2;
				progressBar.y = this.height/2;
				this.addChild(progressBar);
			}
			
			TweenMax.from(progressBar,1,{alpha:0});
			TweenMax.from(lineTop,1,{x:lineTop.width/2, width:0});
			TweenMax.from(lineBottom,1,{x:lineBottom.width/2, width:0, delay:.2});
			
			//listener
			WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(WrkfluxEvent.COMPLETE, loadCompleted);
			WrkfluxController(this.getController()).getModel("wrkflux").addEventListener(ErrorEvent.ERROR, errorHandle);
		}	
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function testForScroll():void {
			
			if (listWorkflows) {
				
				if (!scroll) {
					
					if (listWorkflows.height > maxHeight) {
						
						listWorkflows.mask = listMask;
						
						//add scroll system
						scroll = new Scroll();
						scroll.x = listWorkflows.width - 6;
						scroll.target = listWorkflows;
						scroll.maskContainer = listMask;
						this.addChild(scroll);
						scroll.init();
					}
					
				} else {
					
					scroll.update();
					
				}
			}
			
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function loadCompleted(event:WrkfluxEvent):void {
			
			//remove progress bar
			if (progressBar) {
				this.removeChild(progressBar);
				progressBar = null;
			}
			
			//create list
			if (!listWorkflows) {
				listWorkflows = new WFList(event.data as Array);
				this.addChild(listWorkflows);
				
				//2. edition Mask
				listMask = new Sprite();
				listMask.graphics.beginFill(0x999999,.2);
				listMask.graphics.drawRect(0, 0, this.width, maxHeight);
				listMask.graphics.endFill();
				
				TweenMax.from(listMask,1,{x:listMask.width/2, width:0});
				
				this.addChild(listMask);
				
				listWorkflows.mask = listMask;
				
				testForScroll();
				
				listWorkflows.addEventListener(Event.SELECT, workflowActivate);
			}
			
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandle(event:ErrorEvent):void {
			
			//remove progress bar
			if (progressBar) {
				this.removeChild(progressBar);
				progressBar = null;
			}
			
			if (!errorMessage) {
				
				errorMessage = new MessageField();
				errorMessage.sendMessage("Error. Please try again.", MessageType.ERROR);
				errorMessage.x = (maxWidth/2) - (errorMessage.width/2);
				errorMessage.y = (maxHeight/2) - (errorMessage.height/2);
				this.addChild(errorMessage);
			
			} else {
				errorMessage.sendMessage("Error. Please try again.", MessageType.ERROR);
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function workflowActivate(event:Event):void {
			event.stopImmediatePropagation();
			WrkfluxController(this.getController()).loadWorkflow(listWorkflows.selectedItem, listWorkflows.selectedItemAction);
		}
		
	}
}