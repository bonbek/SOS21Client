package com.sos21.proxy {

	import flash.display.Sprite;
	import flash.events.Event;
	import com.sos21.events.EventChannel;
	import com.sos21.facade.Facade;	
	import com.sos21.proxy.IProxy;
	import com.sos21.facade.Facade;

	/**
	 *	Proxy abstrait servant de classe d'éntrée pour un swf externe destiné à être injecté
	 * dans une Facade.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  16.03.2011
	 */
	public class AbstractModuleProxy extends Sprite {
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function AbstractModuleProxy ()
		{
			super();
		}
	
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		
		protected var _name:String;
		protected var _data:Object;		
		private var _c : EventChannel;		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*
		*	Return Facade instance associated to the EventChannel assigned
		*	to this Notifier instance
		*	@return	Facade
		*/
		public function get facade():Facade
		{
			return Facade.getFacade(channel);
		}
		
		/*
		*	Notify Observers
		*	@param	e : Event
		*/
		final public function sendEvent(event:Event):void
		{
			facade.sendEvent(event);
		}
		
		/*
		*	Notify public Observers ( ApplicationChannel Observers )
		*	@param	e : Event
		*/
		final public function sendPublicEvent(event:Event):void
		{
			facade.sendPublicEvent(event)
		}
		
		/* 
		*	Return the data of this AbstractProxy
		*	additionaly, a getter that return the right type of data or
		*	handled data should be implemented in the sub classes of this
		*	ex :
		*	Class MyProxy extends AbstractProxy {
		*		public function get data() : XML
		*		{
		*			return _data as XML;
		*	...
		*	@return	Object
		*/
		final public function getData():Object
		{
			return _data;
		}
				
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/*
		*	Set the EventChannel this Notifier belong to
		*	Usualy set by a Facade instance during notifycation process (when a Command extends Notifier)
		*	or register Proxy process
		*	@param	ac : EventChannel
		*/
		public function set channel(ec:EventChannel):void
		{ _c = ec; }
		
		/*
		*	@return	EventChannel
		*/
		public function get channel():EventChannel
		{ return _c; }
	
	}

}

