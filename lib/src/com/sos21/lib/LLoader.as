/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.lib {
	
	import com.sos21.debug.log;
	
	import flash.events.*;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class LLoader extends Loader implements IGLoader {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LLoader( f : String = null, context : LoaderContext = null )
		{
			if (f) _file = f;
//			context ? _loaderContext = context : _loaderContext = new LoaderContext( false, ApplicationDomain.currentDomain );
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _file : String;
		private var _vBytes : uint = 51200;
		private var _isLoaded : Boolean = false;
		private var _loaderContext : LoaderContext;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public function get file() : String { return _file }
		public function set file( f :String ) : void { _file = f }

		public function get vBytes() : uint { return _vBytes }
		public function set vBytes( b : uint ) : void { _vBytes = b }

		public function get isLoaded() : Boolean { return _isLoaded }
		
		public function get bytesLoaded() : uint
		{
			return contentLoaderInfo.bytesLoaded;
		}
		
		public function get bytesTotal() : int
		{
			var b : uint;
			contentLoaderInfo.bytesTotal > 1 ? b = contentLoaderInfo.bytesTotal : b = _vBytes;
			
			return b;
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function loadFile() : void
		{
			contentLoaderInfo.addEventListener( Event.COMPLETE, completeHandler, false, 0, true );
			contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true );
         contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );

			load( new URLRequest( _file ), _loaderContext );
		}

		public function getLoader() : Loader
		{
			return this as Loader;
		}
		
		public function getContent() : Object
		{ return this.content; }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------		

		private function completeHandler( e : Event ) : void
		{
			_isLoaded = true;
			removeListeners();
			dispatchEvent( new GLibEvent( GLibEvent.ON_GLOADER_COMPLETE ) );
		}
		private function securityErrorHandler( e : SecurityErrorEvent ) : void
		{
			removeListeners();
			trace( "securityErrorHandler: " + e );
      }

      private function ioErrorHandler( e : IOErrorEvent ) : void
		{
			removeListeners();
			dispatchEvent( new GLibEvent( GLibEvent.ON_GLOADER_ERROR ) );
      }

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
				
		private function removeListeners() : void
		{
			contentLoaderInfo.removeEventListener( Event.COMPLETE, completeHandler );
			contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );			
		}

	}

}
		