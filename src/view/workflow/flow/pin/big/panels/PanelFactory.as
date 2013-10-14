package view.workflow.flow.pin.big.panels {
	
	//imports
	import mvc.IController;
	
	
	/**
	 * Panel Factory.
	 * Fabricates Panels according to the specifications.
	 * Type:
	 * 	- History
	 *  - Info
	 *  
	 * @author lucaju
	 * 
	 */
	public class PanelFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * Add Button Bar
		 * Return a built panel according to the specifications.
		 * Type:
		 * 	- History
		 *  - Info
		 * 
		 * @param title:String
		 * @param location:String
		 * @return ButtonBar
		 * 
		 */
		static public function addPanel(c:IController, type:String):AbstractPanel {	
			
			var item:AbstractPanel;
			
			switch (type) {
				
				case "info":
					item = new InfoPanel(c);
					break;
				
				case "history":
					item = new HistoryLogPanel(c);
					break;
			}
			
			return item;
		}
		
	}
}