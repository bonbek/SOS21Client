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
	 * An iterator over a collection.
     * 
	 * @author 	Francis Bourre
	 * @version 1.0
	 * @see		Iterable
	 */
	public interface Iterator
	{
		/**
		 * Returns true if the iteration has more elements.
		 * (In other words, returns true if next would return
		 * an element rather than throwing an exception.)
		 * 
		 * @return <code>true</code> if the iterator has more elements.
		 */
		function hasNext() : Boolean;
		
 		/**
 		 * Returns the next element in the iteration. Calling this method
 		 * repeatedly until the hasNext() method returns false will return
 		 * each element in the underlying collection exactly once.
 		 * 
 		 * @return	the next element in the iteration.
 		 * @throws 	<code>NoSuchElementException</code> — iteration has no more elements.
 		 */
 		function next() : *;
 		
        /**
         * Removes from the underlying collection the last element returned
         * by the iterator (optional operation). This method can be called
         * only once per call to next. The behavior of an iterator is unspecified
         * if the underlying collection is modified while the iteration is in
         * progress in any way other than by calling this method.
         * 
         * @throws 	<code>UnsupportedOperationException</code> — if the remove  operation is not
         *          supported by this Iterator.
         * @throws 	<code>IllegalStateException</code> — if the next method has not yet been called,
         *          or the remove method has already been called after the last
         *          call to the next  method.
         */
        function remove() : void;
	}
}