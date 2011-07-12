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

	/**
	 * An event object which carry a string value.
	 * 
	 * @author	Francis Bourre
	 * @see		BasicEvent
	 */
	public class StringEvent extends BasicEvent
	{
		private var _s : String;
		
		/**
		 * Creates a new <code>StringEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * @param	string	string value carried by this event
		 */
		public function StringEvent( type : String, target : Object = null, string : String = "" )
		{
			super( type, target );
			_s = string;
		}
		
		/**
		 * Returns the string value carried by this event.
		 * 
		 * @return	the string value carried by this event.
		 */
		public function getString() : String
		{
			return _s;
		}
	}
}