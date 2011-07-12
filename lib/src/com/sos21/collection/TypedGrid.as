/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.collection {	
	import com.sos21.debug.log;
	import com.sos21.collection.Grid;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  07.12.2007
	 */
	public class TypedGrid extends Grid {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
				
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TypedGrid( ix : int, iy : int, iz : int, cellType : Class, nullCell : Object = null )
		{
			super( ix, iy, iz );
			_nullCell = nullCell;
			_cellType = cellType;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _cellType : Class;
		private var _nullCell : Object;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/*
		*	Return the cell type of this TypedGrid instance
		*/
		public function get cellType():Class
		{ return _cellType }
		
		/*
		*	Return the null cell Object of this instance
		*/
		public function get nullCell():Object
		{ return _nullCell }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*
		*	Add a cell to the grid
		*	@param	ix : x coordinate of the cell
		*	@param	iy : y coordinate of the cell
		*	@param	iz : z coordinate of the cell
		*	@param	cell : Object instance
		*	@return	true cell added otherwise false if the grid already contains
		*				an Object at given coordinates or if the cell not match the correct type
		*/
		public function addCell( ix : int, iy : int, iz : int, cell : Object ) : Boolean
		{
			if ( get( ix, iy, iz ) != null || cell is _cellType == false )
				return false;
			
			set( ix, iy, iz, cell );
//trace( _cellType );
			return true;
		}
		
		public function getCell(ix:int, iy:int, iz:int):*
		{	
			var c:Object = get(ix, iy, iz);
			if (!(c is _cellType))
			 	return _nullCell;
			
			return c;
		}
		
		public function replaceCell( ix : int, iy : int, iz : int, cell : Object ) : void
		{
			set( ix, iy, iz, cell );
		}
		
		public function emptyClone( ) : TypedGrid
		{
			return new TypedGrid( width, height, depth, _cellType, _nullCell );
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
