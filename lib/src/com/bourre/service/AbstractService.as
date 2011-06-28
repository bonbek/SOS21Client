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
package com.bourre.service 
{
	import com.bourre.collection.Collection;
	import com.bourre.commands.ASyncCommandListener;
	import com.bourre.commands.AbstractCommand;
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;		

	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	public class AbstractService extends AbstractCommand implements Service
	{
		protected var _oEB : EventBroadcaster;
		protected var _args : Array;
		protected var _result : Object;

		public function AbstractService() 
		{
			_oEB = new EventBroadcaster( this );
		}

		public function setResult( result : Object ) : void
		{
			_result = result;
		}

		public function getResult() : Object
		{
			return _result;
		}

		public function addServiceListener( listener : ServiceListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeServiceListener( listener : ServiceListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		public function getServiceListener() : Collection
		{
			return _oEB.getListenerCollection();
		}

		public function setArguments(...rest) : void
		{
			_args = rest.concat();
		}

		public function getArguments() : Object
		{
			return _args;
		}

		public function fireResult() : void
		{
			_oEB.broadcastEvent( new ServiceEvent( ServiceEvent.onDataResultEVENT, this ) );
		}

		public function fireError() : void
		{
			_oEB.broadcastEvent( new ServiceEvent( ServiceEvent.onDataErrorEVENT, this ) );
		}

		public function addASyncCommandListener( listener : ASyncCommandListener, ...rest ) : Boolean
		{
			var type : String =  AbstractSyncCommand.onCommandEndEVENT;
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.removeEventListener( AbstractSyncCommand.onCommandEndEVENT, listener ); 
		}

		public function fireCommandEndEvent() : void
		{
			_oEB.broadcastEvent( new BasicEvent(  AbstractSyncCommand.onCommandEndEVENT, this ) );
		}

		public function release() : void
		{
			_oEB.removeAllListeners( );
			_args = null;
			_result = null;
		}
		
		public function run () : void
		{
		}
		
		public function isRunning () : Boolean
		{
			return false;
		}	}}