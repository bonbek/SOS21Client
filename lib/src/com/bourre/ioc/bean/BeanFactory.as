package com.bourre.ioc.bean
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
	import flash.utils.Dictionary;

	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.ioc.core.IDExpert;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;		

	public class BeanFactory 
		implements Locator
	{
		private static  var _oI : BeanFactory ;
		
		private var _oEB : EventBroadcaster ;
		private var _m : HashMap ;
		
		public static const onRegisterBeanEVENT:String = "onRegisterBean" ;
		public static const onUnregisterBeanEVENT:String = "onUnregisterBean" ;
		
		public static function getInstance() : BeanFactory
		{
			if ( !(BeanFactory._oI is BeanFactory) ) BeanFactory._oI = new BeanFactory( new PrivateConstructorAccess() );
			return BeanFactory._oI;
		}
		
		public static function release():void
		{
			if ( BeanFactory._oI is BeanFactory ) BeanFactory._oI = null;
		}
		
		public function BeanFactory( access : PrivateConstructorAccess )
		{
			_oEB = new EventBroadcaster( this ) ;
			_m = new HashMap() ;
		}
		
		public function  locate ( key : String ) : Object
		{
			if ( isRegistered(key) )
			{
				return _m.get( key ) ;

			} else
			{
				var msg : String = this + ".locate(" + key + ") fails." ;
				PixlibDebug.ERROR( msg ) ;
				throw( new NoSuchElementException( msg ) ) ;
			}
		}
		
		public function isRegistered( key : String ) : Boolean
		{
			return _m.containsKey( key ) ;
		}
		
		public function isBeanRegistered( bean : Object ) : Boolean
		{
			return _m.containsValue( bean ) ;
		}

		public function register ( key : String, bean : Object ) : Boolean
		{
			if ( !( isRegistered( key ) ) && !( isBeanRegistered( bean ) ) )
			{
				_m.put( key, bean ) ;
				_oEB.broadcastEvent( new BeanEvent( BeanFactory.onRegisterBeanEVENT, key, bean ) ) ;
				return true ;

			} else
			{
				var msg:String = "";

				if ( isRegistered( key ) )
				{
					msg += this+".register(" + key + ", " + bean + ") fails, key is already registered." ;
				}

				if ( isBeanRegistered( bean ) )
				{
					msg += this + ".register(" + key + ", " + bean + ") fails, bean is already registered.";
				}

				PixlibDebug.ERROR( msg ) ;
				throw( new IllegalArgumentException( msg ) );
				return false ;
			}
		}

		public function unregister ( key : String ) : Boolean
		{
			if ( isRegistered( key ) )
			{
				_m.remove( key ) ;
				IDExpert.getInstance().unregister( key );
				_oEB.broadcastEvent( new BeanEvent( BeanFactory.onUnregisterBeanEVENT, key, null ) ) ;
				return true ;
			}
			else
			{
				return false ;
			}
		}

		public function unregisterBean ( bean : Object ) : Boolean
		{
			var b : Boolean = isBeanRegistered( bean );

			if ( b )
			{
				var a : Array = _m.getKeys();
				var l : uint = a.length;

				while( -- l > - 1 ) 
				{
					var key : String = a[ l ];
					if ( locate( a[ l ] ) == bean ) unregister( key );
				}
			}

			return b;
		}

		public function addListener( listener : BeanFactoryListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : BeanFactoryListener ) : Boolean
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

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}

		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					register( key, d[ key ] as Object );

				} catch( e : IllegalArgumentException )
				{
					e.message = this + ".add() fails. " + e.message;
					PixlibDebug.ERROR( e.message );
					throw( e );
				}
			}
		}
	}
}

internal class PrivateConstructorAccess {}