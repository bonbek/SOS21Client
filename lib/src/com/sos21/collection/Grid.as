/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.collection {
	import flash.utils.Dictionary;
	import com.sos21.collection.Collection;
	import com.sos21.collection.Iterator;
	
	/**	// TODO documenter la classe 
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  25.02.2008
	 */
	public class Grid implements Collection {
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function Grid(w:int, h:int, d:int)
		{
			_w = w;
			_h = h;
			_d = d;
			_area = _w * _h;
			clear();
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _g:Dictionary;
		private var _w:int;
		private var _h:int;
		private var _d:int;
		private var _area:int;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get width():int
		{ return _w; }
		public function get height():int
		{ return _h; }
		public function get depth():int
		{ return _d; }
		public function get size():int
		{ return _w * _h * _d; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function set(x:int, y:int, z:int, o:Object):void
		{
			_g[x + (y * _h) + (z * _area)] = o;
		}
		
		public function get(x:int, y:int, z:int ):Object
		{
			return _g[x + (y * _h) + (z * _area)];
		}
		
		public function fill(o:Object):void
		{
			var n:int = size;
			while (--n > -1)
			{
				_g[n] = o;
			}
		}	
		
		public function contains(val:Object):Boolean
		{
			return toArray().indexOf(val) > -1;
		}
		
		public function clear():void
		{
			_g = new Dictionary(true);
		}
		
		public function toArray():Array /* of Object */
		{
			var a:Array /* od Object */ = [];
			for each (var p:Object in _g)
			{
				a.push(p);
			}
				
			return a;
		}
				
		public function getIterator():Iterator
		{
			return new GridIterator(toArray());
		}
		
	}
	
}

import com.sos21.collection.Iterator;
import com.sos21.collection.Grid;

internal class GridIterator implements Iterator {
	
	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------
	
	public function GridIterator(vals:Array)
	{
		v = vals;
		n = v.length;
		i = 0;
	}
	
	//--------------------------------------
	//  PRIVATE VARIABLES
	//--------------------------------------
	
	private var v:Array;
	private var n:int;
	private var i:int;
	
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------
	
	public function hasNext():Boolean
	{
		return i < n;
	}
	
	public function next():Object
	{
		return v[i++];
	}
	
}


