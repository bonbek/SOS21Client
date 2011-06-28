package com.sos21.net {
	import com.sos21.debug.log;
	import flash.net.Responder;
	import com.sos21.net.Service;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ServiceCall extends Responder {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ServiceCall( smethod : String )
		{
			super( _onResult, _onFault );
			_method = smethod;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _method : String;
		private var _service : Service;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set method ( sm : String ) : void
		{ _method = sm }
		
		public function get method () : String
		{ return _method }
		
		public function set service ( s : Service ) : void
		{ if ( _service != s) _service = s }
		
		public function get service () : Service
		{ return _service }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function _onResult( oRes : Object ) : void
		{ _service.dispatchResult( oRes, this ) }

		private function _onFault( oEr : Object ) : void
		{ _service.resultError( oEr, this ) }
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
