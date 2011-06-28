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
	/**
	 * The root interface in the <i>collection hierarchy</i>. A collection
	 * represents a group of objects, known as its <i>elements</i>. Some
	 * collections allow duplicate elements and others do not. Some are ordered
	 * and others unordered. This interface is typically used to pass 
	 * collections around and manipulate them where maximum generality is 
	 * desired.
	 * <p>
	 * The "destructive" methods contained in this interface, that is, the
	 * methods that modify the collection on which they operate, are specified to
	 * throw <code>UnsupportedOperationException</code> if this collection does not
	 * support the operation. If this is the case, these methods may, but are not
	 * required to, throw an <code>UnsupportedOperationException</code> if the
	 * invocation would have no effect on the collection. For example, invoking
	 * the <code>addAll(Collection)</code> method on an unmodifiable collection may,
	 * but is not required to, throw the exception if the collection to be added
	 * is empty.
	 * </p><p>
	 * Some collection implementations have restrictions on the elements that
	 * they may contain.  For example, some implementations prohibit null elements,
	 * and some have restrictions on the types of their elements. Attempting to
	 * add an ineligible element throws an unchecked exception, typically
	 * <code>NullPointerException</code> or <code>ClassCastException</code>. Attempting
	 * to query the presence of an ineligible element may throw an exception,
	 * or it may simply return false; some implementations will exhibit the former
	 * behavior and some will exhibit the latter. More generally, attempting an
	 * operation on an ineligible element whose completion would not result in
	 * the insertion of an ineligible element into the collection may throw an
	 * exception or it may succeed, at the option of the implementation.
	 * Such exceptions are marked as "optional" in the specification for this
	 * interface. 
	 * </p><p>
	 * When dealing with typed and untyped collection, the following rules apply : 
	 * <ul>
	 * <li>Two typed collection, which have the same type, can collaborate each other.</li>
	 * <li>Two untyped collection can collaborate each other.</li>
	 * <li>An untyped collection can add, remove, retain or contains any typed collection
	 * of any type without throwing errors.</li>
	 * <li>A typed collection will always fail when attempting to add, remove, retain
	 * or contains an untyped collection.</li>
	 * </ul></p>
	 *
	 * @author 	Francis Bourre
	 */
	public interface Collection extends Iterable
	{
		/**
	     * Returns the number of elements in this collection.
	     * 
	     * @return the number of elements in this collection
	     */
		function size() : uint;
		
		/**
	     * Returns <code>true</code> if this collection contains no elements.
	     *
	     * @return <code>true</code> if this collection contains no elements
	     */
		function isEmpty() : Boolean;
		
		/**
	     * Returns <code>true</code> if this collection contains the specified
	     * element.
	     *
	     * @param 	o element whose presence in this collection is to be tested.
	     * @return 	<code>true</code> if this collection contains the specified
	     *         	element
	     * @throws 	<code>ClassCastException</code> — if the type of the specified element
	     * 	       	is incompatible with this collection (optional).
	     * @throws 	<code>NullPointerException</code> — if the specified element is null and this
	     *         	collection does not support null elements (optional).
	     */
		function contains( o : Object ) : Boolean;
		
		/**
	     * Returns an array containing all of the elements in this collection.  If
	     * the collection makes any guarantees as to what order its elements are
	     * returned by its iterator, this method must return the elements in the
	     * same order.
	     * <p>
	     * The returned array will be "safe" in that no references to it are
	     * maintained by this collection.  (In other words, this method must
	     * allocate a new array even if this collection is backed by an array).
	     * The caller is thus free to modify the returned array.
	     * </p><p>
	     * This method acts as bridge between array-based and collection-based
	     * APIs.
	     * </p>
	     * @return 	an array containing all of the elements in this collection
	     */
		function toArray() : Array;
		
		// Modification Operations
		
		/**
	     * Ensures that this collection contains the specified element (optional
	     * operation). Returns <code>true</code> if this collection changed as a
	     * result of the call. (Returns <code>false</code> if this collection does
	     * not permit duplicates and already contains the specified element.)
	     * <p>
	     * Collections that support this operation may place limitations on what
	     * elements may be added to this collection.  In particular, some
	     * collections will refuse to add <code>null</code> elements, and others will
	     * impose restrictions on the type of elements that may be added.
	     * Collection classes should clearly specify in their documentation any
	     * restrictions on what elements may be added.
	     * </p><p>
	     * If a collection refuses to add a particular element for any reason
	     * other than that it already contains the element, it <i>must</i> throw
	     * an exception (rather than returning <code>false</code>). This preserves
	     * the invariant that a collection always contains the specified element
	     * after this call returns.
	     * </p>
	     * @param 	o element whose presence in this collection is to be ensured.
	     * @return 	<code>true</code> if this collection changed as a result of the
	     *         	call 
	     * @throws 	<code>UnsupportedOperationException</code> — <code>add</code> is not supported by
	     *         	this collection.
	     * @throws 	<code>ClassCastException</code> — class of the specified element prevents it
	     *         	from being added to this collection.
	     * @throws 	<code>NullPointerException</code> — if the specified element is null and this
	     *         	collection does not support null elements.
	     * @throws 	<code>IllegalArgumentException</code> — some aspect of this element prevents
	     *         	it from being added to this collection.
	     */
		function add( o : Object ) : Boolean;
		
		/**
	     * Removes a single instance of the specified element from this
	     * collection, if this collection contains one or more such
	     * elements.  Returns true if this collection contained the specified
	     * element (or equivalently, if this collection changed as a result of the
	     * call).
	     *
	     * @param 	o element to be removed from this collection, if present.
	     * @return 	<code>true</code> if this collection changed as a result of the
	     *         	call
	     * @throws 	<code>ClassCastException</code> — if the type of the specified element
	     * 	       	is incompatible with this collection (optional).
	     * @throws 	<code>NullPointerException</code> — if the specified element is null and this
	     *         	collection does not support null elements (optional).
	     * @throws 	<code>UnsupportedOperationException</code> — <code>remove</code> is not supported
	     * 			by this collection.
	     */
		function remove( o : Object ) : Boolean;
		
		// Bulk Operations
		
		/**
	     * Returns <code>true</code> if this collection contains all of the elements
	     * in the specified collection.
	     *
	     * @param  	c 	collection to be checked for containment in this collection.
	     * @return 	<code>true</code> if this collection contains all of the elements
	     *	       	in the specified collection
	     * @throws 	<code>ClassCastException</code> — if the types of one or more elements
	     *         	in the specified collection are incompatible with this
	     *         	collection (optional).
	     * @throws 	<code>NullPointerException</code> — if the specified collection contains one
	     *         	or more null elements and this collection does not support null
	     *         	elements (optional).
	     * @throws 	<code>NullPointerException</code> — if the specified collection is
	     *         	<code>null</code>.
	     * @see    	#contains() contains()
	     */
		function containsAll( c : Collection ) : Boolean;
		
		/**
	     * Adds all of the elements in the specified collection to this collection
	     * (optional operation).
	     *
	     * @param 	c 	elements to be inserted into this collection.
	     * @return 	<code>true</code> if this collection changed as a result of the
	     *         	call
	     * @throws 	<code>UnsupportedOperationException</code> — if this collection does not
	     *         	support the <code>addAll</code> method.
	     * @throws 	<code>ClassCastException</code> — if the class of an element of the specified
	     * 	       	collection prevents it from being added to this collection.
	     * @throws 	<code>NullPointerException</code> — if the specified collection contains one
	     *         	or more null elements and this collection does not support null
	     *         	elements, or if the specified collection is <code>null</code>.
	     * @throws 	<code>IllegalArgumentException</code> — some aspect of an element of the
	     *	       	specified collection prevents it from being added to this collection.
	     * @see 	#add() add()
	     */
		function addAll( c : Collection ) : Boolean;
		
		/**
	     * 
	     * Removes all this collection's elements that are also contained in the
	     * specified collection (optional operation).  After this call returns,
	     * this collection will contain no elements in common with the specified
	     * collection.
	     *
	     * @param 	c 	elements to be removed from this collection.
	     * @return 	<code>true</code> if this collection changed as a result of the
	     *         	call
	     * @throws 	<code>UnsupportedOperationException</code> — if the <code>removeAll</code> method
	     * 	       	is not supported by this collection.
	     * @throws 	<code>ClassCastException</code> — if the types of one or more elements
	     *         	in this collection are incompatible with the specified
	     *         	collection (optional).
	     * @throws 	<code>NullPointerException</code> — if this collection contains one or more
	     *         	null elements and the specified collection does not support
	     *         	null elements (optional).
	     * @throws 	<code>NullPointerException</code> — if the specified collection is
	     *         	<code>null</code>.
	     * @see 	#remove() remove()
	     * @see 	#contains() contains()
	     */
		function removeAll( c : Collection ) : Boolean;
		
		/**
	     * Retains only the elements in this collection that are contained in the
	     * specified collection (optional operation).  In other words, removes from
	     * this collection all of its elements that are not contained in the
	     * specified collection.
	     *
	     * @param 	c elements to be retained in this collection.
	     * @return 	<code>true</code> if this collection changed as a result of the
	     *         	call 
	     * @throws 	<code>UnsupportedOperationException</code> — if the <code>retainAll</code> method
	     * 	       	is not supported by this Collection.
	     * @throws 	<code>ClassCastException</code> — if the types of one or more elements
	     *         	in this collection are incompatible with the specified
	     *         	collection (optional).
	     * @throws 	<code>NullPointerException</code> — if this collection contains one or more
	     *         	null elements and the specified collection does not support null 
	     *         	elements (optional).
	     * @throws 	<code>NullPointerException</code> — if the specified collection is
	     *         	<code>null</code>.
	     * @see 	#remove() remove()
	     * @see 	#contains() contains()
	     */
		function retainAll( c : Collection ) : Boolean;
		
		/**
	     * Removes all of the elements from this collection (optional operation).
	     * This collection will be empty after this method returns unless it
	     * throws an exception.
	     *
	     * @throws 	<code>UnsupportedOperationException</code> — if the <code>clear</code> method is
	     *         	not supported by this collection.
	     */
		function clear() : void;
	}
}