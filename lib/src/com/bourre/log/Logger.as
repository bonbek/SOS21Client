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

package com.bourre.log {
	import com.bourre.events.ChannelBroadcaster;
	import com.bourre.events.EventChannel;	

	public class Logger
	{
		private static var _oI : Logger = null;
		
		private var _oCB : ChannelBroadcaster;
		private var _oLevel : LogLevel;
		
		public function Logger( o : ConstructorAccess )
		{
			setLevel( LogLevel.ALL );
			_oCB = new ChannelBroadcaster();
		}
		
		public static function getInstance() : Logger
		{
			if ( !(Logger._oI is Logger) ) Logger._oI = new Logger( new ConstructorAccess() );
			return Logger._oI;
		}
		
		public function setLevel( level : LogLevel ) : void
		{
			_oLevel = level;
		}
		
		public function getLevel() : LogLevel
		{
			return _oLevel;
		}
		
		public function log( e : LogEvent, oChannel : EventChannel = null ) : Boolean
		{	
			if ( e.level.getLevel() >= _oLevel.getLevel() ) 
			{
				_oCB.broadcastEvent( e, oChannel );
				return true;
			} else
			{
				return false;
			}
		}
		
		public function addLogListener( listener : LogListener, oChannel : EventChannel = null ) : void
		{
			_oCB.addEventListener( LogEvent.onLogEVENT, listener, oChannel );
		}
		
		public function removeLogListener( listener : LogListener, oChannel : EventChannel = null ) : void
		{
			_oCB.removeEventListener( LogEvent.onLogEVENT, listener, oChannel );
		}
		
		public function isRegistered( listener : LogListener, oChannel : EventChannel ) : Boolean
		{
			return _oCB.isRegistered( listener, LogEvent.onLogEVENT, oChannel );
		}
		
		public function hasListener( oChannel : EventChannel = null ) : Boolean
		{
			return _oCB.hasChannelListener( LogEvent.onLogEVENT, oChannel );
		}
		
		public function removeAllListeners() : void
		{
			_oCB.empty();
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		// static methods
		public static function LOG( o : *, level : LogLevel, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.getInstance().log( new LogEvent(level, o ), oChannel );
		}
		
		public static function DEBUG( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.DEBUG, oChannel  );
		}
		
		public static function INFO( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.INFO, oChannel  );
		}
		
		public static function WARN( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.WARN, oChannel );
		}
		
		public static function ERROR( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.ERROR, oChannel );
		}
		
		public static function FATAL( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.FATAL, oChannel );
		}
	}
}

internal class ConstructorAccess {}