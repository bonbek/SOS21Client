/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.observer {

	import flash.utils.*;
	import flash.events.Event;
	import com.sos21.events.EventChannel;
	import com.sos21.facade.Facade;
	
	/**
	 *	TODO documenter son rôle et son implémentation
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  24.01.2008
	 */
	public class Notifier {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/*
		*	Return Facade instance associated to the EventChannel assigned
		*	to this Notifier instance
		*	@return	Facade
		*/
		public function get facade () : Facade
		{
			return Facade.getFacade(channel);
		}
		
		/*
		*	Notify Observers
		*	@param	e : Event
		*/
		final public function sendEvent (event:Event) : void
		{
			facade.sendEvent(event);
		}
		
		/*
		*	Notify public Observers ( ApplicationChannel Observers )
		*	@param	e : Event
		*/
		final public function sendPublicEvent (event:Event) : void
		{
			facade.sendPublicEvent(event)
		}
		
		/*
		*	Return the string representation of this
		*/
		public function toString():String
		{
			return "[" + getQualifiedClassName(this) + "]";
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		private var _c : EventChannel;
		
		/*
		*	Set the EventChannel this Notifier belong to
		*	Usualy set by a Facade instance during notifycation process (when a Command extends Notifier)
		*	or register Proxy process
		*	@param	ac : EventChannel
		*/
		public function set channel (ec : EventChannel) : void
		{ _c = ec; }
		
		/*
		*	@return	EventChannel
		*/
		public function get channel () : EventChannel
		{ return _c; }
				
	}
	
}
