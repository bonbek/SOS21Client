package com.sos21.proxy {
	import com.sos21.proxy.AbstractProxy;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  18.01.2008
	 */
	public class ConfigProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME : String = 'configProxy';
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ConfigProxy( acces : PrivateConstructor )
		{
			super( NAME );
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _oI : ConfigProxy;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get data() : XML
		{ return _data as XML }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function setData( d : XML ) : void
		{
			_data = d;
		}
		
		public function getContent( snode : String ) : String
		{
			return data[snode][0].toString();
		}
		
		public static function getInstance() : ConfigProxy
		{
			if ( _oI == null ) _oI = new ConfigProxy( new PrivateConstructor() );
			
			return _oI;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}

internal final class PrivateConstructor {}