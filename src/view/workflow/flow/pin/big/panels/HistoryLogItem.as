package view.workflow.flow.pin.big.panels {
	
	//imports
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import font.HelveticaNeue;
	
	import util.Colors;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class HistoryLogItem extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		public static var columnProportion	:Array				
		
		protected var _uid					:int;				//log ID
		protected var _date					:Date;				//log date
		protected var _step					:String;			//step
		protected var _flagColor			:uint;				//flag
		
		protected var isHeader				:Boolean			//header
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * 
		 */
		public function HistoryLogItem(uid:int = 0, date:Date = null, step:String = "", flagColor:uint = 0) {
			
			
			this._uid = uid;
			this._date = date;
			this._step = step;
			this._flagColor = flagColor;
			
			if (uid != 0) {
				isHeader = true;
				this.addItemInfo();
			} else {
				this.addHeaderInfo();
			}
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addHeaderInfo():void {
			
			//style
			var textStyle:TextFormat = getStyle();
			
			//--------Column1: Date
			
			var dateTF:TextField = this.getTextField();
			
			dateTF.width = columnProportion[0];
			dateTF.height = 18;
			
			dateTF.text = "date";
			
			dateTF.setTextFormat(textStyle);
			this.addChild(dateTF);
			
			
			//--------Column2: Step
			var stepTF:TextField = this.getTextField();
			
			stepTF.width = columnProportion[1];
			stepTF.height = 18;
			
			stepTF.x = dateTF.y + dateTF.width;
			
			stepTF.text = "step";
			
			stepTF.setTextFormat(textStyle);
			this.addChild(stepTF);
			
			
			//--------Column3: Flag
			var flagTF:TextField = this.getTextField();
			
			flagTF.width = columnProportion[2];
			flagTF.height = 18;
			
			flagTF.x = stepTF.x + stepTF.width;
			
			flagTF.text = "flag";
			
			flagTF.setTextFormat(textStyle);
			this.addChild(flagTF);
			
		}
		
		/**
		 * 
		 * 
		 */
		public function addItemInfo():void {
			
			//style
			var textStyle:TextFormat = getStyle();
			
			//--------Column1: Date
			
			var dateTF:TextField = this.getTextField();
			
			dateTF.width = columnProportion[0];
			dateTF.height = 18;
			
			var day:String = date.date.toString();
			if (day.length == 1) day = "0" + day;
			
			var month:String = (date.month + 1).toString();
			if (month.length == 1) month = "0" + month;
			
			dateTF.text = day + "." + month + "." + date.fullYear;
			
			dateTF.setTextFormat(textStyle);
			this.addChild(dateTF);
			
			
			//--------Column2: Step
			
			var stepTF:TextField =this.getTextField();
			
			stepTF.width = columnProportion[1];
			stepTF.height = 18;
			
			stepTF.x = dateTF.y + dateTF.width;
			
			stepTF.text = step.toUpperCase();	
			
			stepTF.setTextFormat(textStyle);
			
			this.addChild(stepTF);
			
			
			//--------Column3: Flag
			var ball:Sprite = new Sprite();	
			var color:uint = flagColor;
			if (color == Colors.getColorByName(Colors.WHITE)) ball.graphics.lineStyle(1, Colors.getColorByName(Colors.DARK_GREY)); ///put a line if it is white color
			
			//draw
			ball.graphics.beginFill(color);
			ball.graphics.drawCircle(0,0,6);
			ball.graphics.endFill();
			ball.x = stepTF.x + stepTF.width + (columnProportion[2]/2);
			ball.y = 8;
			this.addChild(ball);
			
		}

		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function getStyle():TextFormat {
			var style:TextFormat = new TextFormat();
			style.size = 12;
			style.align = TextFormatAlign.CENTER;
			style.color = Colors.getColorByName(Colors.DARK_GREY);
			
			if (isHeader) {
				style.font = HelveticaNeue.LIGHT;
			} else {
				style.font = HelveticaNeue.CONDENSED_BOLD;
			}
			
			return style;
		}
		
		protected function getTextField():TextField {
			var tf:TextField = new TextField();
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.selectable = false;
			tf.embedFonts = true;
			
			return tf;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get uid():int {
			return _uid;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get date():Date {
			return _date;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get step():String {
			return _step;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flagColor():uint{
			return _flagColor;
		}

	}
}