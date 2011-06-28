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

	public class MethodAccessor implements Accessor
	{
		private var _o : Object;
		
		private var _sp : String;
		private var _gp : String;
		
		private var _sf : Function;
		private var _gf : Function;
		
		private var _value : Number;
		
		public function MethodAccessor ( o : Object, setter : String, getter : String  )
		{
			if( o == null )
			{
				PixlibDebug.ERROR( "Can't create an accessor on null" );
			}
			else if( !o.hasOwnProperty( setter ) ) 
			{
				PixlibDebug.ERROR( "Can't create a setter accessor for " + setter + " in " + o );
			}
			else if( !o.hasOwnProperty( getter ) ) 
			{
				PixlibDebug.ERROR( "Can't create a getter accessor for " + getter + " in " + o );
			}
					
			_o = o;
			
			_sp = setter;
			_gp = getter;
			
			_sf = _o[ _sp ];
			_gf = _o[ _gp ];
		}
		
		public function getValue():Number
		{
			return _gf == null ? _value : _gf();
		}	
		
		public function setValue( value : Number ) : void
		{
			if ( _gf == null ) _value = value;
			_sf( value );
		}
		
		public function getTarget() : Object
		{
			return _o;
		}
		
		public function getGetterHelper() : String
		{
			return _gp;
		}
		public function getSetterHelper() : String
		{
			return _sp;
		}
		
		public function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}