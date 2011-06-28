package com.bourre.commands
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
	import com.bourre.error.NoSuchElementException;	
	import com.bourre.core.Locator;	
	
	import flash.events.Event;

	import com.bourre.collection.HashMap;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.*;
	import com.bourre.plugin.*;
	
	import flash.utils.Dictionary;	

	public class FrontController 
		implements Locator
	{
		protected var _oEB : EventBroadcaster;
		protected var _owner : Plugin;
		protected var _mEventList : HashMap;

		public function FrontController( owner : Plugin = null ) 
		{
			setOwner( owner );
			_mEventList = new HashMap();
		}

		final public function setOwner( owner : Plugin ) : void
		{
			if ( _oEB ) _oEB.removeListener( this );

			if ( owner!= null )
			{
				_owner = owner;
				_oEB = new EventBroadcaster( getOwner() );

			} else
			{
				_owner = NullPlugin.getInstance();
				_oEB = EventBroadcaster.getInstance();
			}
			_oEB.addListener( this );
		}

		final public function getOwner() : Plugin
		{
			return _owner;
		}

		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}

		final public function getBroadcaster() : EventBroadcaster
		{
			return _oEB;
		}

		public function pushCommandClass( eventName : String, commandClass : Class ) : void
		{
			_mEventList.put( eventName.toString(), commandClass );
		}

		public function pushCommandInstance( eventName : String, command : Command ) : void
		{
			_mEventList.put( eventName.toString(), command );
		}

		public function remove( eventName : String ) : void
		{
			_mEventList.remove( eventName.toString() );
		}

		final public function handleEvent( event : Event ) : void
		{
			var type : String = event.type.toString();
			var cmd : Command;

			try
			{
				cmd = locate( type ) as Command;

			} catch ( e : Error )
			{
				getLogger().debug( this + ".handleEvent() fails to retrieve command associated with '" + type + "' event type." );
			}

			if ( cmd != null ) cmd.execute( event );
		}

		public function release() : void
		{
			_mEventList.clear();
		}
		
		public function isRegistered(key : String) : Boolean
		{
			return _mEventList.containsKey( key );
		}

		public function locate( key : String ) : Object
		{
			if ( _mEventList.containsKey( key ) )
			{
				var o : Object = _mEventList.get( key );

				if ( o is Class )
				{
					var cmd : Command = new ( o as Class )();
					if ( cmd is AbstractCommand ) ( cmd as AbstractCommand ).setOwner( getOwner() );
					return cmd;

				} else if ( o is Command )
				{
					if ( o is AbstractCommand ) 
					{
						var acmd : AbstractCommand = ( o as AbstractCommand );
						if ( acmd.getOwner() == null ) acmd.setOwner( getOwner() );
					}

					return o;
				}

			} else 
			{
				var msg : String = "Can't find Command instance with '" + key + "' name in " + this;
				getLogger().fatal( msg );
				throw new NoSuchElementException( msg );
			}
			
			return null;
		}

		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					var o : Object = d[ key ] as Object;
					
					if ( o is Class )
					{
						pushCommandClass( key, o as Class );
					} else
					{
						pushCommandInstance( key, o as Command );
					}

				} catch( e : Error )
				{
					e.message = this + ".add() fails. " + e.message;
					PixlibDebug.ERROR( e.message );
					throw( e );
				}
			}
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