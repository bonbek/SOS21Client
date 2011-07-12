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
	 * An asynchronous command is a runnable command, which is not terminated
	 * at the end of the <code>execute</code> call, for example a remoting request,
	 * or a file loading.
	 * <p>
	 * An asynchronous command define a specific ending for the operation. The 
	 * command dispatch an <code>onCommandEnd</code> event at the end of its process.
	 * </p>
	 * @author 	Francis Bourre
	 * @see		Command
	 * @see		Runnable
	 */
	public interface ASyncCommand extends Command, Runnable
	{
		/**
		 * Adds the passed-in command listener object as listener
		 * for this command events.
		 * <p>
		 * The <code>addASyncCommandListener</code> function support
		 * the custom arguments provided by the 
		 * <code>EventBroadcaster.addEventListener()</code> method.
		 * </p> 
		 * @param	listener	the listener object which want to
		 * 						receive notification from this command
		 * @param	rest		optional arguments corresponding to the 
		 * 						<code>EventBroadcaster.addEventListener()</code>
		 * 						behavior.
		 * @return	<code>true</code> if the listener have been added as result
		 * 			of the call	
		 * @see		com.bourre.events.EventBroadcaster#addEventListener()
		 * 			EventBroadcaster.addEventListener() documentation
		 */
		function addASyncCommandListener( listener : ASyncCommandListener, ... rest ) : Boolean;
		
		/**
		 * Removes the passed-in command listener object as listener
		 * for this command events.
		 * 
		 * @param	listener	the listener object which to remove from this
		 * 						command's listeners
		 * @return	<code>true</code> if the listener have been removed as result
		 * 			of the call	
		 * @see		com.bourre.events.EventBroadcaster#addEventListener()
		 * 			EventBroadcaster.addEventListener() documentation
		 */
		function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean;
		
		/**
		 * Fires the <code>onCommandEnd</code> event to the listeners of this command. 
		 */
		function fireCommandEndEvent() : void;
	}
}