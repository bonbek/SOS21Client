package com.bourre.ioc.assembler.channel
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
	 * @author Olympe Dignat
	 * @version 1.0
	 */
	import com.bourre.collection.TypedArray;
	import com.bourre.events.*;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.log.*;
	import com.bourre.plugin.PluginChannel;	

	public class ChannelListenerExpert 
	{
		
		private static var _oI : ChannelListenerExpert;
		
		private var _oEB : EventBroadcaster;
		private var _aChannelListener : TypedArray;
		
		public static function getInstance() : ChannelListenerExpert
		{
			if ( !(ChannelListenerExpert._oI is ChannelListenerExpert) ) 
				ChannelListenerExpert._oI = new ChannelListenerExpert( new PrivateConstructorAccess() );

			return ChannelListenerExpert._oI;
		}
		
		public static function release():void
		{
			if ( ChannelListenerExpert._oI is ChannelListenerExpert ) 
				ChannelListenerExpert._oI = null ;
		}
		
		public function ChannelListenerExpert( access : PrivateConstructorAccess )
		{
			_oEB = new EventBroadcaster( this );
			_aChannelListener = new TypedArray( ChannelListener );
		}
		
		public function assignAllChannelListeners() : void
		{
			var l : Number = _aChannelListener.length;
			for ( var i : Number = 0; i < l; i++ ) assignChannelListener( _aChannelListener[i] );
		}
		
		public function assignChannelListener( o : ChannelListener ) : Boolean
		{
			var listener : Object = BeanFactory.getInstance().locate( o.listenerID );
			var channel : PluginChannel = PluginChannel.getInstance( o.channelName );

			return ApplicationBroadcaster.getInstance().addListener( listener, channel );
		}
		
		public function addChannelListener( listenerID : String, channelName : String ) : void
		{
			_aChannelListener.push( new ChannelListener( listenerID, channelName ) );
		}
		
		/*public function buildChannelListener( listenerID : String, channel:* ) : void
		{
			if ( channel.attribute.channel is String ) 
			{
				_aChannelListener.push( _buildChannelListener( listenerID, channel.attribute ) );
							
			} else
			{
				var l : Number = channel.length;
				for ( var i : Number = 0; i < l; i++ ) _aChannelListener.push( _buildChannelListener( listenerID, channel[i].attribute) );
			}
		}
		
		private function _buildChannelListener( listenerID : String, rawInfo : Object ) : ChannelListener
		{
			return new ChannelListener( listenerID, ContextAttributeList.getChannel( rawInfo ) );
		}*/
		
		/**
		 * Event system
		 */
		public function addListener( listener : ChannelListenerExpertListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : ChannelListenerExpertListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
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