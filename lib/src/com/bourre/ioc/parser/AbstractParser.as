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

	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.assembler.DefaultApplicationAssembler;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;

	public class AbstractParser
	{
		private var _oAssembler : ApplicationAssembler;

		public function AbstractParser( assembler : ApplicationAssembler = null )
		{
			if( !( ClassUtils.isImplemented( this, "com.bourre.ioc.parser:AbstractParser", "parse" ) ) )
			{
				PixlibDebug.ERROR ( this + " have to implement virtual method : parse" );
				throw new UnimplementedVirtualMethodException ( this + " have to implement virtual method : parse" );
			}

			setAssembler( ( assembler != null ) ? assembler : new DefaultApplicationAssembler() );
		}
		
		public function getAssembler() : ApplicationAssembler
		{
			return _oAssembler;
		}
		
		public function setAssembler( assembler : ApplicationAssembler ) : void
		{
			if ( assembler != null )
			{
				_oAssembler = assembler;

			} else
			{
				throw new IllegalArgumentException( this + ".setAssembler() failed. Assembler can't be null" );
			}
		}
		
		public function parse( xml : * ) : void
		{
			//
		}
		
		public final function getArguments( xml : XML, type : String = null ) : Array
		{
			var args : Array = new Array();
			var argList : XMLList = xml.child( ContextNodeNameList.ARGUMENT );
			var length : int = argList.length();

			if ( length > 0 )
			{
				for ( var i : int = 0; i < length; i++ ) 
				{
					var x : XMLList = argList[ i ].attributes();
					var l : int = x.length();

					if ( l > 0 )
					{
						var o : Object = {};
						for ( var j : int = 0; j < l; j++ ) o[ String( x[j].name() ) ]=x[j];
						args.push( o );
					}
				}

			} else
			{
				var value : String = ContextAttributeList.getValue( xml );
				if ( value != null ) args.push( { type:type, value:value } );
			}
			
			return args;
		}
	}
}