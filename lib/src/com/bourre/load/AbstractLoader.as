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
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.utils.*;

	import com.bourre.commands.*;
	import com.bourre.error.NullPointerException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.load.strategy.LoadStrategy;
	import com.bourre.log.*;	

	public class AbstractLoader 
		implements 	com.bourre.load.Loader, 
					ASyncCommand
	{
		private var _oEB : EventBroadcaster;
		private var _sName : String;
		private var _nTimeOut : Number;
		private var _oURL : URLRequest;
		private var _bAntiCache : Boolean;
		protected var _sPrefixURL : String;

		private var _loadStrategy : LoadStrategy;
		private var _oContent : Object;
		private var _nLastBytesLoaded : Number;
		private var _nTime : int;

		public function AbstractLoader( strategy : LoadStrategy = null )
		{
			_loadStrategy = (strategy != null) ? strategy : new NullLoadStrategy();
			_loadStrategy.setOwner( this );

			_oEB = new EventBroadcaster( this, LoaderListener );
			_nTimeOut = 10000;
			_bAntiCache = false;
			_sPrefixURL = "";
		}

		public function execute( e : Event = null ) : void
		{
			load();
		}

		public function getStrategy () : LoadStrategy
		{
			return _loadStrategy;
		}

		public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( url ) setURL( url );
			
			if ( getURL().url.length > 0 )
			{
				_nLastBytesLoaded = 0;
				_nTime = getTimer();

				_loadStrategy.load( getURL(), context );

			} else
			{
				var msg : String = this + ".load() can't retrieve file url.";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException( msg );
			}
		}

		protected function onInitialize() : void
		{
			fireEventType( LoaderEvent.onLoadProgressEVENT );
			fireEventType( LoaderEvent.onLoadInitEVENT );
		}

		protected function setListenerType( type : Class ) : void
		{
			_oEB.setListenerType( type );
		}

		public function getBytesLoaded() : uint
		{
			return _loadStrategy.getBytesLoaded();
		}

		public function getBytesTotal() : uint
		{
			return _loadStrategy.getBytesTotal();
		}

		final public function getPerCent() : Number
		{
			var n : Number = Math.min( 100, Math.ceil( getBytesLoaded() / ( getBytesTotal() / 100 ) ) );
			return ( isNaN(n) ) ? 0 : n;
		}

		public function getURL() : URLRequest
		{
			return _bAntiCache ? new URLRequest( _sPrefixURL + _oURL.url + "?nocache=" + _getStringTimeStamp() ) : new URLRequest( _sPrefixURL + _oURL.url );
		}

		public function setURL( url : URLRequest ) : void
		{
			_oURL = url;
		}

		final public function addASyncCommandListener( listener : ASyncCommandListener, ... rest ) : Boolean
		{
			return _oEB.addEventListener( AbstractSyncCommand.onCommandEndEVENT, listener );
		}

		final public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.removeEventListener(  AbstractSyncCommand.onCommandEndEVENT, listener );
		}

		public function addListener( listener : LoaderListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : LoaderListener ) : Boolean
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

		public function getName() : String
		{
			return _sName;
		}

		public function setName( sName : String ) : void
		{
			_sName = sName;
		}

		public function setAntiCache( b : Boolean ) : void
		{
			_bAntiCache = b;
		}

		public function isAntiCache() : Boolean
		{
			return _bAntiCache;
		}

		public function prefixURL( sURL : String ) : void
		{
			_sPrefixURL = sURL;
		}

		final public function getTimeOut() : Number
		{
			return _nTimeOut;
		}

		final public function setTimeOut( n : Number ) : void
		{
			_nTimeOut = Math.max( 1000, n );
		}

		public function release() : void
		{
			_loadStrategy.release( );
			_oEB.removeAllListeners();
		}
		public function getContent() : Object
		{
			return _oContent;
		}

		public function setContent( content : Object ) : void
		{	
			_oContent = content;
		}

		public function fireOnLoadProgressEvent() : void
		{
			fireEventType( LoaderEvent.onLoadProgressEVENT );
		}

		public function fireOnLoadInitEvent() : void
		{
			onInitialize();
		}

		public function fireOnLoadStartEvent() : void
		{
			fireEventType( LoaderEvent.onLoadStartEVENT );
		}

		public function fireOnLoadErrorEvent( message : String = "" ) : void
		{
			var e : LoaderEvent = getLoaderEvent( LoaderEvent.onLoadErrorEVENT );
			e.setMessage( message );
			fireEvent( e );
		}

		public function fireOnLoadTimeOut() : void
		{
			fireEventType( LoaderEvent.onLoadTimeOutEVENT );
		}

		final public function fireCommandEndEvent() : void
		{
			fireEventType( AbstractSyncCommand.onCommandEndEVENT );
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}

		//
		protected function fireEventType( type : String ) : void
		{
			fireEvent( getLoaderEvent( type ) );
		}

		protected function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e );
		}

		protected function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new LoaderEvent( type, this );
		}

		//
		private function _getStringTimeStamp() : String
		{
			var d : Date = new Date();
			return String( d.getTime() );
		}

		public function run () : void
		{
			
		}

		public function isRunning () : Boolean
		{
			return false;
		}

        // TODO check if _checkTimeOut is important
//        private function _checkTimeOut( nLastBytesLoaded : Number, nTime : Number ) : void 
//		{
//			if ( nLastBytesLoaded != _nLastBytesLoaded)
//			{
//				_nLastBytesLoaded = nLastBytesLoaded;
//				_nTime = nTime;
//			}
//			else if ( nTime - _nTime  > _nTimeOut)
//			{
//				fireOnLoadTimeOut();
//				release();
//				PixlibDebug.ERROR( this + " load timeout with url : '" + getURL() + "'." );
//			}
//		}
	}
}

import flash.net.URLRequest;
import flash.system.LoaderContext;

import com.bourre.load.Loader;
import com.bourre.load.strategy.LoadStrategy;

internal class NullLoadStrategy implements LoadStrategy
{
		public function load( request : URLRequest = null, context : LoaderContext = null  ) : void {}
		public function getBytesLoaded() : uint { return 0; }
		public function getBytesTotal() : uint { return 0; }
		public function setOwner( owner : Loader ) : void {}
		public function release() : void {}
}