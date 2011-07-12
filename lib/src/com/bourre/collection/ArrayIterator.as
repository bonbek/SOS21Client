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
	import com.bourre.error.IndexOutOfBoundsException;	
	import com.bourre.error.NullPointerException;	
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NoSuchElementException;	

	/**
	 * The <code>ArrayIterator</code> utility provide a convenient way
	 * to iterate in an array as you can do with a <code>List</code>.
	 * <p>
	 * Iterations performed by the array iterator are done in the index
	 * order of the array. More formally the iterations are always realized
	 * from <code>0</code> to the <code>length</code> of the passed-in array.
	 * </p> 
	 * @author 	Cedric Nehemie
	 * @see		ListIterator
	 */
	public class ArrayIterator implements ListIterator 
	{
	    private var _aArray : Array;
	    private var _nSize : Number;
	    private var _nIndex : Number;
	    private var _bRemoved : Boolean;	    private var _bAdded : Boolean;

		/**
		 * Creates a new iterator over the passed-in array.
		 * 
		 * @param	a	<code>Array</code> target for this iterator
		 * @param	i	index at which the iterator start
		 * @throws 	<code>NullPointerException</code> — if the specified array is null
		 * @throws 	<code>IndexOutOfBoundsException</code> — if the index is out of range
		 */
		public function ArrayIterator ( a : Array, i : uint = 0 )
	    {
	    	if( a == null )
	    		throw new NullPointerException( "The target array of " + this + "can't be null" );
	    	if( i > a.length )
	    		throw new IndexOutOfBoundsException ( "The passed-in index " + i + " is not a valid for an array of length " + a.length );
		
			_aArray = a;
	        _nSize = a.length;
	        _nIndex = i - 1;
			_bRemoved = false;
			_bAdded = false;
		}

		/**
		 * @inheritDoc
		 */
	    public function hasNext () : Boolean
	    {
	        return ( _nIndex + 1 < _nSize );
	    }
	    
	    /**
		 * @inheritDoc
		 */
	    public function next () : *
	    {
	    	if( !hasNext() )
				throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex + 1 ) );
			
	    	_bRemoved = false;
			_bAdded = false;
			return _aArray[ ++_nIndex ];
	    }
		
		/**
		 * @inheritDoc
		 */
		public function remove () : void
		{
			if( _bRemoved )
			{
				_aArray.splice( _nIndex--, 1 );
				_nSize--;
				_bRemoved = true;
			}
			else
			{
				throw new IllegalStateException ( this + ".remove() have been already called for this iteration" );
			}
		}
		/**
		 * @inheritDoc
		 */
		public function add ( o : Object ) : void
		{
			if( !_bAdded )
			{
				_aArray.splice( _nIndex + 1, 0, o );
				_nSize++;
				_bAdded = true;
			}
			else
			{
				throw new IllegalStateException ( this + ".add() have been already called for this iteration" );
			}
		}
		/**
		 * @inheritDoc
		 */
		public function hasPrevious () : Boolean
		{
			return _nIndex >= 0;
		}
		/**
		 * @inheritDoc
		 */
		public function nextIndex () : uint
		{
			return _nIndex + 1;
		}

		/**
		 * @inheritDoc
		 */
		public function previous () : *
		{
			if( !hasPrevious() )
				throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex ) );
			
	    	_bRemoved = false;
			_bAdded = false;
			
			return _aArray[ _nIndex-- ];
		}

		/**
		 * @inheritDoc
		 */
		public function previousIndex () : uint
		{
			return _nIndex;
		}

		/**
		 * @inheritDoc
		 */
		public function set ( o : Object ) : void
		{
			if( !_bRemoved && !_bAdded )
			{
				_aArray[ _nIndex ] = o;
			}
			else
			{
				throw new IllegalStateException ( this + ".add() or " + this + ".remove() have been " +
												  "already called for this iteration, the set() operation cannot be done" );
			}
		}
	}
}
