/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.proxy {
	import com.sos21.observer.INotifier;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  30.01.2008
	 */
	public interface IProxy extends INotifier {
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function get name():String

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function getData():Object;
		function initialize():void;
		
	}
	
}
