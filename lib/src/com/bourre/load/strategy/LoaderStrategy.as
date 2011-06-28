package com.bourre.load.strategy
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
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.*;
	
	import com.bourre.load.Loader;
	import com.bourre.log.PixlibStringifier;	

	public class LoaderStrategy 
		implements LoadStrategy
	{
		private var _owner : com.bourre.load.Loader;
		private var _loader : flash.display.Loader;
		private var _bytesLoaded : uint;
		private var _bytesTotal : uint;

		public function LoaderStrategy()
		{
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}

		public function load( request : URLRequest = null, context : LoaderContext = null ) : void
		{
			_initLoaderStrategy();
			_loader.load( request, context );
		}

		public function loadBytes( bytes : ByteArray, context : LoaderContext = null ) : void
		{
			_initLoaderStrategy();
			_loader.loadBytes( bytes, context );
		}

		public function getBytesLoaded() : uint
		{
			return _bytesLoaded;
		}

		public function getContentLoaderInfo () : LoaderInfo
	  	{
	  		return _loader.contentLoaderInfo;
	  	}

		public function getBytesTotal() : uint
		{
			return _bytesTotal;
		}

		public function setOwner( owner : com.bourre.load.Loader ) : void
		{
			_owner = owner;
		}

		public function release() : void
		{
			if ( _loader ) _loader.close();
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
		protected function _initLoaderStrategy() : void
		{
			_loader = new flash.display.Loader();
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _onComplete );
			_loader.contentLoaderInfo.addEventListener( Event.OPEN, _onOpen );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _onSecurityError );
			_loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, _onHttpStatus );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _onIOError );
	        _loader.contentLoaderInfo.addEventListener( Event.INIT, _onInit );
	        _loader.contentLoaderInfo.addEventListener( Event.UNLOAD, _onUnLoad );
		}

		protected function _onProgress( e : ProgressEvent ) : void
		{
			// trace( "_onProgress: " + e );
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;

			if ( _owner ) _owner.fireOnLoadProgressEvent();
		}

		protected function _onComplete( e : Event ) : void 
		{
			// trace( "_onComplete: " + e );
	    }

	    protected function _onOpen( e : Event ) : void
	    {
	    	// trace( "_onOpen: " + e );
	    	if ( _owner ) _owner.fireOnLoadStartEvent();
	    }

	    protected function _onSecurityError( e : SecurityErrorEvent ) : void 
	    {
	    	// trace( "_onSecurityError: " + e );
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }

	    protected function _onHttpStatus( e : HTTPStatusEvent ) : void 
	    {
	    	// trace( "_onHttpStatus: " + e );
	    }

	    protected function _onIOError( e : IOErrorEvent ) : void 
	    {
	    	// trace( "_onIOError: " + e );
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }

	    protected function _onInit( e : Event ) : void 
	    {
			// trace( "_onInit: " + e );
			if ( _owner ) 
			{
				_owner.setContent( _loader.content );
				_owner.fireOnLoadInitEvent();
			}
		}

	    protected function _onUnLoad( e : Event ) : void 
	    {
			// trace( "_onUnLoad: " + e );
		}
	}
}