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
	import com.bourre.error.*;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * The Stack class represents a last-in-first-out (LIFO) stack
	 * of objects. The usual <code>push</code> and <code>pop</code>
	 * operations are provided, as well as a method to <code>peek</code>
	 * at the top item on the stack, a method to test for whether the stack
	 * is empty, and a method to <code>search</code> the stack for an item
	 * and discover how far it is from the top.
	 * <p>
	 * When a stack is first created, it contains no items.
	 * </p>
	 * @author Romain Flacher
	 * @author Cédric Néhémie
	 * @see List
	 * @example Using a <code>Stack</code>
	 * <listing>
	 * var stack : Stack = new Stack ( Number );
	 * stack.push( 20 );
	 * 
	 * try
	 * {
	 * 	stack.push("20"); // fail, as "20" isn't a Number
	 * }
	 * catch( e : ClassCastException )
	 * {
	 * 	trace( e );
	 * }
	 * </listing>
	 */
	public class Stack implements List, TypedContainer
	{
		private var _aStack : Array;
		private var _oType : Class;
		
		/**
		 * Create an empty Stack.
		 * <p>
		 * You can pass the type for stack elements as argument
		 * of the constructor. In that case the stack is considered
		 * as typed
		 * </p> 
		 * @param	type A <code>Class</code> instance used as type for elements
		 * @throws 	<code>ClassCastException</code> — if the class of the specified
		 * 		   	elements prevents it from being added to this list.
		 */
		public function Stack (type : Class = null, content : Array = null )
		{
			this._aStack = new Array();
			this._oType = type;
			
			if( content )
			{
				var l : Number = content.length;
				
				for( var i : Number = 0; i < l ; i++ )
				{
					add ( content[ i ] );
				}
			}
		}
		
		
		/**
		 * Appends the specified element to the end of this stack.
		 * 
		 * @param	o 	element to be appended to this Stack
		 * @return 	<code>true</code> if this stack has changed as result
		 * 			of the call (as per the general contract of Collection.add).
		 * @see		#push() push()
		 * @throws 	<code>ClassCastException</code> — if the class of the specified
		 * 		   	element prevents it from being added to this list.
		 * @example Adding elements to an untyped stack
		 * <listing>
		 * var stack : Stack = new Stack();
		 * 
		 * stack.add( 50 );
		 * stack.add( "foo" );
		 * 
		 * trace( stack.add( "foo" ) ); // true, because stack allow one or more entries
		 * 								// for an element
		 * 
		 * trace( stack.size() ); // 3
		 * </listing>
		 * 
		 * Adding elements to a typed stack
		 * <listing>
		 * var stack : Stack = new Stack( String );
		 * 
		 * stack.add( "foo" );
		 * 
		 * trace( stack.add( "foo" ) ); // true, because stack allow one or more occurrences
		 * 								// for an element
		 * 								
		 * try
		 * {
		 * 	stack.add( 50 ); // fail, as 50 is not a string
		 * }
		 * catch( e : ClassCastException )
		 * {
		 * 	trace ( e );
		 * }
		 * 
		 * trace( stack.size() ); // 2
		 * </listing>
		 */
		public function add( o : Object ) : Boolean
		{
			push(o);
			return true;
		}
		
		/**
		 * Inserts the specified element at the specified position
		 * in this stack. Shifts the element currently at that
		 * position (if any) and any subsequent elements to the
		 * right (adds one to their indices).
		 * 
		 * @param	index 	<code>uint</code> index at which the specified
		 * 					element is to be inserted.
		 * @param	o 		element to be inserted.
		 * @throws 	<code>IndexOutOfBoundsException</code> — index is out of range
		 * 		   	(index < 0 || index > size()).
		 * @throws 	<code>ClassCastException</code> — if the class of the specified
		 * 		   	element prevents it from being added to this list.
		 * @see		#add() add()
		 */
		public function addAt(index:uint, o:Object) : void
		{
			isValidIndex ( index );
			_aStack.splice( index, 0, o );
		} 
		
		/**
		 * Appends all of the elements in the specified Collection
		 * to the end of this stack, in the order that
		 * they are returned by the specified Collection's Iterator. 
		 * The behavior of this operation is undefined if the
		 * specified Collection is modified while the operation
		 * is in progress. (This implies that the behavior of this
		 * call is undefined if the specified Collection is this
		 * stack, and this stack is nonempty.)
		 * <p>
		 * The rules which govern collaboration between typed and untyped
		 * <code>Collection</code> are described in the <code>isValidCollection</code>
		 * descrition, all rules described there are supported by the
		 * <code>containsAll</code> method.
		 * </p>
		 * @param	c 	elements to be inserted into this stack.
		 * @return 	<code>true</code> if this stack changed as a result of the call.
		 * @throws 	<code>ClassCastException</code> — if the class of an element of the specified
	     * 	       collection prevents it from being added to this collection.
	     * @throws 	<code>NullPointerException</code> — if the passed in collection is null.
	     * @see		#add() add()
	     * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 */
		public function addAll(c:Collection):Boolean
		{
			isValidCollection( c );
			
			var iter : Iterator = c.iterator();
			var modified : Boolean = false;
			while(iter.hasNext())
			{
				modified = add( iter.next() ) || modified;
			}
			return modified;
			
		}
		
		/**
		 * Inserts all of the elements in the specified Collection into
		 * this stack at the specified position. Shifts the element
		 * currently at that position (if any) and any subsequent
		 * elements to the right (increases their indices). The new
		 * elements will appear in the stack in the order that
		 * they are returned by the specified Collection's iterator.
		 * <p>
		 * The rules which govern collaboration between typed and untyped
		 * <code>Collection</code> are described in the <code>isValidCollection</code>
		 * descrition, all rules described there are supported by the
		 * <code>containsAll</code> method.
		 * </p>
		 * @param 	index 	<code>uint</code> index at which to insert
		 * 					first element from the specified collection.
		 * @param 	c 		elements to be inserted into this stack.
		 * @return 	<code>true</code> if this stack changed as a result of the call.
		 * @throws 	<code>IndexOutOfBoundsException</code> — index is out of range
		 * 		   	(index < 0 || index > size()).
		 * @throws 	<code>ClassCastException</code> — if the class of an element of
		 * 			the specified collection prevents it from being added to this collection.
	     * @throws 	<code>NullPointerException</code> — if the passed in collection is null.
	     * @see		#add() add()	     * @see		#addAt() addAt()	     * @see		#addAll() addAll()
	     * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 */
		public function addAllAt( index : uint, c : Collection ) : Boolean
		{
			isValidIndex ( index );
			isValidCollection( c );
			
			var i : Iterator = c.iterator();
			
			while(i.hasNext())
			{
				addAt( index++, i.next() );
			}
			
			return true;
		}
		
		/**
		 * Removes a single instance of the specified element from this
	     * stack, if this stack contains one or more such elements.
	     * Returns <code>true</code> if this stack contained the specified
	     * element (or equivalently, if this collection changed as a result
	     * of the call).
	     * <p>
	     * In order to remove all occurences of an element you have to call
	     * the <code>remove</code> method as long as the stack contains an
	     * occurrence of the passed-in element. Typically, the construct to
	     * remove all occurrences of an element should look like that :
	     * <listing>
	     * while( stack.contains( element ) ) stack.remove( element );
	     * </listing>
	     * </p><p>
		 * If the current stack object is typed and if the passed-in object's  
		 * type prevents it to be added (and then removed) in this stack,
		 * the function throws a <code>ClassCastException</code>.
		 * </p> 
	     * @param	o 	<code>object</code> to be removed from this stack,
	     * 			  	if present.
		 * @return 	<code>true</code> if the stack contained the 
		 * 			specified element.
	     * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack
		 * @example Using the <code>Stack.remove()</code> method with an untyped stack : 
		 * <listing>
		 * var stack : Stack = new Stack();
		 * stack.add ( "foo" );
		 * stack.add ( "foo" );
		 * 
		 * trace( stack.size() ); // 1
		 * trace( stack.remove( "foo" ) ); // true, the first occurence of 'foo' have
		 * 								   // been removed from the stack
		 * 
		 * trace( stack.size() ); // 1
		 * trace( stack.remove( "foo" ) ); // true, the passed-in value has always
		 * 								   // an occurence contained in the stack
		 * 
		 * trace( stack.size() ); // 0
		 * trace( stack.remove( "foo" ) ); // false, as there is no more occurence
		 * 								   // in the stack
		 * </listing>
		 * 
		 * Using the <code>Stack.remove()</code> method with a typed stack :
		 * 
		 * <listing>
		 * var stack : Stack = new Stack( String );
		 * stack.add ( "foo" );
		 * 
		 * trace( stack.size() ); // 1
		 * trace( stack.remove( "foo" ) ); // true, the passed-in value have been removed
		 * 
		 * // the code below will produce an exception
		 * try
		 * {
		 * 	stack.remove( 45 ); // fail, as the passed-in value is not of type string
		 * }
		 * catch( e : ClassCastException )
		 * {
		 * 	trace ( e );  
		 * }
		 * </listing>
		 */
		public function remove( o : Object ) : Boolean
		{
			if( isValidType( o ) && contains( o ) )
			{
				_aStack.splice( _aStack.indexOf( o ), 1 );
				return true;
			}
			return false;
		}
		
		/**
		 * Removes the element at the specified position in this stack.
		 * Shifts any subsequent elements to the right (subtracts one from
		 * their indices).
		 * 
		 * @copy	com.bourre.collection.Stack#remove()
		 * @param	index 	<code>uint</code> index at which to remove an element
		 * 				  	from the specified <code>Collection</code>.
		 * @return 	<code>true</code> if the object have been removed, false otherwise.
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this stack
		 * @see		#remove() remove()
		 * @example Using the <code>Stack.removeAt</code> method with an untyped stack
		 * <listing>
		 * var stack : Stack = new Stack();
		 * stack.add( "foo1" );
		 * stack.add( "foo2" );
		 * stack.add( "foo3" );
		 * 
		 * trace ( stack.removeAt( 2 ) ); // return true, 'foo3' have been removed
		 * trace ( stack.removeAt( 0 ) ); // return true, 'foo1' have been removed  
		 * 								// and 'foo2' is now at index 0
		 * 
		 * try
		 * {
		 * 	stack.removeAt( 1 ); // fail, as stack have only one entry at index 0
		 * }
		 * catch( e : IndexOutOfBoundsException )
		 * {
		 * 	trace( e );
		 * }
		 * </listing>
		 */
		public function removeAt( index : uint ) : Boolean
		{
			isValidIndex ( index );
			_aStack.splice( index, 1 );
			return true;			
		}
		
		/**
		 * Removes from this stack all of its elements that are contained
		 * in the specified collection (optional operation). At the end
		 * of the call there's no occurences of any elements contained
		 * in the passed-in collection.
		 * <p>
		 * The rules which govern collaboration between typed and untyped
		 * <code>Collection</code> are described in the <code>isValidCollection</code>
		 * descrition, all rules described there are supported by the
		 * <code>removeAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> that defines which elements will be
		 * 			  	removed from this stack.
		 * @return 	<code>true</code> if this stack changed as a result
		 * 			of the call.
		 * @throws 	<code>NullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.    
		 * @see    	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example Using the <code>Stack.removeAll()</code> with untyped stacks
		 * <listing>
		 * var stack1 : Stack = new Stack();
		 * var stack2 : Stack = new Stack();
		 * 
		 * stack1.add( 1 );
		 * stack1.add( 2 );
		 * stack1.add( 3 );
		 * stack1.add( 4 );
		 * stack1.add( "foo1" );
		 * stack1.add( "foo2" );
		 * stack1.add( "foo3" );
		 * stack1.add( "foo4" );
		 * 
		 * stack2.add( 1 );
		 * stack2.add( 3 );
		 * stack2.add( "foo1" );
		 * stack2.add( "foo3" );
		 * 
		 * trace ( stack1.removeAll ( stack2 ) ) ;// true
		 * // stack1 now contains :
		 * // 2, 4, 'foo2', 'foo4' 
		 * </listing>
		 */
		public function removeAll( c : Collection ) : Boolean
		{
			if( isValidCollection( c ) )
			{	
				var iter : Iterator = c.iterator();
				var find : Boolean = false;
				
				while(iter.hasNext( ))
				{
					var o : * = iter.next();
					while( this.contains( o ) )
					{
						find = this.remove( o ) || find;
					}
				}			
				return find;
			}
			return false;
		}
		
		/**
		 * Retains only the elements in this stack that are contained
		 * in the specified collection (optional operation). In other words,
		 * removes from this stack all of its elements that are not
		 * contained in the specified collection.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>retainAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> that defines which elements this
		 * 			  	stack will retain.
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	<code>NullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 * @see 	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example Using the <code>Stack.retainAll()</code> with untyped stacks
		 * <listing>
		 * var stack1 : Stack = new Stack();
		 * var stack2 : Stack = new Stack();
		 * 
		 * stack1.add( 1 );
		 * stack1.add( 2 );
		 * stack1.add( 3 );
		 * stack1.add( 4 );
		 * stack1.add( "foo1" );
		 * stack1.add( "foo2" );
		 * stack1.add( "foo3" );
		 * stack1.add( "foo4" );
		 * 
		 * stack2.add( 1 );
		 * stack2.add( 3 );
		 * stack2.add( "foo1" );
		 * stack2.add( "foo3" );
		 * 
		 * trace ( stack1.retainAll ( stack2 ) ) ;// true
		 * // stack1 now contains :
		 * // 1, 3, 'foo1', 'foo3' 
		 * </listing>
		 */
		public function retainAll(c:Collection):Boolean
		{
			if( isValidCollection( c ) )
			{
				var modified : Boolean = false;
				var fin : int = _aStack.length;
				var id : int = 0;
				while(id < fin)
				{
					var obj : * = _aStack[id];
					if(!c.contains( obj ))
					{
						var fromIndex : int = 0;
						while(true)
						{
							fromIndex = _aStack.indexOf( obj, fromIndex );
							if(fromIndex == -1)
							{
								break;
							}
							modified = true;
							_aStack.splice( fromIndex, 1 );
							--fin;
						}
					}else
					{
						++id;
					}
				}
				return modified;
			}
			return false;
		}
		
		/**
		 * Returns <code>true</code> if this stack contains at least
		 * one occurence of the specified element. Moreformally,
		 * returns <code>true</code> if and only if this stack contains
		 * at least an element <code>e</code> such that <code>o === e</code>.
		 *
		 * @param	o	<code>Object</code> whose presence in this stack
		 * 			  	is to be tested.
		 * @return 	<code>true</code> if this stack contains the specified
		 * 			element.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack
		 */
		public function contains(o:Object):Boolean
		{
			return _aStack.indexOf(o) != -1;
		}
	
		/**
		 * Returns true if this <code>Stack</code> contains all of the elements
		 * in the specified Collection.
		 * 
		 * @param	c 	a collection whose elements will be tested for
		 *          containment in this <code>Stack</code>
		 * @return	<code>true</code> if this <code>Stack</code> contains all of the elements
		 *         	in the specified collection.
		 * @throws 	<code>NullPointerException</code> — if the passed in collection is null.
		 */
		public function containsAll(c:Collection):Boolean
		{
			if( isValidCollection( c ) )
			{
				var iter : Iterator = c.iterator( );
				
				//if one element is not in this collection return false
				//else if all elements is in return true
				while( iter.hasNext( ) )
				{
					if( !contains( iter.next( ) ) )
						return false;
				}
				return true;
			}
			return false;
		}
		
		/**
		 * Searches for the first occurence of the given argument.
		 * 
		 * @param	o 	an object to search in the stack
		 * @return	the index of the first occurrence of the object argument
		 * 		   	in this stack, that is, the smallest value <code>k</code>
		 * 		   	such that <code>(elem === elementData[k]) && (k >= index)</code>
		 * 		   	is true; returns <code>-1</code> if the object is not found.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack
		 */
		public function search( o : Object ) : int
		{
			return _aStack.indexOf(o);
		}		
		
		/**
		 * Searches for the first occurence of the given argument.
		 * 
		 * @param	o 	an object
		 * @return	the index of the first occurrence of the object argument
		 * 		   	in this stack, that is, the smallest value <code>k</code>
		 * 		   	such that <code>(elem === elementData[k]) && (k >= index)</code>
		 * 		   	is true; returns <code>-1</code> if the object is not found.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack
		 */
		public function indexOf( o : Object ) : int
		{
			isValidType( o );
			return _aStack.indexOf(o);
		}
		
		/**
		 * Returns the index of the last occurrence of the specified
		 * object in this <code>Stack</code>.
		 * 
		 * @param 	o	the desired component.
		 * @return	the index of the first occurrence of the object argument
		 * 		   	in this stack, that is, the largest value <code>k</code>
		 * 		   	such that <code>(elem === elementData[k])</code> is true;
		 * 		   	returns <code>-1</code> if the object is not found.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack	
		 */
		public function lastIndexOf( o : Object ) : int
		{
			isValidType( o );
			return _aStack.lastIndexOf(o);
		}
		
		/**
		 * Removes all of the elements from this <code>Stack</code>. 
		 * The <code>Stack</code> will be empty after this call returns
		 * (unless it throws an exception).
		 */
		public function clear():void
		{
			_aStack = new Array();
		}
		
		/**
		 * Returns an iterator over the elements in this list
		 * in proper sequence. The elements are returned according
		 * to the LIFO order of the stack.
		 * <p>
		 * This implementation returns a straightforward implementation
		 * of the iterator interface.
		 * </p>
		 * @return an iterator over the elements in this list in proper sequence.
		 */
		public function iterator():Iterator
		{
			return new StackIterator(this);
		}
		
		/**
		 * Returns a list iterator of the elements in this list
		 * (in proper sequence), starting at the specified position
		 * in the list. The specified index indicates the first
		 * element that would be returned by an initial call to
		 * the next method. An initial call to the previous method
		 * would return the element with the specified index minus one.
		 * <p>
		 * This implementation returns a straightforward implementation
		 * of the ListIterator interface that extends the implementation
		 * of the Iterator interface returned by the iterator() method.
		 * The ListIterator implementation relies on the backing list's
		 * <code>get(int)</code>, <code>set(int, Object)</code>, 
		 * <code>add(int, Object)</code> and <code>remove(int)</code>
		 * methods.
		 * </p>
		 * @param	index 	<code>uint</code> index of the first element
		 * 					to be returned from	the list iterator (by
		 * 					a call to the next method).
		 * @return 	a list iterator of the elements in this list (in proper sequence),
		 *         	starting at the specified position in the list.
		 * @throws 	<code>IndexOutOfBoundsException</code> — index is out of range
		 * 		   	(index < 0 || index > size()).
		 */
		public function listIterator( index : uint = 0 ) : ListIterator
		{
			isValidIndex ( index );
			
			return new StackIterator ( this, index );
		}

		/**
		 * Returns the number of components in this <code>Stack</code>.
		 * 
		 * @return the number of components in this <code>Stack</code>.
		 */
		public function size():uint
		{
			return _aStack.length;
		}
	    
	    /**
		 * Returns the <code>Object</code> stored at the passed-in
		 * <code>index</code> in this stack object.
		 * <p>
		 * If the passed-in <code>index</code> is not a valid index
		 * for this stack, the function throw an 
		 * <code>IndexOutOfBoundsException</code> exception.
		 * </p> 
		 * @param	index 	<code>uint</code> index of the entry to get.
		 * @return	<code>Object</code> stored at the specified <code>index</code>
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this stack
		 */
	    public function get ( index : uint ) : Object
		{
			isValidIndex ( index );
			return _aStack[ index ];
		}
		
		/**
		 * Insert the passed-in <code>Object</code> in this stack
		 * at the specified <code>index</code>. The method returns
		 * the object previously stored at this index.
		 * <p>
		 * If the passed-in <code>index</code> is not a valid index
		 * for this stack, the function throw an 
		 * <code>IndexOutOfBoundsException</code> exception.
		 * </p><p>
		 * If the passed-in object's type prevents it to be added
		 * in this stack the function will throw a 
		 * <code>ClassCastException</code>.
		 * </p>
		 * @param	index 	<code>uint</code> index at which insert the
		 * 					passed-in <code>Object</code>.
		 * @param	o		<code>Object</code> to insert in this stack
		 * @return	<code>Object</code> previously stored at the specified
		 * 			<code>index</code> or null if the insertion haven't been 
		 * 			done.
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this stack
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack	
		 */
		public function set ( index : uint, o : Object ) : Object
		{
			isValidIndex ( index );
			
			if( isValidType( o ) )
				return _aStack.splice( index, 1, o )[0];
			else 
				return false;
		}
	    
		/**
		 * Looks at the object at the top of this stack
		 * without removing it from the stack.
		 * 
		 * @return the object at the top of this stack
		 * 		   (the last item of the object).
		 */
		public function peek() :Object
		{
			return _aStack[ size() - 1 ];
		}
	    
		/**
		 * Removes the object at the top of this stack and returns
		 * that object as the value of this function.
		 * 
		 * @return The object at the top of this stack
		 * 		   (the last item of the <code>Stack</code> object).
		 */
		public function pop() : Object
		{
			return _aStack.pop();
		}
	    
		/**
		 * Pushes an item onto the top of this stack. 
		 * This has exactly the same effect as:
		 * 
 		 * <listing>add(item)</listing>
		 * @param	item the item to be pushed onto this stack..
		 * @return 	the item argument.
		 * @see		#add() add()
		 */
		public function push (item : Object) : Object
		{
			if( isValidType( item ) )
			{
				_aStack.push(item);
			}
			return item;
		}
		
		
	    /**
	     * Returns a view of the portion of this List between fromIndex,
	     * inclusive, and toIndex, exclusive. (If fromIndex and ToIndex
	     * are equal, the returned List is empty.) 
	     * 
	     * @param 	fromIndex 	low endpoint (inclusive) of the subList.
	     * @param	toIndex 	high endpoint (exclusive) of the subList.
	     * @return 	a view of the specified range within this List.
	     * @throws 	<code>IndexOutOfBoundsException</code> — fromIndex or toIndex are
	     * 		   	out of range (index < 0 || index > size()).
	     */
	    public function subList( fromIndex:uint, toIndex:uint ) : List
		{
			isValidIndex( fromIndex );
			isValidIndex( toIndex );
			
			var l : List = new Stack( getType() );
			for(var i : Number = fromIndex;i < toIndex;i++)
			{
				l.add( _aStack[ i ] );
			}
			return l;
		}
		
		/**
		 * Verify that the passed-in <code>uint</code> index is a
		 * valid index for this </code>Stack</code>. If not, an 
		 * <code>IndexOutOfBoundsException</code> exception is
		 * thrown.
		 *  
		 * @param	index 	<code>uint<code> index to verify
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this stack
		 */
		public function isValidIndex ( index : uint ) : void
		{
			if( index >= size( ) )
			{
				PixlibDebug.ERROR( index + " is not a valid index for " +
								   this + " of size " + size() );
				throw new IndexOutOfBoundsException( index + " is not a valid index for " +
													 this + " of size " + size() );
			}
		}
		
		/**
		 * Returns <code>true</code> if this stack contains no elements.
		 *
		 * @return <code>true</code> if this stack contains no elements.
		 */
		public function isEmpty():Boolean
		{
			return size() == 0;
		}
		
		/**
		 * Verify that the passed-in <code>Collection</code> is a valid
		 * collection for use with the <code>addAll</code>, <code>addAllAt</code>,
		 * <code>removeAll</code>, <code>retainAll</code> and
		 * <code>containsAll</code> methods.
		 * <p>
		 * When dealing with typed and untyped collection, the following rules apply : 
		 * <ul>
		 * <li>Two typed collection, which have the same type, can collaborate each other.</li>
		 * <li>Two untyped collection can collaborate each other.</li>
		 * <li>An untyped collection can add, remove, retain or contains any typed collection
		 * of any type without throwing errors.</li>
		 * <li>A typed collection will always fail when attempting to add, remove, retain
		 * or contains an untyped collection.</li>
		 * </ul></p><p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p>
		 * 
		 * @param	c <code>Collection</code> to verify
		 * @return 	boolean <code>true</code> if the collection is valid, 
		 * 			either <code>false</code> 			
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 * @see		#addAll() addAll()
		 * @see		#removeAll() removeAll()
		 * @see		#retainAll() retainAll()
		 * @see		#containsAll() containsAll()
		 */
		public function isValidCollection ( c : Collection ) : Boolean
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this );
				throw new NullPointerException( "The passed-in collection is null in " + this );
			}
			else if( getType() != null )
			{
				if( c is TypedContainer && ( c as TypedContainer ).getType() != getType() )
				{
					PixlibDebug.ERROR( "The passed-in collection " + c +
									   " is not of the same type than " + this );
					throw new IllegalArgumentException( "The passed-in collection " + c +
														" is not of the same type than " + this );
				}
				else
				{
					return true;
				}
			}
			else
			{
				return true;
			}
		}
				
		/**
		 * Verify that the passed-in object type match the current 
		 * <code>Stack</code> element's type. 
		 * <p>
		 * In the case that the stack is untyped the function
		 * will always returns <code>true</code>.
		 * </p><p>
		 * In the case that the object's type prevents it to be added
		 * as element for this stack the method will throw
		 * a <code>ClassCastException</code>.
		 * </p> 
		 * @param	o <code>Object</code> to verify
		 * @return  <code>true</code> if the object is elligible for this
		 * 			stack object, either <cod>false</code>.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack
		 */
		public function isValidType ( o : Object ) : Boolean
		{
			if ( getType() != null)
			{
				if ( matchType( o ) )
				{
					return true;
				}
				else
				{
					PixlibDebug.ERROR( o + " has a wrong type for " + this );
					throw new ClassCastException( o + " has a wrong type for " + this ) ;
				}
			}
			else
				return true ;
		}
				
		/**
		 * Verify if the passed-in object can be inserted in the
		 * current <code>Stack</code>.
		 * 
		 * @param	o	Object to verify
		 * @return 	<code>true</code> if the object can be inserted in
		 * the <code>Stack</code>, either <code>false</code>.
		 */
		public function matchType( o : * ) : Boolean
		{
			return o is _oType;
		}
		
		/**
		 * Returns <code>true</code> if this stack perform a verification
		 * of the type of elements.
		 * 
		 * @return  <code>true</code> if this stack perform a verification
		 * 			of the type of elements.
		 */
		public function isTyped () : Boolean
		{
			return _oType != null;
		}
		
		/**
	     * Return the current type allowed in the <code>Stack</code>
	     * 
	     * @return <code>Class</code> used to type checking.
	     */
		public function getType() : Class
		{
			return _oType;
		}
		
		/**
		 * Returns an array containing all the elements in this stack.
		 * Obeys the general contract of the <code>Collection.toArray</code>
		 * method.
		 *
		 * @return  <code>Array</code> containing all of the elements
		 * 			in this stack.
		 * @see		Collection#toArray() Collection.toArray()
		 */
		public function toArray() : Array
		{
			return _aStack.concat();
		}
		
		/**
		 * Returns the <code>String</code> representation of
		 * this object. 
		 * <p>
		 * The function return a string like
		 * <code>com.bourre.collection::Stack&lt;String&gt;</code>
		 * for a typed collection. The string between the &lt;
		 * and &gt; is the name of the type of the collection's
		 * elements. If the collection is an untyped collection
		 * the function will simply return the result of the
		 * <code>PixlibStringifier.stringify</code> call.
		 * </p>
		 * @return <code>String</code> representation of
		 * 		   this object.
		 */
		public function toString () : String
		{
			var hasType : Boolean = getType() != null;
			var parameter : String = "";
			
			if( hasType )
			{
				parameter = getType().toString();
				parameter = "<" + parameter.substr( 7, parameter.length - 8 ) + ">";
			}
			
			return PixlibStringifier.stringify( this ) + parameter;
		}
	}
}

import com.bourre.collection.ListIterator;import com.bourre.collection.Stack;
import com.bourre.error.IllegalStateException;
import com.bourre.error.NoSuchElementException;

internal class StackIterator implements ListIterator
{
	private var _c : Stack;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _a : Array;
	private var _bRemoved : Boolean;
	private var _bAdded : Boolean;

	public function StackIterator ( c : Stack, index : uint = 0 )
	{
		_c = c;
		_nIndex = index - 1;
		_a = c.toArray( );
		_nLastIndex = _a.length - 1;
		_bRemoved = false;
		_bAdded = false;
	}

	public function hasNext () : Boolean
	{
		return _nIndex + 1 <= _nLastIndex;
	}

	public function next () : *
	{
		if( !hasNext() )
			throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex + 1 ) );
			
	    _bRemoved = false;
		_bAdded = false;
		return _a[ ++_nIndex ];
	}
	
	public function previous () : *
	{
		if( !hasPrevious() )
			throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex ) );
			
	    _bRemoved = false;
		_bAdded = false;
		return _a[ _nIndex-- ];
	}

	public function remove () : void
	{
		if( !_bRemoved )
		{
			_c.remove( _a[_nIndex--] );
			_a = _c.toArray( );
			_nLastIndex--;
			_bRemoved = true;
		}
		else
		{
			throw new IllegalStateException ( this + ".remove() have been already called for this iteration" );
		}
	}

	public function add ( o : Object ) : void
	{
		if( !_bAdded )
		{
			_c.add( o );
			_a = _c.toArray( );
			_nLastIndex++;
			_bAdded = true;
		}
		else
		{
			throw new IllegalStateException ( this + ".add() have been already called for this iteration" );
		}
	}		

	public function hasPrevious () : Boolean
	{
		return _nIndex >= 0;
	}	

	public function nextIndex () : uint
	{
		return _nIndex + 1;
	}

	public function previousIndex () : uint
	{
		return _nIndex;
	}	

	public function set ( o : Object ) : void
	{
		if( !_bAdded && !_bRemoved )
		{
			_c.set( _nIndex, o );
		}
		else
		{
			throw new IllegalStateException ( this + ".set() can't be called after neither a remove() nor an add() call" );
		}
	}
}