package com.sos21.lib  {

	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.Loader;

	/**
	 *	Loader fichier son
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  25.01.2011
	 */
	public class SLoader extends Sound implements IGLoader {
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _file:String;
		private var _vBytes : uint = 51200;
		private var _loaded : Boolean = false;
						
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get file () : String {
			return _file;
		}
		
		public function set file (f:String) : void {
			_file = f;
		}
		
		public function get vBytes () : uint 			{ return _vBytes; }
		public function set vBytes (b:uint) : void 	{ _vBytes = b; }
				
		public function get isLoaded () : Boolean
		{ return _loaded; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public function getLoader () : Loader {
			return null;
		}
		
		public function getContent () : Object {
			return this;
		}
		
		public function loadFile () : void {
			addListeners();
			load(new URLRequest(_file));
		}
		
		public function unload () : void {
			removeListeners()
			// close();
		}
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		private function completeHandler (e:Event) : void
		{
			_loaded = true;
			removeListeners();
			dispatchEvent(new GLibEvent(GLibEvent.ON_GLOADER_COMPLETE));
		}
		
      private function ioErrorHandler (e:IOErrorEvent) : void
		{ 
			removeListeners();
			dispatchEvent(new GLibEvent( GLibEvent.ON_GLOADER_ERROR));
		}
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------

		private function addListeners () : void
		{
			addEventListener(Event.COMPLETE, completeHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function removeListeners () : void
		{
			removeEventListener(Event.COMPLETE, completeHandler);
			removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
	
	}

}