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
	
	import com.bourre.log.*;
	import com.bourre.transitions.TickListener;	

	/**
	 * @author	Francis Bourre
	 */
	public class Delegate implements Command, TickListener
	{
		private var _f : Function;
		private var _a : Array;
		
		public static function create( method : Function, ... args ) : Function 
		{
			return function( ... rest ) : *
			{
				try
				{
					return method.apply( null, rest.length>0? (args.length>0?args.concat(rest):rest) : (args.length>0?args:null) );

				} catch( e : ArgumentError )
				{
					var msg : String = this + " execution failed, you passed incorrect number of arguments or wrong type";
					PixlibDebug.FATAL( msg );
					throw new ArgumentError( msg );
				}
			};
		} 
		
		public function Delegate( f : Function, ... rest )
		{
			_f = f;
			_a = rest;
		}
		
		public function getArguments() : Array
		{
			return _a;
		}

		public function setArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) _a = rest;
		}
		
		public function setArgumentsArray( a : Array ) : void
		{
			if ( a.length > 0 ) _a = a;
		}

		public function addArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) _a = _a.concat( rest );
		}
		
		public function addArgumentsArray( a : Array ) : void
		{
			if ( a.length > 0 ) _a = _a.concat( a );
		}

		public function execute( event : Event = null ) : void
		{
			var a : Array = new Array();
			if ( event != null ) a.push( event );
			
			try
			{
				_f.apply( null, ( _a.length > 0 ) ? a.concat( _a ) : ((a.length > 0 ) ? a : null) );

			} catch( error : ArgumentError )
			{
				var msg : String = this + ".execute() failed, you passed incorrect number of arguments or wrong type";
				PixlibDebug.FATAL( msg );
				throw new ArgumentError( msg );
			}
		}
		
		public function onTick( e : Event = null ) : void
		{
			execute( e );
		}
		
		public function handleEvent( e : Event ) : void
		{
			this.execute( e );
		}
		
		public function callFunction() : *
		{
			return _f.apply( null, _a );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}