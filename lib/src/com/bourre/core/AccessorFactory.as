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
package com.bourre.core 
{ 
	import com.bourre.log.PixlibStringifier;
	import com.bourre.log.PixlibDebug;
	
	public class AccessorFactory 
	{
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		
		public static function getAccessor( t : Object , setter : String, getter : String = null ) : Accessor
		{
			if( !t )
			{
				PixlibDebug.ERROR( t + " isn't a valid target for an accessor." );
				throw new ArgumentError ( t + " isn't a valid target for an accessor." );
			}
				
			if( !t.hasOwnProperty( setter ) )
			{
				PixlibDebug.ERROR(  t + " doesn't own any properties named " + setter );
				throw new ReferenceError ( t + " doesn't own any properties named "+ setter );
			}
			else if( t[ setter ] is Function )
			{
				if( !t.hasOwnProperty( getter ) )
				{
					PixlibDebug.ERROR(  t + " doesn't own any getter method named " + getter );
					throw new ReferenceError ( t + " doesn't own any getter method named "+ getter );
				}
				return new MethodAccessor ( t, setter, getter );
			}
			else
			{
				return new PropertyAccessor ( t, setter );
			}	
		}
		
		public static function getMultiAccessor ( t : Object, setter : Array, getter : Array = null) : AccessorComposer
		{
			if( !t )
			{
				PixlibDebug.ERROR( t + " isn't a valid target for an accessor." );
				throw new ArgumentError ( t + " isn't a valid target for an accessor." );
			}
			return new MultiAccessor ( t, setter, getter );

		}
		// Private constructor
		public function AccessorFactory( o : ConstructorAccess )
		{}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

internal class ConstructorAccess {}