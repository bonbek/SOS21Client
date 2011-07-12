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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	/*
	 * Upgrade to IOC : 
	 *  - remove abstract protection hack and call super with constructor argument
	 *  - uncomment extends elements 
	 *  - refactor add and remove listener return
	 */

	/**
	 * 
	 * 
	 * @author 	Cédric Néhémie
	 * @see		AbstractSyncCommand
	 * @see		ASyncCommand
	 * @see		ASyncCommandListener
	 */
	public class ASyncCommandSequencer extends AbstractSyncCommand	implements ASyncCommand, ASyncCommandListener
	{
		static public const onCommandTimeoutEVENT : String = "onCommandTimeout";
		
		private var _aCommands : Array;
		private var _nTimeout : Number;
		private var _nStep : Number;
		private var _oTimer : Timer;
		
		private var _eOnCommandTimeout : BasicEvent;
		
		/**
		 * 
		 * @param nTimeout
		 */
		public function ASyncCommandSequencer ( nTimeout : int = -1 )
		{
			_nStep = 0;
			_aCommands = new Array();
			
			_nTimeout = isNaN( nTimeout ) ? -1 : nTimeout;
			_oTimer = new Timer( _nTimeout == -1 ? 1 : _nTimeout, 1 );
		  	_oTimer.addEventListener( TimerEvent.TIMER_COMPLETE, _onTimeout );

		  	_eOnCommandTimeout = new BasicEvent ( onCommandTimeoutEVENT, this );
		}		
		
		/**
		 * 
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function addCommand( oCommand : ASyncCommand ) : Boolean
		{
			if( oCommand == null ) return false;
			
			var l : Number = _aCommands.length;
			return (l != _aCommands.push( oCommand ) );
		}
		
		/**
		 * 
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function removeCommand( oCommand : ASyncCommand ):Boolean
		{ 
			var id : Number = _aCommands.indexOf( oCommand ); 
			
			if ( id == -1 ) return false;
			
			while ( ( id = _aCommands.indexOf( oCommand ) ) != -1 )
			{
				_aCommands.splice( id, 1 );
			}
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLength () : uint
		{
			return _aCommands.length;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public override function execute( e : Event = null ) : void
		{
			if( !isRunning() )
			{
				_bIsRunning = true;
				_executeNextCommand ();
			}
		}
				
		/**
		 * 
		 * @param e
		 * 
		 */
		public function onCommandEnd( e : Event):void
		{
			if ( _nStep + 1 < getLength() )
			{
				_aCommands[ _nStep ].removeASyncCommandListener( this );
				_nStep++;
				_executeNextCommand();
			} 
			else
			{
				_nStep = 0;
				_abortTimeout ();
				_bIsRunning = false;
				_oEB.broadcastEvent( _eOnCommandEnd );
			}
		}

		
		/**
		 * 
		 * @param t
		 * @param o
		 * 
		 */
		public function addEventListener ( t : String, o : * ) : void
		{
			_oEB.addEventListener( t, o );
		}
		
		/**
		 * 
		 * @param t
		 * @param o
		 * 
		 */
		public function removeEventListener ( t : String, o : * ) : void
		{
			_oEB.removeEventListener( t, o );
		}
		
		/**
		 * 
		 * @param o
		 * 
		 */
		public function addListener ( o : ASyncCommandSequencerListener ) : void
		{
			_oEB.addListener( o );
		}
		
		/**
		 * 
		 * @param o
		 * 
		 */
		public function removeListener ( o : ASyncCommandSequencerListener ) : void
		{
			_oEB.removeListener( o );
		}
		
		/**
		 * 
		 * 
		 */
		private function _executeNextCommand () : void
		{
			_abortTimeout ();
			if ( _nStep == -1 )
	  		{
	  			PixlibDebug.WARN( this + " process has been aborted. Can't execute next command." );		
	  		} 
	  		else 
			{
		  		_runTimeout ();
		  		_aCommands[ _nStep ].addASyncCommandListener ( this );
				_aCommands[ _nStep ].execute();
	  		}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _onTimeout ( e : TimerEvent ) : void
		{
			_abortTimeout ();
			_nStep = -1;
			_bIsRunning = false;
			_oEB.broadcastEvent( _eOnCommandTimeout );
		}
		
		/**
		 * 
		 * 
		 */
		private function _runTimeout () : void
		{
			if( _nTimeout != -1 )
		  		_oTimer.start();
		}
		
		/**
		 * 
		 * 
		 */
		private function _abortTimeout () : void
		{
			if( _nTimeout != -1 )
				_oTimer.reset();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}