package view.builder.structure.steps.info {
	
	//imports
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import events.WrkfluxEvent;
	
	import view.forms.checkbox.CheckboxFormField;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Links extends CheckboxFormField {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var source					:InfoStep;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param source
		 * @param data
		 * 
		 */
		public function Links(source:InfoStep, data:Array=null) {
			super(data);
			this.source = source;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function init(label:String = ""):void {
			
			populate();
			
			//label
			super.init(label);
				
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function populate():void {
			//Containers
			content = new Sprite();
			content.x = gap;
			content.y = 17;
			this.addChild(content);
			
			//data
			if (data) {
				
				itemCollection = new Array();
				
				var item:Link;
				var posX:Number = 0;
				var posY:Number = 0;
				
				for each (var itemInfo:Object in data) {
					
					var itemLabel:String;
					var direction:String;
					
					if (source._stepID == itemInfo.source || source._stepID == itemInfo.sourceTempUID) {
						itemLabel = itemInfo.targetLabel;
						direction = "right";
					} else if (source._stepID == itemInfo.target || source._stepID == itemInfo.targetTempUID) {
						itemLabel = itemInfo.sourceLabel;
						direction = "left";
					}
				
					var cID:* = (itemInfo.uid != 0) ? itemInfo.uid : itemInfo.tempUID;
					
					item = new Link(cID,itemLabel,direction);
					
					item.init();
					content.addChild(item);
					itemCollection.push(item);
					
					//position
					if (posX + item.width > this.maxWidth - gap) {
						posX = 0;
						posY += item.height + gap;	
					}
					
					item.x = posX;
					item.y = posY;
					
					posX += item.width + gap;
				}
			}
			
			//listeners
			this.addEventListener(MouseEvent.CLICK, linkClick);
		}
		
		/**
		 * 
		 * 
		 */
		public function addLink(linkInfo:Object):void {
			
			var itemLabel:String;
			var direction:String;
			
			if (source._stepID == linkInfo.source || source._stepID == linkInfo.sourceTempUID) {
				itemLabel = linkInfo.targetLabel;
				direction = "right";
			} else if (source._stepID == linkInfo.target || source._stepID == linkInfo.targetTempUID) {
				itemLabel = linkInfo.sourceLabel;
				direction = "left";
			}
			
			var cID:* = (linkInfo.uid != 0) ? linkInfo.uid : linkInfo.tempUID;
			
			var item:Link = new Link(cID,itemLabel,direction);
			
			item.init();
			content.addChild(item);
			itemCollection.push(item);
			
			//position
			var posX:Number = 0
			var posY:Number = 0;
			
			var lastLink:Link = itemCollection[itemCollection.length-2];
			if (lastLink) {
				posX = lastLink.x + lastLink.width + gap;
				posY = lastLink.y;
			}
			
			if (posX + item.width > this.maxWidth - gap) {
				posX = 0;
				posY += item.height + gap;	
			}
			
			item.x = posX;
			item.y = posY;
			
			TweenLite.from(item,.5,{alpha:0, x:item.x - 10, delay:.5});
			TweenLite.from(item,.5,{y:0, onUpdate:resize});
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param link
		 * 
		 */
		protected function removeLink(selectedLink:Link):void {
			
			var link:Link;
			
			//remove from the list
			for each (link in itemCollection) {
				if (selectedLink == link) {
					itemCollection.splice(itemCollection.indexOf(selectedLink),1);
					break;
				}
			}
			
			//dispatch info
			var data:Object = new Object();
			data.action = "removeInfoLink";
			data.uid = selectedLink.id;
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.SELECT,data));
				
			//remove selected item
			TweenLite.to(selectedLink,.6,{y:0, alpha:0, onUpdate:resize, onComplete:removeItem, onCompleteParams:[selectedLink]});
			selectedLink = null;
			
			//change poisiton
			var posX:Number = 0;
			var posY:Number = 0;
			var i:Number = 0;
			
			for each (link in itemCollection) {
				
				if (posX + link.width > this.maxWidth - gap) {
					posX = 0;
					posY += link.height + gap;	
				}
				
				TweenLite.to(link,.6,{x:posX, y:posY, delay:i});
				
				
				posX += link.width + gap;
				
				i += 0.05;
				
			}
			
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */
		protected function removeItem(item:Link):void {
			content.removeChild(item);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function linkClick(event:MouseEvent):void {
			if (event.target is Link) {
				var link:Link = event.target as Link;
				this.removeLink(link);
			}
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param Y
		 * 
		 */
		override public function resize():void {
			source.resize();
			super.resize();
		}
		
	}
}