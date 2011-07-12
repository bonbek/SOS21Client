package com.bourre.service 
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
	 */	import flash.utils.Dictionary;	

	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.service.ServiceLocatorListener;		

	public class ServiceLocator 
		implements Locator
	{
		private var _m : HashMap;
		private var _oEB : EventBroadcaster;

		public function ServiceLocator() 
		{
			_m = new HashMap();
			_oEB = new EventBroadcaster( this );
		}

		public function release() : void
		{
			_m.clear();
		}
		public function isRegistered( key : String ) : Boolean
		{
			return _m.containsKey( key );
		}

		public function registerService( key : String, service : Service ) : Boolean
		{
			return _register( key, service );
		}

		public function registerServiceClass( key : String, serviceClass : Class ) : Boolean
		{
			return _register( key, serviceClass, true );
		}

		protected function _register( key : String, service : Object, isClass : Boolean = false ) : Boolean
		{
			if ( _m.containsKey( key ) )
			{
				var msg : String = "Service instance is already registered with '" + key + "' name in " + this;
				PixlibDebug.ERROR( msg );
				throw new IllegalArgumentException( msg );

				return false;

			} else
			{
				_m.put( key, service );
				var e : ServiceLocatorEvent = new ServiceLocatorEvent( ServiceLocatorEvent.onRegisterServiceEVENT, key, this );
				if ( isClass ) {e.setServiceClass( service as Class );} else {e.setService( service as Service );}
				_oEB.broadcastEvent( e );
				return true;
			}
		}

		public function unregister( key : String ) : Boolean
		{
			if ( isRegistered( key ) )
			{
				_m.remove( key );
				_oEB.broadcastEvent( new ServiceLocatorEvent( ServiceLocatorEvent.onUnregisterServiceEVENT, key, this ) );
				return true;

			} else
			{
				return false;
			}
		}

		public function locate( key : String ) : Object
		{
			if ( isRegistered( key ) ) 
			{
				var o : Object =  _m.get( key );
				return ( o is Class ) ? new ( o as Class )() : o;

			} else
			{
				var msg : String = "Can't find Service instance with '" + key + "' name in " + this;
				PixlibDebug.FATAL( msg );
				throw new NoSuchElementException( msg );
			}
		}

		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					var o : Object = d[ key ] as Object;
					_register( key, o, o is Class );

				} catch( e : Error )
				{
					e.message = this + ".add() fails. " + e.message;
					PixlibDebug.ERROR( e.message );
					throw( e );
				}
			}
		}

		public function getService( key : String ) : Service
		{
			try
			{
				var service : Service = locate( key ) as Service;
				return service;

			} catch ( e : Error )
			{
				throw( e );
			}

			return null;
		}

		public function addListener( listener : ServiceLocatorListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : ServiceLocatorListener ) : Boolean
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
	}}