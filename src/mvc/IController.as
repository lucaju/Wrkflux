package mvc {
	
	/**
	 * @author lucaju
	 * Specifies the minimum services that the "controller" of
	 * a Model/View/Controller triad must provide.
	 */
	public interface IController {
		
		/**
		 * Adds a model to this controller.
		 */
		function addModel(m:Observable):void;
		
		/**
		 * Remove a model from this controller.
		 */
		function removeModel(m:*):Boolean;
		
		/**
		 * Returns the model for this controller.
		 */
		function getModel(param:*):Observable;
		
		/**
		 * Add a view this controller is servicing.
		 */
		function addView(v:IView):void;
		
		/**
		 * Remove a view this controller is servicing.
		 */
		function removeView(v:*):Boolean;
		
		/**
		 * Returns this controller's view.
		 */
		function getView(param:*):AbstractView;
	}
}