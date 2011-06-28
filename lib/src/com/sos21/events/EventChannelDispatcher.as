/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.events {
	
	import flash.utils.*;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	
	import com.sos21.collection.HashMap;
	import com.sos21.events.EventChannel;
	
	/**	TODO cogiter à la nécéssité de l'implémentation IEventDispatcher ( peut être pas obligatoire )
	 * 	EventDispatcher subclass description.
	 *
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 * 	@since  01.02.2008
	 */	
	public class EventChannelDispatcher implements IEventDispatcher {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const PUBLIC_CHANNEL : String = "#PUBLIC_EVENT_CHANNEL";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@constructor
		 */
		public function EventChannelDispatcher( acces : PrivateConstructor )
		{
			_evtChannelList = new HashMap();
			_eD = new EventDispatcher(this);
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _oI : EventChannelDispatcher;
		private var _eD : EventDispatcher;
		private var _evtChannelList : HashMap;
		private var _defaultEventChannel : EventChannel;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function getPublicChannel() : EventChannel
		{
			return getChannel( EventChannelDispatcher.PUBLIC_CHANNEL );
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function getInstance() : EventChannelDispatcher
		{
			if ( _oI == null ) _oI = new EventChannelDispatcher( new PrivateConstructor() );
			
			return _oI;
		}
		
		public function addChannel( echannel : EventChannel ) : Boolean
		{
			if ( !_evtChannelList.insert( echannel.name, echannel ) )
				throw new Error( getQualifiedClassName(echannel) + " can't be registered, probably have not a unique name: " + echannel.name);
			
			return true;
		}
		
		public function getChannel ( stype : String ) : EventChannel
		{
			return _evtChannelList.find( stype ) as EventChannel;
		}
		
		public function removeChannelByName( stype : String ) : Boolean
		{
			return (!_evtChannelList.containsKey( stype )) ? false : _removeChannel( _evtChannelList.find( stype ) as EventChannel );
		}
		
		public function removeChannel( echannel : EventChannel ) : Boolean
		{
			return (!_evtChannelList.contains( echannel )) ? false : _removeChannel( echannel );		
		}
		
		private function _removeChannel( echannel : EventChannel ) : void
		{
			var type : String = echannel.name;
			var li : Array = echannel.listeners;
			var l : int = li.length;
			while( --l > -1 )
				removeEventListener( type, li[l] );
		}
		
		public function channelDispatch( e : Event, ec : EventChannel ) : Boolean
		{
			if ( !_evtChannelList.contains(ec) )
				return false;
			
			(e as BaseEvent) is BaseEvent ? (e as BaseEvent).setChannelName( ec.name ) : void;
			
			var li : Array = ec.listeners;
			var l : int = li.length;
			while ( --l > -1 )
			{
				li[l](e);
			}
			
			return true;
		}
		
		// @--- IEventDispatcher implementation
		public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true ) : void
		{
/*			_eD.addEventListener( PUBLIC_CHANNEL, listener, useCapture, priority, useWeakReference );
			_eD.addEventListener( type, listener, useCapture, priority, useWeakReference ); */
		}

		public function dispatchEvent( evt : Event ) : Boolean
		{
			return _eD.dispatchEvent( evt );
		}

		public function hasEventListener( type : String ) : Boolean
		{
			return _eD.hasEventListener( type );
		}

		public function removeEventListener( type : String, listener : Function, useCapture : Boolean = false) : void
		{
			_eD.removeEventListener( _defaultEventChannel.name, listener, useCapture );
			_eD.removeEventListener( type, listener, useCapture );
		}

		public function willTrigger( type : String ) : Boolean
		{
			return _eD.willTrigger(type);
		}
		// ---@
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
		
	}
	
}
internal final class PrivateConstructor {}