/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.lib {
	
	import com.sos21.debug.log;
	
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import com.sos21.lib.*;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	
	 *
	 *	@author toffer
	 *	@since  16.11.2007
	 */
	public class GLib extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private var _loaderList : Dictionary;
		private var _toLoad : int;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function GLib()
		{
			_loaderList = new Dictionary( true );
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function addFile (f:String, forcebinary:Boolean = false ) : Boolean
		{
			if ( _loaderList[f] ) return false;
			var ext : String = getFileExtension(f);
			if (checkFileExtension(ext))
			{
				var gl : IGLoader;
				forcebinary ? gl = new ULoader(null, URLLoaderDataFormat.BINARY) : gl = createGloader( ext );
				gl.file = f;
				_loaderList[f] = gl;
				return true;
			} else {
				return false;
			}
			
		}
		
		public function clear():void
		{
			for each (var o:IGLoader in _loaderList)
			{
				o.unload();
			}
				
			_loaderList = new Dictionary(true);
		}
		
		public function load() : void
		{
			_toLoad = 0;
			for each( var value : IGLoader in _loaderList ) {
				if ( !value.isLoaded ) {
					_toLoad++;
					value.addEventListener( GLibEvent.ON_GLOADER_COMPLETE , GLoaderCompleteHandler, false, 0, true );
					value.addEventListener( GLibEvent.ON_GLOADER_ERROR , GLoaderErrorHandler, false, 0, true );
					value.loadFile();
				}
			}
			if ( _toLoad > 0 ) addEventListener( Event.ENTER_FRAME, progressEvent, false, 0, true );
		}
		
		public function getBytesTotal() : int
		{
			var b : int = 0;
			for each( var value : IGLoader in _loaderList ) {
				b += value.bytesTotal;
			}
			
			return b;
		}

		public function getBytesLoaded() : int
		{
			var b : int = 0;
			for each( var value : IGLoader in _loaderList ) {
				b += value.bytesLoaded;
			}
			
			return b;
		}
		
		
		public function getGLoader( f : String ) : IGLoader
		{

			var gl : IGLoader = _loaderList[f];
	
			return gl;
		}
		
		public function getLoader(f:String):Loader
		{
			var l:Loader;
			
			if (_loaderList[f])
			{
				var gl:IGLoader = _loaderList[f];
				l = gl.getLoader();
			} else {
				throw new Error("GLib.getLoader: impossible de trouver la référence: " + f ); 
			}
			
			return l;			
		}
		
		public function getContent (f:String) : Object
		{
			var iloader:IGLoader = _loaderList[f];
			if (iloader) {
				return iloader.getContent();
			}
			else {
				throw new Error("GLib.getLoader: impossible de trouver la référence: " + f );
			}
			
			return null;
		}
		
		public function getClassFrom ( f : String, cl : String ) : Class
		{
			var gl : IGLoader = _loaderList[f];
			if ( gl is Loader ) var rcl : Class = Loader(gl).contentLoaderInfo.applicationDomain.getDefinition( cl ) as Class;
			
			return rcl;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// TODO passer les tous les events en type flash.events
		// (ProgressEvent.PROGRESS, Event.COMPLETE, etc....)
		
		private function progressEvent( e : Event ) : void
		{
			dispatchEvent( new GLibEvent( GLibEvent.ON_PROGRESS) );
		}
				
		private function GLoaderCompleteHandler( e : GLibEvent ) : void
		{
			var gl : IGLoader = e.currentTarget as IGLoader;
//			trace("CMOPLETE : " + gl.file);
			GLoaderComplete( gl );
		}
		
		private function GLoaderErrorHandler(e: GLibEvent) : void
		{
			trace("impossible de charger: " + e.currentTarget + " @" + this);
			var gl : IGLoader = e.currentTarget as IGLoader;
			GLoaderComplete(gl);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function GLoaderComplete( o : IGLoader ) : void
		{
			_toLoad--;
			if ( _toLoad == 0 ) {
//				trace( "GLib complete" );
				removeEventListener( Event.ENTER_FRAME, progressEvent );
				dispatchEvent( new GLibEvent( GLibEvent.ON_LIB_COMPLETE ) );
			} else {
				removeGloaderListener( o );
			}
		}
		
		private function removeGloaderListener ( o : IGLoader ) : void
		{
			o.removeEventListener( GLibEvent.ON_GLOADER_COMPLETE , GLoaderCompleteHandler );
			o.removeEventListener( GLibEvent.ON_GLOADER_ERROR , GLoaderErrorHandler );
		}
		
		private function checkFileExtension ( ext : String ) : Boolean
		{
			if ( ext == "swf" || ext == "jpg" || ext == "png" || ext == "gif"
				|| ext == "txt" || ext == "xml" || ext == "mp3") return true;
			
			return false;
		}
		
		public function getFileExtension ( s : String ) : String
		{
			var i : int = s.lastIndexOf(".");
			var ext : String = s.substring( (i + 1), s.length );
			return ext.toLowerCase();
		}
		
		
		private function createGloader( ext : String ) : IGLoader
		{
			var gl : IGLoader;
			switch ( ext ) {
				case "swf" :
					gl = new LLoader();
					break;
				case "png" :
					gl = new LLoader();
					break;
				case "jpg" :
					gl = new LLoader();
					break;
				case "txt" :
					gl = new ULoader();
					break;
				case "xml" :
					gl = new ULoader();
					break;
				case "mp3" :
					gl = new SLoader();
					break;
			}
			
			return gl;
		}
		
	}
	
}
