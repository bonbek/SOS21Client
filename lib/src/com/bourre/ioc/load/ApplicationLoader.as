package com.bourre.ioc.load 
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
	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import com.bourre.error.NullPointerException;
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.assembler.DefaultApplicationAssembler;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectEvent;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpert;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpertEvent;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpertListener;
	import com.bourre.ioc.context.ContextLoader;
	import com.bourre.ioc.context.ContextLoaderEvent;
	import com.bourre.ioc.parser.ContextParser;
	import com.bourre.ioc.parser.ContextParserEvent;
	import com.bourre.ioc.parser.ContextParserListener;
	import com.bourre.ioc.parser.DLLParser;
	import com.bourre.ioc.parser.DisplayObjectParser;
	import com.bourre.ioc.parser.ObjectParser;
	import com.bourre.ioc.parser.ParserCollection;
	import com.bourre.load.AbstractLoader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.LoaderListener;
	import com.bourre.log.PixlibDebug;	

	public class ApplicationLoader
		extends AbstractLoader
		implements LoaderListener, ContextParserListener, DisplayObjectExpertListener
	{
		public static const DEFAULT_URL : String = "applicationContext.xml";

		protected var _oContextLoader : ContextLoader;

		protected var _oContextParser : ContextParser;
		protected var _oAssembler : ApplicationAssembler;
		protected var _oParserCollection : ParserCollection;

		public function ApplicationLoader( target : DisplayObjectContainer, url : URLRequest = null )
		{
			setListenerType( ApplicationLoaderListener );

			setURL( url? url : new URLRequest( ApplicationLoader.DEFAULT_URL ) );

			_oAssembler = new DefaultApplicationAssembler();
			DisplayObjectExpert.getInstance().setRootTarget( target );
			_initParserCollection();
		}
		
		protected function _initParserCollection() : void
		{
			_oParserCollection = new ParserCollection();
			_oParserCollection.push( new DLLParser( getAssembler() ) );
			_oParserCollection.push( new DisplayObjectParser( getAssembler() ) );
			_oParserCollection.push( new ObjectParser( getAssembler() ) );
		}

		public function getContextParser() : ContextParser
		{
			return _oContextParser;
		}

		public function getAssembler() : ApplicationAssembler
		{
			return _oAssembler;
		}

		public function getParserCollection() : ParserCollection
		{
			return _oParserCollection;
		}

		public function addApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return addListener( listener );
		}

		public function removeApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return removeListener( listener );
		}

		override protected function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new ApplicationLoaderEvent( type, this );
		}

		override public function release() : void
		{
			super.release();
		}

		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( url ) setURL( url );

			if ( getURL().url.length > 0 )
			{
				_oContextLoader = new ContextLoader();
				_oContextLoader.addEventListener( ContextLoaderEvent.onLoadInitEVENT, _onContextLoaderLoadInit );
				_oContextLoader.addEventListener( ContextLoaderEvent.onLoadProgressEVENT, this );
				_oContextLoader.addEventListener( ContextLoaderEvent.onLoadTimeOutEVENT, this );
				_oContextLoader.load( getURL(), context );

			} else
			{
				var msg : String = this + ".load() can't retrieve file url.";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException( msg );
			}
		}

		protected function _onContextLoaderLoadInit( e : ContextLoaderEvent ) : void
		{
			_oContextLoader.removeListener( this );
PixlibDebug.INFO("_onContextLoaderLoadInit("+e.getContext()+")");
			_oContextParser = new ContextParser( getParserCollection() );
			_oContextParser.addListener( this );
			_oContextParser.parse( e.getContext() );
		}

		override public function getBytesLoaded() : uint
		{
			return _oContextLoader.getBytesLoaded();
		}

		override public function getBytesTotal() : uint
		{
			return _oContextLoader.getBytesTotal();
		}

		public function fireOnApplicationBuilt() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationBuiltEVENT, this ) );
		}

		public function fireOnApplicationInit() : void 
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationInitEVENT, this ) );
		}

		/**
		 * Loader callbacks
		 */
		public function onLoadStart( e : LoaderEvent ) : void
		{
			fireOnLoadStartEvent();
		}

		public function onLoadInit( e : LoaderEvent ) : void
		{
			fireOnLoadInitEvent();
		}

		public function onLoadProgress( e : LoaderEvent ) : void
		{
			fireOnLoadProgressEvent();
		}

		public function onLoadTimeOut( e : LoaderEvent ) : void
		{
			fireOnLoadTimeOut();
		}

		public function onLoadError( e : LoaderEvent ) : void
		{
			fireOnLoadErrorEvent( e.getMessage() );
			//PixlibDebug.ERROR( e.getMessage() );
		}

		/**
		 * ContextParser callbacks
		 */
		public function onContextParsingStart(e : ContextParserEvent) : void
		{
		}

		public function onContextParsingEnd( e : ContextParserEvent ) : void
		{
			_oContextParser.removeListener( this );

			DisplayObjectExpert.getInstance().addListener( this );
			DisplayObjectExpert.getInstance().load( );
		}

		/**
		 * DisplayObjectExpert callbacks
		 */
		public function onBuildDisplayObject( e : DisplayObjectEvent ) : void
		{
		}

		public function onDisplayObjectExpertLoadStart(e : DisplayObjectExpertEvent) : void
		{
		}

		public function onDLLLoadStart(e : DisplayObjectExpertEvent) : void
		{
		}

		public function onDLLLoadInit(e : DisplayObjectExpertEvent) : void
		{
		}

		public function onDisplayObjectLoadStart(e : DisplayObjectExpertEvent) : void
		{
		}

		public function onDisplayObjectLoadInit(e : DisplayObjectExpertEvent) : void
		{
		}

		public function onDisplayObjectExpertLoadInit(e : DisplayObjectExpertEvent) : void
		{
		}
	}
}