package view.initial {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import font.HelveticaNeue;
	
	import util.Colors;
	
	import view.assets.logo.Logo;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Brand extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var container		:Sprite;
		protected var logo			:Logo;
		protected var tipo			:TextField;
		
		
		//****************** Constructor ****************** ****************** ******************

		
		
		/**
		 * 
		 * 
		 */
		public function Brand() {
			
			container = new Sprite();
			this.addChild(container);
		
			//logo
			logo = new Logo();
			logo.y = logo.height/2;
			container.addChild(logo);
			
			//tipo
			this.addTipo();
			
			//logo position
			logo.x = tipo.width/2
			
			//animation
			TweenMax.from(logo,2,{rotation:-180});
			
			container.x = -container.width/2;
			container.y = -container.height/2;
			
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addTipo():void {
			
			//tipo
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.THIN;
			style.bold = true;
			style.size = 63;
			style.color = Colors.getColorByName(Colors.DARK_GREY);
			style.letterSpacing = 4;
			
			tipo = new TextField();
			tipo.selectable = false;
			tipo.autoSize = TextFieldAutoSize.LEFT;
			tipo.antiAliasType = AntiAliasType.ADVANCED;
			tipo.embedFonts = true;
			tipo.text = "Wrkflux";
			tipo.setTextFormat(style);
			
			tipo.y = logo.height - 20;
			
			container.addChild(tipo);
				
			TweenMax.from(tipo,1,{alpha:0, y:tipo.y-10, delay:1});
		}
		
		/**
		 * 
		 * 
		 */
		public function removeTipo():void {
			if (tipo) {
				container.removeChild(tipo);
				tipo = null;
			};
		}
		
		/**
		 * 
		 * @param r
		 * 
		 */
		public function spin(r:Number = 1):void {
			var rot:Number = (r*360) - 45;
			TweenMax.to(logo,4,{rotation:rot});
		}
	}
}