package mvc {
	
	//imports
	import flash.display.Sprite;
	
	import mvc.*;
	
	/**
	 * @author lucaju
	 * Provides basic services for the "view" of
	 * a Model/View/Controller triad.
	 */
	public class AbstractView extends Sprite implements IObserver, IView{
		
		//****************** Properties ****************** ****************** ******************
		
		private var model				:Observable;
		private var controller			:IController;
		private var _numReg				:int;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function AbstractView (c:IController) {
			// Set the model.
			//setModel(m);
			
			// If a controller was supplied, use it. Otherwise let the first
			// call to getController() create the default controller.
			if (c !== null) setController(c);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * Sets the model this view is observing.
		 */
		public function setModel(m:Observable):void {
			model = m;
		}
		
		/**
		 * Returns the model this view is observing.
		 */
		public function getModel():Observable {
			return model;
		}
		
		/**
		 * Sets the controller for this view.
		 */
		public function setController(c:IController):void {
			controller = c;
			// Tell the controller this object is its view.
			getController().addView(this);
		}
		
		/**
		 * Returns this view's controller.
		 */
		public function getController():IController {
			return controller;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function setReg(value:int):void {
			_numReg = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getReg():int {
			return _numReg;
		}
		
		/**
		 * A do-nothing implementation of the Observer interface's
		 * update() method. Subclasses of AbstractView will provide
		 * a concrete implementation for this method.
		 */
		public function update(o:Observable, infoObj:Object):void {
		}
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			//to override
		}

	}
}