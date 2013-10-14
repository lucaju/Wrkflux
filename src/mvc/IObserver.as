package mvc {
	
	//imports
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public interface IObserver {
		function update(o:Observable, infoObj:Object):void;
		function setReg(value:int):void;
		function getReg():int;
	}
}