package view.workflow.flow.pin.big.knob {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.TouchEvent;
	
	import view.workflow.flow.pin.big.BigPin;
	import view.workflow.flow.pin.big.panels.SlicePanel;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class KnobInputs {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var source			:BigPin;
		protected var target			:Knob;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function KnobInputs(source:BigPin, target:Knob) {
			this.source = source;
			this.target = target;
			
			target.addEventListener(TouchEvent.TOUCH_BEGIN, knobTouchBegin);
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function knobTouchBegin(event:TouchEvent):void {
			target.addEventListener(TouchEvent.TOUCH_END, knobTouchEnd);
			target.addEventListener(Event.CHANGE, knobChange);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function knobChange(event:Event):void {
			
			//Get control and its data
			var pinControlPanel:SlicePanel = pinControlPanel as SlicePanel;
			var startAngle:Number = pinControlPanel.startAngle;
			var numOptions:int = pinControlPanel.getOptionsNum();
			var optionRange:Number = 360/numOptions;
			
			var poinintTo:Number;
			
			switch (target.type) {
				case "inner":
					// rotate knob
					source.source.shape.rotation = target.value;
					
					//highlight
					poinintTo = Math.floor((target.value-startAngle)/optionRange);
					if (poinintTo > numOptions - 1) poinintTo = 0;
					pinControlPanel.highlightOption(poinintTo);
					
					break;
				
				case "outter":
					//rotate control panel based on the touch pivor point.
					pinControlPanel.rotation += target.value - target.getPivotPoint();
					
					//get current rotation
					var rotationValue:Number = pinControlPanel.rotation;
					if (rotationValue < 0) rotationValue = 360 + rotationValue;
					
					//because the logic is counter-clockwise, we have to transform it back to the clockwise reference
					var rotationValueCW:Number = (rotationValue - 360) * -1;
					
					//highlight
					poinintTo = Math.floor((rotationValueCW-startAngle)/optionRange);
					if (poinintTo > numOptions - 1) poinintTo = 0;
					pinControlPanel.highlightOption(poinintTo);
					
					break;
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function knobTouchEnd(event:TouchEvent):void {
			
			//Get control and its data
			var pinControlPanel:SlicePanel = pinControlPanel as SlicePanel;
			
			var startAngle:Number = pinControlPanel.startAngle;
			var numOptions:int = pinControlPanel.getOptionsNum();
			var optionRange:Number = 360/numOptions;
			
			//define values
			var newPosition:Number;
			var rotation:Number;
			var optionUID:int;
			
			switch (target.type) {
				case "inner":
					
					//new position
					newPosition = Math.floor((target.value-startAngle)/optionRange);
					
					//not greater than possible
					if (newPosition > numOptions - 1) newPosition = 0;
					
					//new control position
					rotation = (newPosition/numOptions)*360;
					
					pinControlPanel.highlightOption(-1); // remove highlight
					
					//new
					optionUID = pinControlPanel.getSliceUIDByIndexPosition(newPosition);
					
					//animations - save after
					TweenMax.to(target,.5,{shortRotation:{value:rotation}, ease:Back.easeOut});
					TweenMax.to(source.source.shape,.5,{shortRotation:{rotation:rotation}, ease:Back.easeOut, onComplete:source.saveOption, onCompleteParams:[optionUID]});
					
					break;
				
				case "outter":
					
					//get current rotation
					var rotationValue:Number = pinControlPanel.rotation;
					if (rotationValue < 0) rotationValue = 360 + rotationValue;
					
					//because the logic is counter-clockwise, we have to transform it back to the clockwise reference
					var rotationValueCW:Number = (rotationValue - 360) * -1;
					
					//new position
					newPosition = Math.floor((rotationValueCW-startAngle)/optionRange);
					
					//not greater than possible
					if (newPosition > numOptions - 1) newPosition = 0;
					
					//new control position
					rotation = (newPosition/numOptions)*360;
					
					//rotation CCW
					rotation = (rotation - 360) * -1;
					
					pinControlPanel.highlightOption(-1); // remove highlight
					
					//new
					optionUID = pinControlPanel.getSliceUIDByIndexPosition(newPosition);
					
					//animations - save after
					TweenMax.to(pinControlPanel,.5,{shortRotation:{rotation:rotation}, ease:Back.easeOut, onComplete:source.saveOption, onCompleteParams:[optionUID]});
					
					break;
				
			}
			
			
		}
	}
}