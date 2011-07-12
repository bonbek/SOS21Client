package com.bourre.ioc.parser
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

	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.core.IDExpert;
	import com.bourre.ioc.error.NullChannelException;
	import com.bourre.ioc.error.NullIDException;
	import com.bourre.plugin.PluginDebug;

	public class ObjectParser
		extends AbstractParser
	{
		public function ObjectParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}

		public override function parse( xml : * ) : void
		{
			for each ( var node : XML in xml.* ) _parseNode( node );
		}

		protected function _parseNode( xml : XML ) : void
		{
			var msg : String;
			
			// Debug missing ids.
			var id : String = ContextAttributeList.getID( xml );
			if ( !id )
			{
				msg = this + " encounters parsing error with '" + xml.name() + "' node. You must set an id attribute.";
				PluginDebug.getInstance().fatal( msg );
				throw( new NullIDException( msg ) );
			}

			IDExpert.getInstance().register( id );

			// Build object.
			var type : String = ContextAttributeList.getType( xml );
			var args : Array = getArguments( xml, type );
			var factory : String = ContextAttributeList.getFactoryMethod( xml );
			var singleton : String = ContextAttributeList.getSingletonAccess( xml );
			var channel : String = ContextAttributeList.getChannel( xml );

			getAssembler().buildObject( id, type, args, factory, singleton, channel );
/*	
			// register each object to system channel.
			_oAssembler.buildChannelListener( id, PixiocSystemChannel.CHANNEL );
*/
			// Build property.
			for each ( var property : XML in xml[ ContextNodeNameList.PROPERTY ] )
			{
				getAssembler().buildProperty( 	id, 
												ContextAttributeList.getName( property ),
												ContextAttributeList.getValue( property ),
												ContextAttributeList.getType( property ),
												ContextAttributeList.getRef( property ),
												ContextAttributeList.getMethod( property ) );
			}
	


			// Build method call.
			for each ( var method : XML in xml[ ContextNodeNameList.METHOD_CALL ] )
			{
				getAssembler().buildMethodCall( id, 
												ContextAttributeList.getName( method ),
												getArguments( method ) );
			}

			// Build channel listener.
			for each ( var listener : XML in xml[ ContextNodeNameList.LISTEN ] )
			{
				var channelName : String = ContextAttributeList.getChannel( listener );
				if ( channelName )
				{
					getAssembler().buildChannelListener( id, channelName );

				} else
				{
					msg = this + " encounters parsing error with '" + xml.name() + "' node, 'channel' attribute is mandatory in a 'listen' node.";
					PluginDebug.getInstance().fatal( msg );
					throw( new NullChannelException( msg ) );
				}
			}
		}
	}
}