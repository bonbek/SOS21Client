/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.net {
	import flash.utils.*;
	import flash.net.ObjectEncoding;
	import flash.net.NetConnection;
	import com.sos21.events.EventChannel;
	import com.sos21.debug.log;
	
	/**
	 *	Class description.	//TODO implémenter gestion des erreurs ( sécurité etc... )
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  19.02.2008
	 */
	public class Service {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Service( gatewayURL : String = null, serviceURL : String = null, objEncoding : int = 0 )
		{
			_connection = new NetConnection();
			_connection.objectEncoding = objEncoding;
			if (serviceURL) _service = serviceURL;
			
			if ( gatewayURL != null ) {
				_gateway = gatewayURL;
				_connection.connect( _gateway );
			}
		}
		
		private var _connection : NetConnection;
		private var _gateway : String;
		private var _service : String;
		private var _oHeader : Object;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function callService( sc : ServiceCall, ...args ) : void
		{
			sc.service = this;
			var scall : String = _service != null ? _service + "." + sc.method : sc.method;
			trace( scall );
			var a:Array = [scall, sc].concat( args );
			_connection.call.apply(null, a );
		}
		
		public function get gateway() : String
		{ return _gateway }

		public function set gateway( gURL : String ) : void
		{
			if( gURL != _gateway ) {
				_gateway = gURL;
				_connection.connect( _gateway );
			}
		}
		
		public function set service( sURL : String ) : void
		{ _service = sURL }
		
		public function get service() : String
		{ return _service }
		
		public function setCredentials( sUser : String, sPass : String ) : void
		{ _connection.addHeader( "Credentials", false, {userid: sUser, password: sPass} ) }
		
		public function setHeader( _operation : String, _mustUnderstand : Boolean = false, _param : Object = null ) : void
		{
			_oHeader	= { operation:_operation, mustUnderstand:_mustUnderstand, param:_param };
			_connection.addHeader( _operation, _mustUnderstand, _param );
		}
		
		public function get header() : Object
		{ return _oHeader }
		
		public function addServiceListener( sc : ServiceCall, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true ) : void
		{
			_connection.addEventListener( sc.method, listener, useCapture, priority, useWeakReference );
		}
		
		public function removeServiceListener( sc : ServiceCall, listener : Function, useCapture:Boolean = false) : void
		{
			_connection.removeEventListener( sc.method, listener, useCapture );
		}
		
		public function dispatchResult( oRes : Object, sc : ServiceCall ) : void
		{
			if ( _connection.hasEventListener( sc.method ) )
				_connection.dispatchEvent( new ServiceEvent( sc, oRes ) );
		}
		
		public function resultError( oEr : Object, sc : ServiceCall ) : void
		{
			if ( _connection.hasEventListener( sc.method ) )
				_connection.dispatchEvent( new ServiceEvent( sc, null, oEr.description ) );			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
