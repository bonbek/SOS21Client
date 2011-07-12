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
	import com.bourre.collection.Collection;
	import com.bourre.collection.Iterator;
	import com.bourre.error.ClassCastException;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NullPointerException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * A collection designed for holding elements prior to processing.
	 * Besides basic <code>Collection</code> operations,
	 * queues provide additional insertion, extraction, and inspection
	 * operations.
	 * <p>
	 * The <code>Queue</code> class allow as many occurrences as you
	 * want. In a same way, <code>null</code> values are allowed in
	 * the queue.
	 * </p><p>
	 * Elements in a <code>Queue</code> are orderered according
	 * to a FIFO (first-in-first-out) order.
	 * </p>
	 * @author 	Romain Flacher
	 * @author 	Cédric Néhémie
	 * @example 
	 * Using an untyped <code>Queue</code>
	 * <listing>var queue : Queue = new Queue ();
	 * queue.add( 20 )
	 * queue.add( "20" );
	 * queue.add( 80 );
	 * 
	 * trace ( queue.size() ); // 3 
	 * trace ( queue.poll() ); // 80
	 * 
	 * trace ( queue.peek() ); // "20"
	 * trace ( queue.size() ); // 2 
	 * </listing>
	 * 
	 * Using a typed <code>Queue</code>
	 * <listing>var queue : Queue = new Queue ( Number );
	 * queue.add( 20 )
	 * try
	 * {
	 * 	queue.add( "20" ); // throws an error because "20" is not a Number
	 * 	queue.add( 80 );
	 * }
	 * catch ( e : Error ) {}
	 * 
	 * trace ( queue.size() ); // 2
	 * trace ( queue.poll() ); // 80
	 * 
	 * trace ( queue.peek() ); // 20
	 * trace ( queue.size() ); // 1 
	 * </listing>
	 */
	public class Queue implements Collection, TypedContainer
	{
		private var _aQueue : Array;
		private var _oType : Class;

		/**
		 * Create an empty <code>Queue</code> object. 
		 */
		public function Queue ( type : Class = null )
		{
			this._aQueue = new Array( );
			_oType = type;
		}

		/**
		 * Adds the specified element to this queue. 
		 * The object is added as the top of the queue.
		 * <p>
		 * If the current queue object is typed and if the passed-in object's  
		 * type prevents it to be added in this queue, the function throws
		 * an <code>ClassCastException</code>.
		 * </p>
		 * @param	o element to be added to this queue.
		 * @return 	<code>true</code> if this queue have changed at
		 * 			the end of the call
		 * @throws 	<code>ClassCastException</code> — If the object's
		 * 			type prevents it to be added into this queue
		 * @example Adding elements to an untyped queue
		 * <listing>
		 * var queue : Queue = new Queue();
		 * 
		 * queue.add( 50 );
		 * queue.add( "foo" );
		 * 
		 * trace( queue.add( "foo" ) ); // true, because queue allow one or more entries
		 * 								// for an element
		 * 
		 * trace( queue.size() ); // 3
		 * </listing>
		 * 
		 * Adding elements to a typed queue
		 * <listing>
		 * var queue : Queue = new Queue( String );
		 * 
		 * queue.add( "foo" );
		 * 
		 * trace( queue.add( "foo" ) ); // true, because queue allow one or more occurrences
		 * 								// for an element
		 * 								
		 * try
		 * {
		 * 	queue.add( 50 ); // fail, as 50 is not a string
		 * }
		 * catch( e : ClassCastException )
		 * {
		 * 	trace ( e );
		 * }
		 * 
		 * trace( queue.size() ); // 2
		 * </listing>
		 */
		public function add (o : Object) : Boolean
		{
			if( isValidType( o ) )
			{
				_aQueue.push( o );
				return true;
			}
			return false;
		}

		/**
		 * Removes a single instance of the specified element from this
	     * queue, if this queue contains one or more such elements.
	     * Returns <code>true</code> if this queue contained the specified
	     * element (or equivalently, if this collection changed as a result
	     * of the call).
	     * <p>
	     * In order to remove all occurences of an element you have to call
	     * the <code>remove</code> method as long as the queue contains an
	     * occurrence of the passed-in element. Typically, the construct to
	     * remove all occurrences of an element should look like that :
	     * <listing>
	     * while( queue.contains( element ) ) queue.remove( element );
	     * </listing>
	     * </p><p>
		 * If the current queue object is typed and if the passed-in object's  
		 * type prevents it to be added (and then removed) in this queue,
		 * the function throws a <code>ClassCastException</code>.
		 * </p> 
	     * @param	o <code>object</code> to be removed from this queue,
	     * 			  if present.
		 * @return 	<code>true</code> if the queue contained the 
		 * 			specified element.
	     * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this queue
		 * @example Using the <code>Queue.remove()</code> method of an untyped queue : 
		 * <listing>
		 * var queue : Queue = new Queue();
		 * queue.add ( "foo" );		 * queue.add ( "foo" );
		 * 
		 * trace( queue.size() ); // 1
		 * trace( queue.remove( "foo" ) ); // true, the first occurence of 'foo' have
		 * 								   // been removed from the queue
		 * 
		 * trace( queue.size() ); // 1
		 * trace( queue.remove( "foo" ) ); // true, the passed-in value has always
		 * 								   // an occurence contained in the queue
		 * 
		 * trace( queue.size() ); // 0
		 * trace( queue.remove( "foo" ) ); // false, as there is no more occurence
		 * 								   // in the queue
		 * </listing>
		 * 
		 * Using the <code>Queue.remove()</code> method of a typed queue :
		 * 
		 * <listing>
		 * var queue : Queue = new Queue( String );
		 * queue.add ( "foo" );
		 * 
		 * trace( queue.size() ); // 1
		 * trace( queue.remove( "foo" ) ); // true, the passed-in value have been removed
		 * 
		 * // the code below will produce an exception
		 * try
		 * {
		 * 	queue.remove( 45 ); // fail, as the passed-in value is not of type string
		 * }
		 * catch( e : ClassCastException )
		 * {
		 * 	trace ( e );  
		 * }
		 * </listing>
		 */
		public function remove ( o : Object ) : Boolean
		{
			if( isValidType( o ) && contains( o ) )
			{
				_aQueue.splice( _aQueue.indexOf( o ), 1 );
				return true;
			}
			return false;
		}

		/**
		 * Returns <code>true</code> if this queue contains at least
		 * one occurence of the specified element. Moreformally,
		 * returns <code>true</code> if and only if this queue contains
		 * at least an element <code>e</code> such that <code>o === e</code>.
		 *
		 * @param	o	<code>Object</code> whose presence in this queue
		 * 			  	is to be tested.
		 * @return 	<code>true</code> if this queue contains the specified
		 * 			element.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this queue
		 */
		public function contains ( o : Object ) : Boolean
		{
			isValidType( o );
			
			return _aQueue.indexOf( o ) != -1;
		}

		/**
		 * Returns <code>true</code> if this queue contains no elements.
		 *
		 * @return <code>true</code> if this queue contains no elements.
		 */
		public function isEmpty () : Boolean
		{
			return _aQueue.length == 0;
		}

		/**
		 * Removes all of the elements from this queue
		 * (optional operation). This queue will be empty
		 * after this call returns (unless it throws an exception).
		 */
		public function clear () : void
		{
			_aQueue = new Array( );
		}

		/**
		 * Returns an iterator over the elements in this queue. 
		 * The elements are returned according to the FIFO
		 * (first-in-first-out) order. 
		 *
		 * @return an iterator over the elements in this queue.
		 */
		public function iterator () : Iterator
		{
			return new QueueIterator( this );
		}

		/**
		 * Adds all of the elements in the specified <code>Collection</code> 
		 * to this queue. The behavior of this operation is
		 * unspecified if the specified collection is modified while the
		 * operation is in progress.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>addAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> whose elements are to be added to this queue.
		 * @return 	<code>true</code> if this queue changed as a result of the call.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this queue
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.	
		 * @see 	#add() add()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example	How the <code>Queue.addAll</code> method works with types 
		 * <p>
		 * Let say that you have two typed queues <code>typedQueue1</code>
		 * and <code>typedQueue2</code> such :
		 * </p> 
		 * <listing>
		 * var typedQueue1 : Queue = new Queue( String );
		 * var typedQueue2 : Queue = new Queue( String );
		 * 
		 * typedQueue1.add( "foo1" );
		 * typedQueue1.add( "foo2" );
		 * typedQueue1.add( "foo3" );
		 * typedQueue1.add( "foo4" );
		 * 
		 * typedQueue2.add( "foo3" );
		 * typedQueue2.add( "foo4" );
		 * typedQueue2.add( "foo5" );
		 * typedQueue2.add( "foo6" );
		 * </listing>
		 * 
		 * And two untyped queues <code>untypedQueue1</code>
		 * and <code>untypedQueue2</code> such : 
		 * 
		 * <listing>
		 * var untypedQueue1 : Queue = new Queue();
		 * var untypedQueue2 : Queue = new Queue();
		 * 
		 * untypedQueue1.add( 1 );
		 * untypedQueue1.add( 2 );
		 * untypedQueue1.add( 3 );
		 * untypedQueue1.add( "foo1" );
		 * 
		 * untypedQueue2.add( 3 );
		 * untypedQueue2.add( 4 );
		 * untypedQueue2.add( 5 );
		 * untypedQueue2.add( "foo1" );
		 * </listing>
		 * 
		 * The two operations below will work as expected, 
		 * realizing the union of the queues objects.
		 * 
		 * <listing>
		 * 
		 * typedQueue1.addAll ( typedQueue2 );
		 * // will produce a queue containing : 
		 * // 'foo1'
		 * // 'foo2'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo5'
		 * // 'foo6'
		 * 
		 * untypedQueue1.addAll ( untypedQueue2 );
		 * // will produce a queue containing : 
		 * // 1
		 * // 2
		 * // 3
		 * // 'foo1'
		 * // 3
		 * // 4
		 * // 5
		 * // 'foo1'
		 * </listing>
		 * 
		 * As an untyped queue can contain any types of objects at the
		 * same time, the code below is always valid.
		 * 
		 * <listing>
		 * untypedQueue1.addAll( typedQueue2 );
		 * // will produce a queue containing : 
		 * // 1
		 * // 2
		 * // 3
		 * // 'foo1'
		 * // 3
		 * // 4
		 * // 5
		 * // 'foo1'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo5'
		 * // 'foo6'
		 * </listing>
		 * 
		 * But if you try to add an untyped collection to a typed one
		 * the call will fail with an exception.
		 * 
		 * <listing>
		 * try
		 * {
		 * 	typedQueue2.addAll( untypedQueue2 );
		 * }
		 * catch( e : IllegalArgumentException )
		 * {
		 * 	trace( e ); 
		 * 	// The passed-in collection with type 'null' has not the same type 
		 * 	// than com.bourre.collections::Queue&lt;String&gt;
		 * }
		 * </listing>
		 */
		public function addAll ( c : Collection ) : Boolean
		{
			if( isValidCollection( c ) )
			{
				var iter : Iterator = c.iterator( );
				var modified : Boolean = false;
				
				while(iter.hasNext( ))
				{
					var o : * = iter.next( );
					if( isValidType( o ) )
					{
						_aQueue.push( o );
						modified = true;
					}
				}
				
				return modified;
			}
			return false;
		}

		/**
		 * Removes from this queue all of its elements that are contained
		 * in the specified collection (optional operation). At the end
		 * of the call there's no occurences of any elements contained
		 * in the passed-in collection.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>removeAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> that defines which elements will be
		 * 			  	removed from this queue.
		 * @return 	<code>true</code> if this queue changed as a result
		 * 			of the call.
		 * @throws 	<code>NullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.    
		 * @see    	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example Using the <code>Queue.removeAll()</code> with untyped queues
		 * <listing>
		 * var queue1 : Queue = new Queue();
		 * var queue2 : Queue = new Queue();
		 * 
		 * queue1.add( 1 );
		 * queue1.add( 2 );
		 * queue1.add( 3 );
		 * queue1.add( 4 );
		 * queue1.add( "foo1" );
		 * queue1.add( "foo2" );
		 * queue1.add( "foo3" );
		 * queue1.add( "foo4" );
		 * 
		 * queue2.add( 1 );
		 * queue2.add( 3 );
		 * queue2.add( "foo1" );
		 * queue2.add( "foo3" );
		 * 
		 * trace ( queue1.removeAll ( queue2 ) ) ;// true
		 * // queue1 now contains :
		 * // 2, 4, 'foo2', 'foo4' 
		 * </listing>
		 */
		public function removeAll ( c : Collection ) : Boolean
		{
			if( isValidCollection( c ) )
			{	
				var iter : Iterator = c.iterator( );
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
		 * Returns <code>true</code> if this queue contains
		 * all of the elements of the specified collection. If the specified
		 * collection is also a <code>Set</code>, this method returns <code>true</code>
		 * if it is a <i>subliset</i> of this queue.
		 * <p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>Collection</code> type is different than the current
		 * one the function will throw an <code>IllegalArgumentException</code>.
		 * However, if the type of this queue is <code>null</code>, 
		 * the passed-in <code>Collection</code> can have any type. 
		 * </p><p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>containsAll</code> method.
		 * </p>
		 * @param	c	<code>Collection</code>
		 * @return 	<code>true</code> if this queue contains all of the elements of the
		 * 	       	specified collection.
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 */
		public function containsAll ( c : Collection ) : Boolean
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
		 * Retains only the elements in this queue that are contained
		 * in the specified collection (optional operation). In other words,
		 * removes from this queue all of its elements that are not
		 * contained in the specified collection.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>retainAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> that defines which elements this
		 * 			  	queue will retain.
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	<code>NullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 * @see 	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example Using the <code>Queue.retainAll()</code> with untyped queues
		 * <listing>
		 * var queue1 : Queue = new Queue();
		 * var queue2 : Queue = new Queue();
		 * 
		 * queue1.add( 1 );
		 * queue1.add( 2 );
		 * queue1.add( 3 );
		 * queue1.add( 4 );
		 * queue1.add( "foo1" );
		 * queue1.add( "foo2" );
		 * queue1.add( "foo3" );
		 * queue1.add( "foo4" );
		 * 
		 * queue2.add( 1 );
		 * queue2.add( 3 );
		 * queue2.add( "foo1" );
		 * queue2.add( "foo3" );
		 * 
		 * trace ( queue1.retainAll ( queue2 ) ) ;// true
		 * // queue1 now contains :
		 * // 1, 3, 'foo1', 'foo3' 
		 * </listing>
		 */
		public function retainAll (c : Collection) : Boolean
		{
			if( isValidCollection( c ) )
			{
				var modified : Boolean = false;
				var fin : int = _aQueue.length;
				var id : int = 0;
				while(id < fin)
				{
					var obj : * = _aQueue[id];
					if(!c.contains( obj ))
					{
						var fromIndex : int = 0;
						while(true)
						{
							fromIndex = _aQueue.indexOf( obj, fromIndex );
							if(fromIndex == -1)
							{
								break;
							}
							modified = true;
							_aQueue.splice( fromIndex, 1 );
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
		 * Returns the number of elements in this queue (its cardinality).
		 *
		 * @return <code>Number</code> of elements in this queue (its cardinality).
		 */
		public function size () : uint
		{
			return _aQueue.length;
		}

	    /**
	     * Retrieves, but does not remove, the head of this queue,
	     * or returns <code>null</code> if this queue is empty.
	     *
	     * @return 	the head of this queue, or <code>null</code>
	     * 			if this queue is empty
	     */
		public function peek () : Object
		{
			return _aQueue[0];
		}
		
		/**
	     * Retrieves and removes the head of this queue,
	     * or returns <code>null</code> if this queue is empty.
	     *
	     * @return 	the head of this queue, or <code>null</code>
	     * 		   	if this queue is empty
	     */
		public function poll () : Object
		{
			return _aQueue.shift();
		}

		/**
		 * Verify that the passed-in object type match the current 
		 * queue element's type. 
		 * 
		 * @return  <code>true</code> if the object is elligible for this
		 * 			queue object, either <code>false</code>.
		 */
		public function matchType (o : *) : Boolean
		{
			return o is _oType;
		}
				
		/**
		 * Returns <code>true</code> if this queue perform a verification
		 * of the type of elements.
		 * 
		 * @return  <code>true</code> if this queue perform a verification
		 * 			of the type of elements.
		 */
		public function isTyped () : Boolean
		{
			return _oType != null;
		}
		
		/**
		 * Return the class type of elements in this queue object.
		 * <p>
		 * An untyped queue returns <code>null</code>, as the
		 * wildcard type (<code>*</code>) is not a <code>Class</code>
		 * and <code>Object</code> class doesn't fit for primitive types.
		 * </p>
		 * @return <code>Class</code> type of the queue's elements
		 */
		public function getType () : Class
		{
			return _oType;
		} 
		
		/**
		 * Verify that the passed-in <code>Collection</code> is a valid
		 * collection for use with the <code>addAll</code>, <code>removeAll</code>,
		 * <code>retainAll</code> and <code>containsAll</code> methods.
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
					PixlibDebug.ERROR( "The passed-in collection is not of the same type than " + this );
					throw new IllegalArgumentException( "The passed-in collection is not of the same type than " + this );
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
		 * <code>Queue</code> element's type. 
		 * <p>
		 * In the case that the queue is untyped the function
		 * will always returns <code>true</code>.
		 * </p><p>
		 * In the case that the object's type prevents it to be added
		 * as element for this queue the method will throw
		 * a <code>ClassCastException</code>.
		 * </p> 
		 * @param	o <code>Object</code> to verify
		 * @return  <code>true</code> if the object is elligible for this
		 * 			queue object, either <cod>false</code>.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this queue
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
		 * Returns an array containing all the elements in this queue.
		 * Obeys the general contract of the <code>Collection.toArray</code>
		 * method.
		 *
		 * @return  <code>Array</code> containing all of the elements
		 * 			in this queue.
		 * @see		Collection#toArray() Collection.toArray()
		 */
		public function toArray () : Array
		{
			return _aQueue.concat( );
		}
		
		/**
		 * Returns the <code>String</code> representation of
		 * this object. 
		 * <p>
		 * The function return a string like
		 * <code>com.bourre.collection::Queue&lt;String&gt;</code>
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

import com.bourre.collection.Iterator;
import com.bourre.collection.Queue;
import com.bourre.error.IllegalStateException;
import com.bourre.error.NoSuchElementException;

internal class QueueIterator 
	implements Iterator
{
	private var _c : Queue;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _a : Array;
	private var _bRemoved : Boolean;

	public function QueueIterator ( c : Queue )
	{
		_c = c;
		_nIndex = -1;
		_a = _c.toArray( );
		_nLastIndex = _a.length - 1;
		_bRemoved = false;
	}

	public function hasNext () : Boolean
	{
		return _nLastIndex > _nIndex;
	}

	public function next () : *
	{
		if( !hasNext() )
			throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex ) );
			
		_bRemoved = true;
		return _a[ ++_nIndex];
	}

	public function remove () : void
	{
		if( !_bRemoved )
		{
			_c.remove( _a[ _nIndex] );
			_a = _c.toArray( );
			_nLastIndex--;
			_bRemoved = true;
		}
		else
		{
			throw new IllegalStateException ( this + ".remove() have been already called for this iteration" );
		}
	}
}