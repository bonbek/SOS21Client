package com.bourre.ioc.assembler
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
	
	import com.bourre.ioc.assembler.channel.ChannelListenerExpert;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpert;
	import com.bourre.ioc.assembler.method.MethodExpert;
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.ioc.assembler.property.PropertyExpert;

	public class DefaultApplicationAssembler 
		implements ApplicationAssembler
	{
		public function buildDLL( url : String ) : void
		{
			DisplayObjectExpert.getInstance().buildDLL( url );
		}

		public function buildEmptyDisplayObject( 	ID : String,
													parentID : String,
													isVisible : Boolean,
													type : String ) : void
		{
			DisplayObjectExpert.getInstance().buildEmptyDisplayObject( ID, parentID, isVisible, type );
		}

		public function buildDisplayObject( ID 			: String,
											url : URLRequest,
											parentID 	: String, 
											isVisible 	: Boolean, 
											type : String ) : void
		{
			DisplayObjectExpert.getInstance().buildGraphicLoader( ID, url, parentID, isVisible, type );
		}

		public function buildProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null	) : void
		{
			PropertyExpert.getInstance().addProperty( ownerID, name, value, type, ref, method );
		}

		public function buildObject( 	ownerID 	: String, 
										type 		: String 	= null, 
										args 		: Array 	= null, 
										factory 	: String 	= null, 
										singleton 	: String 	= null, 
										channelName : String 	= null 	) : void
		{
			if ( args != null )
			{
				var l : int = args.length;
				for ( var i : int; i < l; i++ )
				{
					var o : Object = args[ i ];
					var p : Property = new Property( o.id, o.name, o.value, o.type, o.ref, o.method );
					args[ i ] = p;
				}
			}

			ConstructorExpert.getInstance().addConstructor( ownerID, type, args, factory, singleton, channelName );
		}

		public function buildMethodCall( ownerID : String, methodCallName : String, args : Array = null ) : void
		{
			if ( args != null )
			{
				var l : int = args.length;
				for ( var i : int; i < l; i++ )
				{
					var o : Object = args[ i ];
					var p : Property = new Property( o.id, o.name, o.value, o.type, o.ref, o.method );
					args[ i ] = p;
				}
			}

			MethodExpert.getInstance().addMethod( ownerID, methodCallName, args );
		}

		public function buildChannelListener( ownerID : String, channelName : String ) : void
		{
			ChannelListenerExpert.getInstance().addChannelListener( ownerID, channelName );
		}
	}
}