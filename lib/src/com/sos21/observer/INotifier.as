/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.observer {
	
	import flash.events.Event;
	import com.sos21.facade.Facade;
	import com.sos21.events.EventChannel;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  25.01.2008
	 */
	public interface INotifier {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function sendEvent (event:Event) : void;
		function sendPublicEvent (event:Event) : void;
		function toString() : String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function set channel (ac:EventChannel) : void;
		function get channel () : EventChannel;
		function get facade () : Facade;
		
	}
	
}
