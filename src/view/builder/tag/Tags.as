package view.builder.tag {
	
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import events.WrkfluxEvent;
	
	import model.builder.TagModel;
	
	import view.builder.structure.StructureView;
	
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
		protected var threshold					:Number;
		
		protected var topTag					:Tag;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * 
		 */
		public function Tags(target:StructureView) {
			
			this.target = target;
			
			itemCollection = new Array();
			threshold = 20;
			
			
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
			
			
			this.addNewTag(numTag);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.addEventListener(Event.CHANGE, tagLabelChange);
		}

		
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param uid
		 * @param label
		 * 
		 */
		protected function addNewTag(uid:int, label:String = ""):void {
			
			var tag:Tag = new Tag(0, label);
			tag.tempUID = "t_"+numTag;
			tag.init();
			
			tag.x = sourceLocation.x - tag.width;
			tag.y = sourceLocation.y;
			this.addChild(tag);
			
			
			TweenLite.from(tag,1,{x:this.stage.stageWidth - 105, ease:Expo.easeOut});
			
			numTag++;
			
			topTag = tag;
		}
		
		/**
		 * 
		 * @param uid
		 * 
		 */
		protected function removeTag(uid:*):void {
			
			for each (var tag:Tag in itemCollection) {
				if (tag.uid == uid || tag.tempUID == uid) {
					itemCollection.splice(itemCollection.indexOf(tag),1);
					
					var data:Object = new Object();
					data.action = "removeTag";
					data.uid = tag.uid;
					data.tempUID = tag.tempUID;
					this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, data));
					
					
					break;
				}
			}
		}

		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function checkForNewTag(event:MouseEvent):void {
			//push new tag
			if (event.currentTarget == topTag) {
				this.addNewTag(numTag);
			}
			
			//highlight delete button
			target.deleteButton.highlight(event.currentTarget.hitTestObject(target.deleteButton));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseDown(event:MouseEvent):void {
			event.target.addEventListener(MouseEvent.MOUSE_MOVE, checkForNewTag);
			target.showDelete(true);
			
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseUp(event:MouseEvent):void {
			
			event.stopImmediatePropagation();
			
			event.target.removeEventListener(MouseEvent.MOUSE_MOVE, checkForNewTag);
			
			target.showDelete(false);
			
			var tag:Tag = event.target as Tag;
			
			//delete tag
			if (event.target.hitTestObject(target.deleteButton)) {
				(tag.uid != 0) ? this.removeTag(tag.uid) : this.removeTag(tag.tempUID);
				TweenLite.to(tag,1,{y:this.stage.stageHeight, ease:Expo.easeOut, onComplete:removeChild, onCompleteParams:[tag]});
				return;
			}
			
			var existingTag:Boolean = (tag.uid != 0) ? this.getTag(tag.uid) : this.getTag(tag.tempUID);
			
			var data:Object = new Object();
			
			if (existingTag) {
				
				//update tag position
				data.action = "updateTag";
				data.uid = tag.uid;
				data.tempUID = tag.tempUID;
				data.label = tag.label;
				data.position = new Point(tag.x, tag.y);
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, data));
				
			} else {
				
				//new tag
				data.action = "createNewTag";
				data.tempUID = tag.tempUID;
				data.label = tag.label;
				data.position = new Point(tag.x, tag.y);
				this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, data));
				
				itemCollection.push(tag);
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function tagLabelChange(event:Event):void {
			
			event.stopImmediatePropagation();
			
			var tag:Tag = event.target as Tag;
			
			var data:Object = new Object();
			data.action = "updateTag";
			data.uid = tag.uid;
			data.tempUID = tag.tempUID;
			data.label = tag.label;
			data.position = new Point(tag.x, tag.y);
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.COMPLETE, data));
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
		
		/**
		 * 
		 * @param recentAddedFlags
		 * 
		 */
		public function updateTagsUID(recentAddedTags:Array):void {
			
			for each (var recentAddedTag:TagModel in recentAddedTags) {
			
				for each (var tag:Tag in itemCollection) {
					if (recentAddedTag.tempUID == tag.tempUID) {
						tag.uid = recentAddedTag.uid;
						tag.tempUID = "";
						break;
					}
					
				}
				
			}
			
		}
		
		
	}
}