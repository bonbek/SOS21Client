/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.collection {
	import com.sos21.collection.Iterator;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  23.01.2008
	 */
	public interface Collection { // TODO dev de l'interface
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function contains(val:Object):Boolean
		function clear():void
		function toArray():Array
		function getIterator():Iterator
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	}
	
}
