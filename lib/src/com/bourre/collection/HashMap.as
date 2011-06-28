/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.bourre.collection
{
	import flash.utils.Dictionary;
	
	import com.bourre.error.NullPointerException;
	import com.bourre.log.*;		

	/**
	 * An object that maps keys to values.  A map cannot contain duplicate keys;
	 * each key can map to at most one value.
	 * <p>
	 * The "destructive" methods contained in this interface, that is, the
	 * methods that modify the map on which they operate, are specified to throw
	 * <code>UnsupportedOperationException</code> if this map does not support the
	 * operation.  If this is the case, these methods may, but are not required
	 * to, throw an <code>UnsupportedOperationException</code> if the invocation would
	 * have no effect on the map.  For example, invoking the <code>putAll(Map)</code>
	 * method on an unmodifiable map may, but is not required to, throw the
	 * exception if the map whose mappings are to be "superimposed" is empty.
	 * </p><p>
	 * Some map implementations have restrictions on the keys and values they
	 * may contain.  For example, some implementations prohibit null keys and
	 * values, and some have restrictions on the types of their keys.  Attempting
	 * to insert an ineligible key or value throws an unchecked exception,
	 * typically <code>NullPointerException</code> or <code>ClassCastException</code>.
	 * Attempting to query the presence of an ineligible key or value may throw an
	 * exception, or it may simply return false; some implementations will exhibit
	 * the former behavior and some will exhibit the latter.  More generally,
	 * attempting an operation on an ineligible key or value whose completion
	 * would not result in the insertion of an ineligible element into the map may
	 * throw an exception or it may succeed, at the option of the implementation.
	 * Such exceptions are marked as "optional" in the specification for this
	 * interface.
	 * </p><p>
	 * Many methods in Collections Framework interfaces are defined
	 * in terms of the <code>===</code> operator.  For example, the
	 * specification for the <code>containsKey( key : Object )</code>
	 * method says: "returns <code>true</code> if and
	 * only if this map contains a mapping for a key <code>k</code> such that
	 * <code>key === k</code>." This specification should
	 * <i>not</i> be construed to imply that invoking <code>HashMap.containsKey</code>
	 * with a non-null argument <code>key</code> will cause <code>key === k</code> to
	 * be invoked for any key <code>k</code>.  Implementations are free to
	 * implement optimizations whereby the <code>===</code> invocation is avoided,
	 * for example, by first comparing the hash codes of the two keys.  (The
	 * <code>HashCodeFactory.getKey(Object)</code> specification guarantees that two
	 * objects with unequal hash codes cannot be equal.) More generally, implementations of
	 * the various Collections Framework interfaces are free to take advantage of
	 * the specified behavior of underlying <code>Object</code> methods wherever the
	 * implementor deems it appropriate.
	 * </p>
	 * @author  Francis Bourre
	 */
	public class HashMap 
	{
		/**
		 * Number of mappings currently in this map
		 */
		protected var _n : uint;
		
		/**
		 * A dictionnary which stores the mapping (key - value)
		 * for this map.
		 */
		protected var _oKeyDico : Dictionary;
		
		/**
		 * A dictionnary which store the mapping (value - 
		 * occurrences count) for this map.
		 */
		protected var _oValueDico : Dictionary;
		
		/**
		 * Creates a new empty hash map object.
		 */
		public function HashMap()
		{
			_init();
		}
		
		/**
		 * Realize the concret initialization for this map
		 */
		protected function _init() : void
		{
			_n = 0;
			_oKeyDico = new Dictionary( true );
			_oValueDico = new Dictionary( true );
		}
		
	    /**
	     * Removes all of the mappings from this map (optional operation).
	     * The map will be empty after this call returns.
	     */
		public function clear() : void
		{
			_init();
		}
		
	    /**
	     * Returns <code>true</code> if this map contains no key-value mappings.
	     *
	     * @return <code>true</code> if this map contains no key-value mappings
	     */
		public function isEmpty() : Boolean
		{
			return ( _n == 0 );
		}
		
		/**
	     * Returns <code>true</code> if this map contains a mapping for the specified
	     * key.  More formally, returns <code>true</code> if and only if
	     * this map contains a mapping for a key <code>k</code> such that
	     * <code>key === k</code>.  (There can be at most one such mapping.)
	     *
	     * @param	key	 key object whose presence in this map is to be tested
	     * @return 	<code>true</code> if this map contains a mapping for the specified
	     *         	key
	     * @throws 	<code>NullPointerException</code> —  if the specified key is null
	     */
		public function containsKey( key : * ) : Boolean
		{
			if( key == null )
			{
				PixlibDebug.ERROR( this + ".containsKey() failed. key can't be null" );
				throw new NullPointerException( this + ".containsKey() failed. key can't be null" );
			}
			return _oKeyDico[ key ] != null;
		}
		
		/**
	     * Returns <code>true</code> if this map maps one or more keys to the
	     * specified value.  More formally, returns <code>true</code> if and only if
	     * this map contains at least one mapping to a value <code>v</code> such that
	     * <code>(value === v)</code>.
	     * 
	     * @param	value	value whose presence in this map is to be tested
	     * @return <code>true</code> if this map maps one or more keys to the
	     *         specified value
	     */
		public function containsValue( value : * ) : Boolean
		{
			return _oValueDico[ value ] != null;
		}
		
	    /**
	     * Associates the specified value with the specified key in this map
	     * (optional operation).  If the map previously contained a mapping for
	     * the key, the old value is replaced by the specified value.  (A map
	     * <code>m</code> is said to contain a mapping for a key <code>k</code> 
	     * if and only if <code>m.containsKey(k)</code> would return
	     * <code>true</code>.)
	     *
	     * @param	key 	key with which the specified value is to be associated
	     * @param	value 	value to be associated with the specified key
	     * @return 	the previous value associated with <code>key</code>, or
	     *         	<code>null</code> if there was no mapping for <code>key</code>.
	     *         	(A <code>null</code> return can also indicate that the map
	     *         	previously associated <code>null</code> with <code>key</code>,
	     *         	if the implementation supports <code>null</code> values.)
	     * @throws 	<code>NullPointerException</code> —  if the specified key or value is null
	     */
		public function put ( key : *, value : * ) : *
		{
			if (key != null)
			{
				var oldVal : * = null;
				
				if ( containsKey( key ) ) oldVal = remove( key );
				
				_n++;
				var count : uint = _oValueDico[ value ];
				_oValueDico[ value ] = (count > 0) ? count+1 : 1;
				_oKeyDico[ key ] = value;
				
				return oldVal;
			}
			else
			{
				PixlibDebug.ERROR( this + ".put() failed. key can't be null" );
				throw new NullPointerException( this + ".put() failed. key can't be null" );
			}
		}
		
		/**
	     * Returns the value to which the specified key is mapped,
	     * or <code>null</code> if this map contains no mapping for the key.
	     * <p>
	     * More formally, if this map contains a mapping from a key
	     * <code>k</code> to a value <code>v</code> such that 
	     * <code>(key === k)</code>, then this method returns <code>v</code>; otherwise
	     * it returns <code>null</code>.  (There can be at most one such mapping.)
	     * </p><p>
	     * As this map permits null values, a return value of <code>null</code>
	     * does not <i>necessarily</i> indicate that the map contains no mapping
	     * for the key; it's also possible that the map explicitly maps the key to
	     * <code>null</code>. The <code>containsKey</code> operation may be used
	     * to distinguish these two cases.
	     * </p>
	     * @param	key 	the key whose associated value is to be returned
	     * @return 	the value to which the specified key is mapped, or
	     *         	<code>null</code> if this map contains no mapping for the key
	     * @throws 	<code>NullPointerException</code> —  if the specified key is null
	     */
		public function get ( key : * ) : *
		{
			if( key == null )
			{
				PixlibDebug.ERROR( this + ".get() failed. key can't be null" );
				throw new NullPointerException( this + ".get() failed. key can't be null" );
			}
			return _oKeyDico[ key ];
		}
		
		/**
	     * Removes the mapping for a key from this map if it is present
	     * (optional operation). More formally, if this map contains a mapping
	     * from key <code>k</code> to value <code>v</code> such that
	     * <code>(key === k)</code>, that mapping is removed. 
	     * (The map can contain at most one such mapping.)
	     * <p>
	     * Returns the value to which this map previously associated the key,
	     * or <code>null</code> if the map contained no mapping for the key.
	     * </p><p>
	     * As this map permits null values, then a return value of
	     * <code>null</code> does not <i>necessarily</i> indicate that the map
	     * contained no mapping for the key; it's also possible that the map
	     * explicitly mapped the key to <code>null</code>.
	     * </p><p>
	     * The map will not contain a mapping for the specified key once the
	     * call returns.
	     * </p>
	     * @param	key		key whose mapping is to be removed from the map
	     * @return 	the previous value associated with <code>key</code>, or
	     *         	<code>null</code> if there was no mapping for <code>key</code>.
	     * @throws 	<code>NullPointerException</code> —  if the specified key is null 
	     */
		public function remove( key : * ) : *
		{
			var value : *;
			
			if ( containsKey( key ) ) 
			{
				_n--;
				value = _oKeyDico[ key ];
				
				var count : uint = _oValueDico[ value ];
				if (count > 1)
				{
					_oValueDico[ value ] = count - 1;
				} else
				{
					delete _oValueDico[ value ];
				}
				
				delete _oKeyDico[ key ];
			}
			
			return value;
		}
		
		/**
	     * Returns the number of key-value mappings in this map.
	     *
	     * @return the number of key-value mappings in this map
	     */
		public function size() : Number
		{
			return _n;
		}
		
		/**
	     * Returns an <code>Array</code> view of the keys contained in this map.
	     *
	     * @return an array view of the keys contained in this map
	     */
		public function getKeys() : Array
		{
			var a : Array = new Array();
			for ( var key : * in _oKeyDico ) a.push( key );
			return a;
		}
		/**
	     * Returns an <code>Array</code> view of the values contained in this map.
	     *
	     * @return an array view of the values contained in this map
	     */
		public function getValues() : Array
		{
			var a : Array = new Array();
			for each ( var value : * in _oKeyDico ) a.push( value );
			return a;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}