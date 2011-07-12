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
	 * An event object which carry a value object.
	 * 
	 * @author	Francis Bourre
	 * @see		BasicEvent
	 * @see		ValueObject
	 */
	public class ValueObjectEvent extends BasicEvent
	{
		private var _o : ValueObject;
		
		/**
		 * Creates a new <code>ValueObjectEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * @param	obj		value object carried by this event
		 */
		public function ValueObjectEvent( type : String, target : Object = null, obj : ValueObject = null )
		{
			super( type, target );
			_o = obj;
		}
		
		/**
		 * Returns the value object carried by this event.
		 * 
		 * @return	the value object carried by this event.
		 */
		public function getValueObject() : ValueObject
		{
			return _o;
		}
	}
}