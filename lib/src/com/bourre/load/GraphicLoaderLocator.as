package com.bourre.load
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
	import com.bourre.error.IllegalArgumentException;	
	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.*;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;	

	public class GraphicLoaderLocator 
		implements Locator
	{
		private static var _oI : GraphicLoaderLocator = null;

		private var _m : HashMap;
		private var _oEB : EventBroadcaster;

		public function GraphicLoaderLocator( o : ConstructorAccess )
		{
			_m = new HashMap();
			_oEB = new EventBroadcaster( this );
		}
		
		public static function getInstance() : GraphicLoaderLocator
		{
			if ( !(GraphicLoaderLocator._oI is GraphicLoaderLocator) ) GraphicLoaderLocator._oI = new GraphicLoaderLocator( new ConstructorAccess() );
			return GraphicLoaderLocator._oI;
		}
		
		public static function release():void
		{
			if ( GraphicLoaderLocator._oI is GraphicLoaderLocator ) GraphicLoaderLocator._oI = null;
		}
		
		public function isRegistered( name : String ) : Boolean
		{
			return _m.containsKey( name );
		}
		
		public function register( name : String, gl : GraphicLoader ) : Boolean
		{
			if ( _m.containsKey( name ) )
			{
				var msg : String = "GraphicLoader instance is already registered with '" + name + "' name in " + this;
				PixlibDebug.ERROR( msg );
				throw new IllegalArgumentException( msg );
				
				return false;

			} else
			{
				_m.put( name, gl );
				_oEB.broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onRegisterGraphicLoaderEVENT, name, gl ) );
				return true;
			}
		}
		
		public function unregister( name : String ) : Boolean
		{
			if ( isRegistered( name ) )
			{
				_m.remove( name );
				_oEB.broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT, name, null ) );
				return true;
				
			} else
			{
				return false;
			}
		}
		
		public function locate( name : String ) : Object
		{
			if ( isRegistered( name ) ) 
			{
				return _m.get( name );
				
			} else
			{
				var msg : String = "Can't find GraphicLoader instance with '" + name + "' name in " + this;
				PixlibDebug.FATAL( msg );
				throw new NoSuchElementException( msg );
			}
		}
		
		public function getGraphicLoader( name : String ) : GraphicLoader
		{
			try
			{
				var gl : GraphicLoader = locate( name ) as GraphicLoader;
				return gl;

			} catch ( e : Error )
			{
				throw( e );
			}
			
			return null;
		}
		
		public function getApplicationDomain( name : String ) : ApplicationDomain
		{
			return getGraphicLoader( name ).getApplicationDomain();
		}
		
		public function addListener( listener : GraphicLoaderLocatorListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : GraphicLoaderLocatorListener ) : Boolean
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
		
		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					register( key, d[ key ] as GraphicLoader );

				} catch( e : IllegalArgumentException )
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

internal class ConstructorAccess {}