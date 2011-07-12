package com.sos21.net {
	
	import flash.utils.*;
	import flash.net.*;
	import com.sos21.events.EventChannel;
	
	/** //TODO implémenter gestion des erreurs ( sécurité etc... ) + description classe
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  19.02.2008
	 */
	public class Service extends NetConnection {
		
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
			if (serviceURL) _service = serviceURL;
			objectEncoding = objEncoding;
						
			if ( gatewayURL != null ) {
				connect( gatewayURL );
			}
		}
		
		private var _oHeader : Object;
		private var _service : String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get gateway() : String
		{ return uri }

		public function set gateway( gURL : String ) : void
		{
			if( gURL != uri )
				connect( gURL )
		}
		
		public function set service( sURL : String ) : void
		{ _service = sURL }
		
		public function get service() : String
		{ return _service }
		
		public function get header() : Object
		{ return _oHeader }
		
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function call (command:String, responder:Responder, ... arguments) : void
		{
			super.call.apply(null,
			[_service != null ? _service + "." + command : command, responder].concat(arguments));
		}
		
		public function callService( sc : ServiceCall, ...args ) : void
		{
			sc.service = this;
			var scall : String = _service != null ? _service + "." + sc.method : sc.method;
			super.call.apply(null, [scall, sc].concat( args ) );
		}
				
		public function setCredentials( sUser : String, sPass : String ) : void
		{ addHeader( "Credentials", false, {userid: sUser, password: sPass} ) }
		
		public function setHeader( _operation : String, _mustUnderstand : Boolean = false, _param : Object = null ) : void
		{
			_oHeader	= { operation:_operation, mustUnderstand:_mustUnderstand, param:_param };
			addHeader( _operation, _mustUnderstand, _param );
		}
			
		public function addServiceListener( sc : ServiceCall, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true ) : void
		{
			addEventListener( sc.method, listener, useCapture, priority, useWeakReference );
		}
		
		public function removeServiceListener( sc : ServiceCall, listener : Function, useCapture:Boolean = false) : void
		{
			removeEventListener( sc.method, listener, useCapture );
		}
		
		public function dispatchResult( oRes : Object, sc : ServiceCall ) : void
		{
			if ( hasEventListener( sc.method ) )
				dispatchEvent( new ServiceEvent( sc, oRes ) );
		}
		
		public function resultError( oEr : Object, sc : ServiceCall ) : void
		{
			if ( hasEventListener( sc.method ) )
				dispatchEvent( new ServiceEvent( sc, null, oEr.description ) );			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
