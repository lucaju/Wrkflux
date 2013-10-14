package view.workflow.flow.pin.big.panels {
	
	//imports
	import model.FlagModel;
	
	import settings.Settings;
	
	import util.DeviceInfo;
	
	/**
	 * PinControlButton Factory.
	 * Fabricates Control Buttons according to the specifications.
	 * OS:
	 * 	- iPhone (iPad Retina Display)
	 *  - Mac OS
	 * 
	 * @author lucaju
	 * 
	 */
	public class SliceFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * PinControlButton Factory.
		 * Fabricates Control Buttons according to the specifications.
		 * OS:
		 * 	- iPhone (iPad Retina Display)
		 *  - Mac OS
		 * 
		 * @author lucaju
		 * 
		 */
		static public function addPinControlButton(flag:Object):Slice {	
			
			var item:Slice;
			item = new Slice(flag);
			item.hasIcon = false;
			
			if (item.hasIcon) {
				var imageFilePath:String = "images/icons/";
				
				//switch style
				switch (Settings.platformTarget) {
					case "air":
						item.icon = imageFilePath + getSDIcon(flag.label);
						break;
					
					case "mobile":
						item.icon = imageFilePath + getHDIcon(flag.labl);
						break;
				}
			}
			
			return item;
		}
		
		
		//****************** STATIC PROTECTED METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * Get SD icon
		 * 
		 * @param flag
		 * @return 
		 * 
		 */
		static protected function getSDIcon(flag:FlagModel):String {
			
			var icon:String;
			var baseFlag:FlagModel = Settings.getFlagByName(flag.title);
			
			//Switch Flag
			switch (flag.title) {
				
				case "Start":
					icon = "start_circle.png";
					break;
				
				case "Working":
					icon = "working_circle.png";
					break;
				
				case "Working Complete":
					icon = "working_circle.png";
					break;
				
				case "Incomplete":
					icon = "incomplete_circle.png";
					break;
				
				case "Complete":
					icon = "complete_circle.png";
					break;
				
				default:
					icon ="";
					break;
			}
			
			baseFlag.icon = icon;
			
			return icon;
		}
		
		/**
		 * 
		 * Get HD icon
		 * 
		 * @param flag
		 * @return 
		 * 
		 */
		static protected function getHDIcon(flag:FlagModel):String {
			
			var icon:String;
			var baseFlag:FlagModel = Settings.getFlagByName(flag.title);
			
			//Switch Flag
			switch (flag.title) {
				
				case "Start":
					icon = "start_circle@2x.png";
					break;
				
				case "Working":
					icon = "working_circle@2x.png";
					break;
				
				case "Working Complete":
					icon = "working_circle@2x.png";
					break;
				
				case "Incomplete":
					icon = "incomplete_circle@2x.png";
					break;
				
				case "Complete":
					icon = "complete_circle@2x.png";
					break;
				
				default:
					icon ="";
					break;
			}
			
			baseFlag.icon = icon;
			
			return icon;
		}
		
	}
}