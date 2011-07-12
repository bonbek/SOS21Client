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

package com.bourre.commands 
{
	import flash.events.Event;
	
	/**
	 * Encapsulate a request as an object, thereby letting you parameterize
	 * clients with different requests, queue or log requests, 
	 * and support undoable operations.
	 * <p>
	 * Commands are named <strong>state-less</strong> when they can work
	 * only from the passed-in event in the <code>execute</code> method without
	 * having to define any parameters in the constructor.
	 * </p><p>
	 * Commands can be asynchronous by implementing the <code>ASyncCommand</code>
	 * interface.
	 * </p>
	 * @author 	Francis Bourre
	 * @see		ASyncCommand
	 */
	public interface Command 
	{
		
		/**
		 * Execute the request according to the current command data.
		 * <p>
		 * Stateless commands may use the passed-in event object
		 * as data source for its execution. If the execution can't
		 * be performed because of unreachable data the command have
		 * to throw an error.
		 * </p> 
		 * @param	e	An event that will be used as data source by the command. 
		 * @throws 	<code>UnreachableDataException</code> — Stateless command use the passed-in event
		 * 			as data source for its execution, so the event must provide the right data for
		 * 			the current <code>Command</code> object.
		 */
		function execute( e : Event = null ) : void;
	}
}