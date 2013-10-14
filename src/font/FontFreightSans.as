package font {
	
	//imports
	import flash.text.Font;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FontFreightSans {
		
		//****************** Properties ****************** ****************** ******************
		
		[Embed(source="../font/FreigSanProLig.otf",
				fontName="FreightSansLight",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _light:Class;
		
		[Embed(source="../font/FreigSanProBook.otf",
				fontName="FreightSansBook",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _book:Class;
		
		[Embed(source="../font/FreigSanProMed.otf",
				fontName="FreightSansMedium",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _medium:Class;
		
		public static const NAME:String = "FreightSans"
		public static const LIGHT:String = "FreightSansLight";
		public static const BOOK:String = "FreightSansBook";
		public static const MEDIUM:String = "FreightSansMedium";
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function FontFreightSans() {
			Font.registerFont(_light);
			Font.registerFont(_book);
			Font.registerFont(_medium);
		}
		
	}
}