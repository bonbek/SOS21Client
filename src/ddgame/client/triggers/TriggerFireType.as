/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.triggers {
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import com.sos21.debug.log;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  04.03.2008
	 */
	public class TriggerFireType {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function listFireType():Dictionary
		{
			var fireType:Array = new Dictionary(true);
			fireType[parseInt("1",2)] = MouseEvent.MOUSE_OVER;
			fireType[parseInt("10",2)] = MouseEvent.MOUSE_OUT;
			fireType[parseInt("100",2)] = MouseEvent.CLICK;
			return fireType;
		}
		
		public static function logFireType():void
		{
			trace(parseInt( "1", 2 )); 
			trace(parseInt( "10", 2 )); 
			trace(parseInt( "100", 2 )); 
			trace(parseInt( "1000", 2 ));	
			trace(parseInt( "10000", 2 )); 
			trace(parseInt( "100000", 2 )); 
			trace(parseInt( "1000000", 2 ));
			trace(parseInt( "10000000", 2 )); 
			trace(parseInt( "100000000", 2 ));	
			trace(parseInt( "1000000000", 2 ));
			trace(parseInt( "10000000000", 2 ));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
