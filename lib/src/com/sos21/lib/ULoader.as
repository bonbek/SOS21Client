/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.lib {
	
	import com.sos21.debug.log;
	import flash.utils.*;
	import flash.events.*;
	import flash.system.ApplicationDomain;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.display.*;
	import flash.system.LoaderContext;
//	import flash.display.Loader;
	
	import com.sos21.lib.IGLoader;
	import com.sos21.lib.GLibEvent;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  16.11.2007
	 */
	public class ULoader extends EventDispatcher implements IGLoader {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ULoader( f : String = null, df : String = null )
		{
			_file = f;
			if ( df ) _dataFormat = df;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _urlLoader : URLLoader;
		private var _file : String;
		private var _vBytes : uint = 51200;
		private var _isLoaded : Boolean = false;
		private var _dataFormat : String = URLLoaderDataFormat.TEXT;
				
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function get file() : String { return _file }
		public function set file( f :String ) : void { _file = f }
		
		public function get vBytes() : uint { return _vBytes }
		public function set vBytes( b : uint ) : void { _vBytes = b }
		
		public function get isLoaded() : Boolean { return _isLoaded }
		
		public function get loader() : URLLoader { return _urlLoader }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function loadFile() : void
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = _dataFormat;
			var request : URLRequest = new URLRequest( _file );
			addListeners()
			try {
				_urlLoader.load(request);
			}
			catch (error:Error) {
				trace( "chargement impossible @" + this );
			}
		}
		
		public function unload():void {
		}
		
		public function get bytesLoaded() : uint
		{
			return _urlLoader.bytesLoaded;
		}
		
		public function get bytesTotal() : int
		{
			var b : uint;
			_urlLoader.bytesTotal > 1 ? b = _urlLoader.bytesTotal : b = _vBytes;
			
			return b;
		}
		
		public function getLoader() : Loader
		{
			var l:Loader = new Loader();
//			try
//			{
//				var loaderContext:LoaderContext = new LoaderContext();
//				loaderContext.allowLoadBytesCodeExecution = true;
				l.loadBytes(_urlLoader.data);
//			} catch (e:Error) {
//				trace("erreur de copie @" + this);
//			}
			
			return l;
		}
		
		public function getContent() : Object
		{ return _urlLoader.data; }
		
		override public function toString() : String
		{
			return "ULoader (file:" + _file + ", isLoaded:" + isLoaded + ")";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------		

		private function completeHandler( e : Event ) : void
		{
			_isLoaded = true;
			removeListeners();
			dispatchEvent( new GLibEvent( GLibEvent.ON_GLOADER_COMPLETE ) );
		}
		private function securityErrorHandler(e : SecurityErrorEvent) : void
		{
			removeListeners();
			trace("securityErrorHandler: " + e);
      }

      private function ioErrorHandler(e : IOErrorEvent) : void
		{
			removeListeners();
			dispatchEvent( new GLibEvent( GLibEvent.ON_GLOADER_ERROR ) );
      }

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function addListeners () : void
		{
			_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function removeListeners () : void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			
		}
		
	}
	
}
