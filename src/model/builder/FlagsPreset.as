package model.builder {
	import model.FlagModel;
	
	import util.Colors;
	
	//imports
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlagsPreset {

		//****************** Properties ****************** ****************** ******************
		
		protected var collection		:Array;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function FlagsPreset() {
			
			collection = new Array();
			collection[0] = new FlagModel(0,Colors.WHITE, Colors.getColorByName(Colors.WHITE),"",0);
			collection[1] = new FlagModel(1,Colors.BLUE, Colors.getColorByName(Colors.BLUE),"",1);
			collection[2] = new FlagModel(3,Colors.RED, Colors.getColorByName(Colors.RED),"",2);
			collection[3] = new FlagModel(4,Colors.GREEN, Colors.getColorByName(Colors.GREEN),"",3);
			collection[4] = new FlagModel(2,Colors.YELLOW, Colors.getColorByName(Colors.YELLOW),"",4);
			collection[5] = new FlagModel(5,Colors.PURPLE, Colors.getColorByName(Colors.PURPLE),"",5);
			
		}
		
		//****************** Public Methods ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlagsPreset(limit:int = 0):Array {
			if (limit == 0) {
				return collection.concat();
			} else {
				return collection.slice(0,limit);	
			}
		}
	}
}