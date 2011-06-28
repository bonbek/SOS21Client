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

/**
 * @author Francis Bourre
 * @version 1.0
 */

package com.bourre.log
{
	import flash.events.Event;

	public class LogEvent 
		extends Event
	{
		public static const onLogEVENT : String = "onLog";
		
		public var level : LogLevel;
		public var message : *;
		
		public function LogEvent( level : LogLevel, message : * = undefined )
		{
			super( LogEvent.onLogEVENT, false, false );

			this.level = level;
			this.message = message;
		}
		
		public override function clone() : Event 
		{
            return new LogEvent( level, message );
        }
        
        /**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}