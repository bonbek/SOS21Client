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
	
	import com.bourre.collection.*;
	import com.bourre.log.*;	

	/**
	 * The <code>ChannelBroadcaster</code> is a macro broadcaster
	 * which offer to dispatch events over communication channels.
	 * <p>
	 * The main idea is the following, developpers can create specific
	 * channels for communication, onto which event will be broadcasted.
	 * To take a metaphor, is like a CB radio, you can select a frequency
	 * and then you will listen and talk to people which are connected to
	 * that frequency, and only that one. To achieve this process, the
	 * channel broadcaster aggregate <code>EventBroadcaster</code> and
	 * map it with <code>EventChannel</code> object. In that principle
	 * the channel broadcaster is no more than a CB base station. With
	 * a big difference anyway, the channel broadcaster offer an access
	 * to a frequency, it doesn't broadcast messages.
	 * </p><p>
	 * To initiate the dispatching on a specific channel, developpers
	 * only need to call the redefined functions of the class as they
	 * can do with the <code>EventBroadcaster</code> class with a proper
	 * event channel, the channel broadcaster will check for the presence
	 * of an event broadcaster for this channel, and if there's no corresponding
	 * broadcaster it will create it.
	 * </p><p>
	 * The channel broadcaster redefine many functions of the 
	 * <code>EventBroadcaster</code> class in order to add the channel
	 * parameter. Below the list of redefined methods : 
	 * <ul>
	 * <li><code>isRegistered</code></li>	 * <li><code>broadcastEvent</code></li>	 * <li><code>addListener</code></li>	 * <li><code>addEventListener</code></li>	 * <li><code>removeListener</code></li>	 * <li><code>removeEventListener</code></li>	 * <li><code>hasChannelListener</code>, which correspond 
	 * to the <code>hasListenerCollection</code> method of the 
	 * <code>EventBroadcaster</code> class</li>.
	 * </ul></p>
	 * 
	 * @author 	Francis Bourre
	 * @see		EventBroadcaster
	 * @see		EventChannel
	 */
	public class ChannelBroadcaster
	{
		private var _oDefaultChannel :EventChannel;
		private var _mChannel : HashMap;
		
		/**
		 * Creates a new <code>ChannelBroadcaster</code> with the passed-in
		 * event channel as default channel. The default channel is used when
		 * a call to function is done without specifying any channel. If the 
		 * channel argument is omitted, the default channel is set to the
		 * internal <code>DefaultChannel.CHANNEL</code> constant.
		 * 
		 * @param	channel	default channel for this broadcaster
		 */
		public function ChannelBroadcaster( channel : EventChannel = null )
		{
			empty();
			setDefaultChannel( channel );
		}
		
		/**
		 * Returns the <code>EventBroadcaster</code> associated with
		 * the default channel of this channel broadcaster.
		 * 
		 * @return	the <code>EventBroadcaster</code> associated with
		 * 			the default channel of this channel broadcaster 
		 */
		public function getDefaultDispatcher() : EventBroadcaster
		{
			return _mChannel.get( _oDefaultChannel );
		}
		
		/**
		 * Returns a reference to the default channel of this
		 * channel broadcaster. This function never returns
		 * <code>null</code>.
		 * 
		 * @return	a reference to the default channel of this
		 * 			channel broadcaster
		 */
		public function getDefaultChannel() : EventChannel
		{
			return _oDefaultChannel;
		}
		
		/**
		 * Defines which channel is used as default channel for this
		 * channel broadcaster. If the passed-in channel is <code>null</code>
		 * the internal <code>DefaultChannel.CHANNEL</code> constant is used
		 * as default channel.
		 * 
		 * @param	channel	the new default channel for this channel broadcaster
		 */
		public function setDefaultChannel( channel : EventChannel = null ) : void
		{
			_oDefaultChannel = (channel == null) ? DefaultChannel.CHANNEL : channel;
			getChannelDispatcher( getDefaultChannel() );
		}
		
		/**
		 * Clean the current channel broacaster by removing all 
		 * <code>EventBroadcaster</code> previously created and
		 * then rebuild the default <code>EventBroadcaster</code>. 
		 */
		public function empty() : void
		{
			_mChannel = new HashMap();
			
			var channel : EventChannel = getDefaultChannel();
			if ( channel != null ) getChannelDispatcher( channel );
		}
		
		/**
		 * Returns <code>true</code> if the passed-in <code>listener</code>
		 * is registered as listener for the passed-in event <code>type</code>
		 * in the passed-in <code>channel</code>.
		 * 
		 * @param	listener	object to look for registration
		 * @param	type		event type to look at
		 * @param	channel		channel onto which look at
		 * @return	<code>true</code> if the passed-in <code>listener</code>
		 * 			is registered as listener for the passed-in event
		 * 			<code>type</code> in the passed-in <code>channel</code>
		 */
		public function isRegistered( listener : Object, type : String, channel : EventChannel ) : Boolean
		{
			if( hasChannelDispatcher( channel ) )
				return getChannelDispatcher( channel ).isRegistered( listener, type );
			else 
				return false;
		}
		
		/**
		 * Returns <code>true</code> if there is an <code>EventBroadcaster</code>
		 * registered for the passed-in channel.
		 * 
		 * @param	channel	channel onto which look at
		 * @return	<code>true</code> if there is an <code>EventBroadcaster</code>
		 * 			registered for the passed-in channel
		 */
		public function hasChannelDispatcher( channel : EventChannel ) : Boolean
		{
			return channel == null ? _mChannel.containsKey( _oDefaultChannel ) : _mChannel.containsKey( channel );
		}
		
		/**
		 * Returns <code>true</code> if there is an <code>EventBroadcaster</code>
		 * registered for the passed-in channel, and if this broadcaster has registered
		 * listeners.
		 * 
		 * @param	type		event type to look at
		 * @param	channel		channel onto which look at
		 * @return	<code>true</code> if there is an <code>EventBroadcaster</code>
		 * 			registered for the passed-in channel, and if this broadcaster
		 * 			has registered listeners
		 */
		public function hasChannelListener( type : String, channel : EventChannel = null ) : Boolean
		{
			if ( hasChannelDispatcher( channel ) )
				return getChannelDispatcher( channel ).hasListenerCollection( type );
			else
				return false;
		}
		
		/**
		 * Returns the <code>EventBroadcaster</code> object associated with
		 * the passed-in <code>channel<code>. The <code>owner</code> is an optionnal
		 * parameter which is used to initialize the newly created <code>EventBroadcaster</code>
		 * when there is no broadcaster for this channel.
		 * 
		 * @param	channel	the channel for which get the associated broadcaster
		 * @param	owner	an optional object which will used as source if there
		 * 					is no broadcaster associated to the channel
		 * @return	the <code>EventBroadcaster</code> object associated with
		 * 			the passed-in <code>channel<code>
		 */
		public function getChannelDispatcher( channel : EventChannel = null, owner : Object = null ) : EventBroadcaster
		{
			if ( hasChannelDispatcher( channel ) )
				return channel == null ? _mChannel.get( _oDefaultChannel ) : _mChannel.get( channel );
			else
			{
				var eb : EventBroadcaster = new EventBroadcaster( owner );
				_mChannel.put( channel, eb );
				return eb;
			}
		}

		/**
		 * Removes the <code>EventBroadcaster</code> object associated with
		 * the passed-in <code>channel<code>, and return <code>true</code>
		 * if there is a broadcaster and if it have been successfully removed.
		 * 
		 * @param	channel	channel for which remove the associated broadcaster
		 * @return	<code>true</code> if there is a broadcaster and if it have
		 * 			been successfully removed.
		 */
		public function releaseChannelDispatcher( channel : EventChannel ) : Boolean
		{
			if ( hasChannelDispatcher( channel ) )
			{
				var eb : EventBroadcaster = _mChannel.get( channel ) as EventBroadcaster;
				eb.removeAllListeners();
				_mChannel.remove( channel );

				return true;
			} 
			else return false;
		}

		/**
		 * Adds the passed-in listener as listener for all events 
		 * dispatched by this event channel broadcaster. The function
		 * returns <code>true</code> if the listener have been added
		 * at the end of the call. If the listener is already registered
		 * in this event channel broadcaster the function returns
		 * <code>false</code>.
		 * <p>
		 * Note : The <code>addListener</code> function doesn't accept
		 * functions as listener, functions could only register for
		 * a single event.
		 * </p>
		 * @param 	listener	the listener object to add as channel listener
		 * @param	channel		the channel for which the object listen
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 * @see		EventBroadcaster#addListener()
		 */
		public function addListener( listener : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).addListener( listener );
		}
		
		/**
		 * Removes the passed-in listener object from this event
		 * channel broadcaster. The object is removed as listener
		 * for all events the broadcaster may dispatch on this
		 * channel.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * @param	channel		the channel for which the object will be removed			
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 * @see		EventBroadcaster#removeListener()
		 */
		public function removeListener( listener : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).removeListener( listener );
		}
		
		/**
		 * Adds an event listener for the specified event type of the
		 * specified channel. There is two behaviors for the 
		 * <code>addEventListener</code> function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object
		 * must have a function with the same name than <code>type</code> or at least
		 * a <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * A <code>Delegate</code> object is created and then
		 * added as listener for the event type . There is no restriction on the name
		 * of the function.
		 * </ol>
		 * 
		 * @param 	type		name of the event for which register the listener
		 * @param 	listener	object or function which will receive this event
		 * @param	channel		event channel for which the listener listen
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * @throws 	<code>UnsupportedOperationException</code> — If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * @see		EventBroadcaster#addEventListener()
		 */
		public function addEventListener( type : String, listener : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).addEventListener( type, listener );
		}
		
		/**
		 * Removes the passed-in listener for listening the specified event of
		 * the specified channel. The listener could be either an object or a function.
		 * 
		 * @param 	type		name of the event for which unregister the listener
		 * @param 	listener	object or function to be unregistered
		 * @param	channel		event channel on which unregister the listener
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 */
		public function removeEventListener( type : String, listener : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).removeEventListener( type, listener );
		}
		
		/**
		 * Broadcast the passed-in event object to listeners
		 * according to the event's type and <code>channel</code>
		 * argument. The event is broadcasted to both listeners
		 * registered specifically for this event type and global
		 * listeners in the broadcaster.
		 * <p>
		 * If the <code>target</code> property of the passed-in event
		 * is <code>null</code>, it will be set using the value of the
		 * source property of this event broadcaster.
		 * </p>
		 * @param	e		event object to broadcast
		 * @param 	channel event channel onto which broadcast event
		 * @throws 	<code>UnsupportedOperationException</code> — If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		public function broadcastEvent( e : Event, channel : EventChannel = null ) : void
		{
			getChannelDispatcher( channel ).broadcastEvent( e );
			if ( channel ) getChannelDispatcher().broadcastEvent( e );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

import com.bourre.events.EventChannel;

internal class DefaultChannel extends EventChannel
{
	public static const CHANNEL : DefaultChannel = new DefaultChannel();
}