/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.events {
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.events.EventChannelDispatcher;
	import com.sos21.collection.HashMap;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  01.02.2008
	 */
	public class EventChannel implements IEventDispatcher {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function EventChannel( sname : String = null ) {
			_name = sname;
			_listeners = new Array();
			_eD = new EventDispatcher(this);
			_register();
		}
		
		protected function _register() : void
		{
			getEventDispatcher().addChannel( this );
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _apfList : HashMap = new HashMap();		// Map des ApplicationChannel / Facade		
		protected var _name : String;
		protected var _eD : EventDispatcher;
		private var _controller : Object;
		protected var _listeners : Array;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get name() : String
		{ return _name }
		
		public function getEventDispatcher() : EventChannelDispatcher
		{ return EventChannelDispatcher.getInstance() }
		
		public function get listeners() : Array
		{ return _listeners }
		
		public static function getController( ac : EventChannel ) : Object
		{ return _apfList.find( ac ) }
		
		public function setController( ctrl : Object ) : void
		{
			if ( _apfList.insert( this, ctrl ) )
				_controller = ctrl;
		}
		
		public function get controller() : Object
		{ return EventChannel.getController( this ) }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function addChannelListener ( listener : Object ) : Boolean
		{
			var handle : Function = extractListener( listener );
			if ( handle == null || _listeners.indexOf( handle ) > -1 )
				return false;
			_listeners.push( handle );
			
			return true
		}
		
		public function removeChannelListener ( listener : Object ) : Boolean
		{
			var handle : Function = extractListener( listener );
			var ind : int = _listeners.indexOf( handle );
			if ( ind == -1 )
				return false;
			
			_listeners.splice( ind, 1 );
			return true
		}
		
		public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			_eD.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		public function dispatchEvent( e : Event ) : Boolean
		{
//			(e as BaseEvent) is BaseEvent ? (e as BaseEvent).setChannelName( name ) : void;
			if (e is BaseEvent) (e as BaseEvent).setChannelName( name );
			return _eD.dispatchEvent( e );
		}

		public function hasEventListener( type : String ) : Boolean
		{
			return _eD.hasEventListener( type );
		}

		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false) : void
		{
			_eD.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger( type:String ) : Boolean
		{
			return _eD.willTrigger(type);
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function extractListener ( o : Object ) : Function
		{
			var f : Function;
			if ( o is Function ) {
				f = o as Function;
			} else if ( o.hasOwnProperty( "handleEvent" ) && o.handleEvent is Function ) {
				f = o.handleEvent;
			} else if ( o.hasOwnProperty( name ) && o[name] is Function ) {
				f = o[name];
			} else { return null }
			
			return f
		}
		
		
	}
	
}
