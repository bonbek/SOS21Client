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
	 * A <code>TypedContainer</code> allow collections and data structures 
	 * to provide runtime type checking over their elements.
	 * <p>
	 * A typed container does not define how elements are inserted into
	 * the container, but provides convenient methods to check type 
	 * of these elements and to know if the container is typed and which
	 * type the container support.
	 * </p><p>
	 * By convention, the constructor of an implementation of the 
	 * <code>TypedContainer</code> interface will define an optional argument
	 * <code>type</code> such <code>type : Class = null</code> which let
	 * the user of the class define if the container is typed and which 
	 * type the container support.
	 * </p><p>
	 * When dealing with typed and untyped container, the following rules apply : 
	 * <ul>
	 * <li>Two typed container, which have the same type, can collaborate each other.</li>
	 * <li>Two untyped container can collaborate each other.</li>
	 * <li>An untyped container can add, remove, retain or contains any typed container
	 * of any type without throwing errors.</li>
	 * <li>A typed container will always fail when attempting to add, remove, retain
	 * or contains an untyped container.</li>
	 * </ul>
	 * </p> 
	 * @author	Cédric Néhémie
	 * @see		Queue
	 * @see		Set
	 * @see		Stack
	 */
	public interface TypedContainer
	{
		/**
		 * Verify that the passed-in object type match the current 
		 * container element's type. 
		 * 
		 * @return  <code>true</code> if the object is elligible for this
		 * 			container, either <code>false</code>.
		 */
		function matchType ( o : * ) : Boolean;
		
		/**
		 * Return the class type of elements in this container.
		 * <p>
		 * An untyped container returns <code>null</code>, as the
		 * wildcard type (<code>*</code>) is not a <code>Class</code>
		 * and <code>Object</code> class doesn't fit for primitive types.
		 * </p>
		 * @return <code>Class</code> type of the container's elements
		 */
		function getType () : Class;
		
		/**
		 * Returns <code>true</code> if this container perform a verification
		 * of the type of elements.
		 * 
		 * @return  <code>true</code> if this container perform a verification
		 * 			of the type of elements.
		 */
		function isTyped () : Boolean;
	}
}