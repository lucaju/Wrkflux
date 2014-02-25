package font {
	
	//imports
	import flash.text.Font;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class HelveticaNeue {
		
		//****************** Properties ****************** ****************** ******************
		
		[Embed(source="HelveticaNeueLTProTh.otf",
				fontName="HelveticaNeueThin",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _thin:Class;
		
		[Embed(source="HelveticaNeueLTProLt.otf",
				fontName="HelveticaNeueLight",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _light:Class;
		
		[Embed(source="HelveticaNeueLTProBdCn.otf",
				fontName="HelveticaNeueCondensedBold",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _condensedBold:Class;
		
		[Embed(source="HelveticaNeueLTProMedium.otf",
				fontName="HelveticaNeueMedium",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _medium:Class;
		
		
		public static const NAME:String = "HelveticaNeue"
		public static const THIN:String = "HelveticaNeueThin";
		public static const LIGHT:String = "HelveticaNeueLight";
		public static const CONDENSED_BOLD:String = "HelveticaNeueCondensedBold";
		public static const MEDIUM:String = "HelveticaNeueMedium";
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function HelveticaNeue() {
			Font.registerFont(_thin);
			Font.registerFont(_light);
			Font.registerFont(_condensedBold);
			Font.registerFont(_medium);
		}
	}
}