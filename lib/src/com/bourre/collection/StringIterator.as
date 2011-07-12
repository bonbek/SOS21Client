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
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.IndexOutOfBoundsException;
	import com.bourre.error.NullPointerException;	

	/**
	 * The <code>StringIterator</code> utility provide a convenient way
	 * to iterate over the character of a string as you can do with a
	 * <code>List</code>.
	 * <p>
	 * Iterations performed by the string iterator are done in the index
	 * order of the string. More formally the iterations are always realized
	 * from <code>0</code> to the <code>length</code> of the passed-in string.
	 * </p>
	 * @author 	Cédric Néhémie
	 * @see		ListIterator
	 */
	public class StringIterator implements ListIterator 
	{
		private var _sString : String;
		private var _nSize : Number;
		private var _nIndex : Number;
		private var _bRemoved : Boolean;
		private var _bAdded : Boolean;
		
		/**
		 * Creates a new string iterator over the character
		 * of the passed-in string.
		 * 
		 * @param	s	<code>String</code> target of this iterator
		 * @param	i	index at which the iterator start
		 * @throws 	<code>NullPointerException</code> — if the specified string is null
		 * @throws 	<code>IndexOutOfBoundsException</code> — if the index is out of range
		 */
		public function StringIterator ( s : String, i : uint = 0 ) 
		{
			if( s == null )
	    		throw new NullPointerException( "The target string of " + this + "can't be null" );
	    	if( i > s.length )
	    		throw new IndexOutOfBoundsException ( "The passed-in index " + i + " is not a valid for a string of length " + s.length );
		
			_sString = s;
			_nSize = _sString.length;
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
				
			_bAdded = false;
	    	_bRemoved = false;
			return _sString.substr( ++_nIndex, 1 );
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove () : void
		{
			if( !_bRemoved )
			{
				_sString.slice( _nIndex--, 1 );
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
		 * @throws 	<code>IllegalArgumentException</code> — The passed-in string couldn't be added due to its length
		 */
		public function add (o : Object) : void
		{
			if( !_bAdded )
			{
				if( ( o as String ).length != 1 )
				{
					throw new IllegalArgumentException ( "The passed-in character couldn't be added in " +
														 this + ".add(), expected length 1, get " + (o as String).length );
				}
				_sString = _sString.substr( 0, _nIndex + 1 ) + o + _sString.substring( _nIndex + 1 );
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
				
			_bAdded = false;
	    	_bRemoved = false;
			return _sString.substr( _nIndex--, 1 );
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
		 * @throws 	<code>IllegalArgumentException</code> — The passed-in string couldn't be set due to its length
		 */
		public function set (o : Object) : void
		{
			if( !_bRemoved && !_bAdded )
			{
				if( ( o as String ).length != 1 )
				{
					throw new IllegalArgumentException ( "The passed-in character couldn't be added in " +
														 this + ".add(), expected length 1, get " + (o as String).length );
				}
				_sString = _sString.substr( 0, _nIndex ) + o + _sString.substr( _nIndex + 1 );
			}
			else
			{
				throw new IllegalStateException ( this + ".add() or " + this + ".remove() have been " +
												  "already called for this iteration, the set() operation cannot be done" );
			}
		}
	}
}
