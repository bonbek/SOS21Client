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
	 * A collection that contains no duplicate elements. More formally, sets
	 * contain no pair of elements <code>e1</code> and <code>e2</code> such that
	 * <code>e1 === e2</code>, and at most one null element. As implied by
	 * its name, this interface models the mathematical <i>set</i> abstraction.
	 * <p>
	 * The <code>Set</code> class places additional stipulations, beyond those
	 * inherited from the <code>Collection</code> interface, on the contracts of the
	 * constructor and on the contracts of the <code>add</code> method. 
	 * Declarations for other inherited methods are also included here for convenience.
	 * (The specifications accompanying these declarations have been tailored to the
	 * <code>Set</code> class, but they do not contain any additional stipulations.)
	 * </p><p>
	 * The additional stipulation on constructors is, not surprisingly,
	 * that all constructors must create a set that contains no duplicate elements
	 * (as defined above).
	 * </p><p>
	 * Some set implementations have restrictions on the elements that
	 * they may contain.  For example, some implementations prohibit null elements,
	 * and some have restrictions on the types of their elements.  Attempting to
	 * add an ineligible element throws an unchecked exception, typically
	 * <code>NullPointerException</code> or <code>ClassCastException</code>. 
	 * Attempting to query the presence of an ineligible element may throw an exception,
	 * or it may simply return false; some implementations will exhibit the former
	 * behavior and some will exhibit the latter. More generally, attempting an
	 * operation on an ineligible element whose completion would not result in
	 * the insertion of an ineligible element into the set may throw an
	 * exception or it may succeed, at the option of the implementation.
	 * Such exceptions are marked as "optional" in the specification for this
	 * class. 
	 * </p>
	 * @author  Olympe Dignat
	 * @author 	Cédric Néhémie
	 * @see 	Collection
	 * @see		TypedContainer
	 * @example Using an untyped <code>Set</code>
	 * <listing>
	 * var set : Set = new Set();
	 * 
	 * set.add( "foo" );
	 * set.add( 25 );
	 * 
	 * trace ( set.add( 25 ) ) // false, as the object already exist in this set
	 * 
	 * set.add( false );
	 * 
	 * trace( set.size() ); // 3
	 * </listing>
	 * 
	 * Using a typed <code>Set</code>
	 * <listing>
	 * var set : Set = new Set( String );
	 * 
	 * set.add( "foo" );
	 * 
	 * try
	 * {
	 * 	set.add( 25 ); // throw an error, as 25 is not a String
	 * }
	 * catch( e : Error ) {}
	 * 
	 * trace ( set.add( "foo" ); ) // false, as the object already exist in this set
	 * 
	 * set.add( "hello" );
	 * 
	 * trace( set.size() ); // 2
	 * </listing>
	 */	
	public class Set implements List, TypedContainer
	{
		private var _aSet : Array;
		private var _oType : Class;

		/**
		 * Creates a new set object. If the <code>type</code>
		 * argument is defined, the set is considered as typed, and then
		 * the type of all elements inserted in this set is checked.
		 * 
		 * @param	type <code>Class</code> type for elements of this set
		 */
		public function Set ( type : Class = null )
		{
			this._aSet = new Array( );
			_oType = type;
		}

		/**
		 * Adds the specified element to this set if it is not already 
		 * present (optional operation).  More formally, adds the specified
		 * element, <code>o</code>, to this set if this set contains no
		 * element <code>e</code> such that <code>o === e</code>. If this set
		 * already contains the specified element, the call leaves this set
		 * unchanged and returns <code>false</code>. In combination with the
		 * restriction on constructors, this ensures that sets never contain
		 * duplicate elements.
		 * <p>
		 * The stipulation above does not imply that sets must accept all
		 * elements; sets may refuse to add any particular element, including
		 * <code>null</code>, and throwing an exception, as described in the
		 * specification for <code>Collection.add</code>. Individual set
		 * implementations should clearly document any restrictions on the the
		 * elements that they may contain.
		 * </p>
		 * @param	o	element to be added to this set.
		 * @return 	<code>true</code> if this set did not already contain the specified
		 *         	element.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into thisset
		 * @example How to use the <code>Set.add</code> method
		 * <listing>
		 * var set : Set = new Set( String );
		 * 
		 * set.add( "foo" );
		 * 
		 * set.add( "foo" ); // return false, as 'foo' already exist in this set
		 * 
		 * set.add( 25 ); // throw a ClassCastException, as 25 is not a string 
		 * </listing>
		 * 
		 * In comparison with Java, where object which have all of their properties
		 * equals are considered as equals, AS3 doesn't allow that, except if objects
		 * provides an <code>equals</code> method which is used instead of the 
		 * <code>==</code> or <code>===</code> operators. Nevertheless, the <code>Set</code>
		 * class use the native operator to perform comparison, thus two objects with
		 * equals properties are considered as differents.
		 * 
		 * <listing>
		 * var set : Set = new Set( Object );
		 * var o : Object = { x : 50, y : 100 };
		 * 
		 * set.add( o ); 
		 * set.add( o ); // return false, as o' already exist in this set
		 * 
		 * set.add( { x : 50, y : 100 } ); // return true, as the argument is not
		 * 								   // the same object than o, even if all
		 * 								   // their properties are equals
		 * </listing>
		 */
		public function add ( o : Object ) : Boolean
		{
			if( isValidObject( o ) )
			{
				_aSet.splice( _aSet.length, 0, o );
				return true ;
			}
			else
			{
				return false ;
			}				
		}

		/**
		 * Inserts the specified element at the specified position
		 * in this set. Shifts the element currently at that
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
			if( isValidObject( o ) )			
				_aSet.splice( index, 0, o );
		}

		/**
		 * Adds all of the elements in the specified <code>Collection</code> 
		 * to this set if they're not already present (optional operation).
		 * If the specified collection is also a set, the <code>addAll</code>
		 * operation effectively modifies this set so that its value is the 
		 * <i>union</i> of the two sets. The behavior of this operation is
		 * unspecified if the specified collection is modified while the
		 * operation is in progress.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>addAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> whose elements are to be added to this set.
		 * @return 	<code>true</code> if this set changed as a result of the call.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this set
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.	
		 * @see 	#add() add()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example	How the <code>Set.addAll</code> method works with types 
		 * <p>
		 * Let say that you have two typed sets <code>typedSet1</code>
		 * and <code>typedSet1</code>.
		 * </p> 
		 * <listing>
		 * var typedSet1 : Set = new Set( String );
		 * var typedSet2 : Set = new Set( String );
		 * 
		 * typedSet1.add( "foo1" );
		 * typedSet1.add( "foo2" );
		 * typedSet1.add( "foo3" );
		 * typedSet1.add( "foo4" );
		 * 
		 * typedSet2.add( "foo3" );
		 * typedSet2.add( "foo4" );
		 * typedSet2.add( "foo5" );
		 * typedSet2.add( "foo6" );
		 * </listing>
		 * 
		 * And two untyped sets <code>untypedSet1</code>
		 * and <code>untypedSet1</code>. 
		 * 
		 * <listing>
		 * var untypedSet1 : Set = new Set();
		 * var untypedSet2 : Set = new Set();
		 * 
		 * untypedSet1.add( 1 );
		 * untypedSet1.add( 2 );
		 * untypedSet1.add( 3 );
		 * untypedSet1.add( "foo1" );
		 * 
		 * untypedSet1.add( 3 );
		 * untypedSet1.add( 4 );
		 * untypedSet1.add( 5 );
		 * untypedSet1.add( "foo1" );
		 * </listing>
		 * 
		 * The two operations below will work as expected, 
		 * realizing an union between <code>Set</code>s objects.
		 * 
		 * <listing>
		 * 
		 * typedSet1.addAll ( typedSet2 );
		 * // will produce a set containing : 
		 * // 'foo1'
		 * // 'foo2'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo5'
		 * // 'foo6'
		 * 
		 * untypedSet1.addAll ( untypedSet2 );
		 * // will produce a set containing : 
		 * // 'foo1'
		 * // 1
		 * // 2
		 * // 3
		 * // 4
		 * // 5
		 * </listing>
		 * 
		 * As an untyped set can contain any types of objects at the
		 * same time, the code below is always valid.
		 * 
		 * <listing>
		 * untypedSet1.addAll( typedSet2 );
		 * // will produce a set containing : 
		 * // 'foo1'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo5'
		 * // 'foo6'
		 * // 1
		 * // 2
		 * // 3
		 * // 4
		 * // 5
		 * </listing>
		 * 
		 * But if you try to add an untyped collection to a typed one
		 * the call will fail with an exception.
		 * 
		 * <listing>
		 * try
		 * {
		 * 	typedSet2.addAll( untypedSet2 );
		 * }
		 * catch( e : IllegalArgumentException )
		 * {
		 * 	trace( e ); 
		 * 	// The passed-in collection with type 'null' has not the same type 
		 * 	// than com.bourre.collections::Set&lt;String&gt;
		 * }
		 * </listing>
		 */
		public function addAll (c : Collection) : Boolean
		{
			var modified : Boolean = false;
			if (isValidCollection( c ))
			{
				var iter : Iterator = c.iterator( );

				while(iter.hasNext( ))
				{
					modified = add( iter.next( ) ) || modified;
				}
			}
			return modified;
		}
		
		/**
		 * Inserts all of the elements in the specified Collection into
		 * this set at the specified position. Shifts the element
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
		 * @return 	<code>true</code> if this set changed as a result of the call.
		 * @throws 	<code>IndexOutOfBoundsException</code> — index is out of range
		 * 		   	(index < 0 || index > size()).
		 * @throws 	<code>ClassCastException</code> — if the class of an element of
		 * 			the specified collection prevents it from being added to this collection.
	     * @throws 	<code>NullPointerException</code> — if the passed in collection is null.
	     * @see		#add() add()
	     * @see		#addAt() addAt()
	     * @see		#addAll() addAll()
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
		 * Removes the specified element from this set
		 * if it is present (optional operation). More formally,
		 * removes an element <code>e</code> such that
		 * <code>o === e</code>, if the set contains
		 * such an element. Returns <code>true</code> if the set
		 * contained the specified element (or equivalently, if the
		 * set changed as a result of the call). 
		 * (The set will not contain the specified element
		 * once the call returns.)
		 *
		 * @param	o 	<code>object</code> to be removed from this <code>Set</code>,
		 * 				if present.
		 * @return 	<code>true</code> if the set contained the specified element.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this set
		 * @example	Using the <code>Set.remove()</code> method of an untyped set : 
		 * <listing>
		 * var set : Set = new Set();
		 * set.add ( "foo" );
		 * 
		 * trace( set.size() ); // 1
		 * trace( set.remove( "foo" ) ); // true, the passed-in value have been removed
		 * 
		 * trace( set.size() ); // 0
		 * trace( set.remove( "foo" ) ); // false, the passed-in value is no longer stored in this set
		 * </listing>
		 * 
		 * Using the <code>Set.remove()</code> method of a typed set :
		 * 
		 * <listing>
		 * var set : Set = new Set( String );
		 * set.add ( "foo" );
		 * 
		 * trace( set.size() ); // 1
		 * trace( set.remove( "foo" ) ); // true, the passed-in value have been removed
		 * 
		 * // the code below will produce an exception
		 * try
		 * {
		 * 	set.remove( 45 ); // fail, as the passed-in value is not of type string
		 * }
		 * catch( e : ClassCastException )
		 * {
		 * 	trace ( e );  
		 * }
		 * </listing>
		 */
		public function remove ( o : Object ) : Boolean
		{
			var find : Boolean = false;

			if ( isValidType( o ) && contains( o ) )
			{
				_aSet.splice( _aSet.indexOf( o ), 1 );
				find = true ;
			}
			return find ;
		}

		/**
		 * Removes the element at the specified position in this set.
		 * Shifts any subsequent elements to the right (subtracts one from
		 * their indices).
		 * 
		 * @copy	com.bourre.collection.Set#remove()
		 * @param	index 	<code>uint</code> index at which to remove an element
		 * 				  	from the specified <code>Collection</code>.
		 * @return 	<code>true</code> if the object have been removed, false otherwise.
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this set
		 * @see		#remove() remove()
		 * @example Using the <code>Set.removeAt</code> method with an untyped set
		 * <listing>
		 * var set : Set = new Set();
		 * set.add( "foo1" );
		 * set.add( "foo2" );
		 * set.add( "foo3" );
		 * 
		 * trace ( set.removeAt( 2 ) ); // return true, 'foo3' have been removed
		 * trace ( set.removeAt( 0 ) ); // return true, 'foo1' have been removed  
		 * 								// and 'foo2' is now at index 0
		 * 
		 * try
		 * {
		 * 	set.removeAt( 1 ); // fail, as set have only one entry at index 0
		 * }
		 * catch( e : IndexOutOfBoundsException )
		 * {
		 * 	trace( e );
		 * }
		 * </listing>
		 */
		public function removeAt ( index : uint ) : Boolean
		{
			isValidIndex( index );
			_aSet.splice( index, 1 );
			return true;			
		}

		/**
		 * Removes from this set all of its elements that are contained
		 * in the specified collection (optional operation). If the specified
		 * <code>Collection</code> is also a <code>Set</code>, this operation
		 * effectively modifies this set so that its value is the
		 * <i>asymmetric set difference</i> of the two sets.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>removeAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> that defines which elements will be
		 * 			  	removed from this set.
		 * @return 	<code>true</code> if this set changed as a result
		 * 			of the call.
		 * @throws 	<code>NullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.    
		 * @see    	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example Using the <code>Set.removeAll()</code> with untyped sets
		 * <listing>
		 * var set1 : Set = new Set();
		 * var set2 : Set = new Set();
		 * 
		 * set1.add( 1 );
		 * set1.add( 2 );
		 * set1.add( 3 );
		 * set1.add( 4 );
		 * set1.add( "foo1" );
		 * set1.add( "foo2" );
		 * set1.add( "foo3" );
		 * set1.add( "foo4" );
		 * 
		 * set2.add( 1 );
		 * set2.add( 3 );
		 * set2.add( "foo1" );
		 * set2.add( "foo3" );
		 * 
		 * trace ( set1.removeAll ( set2 ) ) ;// true
		 * // set1 now contains :
		 * // 2, 4, 'foo2', 'foo4' 
		 * </listing>
		 */
		public function removeAll ( c : Collection ) : Boolean
		{
			var find : Boolean = false;
			if (isValidCollection( c ))
			{
				var iter : Iterator = c.iterator( );
				while( iter.hasNext( ) ) find = remove( iter.next( ) ) || find;
			}
			return find;
		}

		/**
		 * Retains only the elements in this set that are contained
		 * in the specified collection (optional operation).  In other words,
		 * removes from this set all of its elements that are not
		 * contained in the specified collection.  If the specified collection
		 * is also a <code>Set</code>, this operation effectively modifies this
		 * set so that its value is the <i>intersection</i> of the
		 * two sets.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>retainAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> that defines which elements this
		 * 			  	set will retain.
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	<code>NullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 * @see 	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * @example Using the <code>Set.retainAll()</code> with untyped sets
		 * <listing>
		 * var set1 : Set = new Set();
		 * var set2 : Set = new Set();
		 * 
		 * set1.add( 1 );
		 * set1.add( 2 );
		 * set1.add( 3 );
		 * set1.add( 4 );
		 * set1.add( "foo1" );
		 * set1.add( "foo2" );
		 * set1.add( "foo3" );
		 * set1.add( "foo4" );
		 * 
		 * set2.add( 1 );
		 * set2.add( 3 );
		 * set2.add( "foo1" );
		 * set2.add( "foo3" );
		 * 
		 * trace ( set1.retainAll ( set2 ) ) ;// true
		 * // set1 now contains :
		 * // 1, 3, 'foo1', 'foo3' 
		 * </listing>
		 */
		public function retainAll (c : Collection) : Boolean
		{
			var b : Boolean = false;
			
			if (isValidCollection( c ))
			{
				var i : Iterator = iterator( );
				
				while( i.hasNext( ) )
				{
					var o : Object = i.next( );	
					if ( !( c.contains( o ) ) ) b = remove( o ) || b;
				}
			}
			return b;
		}

		/**
		 * Returns <code>true</code> if this set contains the
		 * specified element. More formally, returns <code>true</code> if
		 * and only if this set contains an element <code>e</code>
		 * such that <code>o === e</code>.
		 *
		 * @param	o	<code>Object</code> whose presence in this set
		 * 			  	is to be tested.
		 * @return 	<code>true</code> if this set contains the specified
		 * 			element.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this set
		 */
		public function contains ( o : Object ) : Boolean
		{
			if (isValidType( o ))
				return _aSet.indexOf( o ) != -1;
			else
				return false ;
		}

		/**
		 * Returns <code>true</code> if this set contains
		 * all of the elements of the specified collection. If the specified
		 * collection is also a <code>Set</code>, this method returns <code>true</code>
		 * if it is a <i>subset</i> of this set.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>containsAll</code> method.
		 * </p>
		 * @param	c	<code>Collection</code> to be checked for containment in this set.
		 * @return 	<code>true</code> if this set contains all of the elements of the
		 * 	       	specified collection.
		 * @throws 	<code>NullPointerException</code> — if the specified collection is
		 *         	<code>null</code>.
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 * @see    	#contains() contains()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 */
		public function containsAll (c : Collection) : Boolean
		{
			var b : Boolean = true ;
			
			if (isValidCollection( c ))
			{
				var iter : Iterator = c.iterator( );
				
				while( iter.hasNext( ) )
				{
					var ok : Boolean = contains( iter.next( ) ) ;
					if( ok == false ) 
					{
						b = false;
					}
				}
			}
			else
			{
				b = false ;
			}

			return b;
		}

		/**
		 * Compares the specified object with this set for equality.
		 * Returns <code>true</code> if the specified object is also a <code>Set</code>,
		 * the two sets have the same size, and every member of the specified
		 * <code>Set</code> is contained in this set (or equivalently,
		 * every member of this set is contained in the specified
		 * set). This definition ensures that the equals method works
		 * properly across different implementations of the set class.
		 *
		 * @param	o 	<code>Object</code> to be compared for equality with this
		 * 			  	set.
		 * @return 	<code>true</code> if the specified Object is equal to this
		 * 			set.
		 */
		public function equals ( o : Object ) : Boolean
		{
			if (o is Set)
			{
				var _set : Set = o as Set;
				if (_set.size( ) == size( ))
				{
					return containsAll( _set ) ;
				}
				else
					return false ;
			}
			else
				return false ;
		}

		/**
		 * Returns the index of the object in this set		 
		 * 
		 * @param	o 	the object to find
		 * @return 	<code>int</code> index of the passed object in this
		 * 			set, either if the object isn't contained
		 * 			in this set the function return <code>-1</code>
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this stack	
		 */
		public function indexOf ( o : Object ) : int
		{
			isValidType( o );
			return _aSet.indexOf( o );
		}
		
		/**
		 * Returns the index of the last occurrence of the specified
		 * object in this <code>Set</code>.
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
			return _aSet.lastIndexOf(o);
		}

		/**
		 * Removes all of the elements from this set
		 * (optional operation). This set will be empty
		 * after this call returns (unless it throws an exception).
		 */
		public function clear () : void
		{
			_aSet = new Array( );
		}

		/**
		 * Returns an iterator over the elements in this set. 
		 * The elements are returned in no particular order (unless this
		 * set is an instance of some class that provides
		 * a guarantee).
		 *
		 * @return an iterator over the elements in this set.
		 */
		public function iterator () : Iterator
		{
			return new SetIterator( this );
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
			
			return new SetIterator ( this, index );
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
				l.add( _aSet[ i ] );
			}
			return l;
		}

		/**
		 * Returns the number of elements in this set (its cardinality). 
		 * 
		 * @return <code>Number</code> of elements in this set (its cardinality).
		 */
		public function size () : uint
		{
			return _aSet.length;
		}

		/**
		 * Returns the <code>Object</code> stored at the passed-in
		 * <code>index</code> in this set object.
		 * <p>
		 * If the passed-in <code>index</code> is not a valid index
		 * for this set, the function throw an 
		 * <code>IndexOutOfBoundsException</code> exception.
		 * </p> 
		 * @param	index 	<code>uint</code> index of the entry to get.
		 * @return	<code>Object</code> stored at the specified <code>index</code>
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this set
		 */
		public function get ( index : uint ) : Object
		{
			isValidIndex( index );
			return _aSet[ index ];
		}

		/**
		 * Insert the passed-in <code>Object</code> in this set
		 * at the specified <code>index</code>. The method returns
		 * the object previously stored at this index.
		 * <p>
		 * If the passed-in <code>index</code> is not a valid index
		 * for this set, the function throw an 
		 * <code>IndexOutOfBoundsException</code> exception.
		 * </p><p>
		 * If the passed-in object's type prevents it to be added
		 * in this set the function will throw a 
		 * <code>ClassCastException</code>.
		 * </p>
		 * @param	index 	<code>uint</code> index at which insert the
		 * 					passed-in <code>Object</code>.
		 * @param	o		<code>Object</code> to insert in this set
		 * @return	<code>Object</code> previously stored at the specified
		 * 			<code>index</code> or null if the insertion haven't been 
		 * 			done.
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this set
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this set	
		 */
		public function set ( index : uint, o : Object ) : Object
		{
			isValidIndex( index );
			if( isValidObject( o ) )
				return _aSet.splice( index, 1, o )[0];
			else
				return null;
		}

		/**
		 * Verify that the passed-in <code>uint</code> index is a
		 * valid index for this </code>Set</code>. If not, an 
		 * <code>IndexOutOfBoundsException</code> exception is
		 * thrown.
		 *  
		 * @param	index 	<code>uint<code> index to verify
		 * @throws 	<code>IndexOutOfBoundsException</code> — The passed-in
		 * 			index is not a valid index for this set
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
					PixlibDebug.ERROR( "The passed-in collection with type '" + 
									   ( c as TypedContainer ).getType() +
									   "' has not the same type than" + this );
					
					throw new IllegalArgumentException( "The passed-in collection with type '" + 
													    ( c as TypedContainer ).getType() +
													    "' has not the same type than" + this );
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
		 * Verify that the passed-in object is valid for this <code>Set</code>
		 * (well-typed, not already present in the set).
		 * <p>
		 * In the case that the object's type prevents it to be added
		 * as element for this set the method will throw
		 * a <code>ClassCastException</code>.
		 * </p> 
		 * @return 	<code>true</code> if the object is valid
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this set
		 */
		public function isValidObject (o : Object) : Boolean
		{				
			if ( isValidType( o ) )
				return ( !contains( o ) );
			else 
				return false ;
		}

		/**
		 * Verify that the passed-in object type match the current 
		 * <code>Set</code> element's type. 
		 * <p>
		 * In the case that the set is untyped the function will
		 * always returns <code>true</code>.
		 * </p><p>
		 * In the case that the object's type prevents it to be added
		 * as element for this set the method will throw
		 * a <code>ClassCastException</code>.
		 * </p> 
		 * @param	o <code>Object</code> to verify
		 * @return  <code>true</code> if the object is elligible for this
		 * 			set object, either <cod>false</code>.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this set
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
					PixlibDebug.ERROR( o + " has a wrong type for " + this  );
					throw new ClassCastException( o + " has a wrong type for " + this  ) ;
				}
			}
			else
				return true ;
		}

		/**
		 * Returns <code>true</code> if this set contains no elements.
		 *
		 * @return <code>true</code> if this set contains no elements.
		 */
		public function isEmpty () : Boolean
		{
			return size() == 0;
		}

		/**
		 * Verify that the passed-in object type match the current 
		 * set element's type. 
		 * 
		 * @return  <code>true</code> if the object is elligible for this
		 * 			set object, either <code>false</code>.
		 */
		public function matchType ( o : * ) : Boolean
		{
			return o is _oType || o == null;
		}

		/**
		 * Returns <code>true</code> if this set perform a verification
		 * of the type of elements.
		 * 
		 * @return  <code>true</code> if this set perform a verification
		 * 			of the type of elements.
		 */
		public function isTyped () : Boolean
		{
			return _oType != null;
		}

		/**
		 * Return the class type of element in this set object.
		 * <p>
		 * An untyped set returns <code>null</code>, as the
		 * wildcard type (<code>*</code>) is not a <code>Class</code>
		 * and <code>Object</code> class doesn't fit for primitive types.
		 * </p>
		 * @return <code>Class</code> type of the set's elements
		 */
		public function getType () : Class
		{
			return _oType;
		}

		/**
		 * Returns an array containing all the elements in this set.
		 * Obeys the general contract of the <code>Collection.toArray</code>
		 * method.
		 *
		 * @return  <code>Array</code> containing all of the elements in this set.
		 * @see		Collection#toArray() Collection.toArray()
		 */
		public function toArray () : Array
		{
			return _aSet.concat();
		}

		/**
		 * Returns the <code>String</code> representation of
		 * this object. 
		 * <p>
		 * The function return a string like
		 * <code>com.bourre.collection::Set&lt;String&gt;</code>
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

import com.bourre.collection.ListIterator;
import com.bourre.collection.Set;
import com.bourre.error.NoSuchElementException;
import com.bourre.error.IllegalStateException;

internal class SetIterator implements ListIterator
{
	private var _c : Set;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _a : Array;
	private var _bRemoved : Boolean;
	private var _bAdded : Boolean;

	public function SetIterator ( c : Set, index : uint = 0 )
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