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
	 * to its listeners.
	 * 
	 * @author 	Cédric Néhémie
	 * @see		BasicEvent
	 * @see		com.bourre.event.LoopCommand	 * @see		com.bourre.event.LoopCommandListener
	 */
	public class LoopEvent extends BasicEvent 
	{
		private var _nCount : Number;
		
		/**
		 * Creates a new <code>LoopEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target object of this event
		 * @param	count	the number of iterations realized
		 * 					since this event be fired
		 */
		public function LoopEvent ( type : String, target : Object = null, count : Number = 0 )
		{
			super( type, target );
			_nCount = count;
		}
		
		/**
		 * Returns the iterations count since this event be fired.
		 * 
		 * @return	the number of iterations realized
		 * 			since this event be fired
		 */
		public function getCount () : Number
		{
			return _nCount;
		}
	}
}
