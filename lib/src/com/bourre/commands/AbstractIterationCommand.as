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
package com.bourre.commands 
{
	import flash.events.Event;
	
	import com.bourre.collection.Iterator;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;		

	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractIterationCommand implements IterationCommand 
	{
		protected var _oIterator : Iterator;

		public function AbstractIterationCommand ( i : Iterator )
		{
			_oIterator = i;
		}
		
		public function execute( e : Event = null ) : void
		{
			var msg : String = this + ".execute() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
		
		public function iterator () : Iterator
		{
			return _oIterator;
		}
		
		public function setIterator ( i : Iterator ) : void
		{
			_oIterator = i;
		}
	
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
