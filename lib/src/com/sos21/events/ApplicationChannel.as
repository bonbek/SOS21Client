/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.events {
	import com.sos21.events.EventChannel;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  06.02.2008
	 */
	public class ApplicationChannel extends EventChannel {
		
		public static const NAME:String = "_PAC_";
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ApplicationChannel (acces:PrivateConstructor)
		{
			super(NAME);
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _oI:ApplicationChannel
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function setController(ctrl:Object):void
		{ }
		
		override public function get controller():Object
		{
			return null;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function getInstance() : ApplicationChannel
		{
			if (_oI == null)
				_oI = new ApplicationChannel(new PrivateConstructor());
			
			return _oI;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
internal final class PrivateConstructor {}
