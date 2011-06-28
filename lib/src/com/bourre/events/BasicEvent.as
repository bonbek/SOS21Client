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
	import flash.events.Event;
	
	import com.bourre.log.*;	

	/**
	 * The <code>BasicEvent</code> class adds the ability for
	 * developpers to change the <code>type</code> and the 
	 * <code>target</code> of an event after its creation.
	 * <p>
	 * Target and type redefinition is usefull when creating
	 * macro objects, which dispatch events, but according to
	 * their children event flow. The macro object may only 
	 * change event's type or target of the child event and
	 * then redispatch it to its own liteners. You could take
	 * a look to the <code>QueueLoader</code> class fo a concret 
	 * usage of this concept.
	 * </p> 
	 * @author 	Francis Bourre
	 * @see		com.bourre.load.QueueLoader
	 */	
	public class BasicEvent extends Event
	{
		/**
		 * The source object of this event, redefined to provide write access
		 */
		protected var _oTarget : Object;
		/**
		 * The type of the event, redefined to provide write access
		 */
		protected var _sType : String;
		
		/**
		 * Creates a new <code>BasicEvent</code> event for the
		 * passed-in event type. The <code>target</code> is optional, 
		 * if the target is omitted and the event used in combination
		 * with the <code>EventBroadcaster</code> class, the event
		 * target will be set on the event broadcaster source.
		 * 
		 * @param	type	<code>String</code> name of the event
		 * @param	target	an object considered as source for this event
		 * @see		EventBroadcaster#broadcastEvent() The EventBroadcaster.broadcastEvent() method
		 */
		public function BasicEvent( type : String, target : Object = null )
		{
			super ( type );
			_sType = type;
			_oTarget = target;
		}
		
		/**
		 * The type of this event
		 */
		public override function get type() : String
		{
			return _sType;
		}
		/**
		 * @private
		 */
		public function set type( en : String ) : void
		{
			_sType = en;
		}
		
		/**
		 * Defines the new event type for this event object.
		 * 
		 * @param	en	the new event name, or event type, as string
		 */
		public function setType( en : String ) : void
		{
			_sType = en;
		}
		/**
		 * Returns the type of this event, which generally correspond
		 * to the name of the called function on the listener.
		 * 
		 * @return	the type of this event
		 */
		public function getType():String
		{
			return _sType;
		}
		
		/**
		 * The source object of this event
		 */
		public override function get target() : Object
		{ 
			return _oTarget; 
		}
		/**
		 * @private
		 */
		public function set target( oTarget : Object ) : void 
		{ 
			_oTarget = oTarget; 
		}
		
		/**
		 * Defines the new source object of this event.
		 *  
		 * @param	oTarget	the new source object of this event
		 */
		public function setTarget( oTarget : Object ) : void 
		{ 
			_oTarget = oTarget; 
		}
		/**
		 * Returns the current source of this event object.
		 * 
		 * @return	object source of this event
		 */
		public function getTarget() : Object
		{ 
			return _oTarget; 
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}