package {
	
	//import
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import controller.WrkfluxController;
	
	import model.WrkfluxModel;
	
	import settings.Settings;
	
	import view.WrkfluxView;
	
	
	//[SWF(width="1260", height="700", backgroundColor="#FFFFFF", frameRate="60")]
	[SWF(width="1260", height="800", backgroundColor="#FFFFFF", frameRate="60")]
	public class Wrkflux extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var wrkfluxModel					:WrkfluxModel;
		protected var wrkfluxController				:WrkfluxController;
		protected var wrkfluxView					:WrkfluxView;
		
		protected var configure						:Settings;					//Settings
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Wrkflux() {
			
			//align
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//settings
			setting();
			
			//Start models
			wrkfluxModel = new WrkfluxModel();
			
			//Start controler
			wrkfluxController = new WrkfluxController([wrkfluxModel]);
			
			//Starting View
			wrkfluxView = new WrkfluxView(wrkfluxController);
			this.addChild(wrkfluxView);
			wrkfluxView.setModel(wrkfluxModel);
			wrkfluxView.init();
			
		}		
		
		//****************** PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		private function setting():void {
			configure = new Settings();
			//default values
			Settings.platformTarget = "air";
			Settings.debug = false;
		}
		
	}
}
