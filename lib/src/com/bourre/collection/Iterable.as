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
	 * An object onto which the user can iterate using an <code>Iterator</code>
	 * object provided by this <code>Iterable</code> object.
	 * 
	 * @author 	Cédric Néhémie
	 * @see		Iterator
	 */
	public interface Iterable 
	{
		/**
	     * Returns an iterator over the elements in this collection. There are no
	     * guarantees concerning the order in which the elements are returned
	     * (unless this collection is an instance of some class that provides a
	     * guarantee).
	     * 
	     * @return an <code>Iterator</code> over the elements in this collection
	     */
		function iterator () : Iterator;
	}
}
