/* AS3
	Copyright 2008 sos-21.com
*/
package com.sos21.collection {
	import flash.utils.Dictionary;
	
	import com.sos21.collection.Collection;
	import com.sos21.collection.Iterator;
	import com.sos21.collection.Iterator;
	
	/**
	 *	A hash map
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  23.01.2008
	 */
	public class HashMap implements Collection {
		
		/**
		 *	@Constructor
		 */
		public function HashMap()
		{
			_init();
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _kD:Dictionary;
		private var _vD:Dictionary;
		private var _size:int;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get size():uint
		{	
			return _size;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*
		*	Insert a new key:value pair in the map
		*	@param	key : key
		*	@param	val : value associated with the key
		*/
		public function insert(key:Object, val:Object):Boolean
		{
			if (_kD[key] != null)
				return false;
				
			_kD[key] = val;
			_vD[val] = key;
			_size++;
			
			return true;
		}
		
		/*
		*	Search the value mapped by the given key
		*	@return	value of the given key if exists, otherwise null
		*/
		public function find(key:Object):Object
		{
			return _kD[key] || null;
		}
		
		/*
		*	Search the key entry for the given val	
		*	@return	the key if exists, otherwise null
		*/ 
		public function findKey(val:Object):Object
		{
			return _vD[val] || null;
		}
		
		/*
		*	Check if an entry map the given value
		*	@return	true if the entry exists, otherwise false
		*/
		public function contains(val:Object):Boolean
		{
			return _vD[val] ? true : false;
		}
		
		/*
		*	Check if an entry map the given key
		*	@return true if the entry exists, otherwise false
		*/ 
		public function containsKey(key:Object):Boolean
		{
			return _kD[key] ? true : false;
		}
		
		/*
		*	Remove entry from the given key
		*	@return	key value or null if no matching found
		*/
		public function remove(key:Object):Object
		{
			if (!containsKey(key))
				return null;
			
			var o:Object = _kD[key];
			delete _kD[key];
			delete _vD[o];
			_size--;
			
			return o;			
		}
		
		/*
		*	Overwrite an entry
		*	@return	old value if the entry exist else return null
		*/
		public function overwrite(key:Object, val:Object):Object
		{
			if (!containsKey(key))
				return null
			
			var o:Object = _kD[key];
			_kD[key] = val;
			
			return o;
		}
		
		/*
		*	Clear the whole HashMap
		*/
		public function clear():void
		{
			_init();
		}
		
		/*
		*	Return Iterator
		*/
		public function getIterator():Iterator
		{
			return new HashMapIterator(toArray());
		}
		
		/*
		*	Return Array of HashMap values
		*/
		public function toArray():Array /* of Object */
		{
			var a:Array /* of Object */ = [];
			for each (var p:Object in _kD)
			{
				a.push(p);
			}
				
			return a;
		}
		
		/*
		*	Return Array of HashMap Keys
		*/
		public function keyToArray():Array /* of Object */
		{
			var a:Array /* of Object */ = [];
			for each (var p:Object in _vD)
			{
				a.push(p);
			}
				
			return a;			
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function _init():void
		{
			_kD = new Dictionary(true);
			_vD = new Dictionary(true);
			_size = 0;
		}
		
	}
	
}


import com.sos21.collection.Iterator;

internal class HashMapIterator implements Iterator {
	
	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------
	
	public function HashMapIterator(vals:Array)
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