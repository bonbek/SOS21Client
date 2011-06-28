package com.bourre.log 
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
	 * @version 1.0
	 */

	import com.bourre.events.EventChannel;

	public class PixlibDebug 
	{
		public static var isOn : Boolean = true;
		private static var _CHANNEL : EventChannel;
		
		public function PixlibDebug()
		{
			
		}
		
		public static function get CHANNEL() : EventChannel
		{
			if ( !PixlibDebug._CHANNEL ) PixlibDebug._CHANNEL = new PixlibDebugChannel();
			return PixlibDebug._CHANNEL;
		}
		
		public static function DEBUG( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.DEBUG( o, PixlibDebug.CHANNEL );
		}
		
		public static function INFO( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.INFO( o, PixlibDebug.CHANNEL );
		}
		
		public static function WARN( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.WARN( o, PixlibDebug.CHANNEL );
		}
		
		public static function ERROR( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.ERROR( o, PixlibDebug.CHANNEL );
		}
		
		public static function FATAL( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.FATAL( o, PixlibDebug.CHANNEL );
		}
	}
}

import com.bourre.events.EventChannel;

internal class PixlibDebugChannel 
	extends EventChannel
{
	
}