/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.lib {
	
	import flash.events.IEventDispatcher;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  23.11.2007
	 */
	public interface IGLoader extends IEventDispatcher
	{

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function getLoader() : Loader;
		function getContent() : Object;
		function loadFile() : void;
		function unload() : void;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function get file() : String;
		function set file( f : String ) : void;
		function get vBytes() : uint;
		function set vBytes( v : uint ) : void;
		function get bytesLoaded() : uint;
		function get bytesTotal() : int;
		function get isLoaded() : Boolean;
		
	}
	
}
