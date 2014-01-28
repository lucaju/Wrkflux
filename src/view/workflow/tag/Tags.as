package view.workflow.tag {
	
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import view.workflow.structure.StructureView;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Tags extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var numTag				:int = 0;
		
		protected var target					:StructureView;
		
		protected var itemCollection			:Array;
		protected var sourceLocation			:Point;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * 
		 */
		public function Tags(target:StructureView) {
			
			this.target = target;
			
			itemCollection = new Array();
			
			
		}
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function init(data:Array = null):void {
			
			//
			sourceLocation = new Point(this.stage.stageWidth - 105, 20);
			
			//checking data
			if (data) {
				
				//loop
				for each (var tagObject:Object in data) {
					
					var tag:Tag = new Tag(tagObject.uid, tagObject.label);
					tag.tempUID = "t_"+numTag;
					tag.init();
					
					tag.x = tagObject.position.x;
					tag.y = tagObject.position.y;
					this.addChild(tag);
					
					TweenLite.from(tag,1,{x:sourceLocation.x, y:sourceLocation.y, ease:Expo.easeOut, delay:1+(numTag*0.2)});
					
					numTag++;
					
					itemCollection.push(tag)
					
				}
				
			}
			
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param uid
		 * @return 
		 * 
		 */
		public function getTag(uid:*):Tag {
			for each (var tag:Tag in itemCollection) {
				if (tag.uid == uid || tag.tempUID == uid) return tag;
			}
			
			return null;
		}
		
		public function show(value:Boolean):void {
			if (value) {
				TweenLite.from(itemCollection,1,{x:sourceLocation.x, y:sourceLocation.y, ease:Expo.easeOut, delay:1+(numTag*0.2)});
			} else {
				TweenLite.to(itemCollection,1,{x:sourceLocation.x, y:sourceLocation.y, ease:Expo.easeOut, delay:1+(numTag*0.2)});
				
			}
		}
		
	}
}