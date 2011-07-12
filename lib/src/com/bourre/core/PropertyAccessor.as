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
package com.bourre.core {
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	public class PropertyAccessor implements Accessor
	{
		private var _o : Object;
		private var _p : String;
		
		public function PropertyAccessor ( o : Object, p : String )
		{
			if( o == null )
			{
				PixlibDebug.ERROR( "Can't create an accessor on null" );
			}
			else if( !o.hasOwnProperty( p ) ) 
			{
				PixlibDebug.ERROR( "Can't create an accessor for " + p + " in " + o );
			}
					
			_o = o;
			_p = p;
		}
		
		public function getValue():Number
		{
			return _o[ _p ];
		}	
		
		public function setValue( value : Number ) : void
		{
			_o[ _p ] = value ;
		}
		
		public function getTarget() : Object
		{
			return _o;
		}
		
		public function getGetterHelper() : String
		{
			return _p;
		}
		public function getSetterHelper() : String
		{
			return _p;
		}
		public function getProperty() : String
		{
			return _p;
		}
		
		public function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}