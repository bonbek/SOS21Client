/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.helper {
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import com.sos21.helper.Helper;
	import com.sos21.debug.log;
	import com.sos21.facade.Facade;
	import com.sos21.events.EventChannelDispatcher;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  12.02.2008
	 */
	public class PluginHelper extends Helper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME : String = "PluginHelper";
		
		public static const ON_PLUGED : String = "onPluginPluged";
		public static const ON_UNPLUGED : String = "onPluginUnpluged";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PluginHelper( sname : String = null )
		{	
			super( sname == null ? NAME : sname );
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _l : Loader;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function load( url : String ) : void
		{
			if ( _l == null )
				_initLoader();
				
			_l.load( new URLRequest( url ) );
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onHandler( e : Event ) : void
		{
//			trace( "plugin loaded" );
			var pfacade : Object = Facade.getFacade(EventChannelDispatcher.getInstance().getChannel("Plugin Channel"));
			trace(pfacade.PLUGIN_STARTUP);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function _initLoader() : void
		{
			_l = new Loader;
			_l.contentLoaderInfo.addEventListener( Event.INIT, onHandler)
			_l.contentLoaderInfo.addEventListener( Event.COMPLETE, onHandler)
			_l.contentLoaderInfo.addEventListener( Event.OPEN, onHandler );
		}
		
	}
	
}
