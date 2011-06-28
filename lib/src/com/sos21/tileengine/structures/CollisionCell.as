/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.structures {
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  07.12.2007
	 */
	public class CollisionCell {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static var coll:int =	         parseInt( "1", 2 );	// collision					= 1
		public static var thro:int =	        parseInt( "10", 2 );	// traversable					= 2
		public static var climb:int =	       parseInt( "100", 2 );	// "montable"					=
		public static var ND:int = 		      parseInt( "1000", 2 );	// dénivélation nord		=
		public static var NED:int = 	     parseInt( "10000", 2 );	// dénivélation nord est	=
		public static var ED:int =	 	    parseInt( "100000", 2 );	// dénivélation est			=
		public static var SED:int = 	   parseInt( "1000000", 2 );	// dénivélation sud est		=
		public static var SD:int =	 	  parseInt( "10000000", 2 );	// dénivélation sud			=
		public static var SWD:int =	    parseInt( "100000000", 2 );	// dénivélation sud ouest	=
		public static var WD:int =	 	parseInt( "1000000000", 2 );	// ouest							=
		public static var NWD:int =	  parseInt( "10000000000", 2 );	// nord ouest					=
		
		public static var DEFAULTCOST:int = 0;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *	
		 *	@arg val : String valeur à convertir en base 2;
		 */
		public function CollisionCell(val:int = 0, cost:int = 0)
		{
			_v = val;
			_cost = cost;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _v:int;
		private var _cost:int;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get value():int
		{
			return _v;
		}
		
		public function get collision():Boolean
		{
			return Boolean(_v & coll);
		}
		
		public function get throwable():Boolean
		{
			return Boolean(_v & thro);
		}
		
		public function get climbable():Boolean
		{
			return Boolean(_v & climb);
		}
		
		public function get N() : Boolean { return( Boolean( _v & ND ) ) }
		public function get NE() : Boolean { return( Boolean( _v & NED ) ) }
		public function get E() : Boolean { return( Boolean( _v & ED ) ) }
		public function get SE() : Boolean { return( Boolean( _v & SED ) ) }
		public function get S() : Boolean { return( Boolean( _v & SD ) ) }
		public function get SW() : Boolean { return( Boolean( _v & SWD ) ) }
		public function get W() : Boolean { return( Boolean( _v & WD ) ) }
		public function get NW() : Boolean { return( Boolean( _v & NWD ) ) }
		
		public function get cost():int
		{
			return _cost;
		}
		
		public function set cost(val:int):void
		{
			_cost = val;
		}		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
