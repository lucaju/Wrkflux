package font {
	
	//imports
	import flash.text.Font;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FontFolio {
		
		//****************** Properties ****************** ****************** ******************
		
		[Embed(source="FOLIOBC.ttf",
				fontName="folioBoldCondensed",
				mimeType="application/x-font-truetype",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		private const _boldCondensed:Class;
		
		public static const NAME:String = "Folio";
		public static const BOLD_CONDENSED:String = "folioBoldCondensed";
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function FontFolio() {
			Font.registerFont(_boldCondensed);
		}
	}
}