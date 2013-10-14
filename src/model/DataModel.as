package model {
	
	//imports
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import events.WrkfluxEvent;
	
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class DataModel extends Observable {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var docCollections			:Array;						//Collection of docs
		
		protected var completeLoad				:Boolean = false;
		protected var totalDocs					:int = 0;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function DataModel() {
			
			super();
			
			//define name
			this.name = "data";
			
			//init
			docCollections = new Array();
			
			//var dir:File = File.applicationDirectory.resolvePath("resource/FULL");
			var dir:File = File.applicationDirectory.resolvePath("resource");
			var files:Array = dir.getDirectoryListing();
			
			//Loop
			for each(var doc:File in files) {
				if (doc.extension == "sgm") {
					//load file
					//var urlLoader:URLLoader = new URLLoader(new URLRequest(doc.parent.parent.name + "/" + doc.parent.name + "/" + doc.name));
					var urlLoader:URLLoader = new URLLoader(new URLRequest(doc.parent.name + "/" + doc.name));
						
					totalDocs++;
					urlLoader.addEventListener(Event.COMPLETE, _docLoadComplete);
				}		
			}
			
		}
		
		
		//****************** PROCESS DATA ****************** ****************** ******************
		
		/**
		 * Create Orlando doc collections.
		 * Save all properties in an Document Model Class
		 * Push doc to doc collection
		 * 
		 * @param	e	event - The target is a XML file
		 */
		private function _docLoadComplete(e:Event):void {
			var doc:XMLList = new XMLList(e.target.data);
			
			var documentModel:DocumentModel = new DocumentModel(docCollections.length+1);
			
			//add title, authority and source
			documentModel.title = doc.ORLANDOHEADER.FILEDESC.TITLESTMT.DOCTITLE;
			documentModel.authority = doc.ORLANDOHEADER.FILEDESC.PUBLICATIONSTMT.AUTHORITY;
			documentModel.source = doc.ORLANDOHEADER.FILEDESC.SOURCEDESC
			
			//add revisions to the log history
			var revisions:XMLList = doc.ORLANDOHEADER.REVISIONDESC;
			if (revisions.children().length() > 0) {
				for each(var rev:XML in revisions.children()) {
					documentModel.addLog(rev.attribute("WORKVALUE"), rev.attribute("WORKSTATUS"), rev.attribute("RESP"),rev.ITEM, rev.DATE)
				}
			}
			
			//push to collection
			docCollections.push(documentModel);
			
			testCompleteLoad()
		}
		
		/**
		 * 
		 * 
		 */
		private function testCompleteLoad():void {
			if (docCollections.length == totalDocs ) {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//****************** PUBLIC METHODS - GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * Get Document Collections
		 * 
		 * Return	Array
		 **/
		public function getDocumentCollection():Array {
			return docCollections.concat();
		}
		
		/**
		 * 
		 * Get Document by Id
		 * 
		 * Return	AbstractDoc
		 **/
		public function getDocument(id:int):DocumentModel {
			for each(var doc:DocumentModel in docCollections) {
				if(doc.id == id) {
					return doc;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * Get Document Title
		 * 
		 * Return	String
		 **/
		public function getDocumentTitle(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.title;
			return null;
		}
		
		/**
		 * 
		 * Get Document Authority
		 * 
		 * Return	String
		 **/
		public function getDocumentAuthority(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.authority;
			return null;
		}
		
		/**
		 * Get Document Source
		 * 
		 * Return	String
		 **/
		public function getDocumentSource(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.source;
			return null;
		}
		
		/**
		 * 
		 * Get Document current Step
		 * 
		 * Return	String
		 **/
		public function getDocumentCurrentStep(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentStep;
			return null;
		}
		
		/**
		 * 
		 * Get Document Current Flag
		 * 
		 * Return	StatusFlag	- currentFlag
		 **/
		public function getDocumentCurrentFlag(id:int):FlagModel {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentStatus;
			return null;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getDocumentCurrentResponsible(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentResponsible;
			return null;
		}
		
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getDocumentCurrentNote(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentNote;
			return null;
		}
		
		/**
		 * 
		 * Get a Document log history
		 * @param id
		 * @return 
		 * 
		 */
		public function getDocumentLogHistory(id:int):Array {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.history;
			return null;
		}
		
		
		//****************** PUBLIC METHODS - ACTIONS ****************** ****************** ******************
		
		/**
		 * Add a log item to the pin
		 * 
		 **/
		public function updateDocument(id:int, newFlag:String = "", newStep:String = ""):void {
			
			var doc:DocumentModel = getDocument(id);
			
			//flag
			var flag:String;
			if (newFlag == "") {
				flag = "Start";
			} else {
				flag = newFlag;
			}
			
			//step
			var step:String;
			if (newStep == "") {
				step = getDocumentCurrentStep(id);
			} else {
				step = newStep;
			}
			
			//get new responsable
			var responsible:String = "WFM";
			
			//addLog
			doc.addLog(flag, step, responsible);
			
			//dispatch Event
			var data:Object = {};
			data.document = doc;
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.UPDATE_PIN, data));
			
		}
		
		/**
		 * 
		 * @param id
		 * @param tagged
		 * @return 
		 * 
		 */
		public function setDocumentTagged(id:int, tagged:Boolean):DocumentModel {
			var doc:DocumentModel = getDocument(id);
			doc.tagged = tagged;
			return doc;
			
			//dispatch Event
			var data:Object = {};
			data.pinId = id;
			
			this.dispatchEvent(new WrkfluxEvent(WrkfluxEvent.UPDATE_PIN, data));
		}
		
	}
}