/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.utils {
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  04.04.2008
	 */
	public class Delegate {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function create (ref:Function, ...args):Function
		{
			return function(...rest):*
			{
				ref.apply(this, rest.concat(args));
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
