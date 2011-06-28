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
	/**
	 * The <code>Runnable</code> interface should be implemented by any
	 * class whose instances are intended to be executed asynchronously.
	 * The class must define a method of no arguments called <code>run</code>.
	 * <p>
	 * This interface is designed to provide a common protocol for objects
	 * that wish to execute code while they are active. For example,
	 * <code>Runnable</code> is implemented by interface <code>Tween</code>
	 * or <code>ASyncCommand</code>. Being active simply means that an
	 * asynchronous process has been started and has not yet been stopped.
	 * </p><p>
	 * Concret implementations must take care that a process is considered
	 * as running only if there is an active computation. More formally,
	 * if the operation is paused, suspended (as defined by the
	 * <code>Suspendable</code> interface or any other interface), the
	 * object is considered as not running.
	 * <p>
	 * To go further, and to make clear the differents reflections about
	 * the <i>run</i> concept, I will detail the notion with the loading 
	 * example. We could consider that a loading is not running inasmuch
	 * as the bytes loaded doesn't change since the last check. In that
	 * approach we can make the timeout detection more accurate by not
	 * esteem systematically that a slow loading is a failing loading.	 * </p><p>
	 * The rules which defines the interruption clauses of a <code>Runnable</code>
	 * are not defined here. Sub-interfaces such <code>Suspendable</code> and
	 * <code>Cancelable</code> provides methods to allow users to interrupt the
	 * operation in slightly different ways.
	 * </p><p>
	 * There's no restriction about how concret classes implements or not
	 * a notification of their process completion. More formally, there's 
	 * many possible ending for an asynchronous process, such failure, success
	 * or user interruption, it is the reason why there's many interface which
	 * extends the <code>Runnable</code> interface to define process ending rules.	 * </p>
	 * @author	Cédric Néhémie
	 */
	public interface Runnable 
	{
		/**
		 * Starts the asynchronous process of this runnable object.
		 * <p>
		 * The contract for concret implementations of the <code>run</code> 
		 * method is that the <code>Runnable</code> object must be considered
		 * as running as result of the call. Except if an exception was throw
		 * during the call.
		 * </p>
		 * @throws 	<code>IllegalStateException</code> — if the <code>run</code>
		 * 			method have been called wheras the operation is currently
		 * 			running.
		 * @throws 	<code>IllegalStateException</code> — if the object cannot
		 * 			be run for any reasons.
		 */
		function run() : void;
		
		/**
		 * Returns <code>true</code> if this object is running. 
		 * 
		 * @return <code>true</code> if this object is running.
		 */
		function isRunning () : Boolean;
	}
}
