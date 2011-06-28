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
	 * The <code>ApplicationBroadcaster</code> class is a singleton
	 * implementation of the <code>ChannelBroadcaster</code> class, 
	 * used for <i>Inversion of Controls</i> purpose. More formally
	 * the application broadcaster is dedicated to plugin to plugin
	 * communication. When defining a plugin with a specific channel, 
	 * and then listeners of this plugin, a channel instance is created
	 * in the <code>ChannelExpert</code> and then this channel is used
	 * in order to create the whole dispatching stuff between these 
	 * plugins.
	 * <p>
	 * The class defines two constant channels dedicated to an IoC usage.
	 * These channel represents particular behaviors of the application
	 * broadcaster. Such : 
	 * <ul>
	 * <li><code>NO_CHANNEL</code> : That constant, when used as argument of
	 * the <code>getChannelDispatcher</code> method, force the application
	 * broadcaster to ignore the call. No broadcaster will be created and
	 * then returned by the function.</li>
	 * <li><code>SYSTEM_CHANNEL</code> : Defines the default channel of the
	 * application broadcaster singleton. All objects which add themselves
	 * as listener without specifying any channel are considered as system
	 * listeners.</li>
	 * </ul>
	 * </p>
	 * 
	 * @author 	Francis Bourre
	 * @author 	Romain Flacher
	 * @see		ChannelBroadcaster
	 * @see		com.bourre.plugin.ChannelExpert
	 */
	public class ApplicationBroadcaster	extends ChannelBroadcaster
	{
		private static var _oI : ApplicationBroadcaster;

		/**
		 * Inhibit the behavior of the <code>getChannelDispatcher</code>
		 * which will return nothing if this channel is passed as argument.
		 */
		public const NO_CHANNEL : EventChannel = new NoChannel( );

		/**
		 * Default channel for the application broadcaster, all listeners
		 * which not define any channel are considered as system listeners.
		 */
		public const SYSTEM_CHANNEL : EventChannel = new SystemChannel( );

		/**
		 * Returns the singleton instance of the <code>ApplicationBroadcaster</code>
		 * class. The class instance is created using the lazy initialisation concept.
		 * 
		 * @return	singleton instance of <code>ApplicationBroadcaster</code>
		 */
		public static function getInstance () : ApplicationBroadcaster 
		{
			if ( !(ApplicationBroadcaster._oI is ApplicationBroadcaster) ) 
				ApplicationBroadcaster._oI = new ApplicationBroadcaster( new PrivateConstructorAccess( ) );
				
			return ApplicationBroadcaster._oI;
		}

		/**
		 * Creates a new <code>ApplicationBroadcaster</code> object. This constructor
		 * is locked using a simple hack, you cannot call the constructor directly.
		 * Please use the <code>ApplicationBroadcaster.getInstance</code> method instead,
		 * in order to retreive the singleton instance of the class.
		 * 
		 * @param	access	a lock for direct instanciation of the
		 * 					<code>ApplicationBroadcaster</code>	class
		 */
		public function ApplicationBroadcaster ( access : PrivateConstructorAccess )
		{
			super( SYSTEM_CHANNEL );
		}

		/**
		 * Returns the <code>EventBroadcaster</code> object associated with
		 * the passed-in <code>channel<code>. The <code>owner</code> is an optionnal
		 * parameter which is used to initialize the newly created <code>EventBroadcaster</code>
		 * when there is no broadcaster for this channel.
		 * <p>
		 * There's a particular case defined by this class, when passing the <code>NO_CHANNEL</code>
		 * channel in this function, the function will return <code>null</code> instead of a broadcaster.
		 * </p>
		 * 
		 * @param	channel	the channel for which get the associated broadcaster
		 * @param	owner	an optional object which will used as source if there
		 * 					is no broadcaster associated to the channel
		 * @return	the <code>EventBroadcaster</code> object associated with
		 * 			the passed-in <code>channel<code>
		 */
		public override function getChannelDispatcher ( channel : EventChannel = null, owner : Object = null ) : EventBroadcaster
		{
			return ( channel != NO_CHANNEL ) ? super.getChannelDispatcher( channel, owner ) : null;
		}
	}
}

import com.bourre.events.EventChannel;

internal class NoChannel extends EventChannel
{
}

internal class SystemChannel extends EventChannel
{
}

internal class PrivateConstructorAccess 
{
}