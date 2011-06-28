/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package components.quiz {
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  17.03.2008
	 */
	public class DataProvider {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function DataProvider()
		{
//			_items = new Array(); 			
		}
		
		public function addItem(item:Object):Boolean { 
			if (item !=null )
			{ 
				_items.push(item); 
				return true; 
			}  
			return false
		} 

		public function clear():void
		{
			_items = new Array(); 
		} 

		public function getItemAt(index:Number):Object
		{
			return(_items[index]); 
		} 

		public function get length():int
		{
			return _items.length; 
		}
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		private var _items:Array /* of Object */= [];

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
