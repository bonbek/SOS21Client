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
	public class LogLevel
	{
		public static const ALL : LogLevel = new LogLevel( uint.MIN_VALUE, "ALL" );
		public static const DEBUG : LogLevel = new LogLevel( 10000, "DEBUG" );
		public static const INFO : LogLevel = new LogLevel( 20000, "INFO" );
		public static const WARN:LogLevel = new LogLevel( 30000, "WARN" );
		public static const ERROR:LogLevel = new LogLevel( 40000, "ERROR" );
		public static const FATAL:LogLevel = new LogLevel( 50000, "FATAL" );
		public static const OFF:LogLevel = new LogLevel( uint.MAX_VALUE, "OFF" );
	
		private var _sName : String;
		private var _nLevel : Number;
		
		public function LogLevel( nLevel : uint = uint.MIN_VALUE, sName : String = "" )
		{
			_sName = sName;
			_nLevel = nLevel;
		}
		
		public function getName() : String
		{
			return _sName;
		}
	
		public function getLevel() : uint
		{
			return _nLevel;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
