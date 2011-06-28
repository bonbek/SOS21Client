/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.net {
	import flash.events.Event;
	import com.sos21.net.Service;
	import com.sos21.net.ServiceCall;
	
	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  19.02.2008
	 */
	public class ServiceEvent extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const EVENT_NAME : String = "serviceEvent";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@constructor
		 */
		public function ServiceEvent( sc : ServiceCall,
												oRes : Object = null,
												sErr : String = null,
												bubbles : Boolean = true, cancelable : Boolean = false )
		{
			super( sc.method, bubbles, cancelable );
			sErr == null ? _res = oRes : _err = sErr;
			_sc = sc;
			
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get result () : Object
		{ return _res }
		
		public function get error() : String
		{ return _err }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function get service() : Service
		{ return _sc.service }
		
		public function get serviceCall() : ServiceCall
		{ return _sc }
		
		public function get failed() : Boolean
		{ return _err != null }
		
		override public function clone() : Event
		{ return new ServiceEvent( _sc, _res, _err, bubbles, cancelable ) }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _sc : ServiceCall;
		private var _res : Object;
		private var _err : String;
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
