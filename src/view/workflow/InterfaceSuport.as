package view.workflow {
	
	//imports
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import settings.Settings;
	
	import view.workflow.flow.pin.PinView;
	import view.workflow.structure.StructureView;
	import view.workflow.structure.steps.Step;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InterfaceSuport {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var structureView				:StructureView;
		static public var structureViewOffsetX		:Number;
		static public var structureViewOffsetY		:Number;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function InterfaceSuport() {
			
		}
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 */
		static public function calculateRelativePinPosition(pinView:PinView):void {
			
			//------Pin position and step count box
			var stepBounds:Rectangle;
			
			var stepContainer:Step = structureView.getStep(pinView.currentStep);
			stepBounds = stepContainer.getPositionForPin();
			
			//for retina display
			if (Settings.platformTarget == "mobile") { 
				stepBounds.width = stepBounds.width * 2;
				stepBounds.height = stepBounds.height * 2;
				pinView.scaleX = pinView.scaleY = 2;
			}
			
			var ratioX:Number = Math.random(); // **
			var ratioY:Number = Math.random(); // **
			
			pinView.ratioPos = {w:ratioX, h:ratioY};
			
			//random position inside the step active area.
			var xR:Number = stepBounds.x + pinView.width/2 + (ratioX * (stepBounds.width - pinView.width));
			var yR:Number = stepBounds.y + pinView.height/2 + (ratioY * (stepBounds.height - pinView.height));
			
			//transform from local to global
			var pLocal:Point = new Point(xR,yR);
			var pGlobal:Point = structureView.localToGlobal(pLocal);
			
			pGlobal.x = pGlobal.x - structureViewOffsetX;
			pGlobal.y = pGlobal.y - structureViewOffsetY;
			
			pinView.x = pGlobal.x;
			pinView.y = pGlobal.y;
			
		}
		
		
	}
}