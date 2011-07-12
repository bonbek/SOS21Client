/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.observer {
	import flash.events.Event;
	import com.sos21.events.EventChannel;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  29.01.2008
	 */
	public interface IObserver {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function handleEvent(event:Event):void
		function suscribeEvent(type:String, funcHandler:Function = null, pub:Boolean = false, priority:int = 0):Boolean
		function unsuscribeEvent(type:String, funcHandler:Function = null, pub:Boolean = false):Boolean
		function initialize():void
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function set channel(ac:EventChannel):void
		function get channel():EventChannel
		function get eventsInterest():Array
		function set defaultEventHandler(func:Function):void
		function get defaultEventHandler():Function
		
	}
	
}
