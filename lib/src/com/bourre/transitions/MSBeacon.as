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
package com.bourre.transitions 
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * <code>MSBeacon</code> provides tick to its listeners based
	 * on the native <code>TIMER</code> event. A <code>Timer</code>
	 * object is instanciated internally to provide that callback.
	 * By comparison with the <code>FPSBeacon</code> the number of
	 * ticks per second is relatively independant of the flash player
	 * framerate, as said in the <code>Timer</code> class documentation :
	 * <blockquote><i>
	 * For example, if a SWF file is set to play at 10 frames per second
	 * (fps), which is 100 millisecond intervals, but your timer is set
	 * to fire an event at 80 milliseconds, the event will be dispatched
	 * close to the 100 millisecond interval.  Applications may dispatch
	 * events at slightly offset intervals based on the internal frame
	 * rate of the application.  Memory-intensive scripts may also offset
	 * the events.
	 * </i></blockquote>
	 * <p>
	 * The <code>MSBeacon</code> provides an access to a global instance
	 * of the class, concret <code>TickListener</code> may use that instance
	 * by default when starting or stopping their animations.
	 * </p>
	 * @author	Cédric Néhémie
	 * @see		TickBeacon
	 */
	public class MSBeacon implements TickBeacon
	{
		/*-----------------------------------------------------
		 * 	CLASS MEMBERS
		 *-----------------------------------------------------*/
		
		private static var _oInstance : MSBeacon;
		
		private static const TICK : String = "onTick";
		
		/**
		 * Provides an access to a global instance of the 
		 * <code>MSBeacon</code> class. That doesn't mean
		 * that the MSBeacon class is a singleton, it simplify
		 * the usage of that beacon into concret <code>TickListener</code>
		 * implementation, which would register to a MSBeacon instance.
		 * 
		 * @return a global instance of the <code>MSBeacon</code> class
		 */
		public static function getInstance() : MSBeacon
		{
			if( !_oInstance ) _oInstance = new MSBeacon();
			return _oInstance;
		}
		
		/**
		 * Stops and the delete the current global instance
		 * of the <code>MSBeacon</code> class.
		 */
		public static function release () : void
		{
			_oInstance.stop();
			_oInstance._oTimer.removeEventListener( TimerEvent.TIMER , _oInstance.timeHandler );
			_oInstance = null;
		}
		
		/*-----------------------------------------------------
		 * 	INSTANCE MEMBERS
		 *-----------------------------------------------------*/
		
		private var _oTimer : Timer; 
		private var _nTickDelay : Number;
		private var _bIP : Boolean;
		private var _oED : EventDispatcher;
		
		/**
		 * Creates a new <code>MSBeacon</code>.
		 */
		public function MSBeacon ()
		{
			_nTickDelay = 1000/40;
			_oTimer = new Timer( _nTickDelay, 0 );
			_oTimer.addEventListener( TimerEvent.TIMER , timeHandler );
			_bIP = false;
			_oED = new EventDispatcher ();
		}
		
		/**
		 * Starts this beacon if it wasn't already playing.
		 */
		public function start() : void
		{
			if( !_bIP )
			{
				_bIP = true;
				_oTimer.start();
			}
		}
		
		/**
		 * Stops this beacon if it wasn't already stopped.
		 */	
		public function stop() : void
		{
			if( _bIP )
			{
				_bIP = false;
				_oTimer.stop();
			}
		}
		
		/**
		 * Returns <code>true</code> if this beacon is currently running.
		 * A MSBeacon is considered as running when it receive events
		 * from its internal <code>Timer</code> object.
		 * 
		 * @return	<code>true</code> if this beacon is currently running
		 */	
		public function isPlaying() : Boolean
		{
			return _bIP;
		}
		
		/**
		 * Adds the passed-in <code>listener</code> as listener for
		 * this <code>TickBeacon</code>. If the passed-in listener
		 * is the first listener added to this beacon, the beacon
		 * will automatically start itself.
		 * 
		 * @param	listener	tick listener to be added
		 */
		public function addTickListener( listener : TickListener ) : void
		{
			if( !_oED.hasEventListener( TICK ) )
				start();
			_oED.addEventListener( TICK, listener.onTick, false, 0, true );
		}
		
		/**
		 * Removes the passed-in <code>listener</code> as listener 
		 * for this <code>TickBeacon</code>. If the passed-in listener
		 * is the last listener registered to this beacon, the beacon
		 * will automatically stop itself.
		 * 
		 * @param	listener	tick listener to be removed
		 */
		public function removeTickListener( listener : TickListener ) : void
		{
			_oED.removeEventListener( TICK, listener.onTick );
			if( !_oED.hasEventListener( TICK ) )
				stop();
		}
		
		/**
		 * Handles the <code>TIMER</code> from the internal
		 * <code>Timer</code> object, and dispatch the <code>onTick</code>
		 * event to its listeners.
		 * 
		 * @param	e	event dispatched by the Timer object
		 */
		public function timeHandler ( e : TimerEvent = null ) : void
		{
			var evt : BasicEvent = new BasicEvent( TICK, this );
			_oED.dispatchEvent( evt );
		}
		
		/**
		 * Defines the preferred delay to occurs between two ticks.
		 * There's no guarantee on the regularity of the delay, as 
		 * the Flash player can restrict the delay to match the 
		 * framerate defined for the compiled swf.
		 * 
		 * @param	n	number of milliseconds between each tick
		 */
		public function setTickDelay ( n : Number = 25 ) : void 
		{
			_nTickDelay = n;
			_oTimer.delay = _nTickDelay;
		}
		/**
		 * Returns the current delay in milliseconds between ticks.
		 * 
		 * @return the current delay in milliseconds between ticks
		 */
		public function getTickDelay () : Number
		{
			return _nTickDelay;
		}
		/**
		 * Sets the delay between ticks by defining the number of
		 * ticks per seconds to occurs. As with the <code>setTickDelay</code>
		 * method, there's no guarantee that the observed delay
		 * was conform to the specified one.
		 * 
		 * @param	n	number of ticks per seconds
		 */
		public function setTickPerSecond ( n : Number = 40 ) : void
		{
			setTickDelay ( Math.round( 1000/n ) );
		}
		/**
		 * Returns the number of ticks per seconds which may
		 * occurs with the current delay. 
		 * 
		 * @return	the number of ticks per seconds which may
		 * 			occurs with the current delay
		 */ 
		public function getTickPerSecond () : Number
		{
			return Math.round( 1000 / _nTickDelay );
		}
		
		/**
		 * Returns the string representation of this object.
		 * 
		 * @return	the string representation of this object.
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
internal class PrivateMSBeaconConstructorAccess {}