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
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import com.bourre.load.strategy.URLLoaderStrategy;	

	public class XMLLoader 
		extends AbstractLoader
	{
		// TODO check _oContent is important
//		private var _oContent : XML;
		private var _oDeserializer : XMLLoaderDeserializer;

		public function XMLLoader( deserializer : XMLLoaderDeserializer = null )
		{
			super( new URLLoaderStrategy() );
			if ( deserializer ) setDeserializer ( deserializer );
		}

		public function setDeserializer ( deserializer : XMLLoaderDeserializer ) : void
		{
			_oDeserializer = deserializer;
		}

		public function getDeserializer () : XMLLoaderDeserializer 
		{
			return _oDeserializer;
		}

		protected override function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new XMLLoaderEvent( type, this );
		}

		public function getXML() : XML
		{
			return XML( getContent() );
		}

		public override function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			super.load( url, context );
		}

		public override function release() : void
		{
			super.release();
		}

		protected override function onInitialize() : void
		{
			if ( getDeserializer() != null ) getDeserializer().deserialize( new Object(), getXML() );
			super.onInitialize();
		}
		
	}
}