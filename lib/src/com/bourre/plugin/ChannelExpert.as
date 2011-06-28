package com.bourre.plugin
{
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
	 * @author Romain Flacher
	 * @version 1.0
	 */

	import com.bourre.collection.HashMap;
	import com.bourre.events.*;
	import com.bourre.log.*;

	import flash.utils.Dictionary;
	
	public class ChannelExpert
	{
		private static var _oI : ChannelExpert;
		private static var _N : uint = 0;

		private var _m : HashMap;
		private var _oRegistered : Dictionary;
		
		/**
		 * @return singleton instance of ChannelExpert
		 */
		public static function getInstance() : ChannelExpert 
		{
			if ( !( ChannelExpert._oI is ChannelExpert ) ) 
				ChannelExpert._oI = new ChannelExpert( new PrivateConstructorAccess() );

			return ChannelExpert._oI;
		}
		
		public static function release():void
		{
			if ( ChannelExpert._oI is ChannelExpert ) 
			{
				ChannelExpert._oI = null;
				ChannelExpert._N = 0;
			}
		}
		
		public function ChannelExpert( access : PrivateConstructorAccess )
		{
			_m = new HashMap();
			_oRegistered = new Dictionary( true );
		}
		
		public function getChannel( o : Plugin ) : EventChannel
		{
			if( _oRegistered[o] == null )
			{
				if ( _m.containsKey( ChannelExpert._N ) )
				{
					var channel : EventChannel = _m.get( ChannelExpert._N ) as EventChannel;
					_oRegistered[o] = channel;
					++ ChannelExpert._N;
					return channel;
		
				} else
				{
					PluginDebug.getInstance().debug( this + ".getChannel() failed on " + o );
					_oRegistered[o] = ApplicationBroadcaster.getInstance().NO_CHANNEL;
					return ApplicationBroadcaster.getInstance().NO_CHANNEL;
				}
			}
			else
			{
				 return _oRegistered[o] as EventChannel;
			}
		}
		
		public function releaseChannel( o : Plugin ) : Boolean
		{
			if( _oRegistered[o] )
			{
				if ( _m.containsKey( o.getChannel() ) ) _m.remove( o.getChannel() );
				_oRegistered[o] = null;

				return true;
			}
			else
			{
				 return false;
			}
		}
		
		public function registerChannel( channel : EventChannel ) : void
		{
			_m.put( ChannelExpert._N, channel );
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

internal class PrivateConstructorAccess {}