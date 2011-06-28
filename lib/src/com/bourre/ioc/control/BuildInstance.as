package com.bourre.ioc.control
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

	import com.bourre.core.CoreFactory;
	import com.bourre.log.*;
	import com.bourre.plugin.*;
	
	public class BuildInstance 
		implements IBuilder
	{

		public function build ( qualifiedClassName : String = null, 
								args : Array = null, 
								factory : String = null, 
								singleton : String = null, 
								channelName : String = null		) : *
		{
			var o : Object = null;

			if ( channelName ) ChannelExpert.getInstance().registerChannel( PluginChannel.getInstance( channelName ) );
			if ( qualifiedClassName ) o = CoreFactory.buildInstance( qualifiedClassName, args, factory, singleton );
			if ( o == null ) PixlibDebug.FATAL( this + ".build(" + qualifiedClassName + ") failed." );
			return o;
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}