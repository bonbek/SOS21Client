package com.sos21.utils {
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  18.07.2010
	 */
	public interface Condition {				
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function add (prim:Object, vVal:Object, vProp:Object = null) : void;
		function verify (val:* = void) : Boolean;
			
	}
}