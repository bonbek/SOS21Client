/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.helper {

	import flash.utils.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import com.sos21.facade.Facade;
	import com.sos21.observer.IObserver;
	import com.sos21.observer.INotifier;
	import com.sos21.events.EventChannel;
	import com.sos21.events.ApplicationChannel;
	
	/**
	 *	TODO documenter son rôle et son implémentation
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  24.01.2008
	 */
	public class AbstractHelper implements IObserver, INotifier {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "AbstractHelper";
		public static var stage:DisplayObjectContainer;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AbstractHelper(sname:String = null, oComponent:Object = null)
		{
			_name = sname == null ? NAME : sname;
			_component = oComponent;
			_defaultEventHandler = handleEvent;
			_eventsInterest = listInterest();
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _name:String;
		protected var _component:Object;
		protected var _defaultEventHandler:Function;
		protected var _channel:EventChannel;
		protected var _eventsInterest:Array;
		protected var _peventsInterest:Array = [];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get name():String { return _name; }
		
		public function set channel(ec:EventChannel):void { _channel = ec; }
		
		public function get channel():EventChannel { return _channel; }
		
		public function get facade():Facade { return Facade(_channel.controller); }
		
		public function get eventsInterest():Array { return _eventsInterest; }
		
		public function set defaultEventHandler(func:Function):void {}
		
		/*
		*	Return the default Event handler Function
		*/
		public function get defaultEventHandler():Function { return _defaultEventHandler; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*
		*	Return the component associated width this Helper
		*	Additionaly, à getter that return the right component type
		*	should be implemented in the sub classes of this
		*	ex : public function get component() : Sprite {
		*		return component as Sprite;
		*		...
		*	
		*	@return	Object
		*/
		public function getComponent():Object { return _component; }
		
		public function setVisible (val:Boolean):void
		{
			_component.visible = val;
		}
		
		public function getVisible ():Boolean
		{
			return _component.visible;
		}
		
		/*
		*	Suscribe an Event this Helper is intersted in
		*	@param	type : Event type to listen
		*	@param	funcHandler : Event handler function, by default defaultEventHandler
		*	@param	pub : listen to public Event channel(dispatcher)
		*	@return	true if the listener added othewise false
		*/
		public function suscribeEvent(type:String, funcHandler:Function = null, pub:Boolean = false, priority:int = 0):Boolean
		{
			if (!pub)
			{
					// Suscribe to internal channel
				if (_eventsInterest.indexOf(type) > -1)
					return false;
			
				_eventsInterest.push(type);
				channel.addEventListener(type, _defaultEventHandler, false, priority, true);
				return true;
			}
				// Suscribe to public channel
			if (_peventsInterest.indexOf(type) > -1)
				return false;

			_peventsInterest.push(type);
			facade.publicChannel.addEventListener(type, _defaultEventHandler, false, priority, true);
			return true;			
		}
		
		/* //TODO implementer removeListener du correcte funcHandler si pas _defaultEventHandler
		*	Unsuscribe an event this Helper is listening
		*	@param	type : type of Event to remove from listening
		*	@param	funcHandler : not implemented
		*	@return	true if the event listening from this Helper is removed otherwise false
		*/
		public function unsuscribeEvent(type:String, funcHandler:Function = null, pub:Boolean = false):Boolean
		{
			if (!pub)
			{
				var ind:uint = _eventsInterest.indexOf(type);
				if (ind == -1)
					return false;
			
				channel.removeEventListener(type, _defaultEventHandler);
				_eventsInterest.splice(ind, 1);
				return true;
			}
			
			ind = _peventsInterest.indexOf(type);
			if (ind == -1)
				return false;
		
			facade.publicChannel.removeEventListener(type, _defaultEventHandler);
			_peventsInterest.splice(ind, 1);
			return true;			
		}
		
		/*
		*	Notify Observers
		*	@param	event : Event
		*/
		final public function sendEvent(event:Event):void
		{ facade.sendEvent(event); }
		
		/*
		*	Notify public Observers ( ApplicationChannel Observers )
		*	@param	event : Event
		*/		
		final public function sendPublicEvent(event:Event):void
		{ facade.sendPublicEvent(event); }
		
		/*
		*	Method called by when Facade when registering this instance
		*	override this method in your sub class to do some initialization stuff
		*	ex : cache references to needed AbstractHelper/AbstractProxy 
		*	override public function initialize():void
		*	{
		*		cachedProxyReference:MyProxy = MyProxy(facade.getProxy(MyProxy.NAME));
		*	...
		*/
		public function initialize():void
		{}
		
		/*
		*	Return the string representation of this instance
		*/
		final public function toString():String
		{ return "[" + getQualifiedClassName(this) + "]"; }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/*
		*	Handle Events the Helper is interested in
		*	Should be overrided by the sub classes and traited in a
		*	switch statement. ex :
		*	override public function handleNotification( e : Event ) : void
		*	{
		*		var note : NoteEvent = e as NoteEvent;
		*		switch( e.type ) {
		*			case "com.package.class1" :
		*				component.doSomething( e.data );
		*				break;
		*			default :
		*	...
		*/
		public function handleEvent(event:Event):void {}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/*
		*	Method called during the instanciation of the Helper
		*	override this method in your sub classes to return the
		*	list of events your instance is interested.
		*	During the registration of your instance,the Facade get this list
		*	and add the listeners to the defaultEventHandler.
		*	ex :
		*	override protected function listInterest() : Array
		*	{
		*		return[	ApplicationFacade.START_APP,
		*					ApplicationFacade.STOP_APP	];
		*	...
		*/		
		protected function listInterest():Array { return []; }
		
	}
	
}
