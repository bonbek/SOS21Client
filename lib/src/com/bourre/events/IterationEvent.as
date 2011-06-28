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
package com.bourre.events 
{
	import com.bourre.events.BasicEvent;
	
	/**
	 * Event dispatched by the <code>LoopCommand</code> class
	 * to its dedicated <code>IterationCommand</code>. The event
	 * carry the iteration index, and its associated value, provided
	 * by the <code>Iterator</code> used by the loop command.
	 * 
	 * @author 	Cédric Néhémie
	 * @see		BasicEvent
	 * @see		com.bourre.event.LoopCommand	 * @see		com.bourre.event.IterationCommand
	 */
	public class IterationEvent extends BasicEvent 
	{
		private var _nIndex : Number;
		private var _oValue : *;
		
		/**
		 * Creates a new <code>Iteration</code> event.
		 * 
		 * @param	type	name of this event type
		 * @param	target	target of this event
		 * @param	index	index of the current iteration
		 * @param	value	value associated with this iteration
		 */
		public function IterationEvent ( type : String, target : Object = null, index : Number = 0, value : * = null )
		{
			super( type, target );
			
			_nIndex = index;
			_oValue = value;
		}
		
		/**
		 * Returns the index of the iteration in the loop
		 * performed by the <code>LoopCommand</code>.
		 * 
		 * @return	the index of the iteration in the loop
		 * 			performed by the <code>LoopCommand</code>
		 */
		public function getIndex () : Number
		{
			return _nIndex;
		}		
		/**
		 * Returns the value of the iteration in the loop
		 * performed by the <code>LoopCommand</code>.
		 * 
		 * @return	the value of the iteration in the loop
		 * 			performed by the <code>LoopCommand</code>
		 */
		public function getValue () : *
		{
			return _oValue;
		}
	}
}
