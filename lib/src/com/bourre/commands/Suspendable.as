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
	 * <code>Suspendable</code> defines rules for <code>Runnable</code>
	 * implementations whose instances process could be suspended.
	 * Implementers should consider the possibility for the user of the class
	 * to suspend or not the operation, if the operation could be suspended,
	 * the implementer should create a <code>Suspendable</code> class.
	 * <p>
	 * More formally, an operation is suspendable if and only if the operation could
	 * be paused(stopped) and resumed(re-started) without breaking the state of the
	 * process. For example, a loading process could be stopped, but it couldn't
	 * be suspended, when a file loading is stopped there's no possibility to restart
	 * it at the point it was stopped. In that logic, the only way to reset the state
	 * of a suspendable operation is to call the <code>reset</code> method defined
	 * in this interface. 
	 * </p><p>
	 * Implementing the <code>Suspendable</code> interface doesn't require anything
	 * regarding the time outflow approach. The only requirements concerned the suspendable
	 * nature of the process. 
	 * </p><p>
	 * Note : There's no restriction concerning class which would implements both <code>Suspendable</code>
	 * and <code>Cancelable</code> interfaces.
	 * </p>
	 * @author 	Cédric Néhémie
	 * @see		Runnable
	 * @see		Cancelable
	 */
	public interface Suspendable extends Runnable
	{
		/**
		 * Starts the operation of this suspendable operation.
		 * If a call to the <code>start</code> method is done
		 * while the operation is playing, concret class must
		 * ignore it. 
		 */
		function start() : void;
		
		/**
		 * Stops the operation in process. If a call to the
		 * <code>stop</code> method is done whereas this operation
		 * is already stopped, concret class must ignore it.
		 */
		function stop() : void;
		
		/**
		 * Resets the state of this object. The state of an operation
		 * could be reset at any time, whether it be running or stopped.
		 */
		function reset () : void;
	}
}
