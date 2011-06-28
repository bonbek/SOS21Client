/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.commands {
	
	import flash.events.Event;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  23.01.2008
	 */
	public interface ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function execute (event:Event) : void
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	}
	
}
