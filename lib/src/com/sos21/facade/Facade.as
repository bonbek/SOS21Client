/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.facade {

	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.*;
	import com.sos21.events.EventChannelDispatcher;
	import com.sos21.events.ApplicationChannel;
	import com.sos21.events.EventChannel;
	import com.sos21.events.BaseEvent;
	import com.sos21.collection.HashMap;
	import com.sos21.commands.ICommand;
	import com.sos21.observer.IObserver;
	import com.sos21.observer.Notifier;
	import com.sos21.proxy.IProxy;
	import com.sos21.debug.log;
	
	/**
	 *	TODO documenter son rôle et son implémentation
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  24.01.2008
	 */
	public class Facade {
		
		/**
		 *	@Constructor
		 */
		public function Facade (achannel:EventChannel = null)
		{
			if (_eCD == null)
			{
				_eCD = EventChannelDispatcher.getInstance();
				_puChannel = ApplicationChannel.getInstance();
			}
			// TODO trouver methode plus intelligente si pas de ApplicationChannel passé en arg
			_prChannel = achannel == null ? new EventChannel( getQualifiedClassName(this) ) : achannel;
			_prChannel.setController(this);
			
			_commandList = new HashMap();
			_observerList = new HashMap();
			_proxyList = new HashMap();
			
//			_eCD.getPublicChannel().addListener( onInitFacade );
			
			initialize();
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _eCD:EventChannelDispatcher;
		private static var _puChannel:EventChannel;						// public channel
		private var _prChannel:EventChannel;								// private (internal) channel
		private var _commandList:HashMap;
		private var _observerList:HashMap;
		private var _proxyList:HashMap;
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*
		*	Retrieve Facade instance by his associated Channel
		*	@return Facade
		*/
		public static function getFacade(key:*) : Facade
		{
			var ec:EventChannel = key is String 	? _eCD.getChannel(key)
																: key as EventChannel;
			
			return Facade(EventChannel.getController(ec));
		}
		
		public function retrieveFacade(ec:EventChannel):Facade
		{ return Facade(EventChannel.getController(ec)); }
		
		public function get publicChannel():EventChannel
		{ return _puChannel; }
		
		public function get channel () : EventChannel
		{ return _prChannel; }
		
		/*
		*	Register a reference to a ICommand
		*	@param	commandName : the string identifier associated with a ICommand class reference
		*	@param	classRef : the class reference of the ICommand
		*	@param	publicEvt : if the command must be associated width a public event 
		*								-> to associate execution of internal command from an external Event
		*									(basic communication between multiple Facade instances)
		*	@return	true if the registration succes otherwise false
		*/
		public function registerCommand (commandName:String, classRef:Class, publicEvt:Boolean = false) : Boolean
		{

			if (publicEvt) {
				_puChannel.addEventListener(commandName, fireCommand);
			}

			if (!_commandList.insert(commandName, classRef))
				return false;
				
			return true;
		}
		
		/*
		*	Unregister a reference to a ICommand
		*	@param : commandName : the string identifier associated with a ICommand class reference
		*	@return	true if the unregistration succes otherwise false
		*/
		public function unregisterCommand (commandName:String) : Boolean
		{
			if (_commandList.remove(commandName) == null)
			{
				return false;
			} else {				
				_puChannel.removeEventListener(commandName, handlePublicEvent);
			}
				
			return true;
		}
		
		/*	
		*	Notify Observers
		*	If the Event passed to the method is associated with a ICommand,
		*	the ICommand is executed and the Event is dispatched
		*	If public channel (ApplicationChannel) has listeners of Event.type, a
		*	public event is dispatched
		*	@param	e : Event
		*	@param	ec : optionnal to notify all ChannelListeners of the
		*				EventChannel passed in parameter						
		*/
		final public function sendEvent (event:Event, ec:EventChannel = null) : void
		{
			ec != null ? _eCD.channelDispatch(event, ec) : _prChannel.dispatchEvent(event);			
			fireCommand(event);
		}
		
		/*
		*	Notify public Observers ( ApplicationChannel Observers )
		*	@param	e : Event
		*/
		final public function sendPublicEvent (event:Event) : void
		{
			_puChannel.dispatchEvent(event);
		}
		
		/*
		*	Register a IObserver to this Facade, typically a sub class of Helper
		*	get the Events this Observer is interested in and do the
		*	relationship for the notifycation process ( add the listeners );
		*	@param	sname : the string identifier associated with the IObserver
		*	@param	observer : the IObserver instance
		*	@return	true if the Helper registeration success otherwise false
		*/ 
		public function registerObserver (sname:String, observer:IObserver) : Boolean
		{
			if (!_observerList.insert(sname, observer))
				return false;
			
			observer.channel = _prChannel;
			observer.initialize();

			var evtInterest:Array = observer.eventsInterest;
			var n:int = evtInterest.length;
			if (n)
			{
				for (var i:int = 0; i < n; i++)
				{
					_prChannel.addEventListener(evtInterest[i], observer.defaultEventHandler, false, 0, true);
				}
			}
			
			return true;
		}
		
		/* TODO réfléchir au fait que les listeners de l'Observer sont enlevés mais pas leur références (observer.eventsInterest) 
		*	Unregister a IObserver from this Facade
		*	remove the events listeners associated to the IObserver
		*	@param	: sname the string identifier associated with the registered IObserver
		*	@return	true if the IObserver was unregistered otherwise false
		*/
		public function unregisterObserver (sname:String) : Boolean
		{
			var observer:IObserver = IObserver(_observerList.remove(sname));
			if (observer is IObserver == false)
				return false;
			
			var evtInterest:Array = observer.eventsInterest;
			var n:int = evtInterest.length;
			if (n)
			{
				for (var i:int = 0; i < n; i++)
				{
					_prChannel.removeEventListener(evtInterest[i], observer.defaultEventHandler);
				}
			}
			
			return true;
		}
		
		/*
		*	Get an IObserver register by this Facade
		*	@param	sname : the string identifier associated with the registered IObserver
		*	@return	IObserver othewise a null Object
		*/
		public function getObserver (sname:String) : IObserver
		{
			return _observerList.find(sname) as IObserver;
		}
		
		/*
		*	Register a IProxy to this Facade, typically a sub class of AbstractProxy
		*	if no sname associated with the IProxy is passed to the method, the name of
		*	the name of the IProxy is taken. A unique name for the sub class of AbstractProxy 
		*	should be given
		*	@param	sname : the string identifier associated with the IProxy
		*	@param	proxy : the IProxy instance
		*	@return	true if the registration succes othewise false
		*/
		public function registerProxy (sname:String, proxy:IProxy) : Boolean
		{
			if (!_proxyList.insert(sname, proxy))
				return false;

			proxy.channel = _prChannel;
			proxy.initialize();

			return true;
		}
		
		/*
		*	Unregister a IProxy from this Facade
		*	@param	sname : the string identifier associated with the registered IProxy
		*	@return	true if the IProxy was unregistered othewise false
		*/
		public function unregisterProxy (sname:String) : Boolean
		{
			return _proxyList.remove(sname) is IProxy;
		}
		
		/*
		*	Chack if a IProxy is registered in this Facade instance
		*/
		public function isregisteredProxy (sname:String) : Boolean
		{ 
			return _proxyList.containsKey(sname);
		}
		
		/*
		*	Get a IProxy registered by this Facade
		*	@param	sname : the string identifier associated with the registered IProxy
		*	@return	IProxy othewise a null Object
		*/
		public function getProxy (sname:String) : IProxy
		{
			return _proxyList.find(sname) as IProxy;
		}		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/*
		*	Handle a public event ( dispatched by other Facade ) to redispatch internal
		*	@param	e : Event
		*/
		protected function handlePublicEvent (event:Event) : void
		{
			fireCommand(event);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/*
		*	Execute a ICommand associated with a Event.type
		*	Pass the internal EvenChannel ref. of this Facade Instance
		*	to the ICommand if this one extends Notifier (serve the notifycation
		*	process inside the ICommand instance)
		*/
		private function fireCommand (event:Event) : void
		{
			var type:String = event.type;
			if (_commandList.containsKey(type))
			{
				var classRef:Object = _commandList.find(type);
				if (classRef is Class)
				{
					var command:ICommand = new (classRef as Class);
					if (command is Notifier)
						Notifier(command).channel = _prChannel;
					command.execute(event);
				}
			}
		}
		
		/*
		*	Method called during the instanciation of the Facade
		*	Override this method in your sub class to do some initialization stuff
		*	ex : register some Commands
		*	override protected function initialize() : void
		*	{
		*	registerCommand(	APP_STARTUP,
		*							commands.StartupCommand );
		*	...
		*/                  
		protected function initialize():void
		{}
				
	}
	
}
