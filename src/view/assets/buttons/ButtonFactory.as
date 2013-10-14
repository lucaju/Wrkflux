package view.assets.buttons {
	
	//imports
	
	/**
	 * Button Factory.
	 * Fabricates Button according to the speciications.
	 * Type:
	 * 	- topBar
	 *  - initial
	 * Set attributes
	 * 	- shape form
	 * 	- color
	 *  - color alpha
	 * 	- line
	 * 	- line thickness
	 * 	- line color
	 *  - line color alpha
	 *  
	 * @author lucaju
	 * 
	 */
	public class ButtonFactory {
		
		//****************** STATIC PROPERTIES ****************** ****************** ****************** 
		
		static public const INITIAL		:String = "initial";
		static public const TOPBAR		:String = "topBar";
		static public const FORM		:String = "form";
		
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 

		/**
		 * 
		 * @param title
		 * @return 
		 * 
		 */
		static public function getButton(color:*,type:String):AbstractButton {
			
			//create new Button Bar
			var item:AbstractButton;
			
			switch (type) {
				case INITIAL:
					item = new Button();
					item.shapeForm = ButtonShapeForm.ROUND_RECT;
					item.color = color;
					item.line = true;
					item.lineThickness = 2;
					item.lineColorAlpha = .5;
					break;
				
				case TOPBAR:
					item = new ButtonTopbar();
					item.shapeForm = ButtonShapeForm.RECT;
					item.color = color;
					item.colorAlpha = .3;
					break;
				
				case FORM:
					item = new Button();
					item.shapeForm = ButtonShapeForm.RECT;
					item.color = color;
					item.colorAlpha = .4;
					item.line = true;
					item.lineThickness = 1;
					item.lineColorAlpha = .5;
					break;
			}
			
			return item;
		}
		
		
		//****************** STATIC PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * Get Icon File for Mac
		 *  
		 * @param titleLower:Strinf
		 * @return String
		 * 
		 */
		static private function getIconSDIcon(titleLower:String):String {
			
			var file:String;
			
			switch(titleLower) {
				
				case "list":
					file = "images/icons/" + titleLower + ".png";
					break;
				
			}
			
			return file;
		}
		
		/**
		 * Get Icon File for iPhone (iPad retina Display)
		 *  
		 * @param titleLower:Strinf
		 * @return String
		 * 
		 */
		static private function getIconHDIcon(titleLower:String):String {
			
			var file:String;
			
			switch(titleLower) {
				
				case "list":
					file = "images/icons/" + titleLower + "@2x.png";
					break;

			}
			
			return file;
		}
	}
}