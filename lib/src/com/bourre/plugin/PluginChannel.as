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
	 * @version 1.0
	 */

	import com.bourre.events.EventChannel;
	import com.bourre.collection.HashMap;
	
	public class PluginChannel
		extends EventChannel
	{
		private static var _M : HashMap = new HashMap();
		
		public function PluginChannel( access : PrivateConstructorAccess, channelName : String )
		{
			super( channelName );
		}
		
		public static function getInstance( channelName : String ) : PluginChannel
		{
			if ( !(PluginChannel._M.containsKey( channelName )) )
				PluginChannel._M.put( channelName, new PluginChannel( new PrivateConstructorAccess(), channelName ) );
				
			return PluginChannel._M.get( channelName ) as PluginChannel;
		}
	}
}

internal class PrivateConstructorAccess{}