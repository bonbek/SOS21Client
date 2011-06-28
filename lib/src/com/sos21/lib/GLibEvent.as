/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.lib {
	import flash.events.Event;
	
	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  16.11.2007
	 */
	public class GLibEvent extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const ON_LIB_COMPLETE : String = "onLibComplete";
		public static const ON_PROGRESS : String = "onProgress";
		public static const ON_GLOADER_COMPLETE : String = "gLoaderComplete";
		public static const ON_GLOADER_ERROR : String = "gLoaderError";
		public static const ON_GCOPY_COMPLETE : String = "onCopyComplete";
		
		/**
		 *	@constructor
		 */
		public function GLibEvent( type : String, bubbles : Boolean = true, cancelable : Boolean = false ){
			super( type, bubbles, cancelable );		
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get bytesTotal() : int
		{
			var b : int = currentTarget.getBytesTotal();
			return b;
		}
		public function get bytesLoaded() : int
		{
			var b : int = currentTarget.getBytesLoaded();
			return b; 
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function clone() : Event {
			return new GLibEvent(type, bubbles, cancelable );
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
