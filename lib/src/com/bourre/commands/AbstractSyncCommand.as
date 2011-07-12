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
	
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibStringifier;	

	/*
	 * Upgrade to IOC : 
	 *  - remove abstract protection hack and call super with constructor argument
	 *  - uncomment extends elements 
	 *  - refactor add and remove listener return
	 */

	/**
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractSyncCommand extends AbstractCommand implements ASyncCommand
	{	
		static public const onCommandEndEVENT : String = "onCommandEnd";
		
		protected var _oEB : EventBroadcaster;
		protected var _eOnCommandEnd : BasicEvent;
		protected var _bIsRunning : Boolean;
		
		/**
		 * 
		 * @param o
		 * @return 
		 * 
		 */
		public function AbstractSyncCommand ()
		{
			_bIsRunning = false;
			_oEB = new EventBroadcaster ( this );
			_eOnCommandEnd = new BasicEvent ( onCommandEndEVENT, this );
		}
		
		/**
		 * 
		 * @param listener
		 * 
		 */
		public function addASyncCommandListener( listener : ASyncCommandListener, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? 
												[ onCommandEndEVENT, listener ].concat( rest )
												: [ onCommandEndEVENT, listener ] );
		}
		
		/**
		 * 
		 * @param listener
		 * 
		 */
		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.removeEventListener( onCommandEndEVENT, listener );
		}

		/**
		 * 
		 * 
		 */
		public function fireCommandEndEvent() : void
		{
			_oEB.broadcastEvent( _eOnCommandEnd );
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public override function execute( e : Event = null) : void
		{
			fireCommandEndEvent();
		}
		
		/**
		 * 
		 */
		public function run() : void
		{
			execute();
		}
		
		/**
		 * 
		 */
		public function isRunning () : Boolean
		{
			return _bIsRunning;
		}

		/**
		 * 
		 * 
		 * @return the string representation of the object
		 */
		public override function toString():String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}