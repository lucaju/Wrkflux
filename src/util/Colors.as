package util {
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Colors {
		
		//****************** Proprieties ****************** ****************** ****************** 
		
		static public const WHITE:String = "white";
		static public const BLACK:String = "black";
		static public const LIGHT_GREY:String = "light_gray";
		static public const WHITE_ICE:String = "white_ice";
		static public const DARK_GREY:String = "dark_gray";
		static public const GREEN:String = "green";
		static public const BLUE:String = "blue";
		static public const YELLOW:String = "yellow";
		static public const RED:String = "red";
		static public const PURPLE:String = "purple";
		
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static public function getColorByName(value:String):uint {
		
			var color:uint;
			
			switch (value) {
				
				case WHITE:
					color = 0xFFFFFF;
					break;
				
				case BLACK:
					color = 0x000000;
					break;
				
				case LIGHT_GREY:
					color = 0xDADBDA;
					break;
				
				case WHITE_ICE:
					color = 0xF1F1F2;
					break;
				
				case DARK_GREY:
					color = 0x59595B;
					break;
				
				case GREEN:
					color = 0x819352;
					break;
				
				case BLUE:
					color = 0x2F99C9;
					break;
				
				case YELLOW:
					color = 0xC39A27;
					break;
				
				case RED:
					color = 0xD94038;
					break;
				
				case PURPLE:
					color = 0xA69EC5;
					break;
				
				default:
					color = 0;
					break;
			}
			
			return color;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static public function getColorByUint(value:uint):String {
			
			switch (value) {
				
				case 0xFFFFFF:
					return WHITE;
					break;
				
				case 0x000000:
					return BLACK;
					break;
				
				case 0xDADBDA:
					return LIGHT_GREY;
					break;
				
				case 0xF1F1F2:
					return WHITE_ICE;
					break;
				
				case 0xDADBDA:
					return DARK_GREY;
					break;
				
				case 0x819352:
					return GREEN;
					break;
				
				case 0x2F99C9:
					return BLUE;
					break;
				
				case 0xC39A27:
					return YELLOW;
					break;
				
				case 0xD94038:
					return RED;
					break;
				
				case 0xA69EC5:
					return PURPLE;
					break;
				
				default:
					return value.toString();
					break;
			}
		}
		
	}
}