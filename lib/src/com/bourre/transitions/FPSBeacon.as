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
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * <code>FPSBeacon</code> provides tick to its listeners based
	 * on the native <code>ENTER_FRAME</code> event. A <code>Shape</code>
	 * object is instanciated internally to provide that callback. By the
	 * way, the minimum time step for this beacon is subject to the flash
	 * player restrictions (playing in a browser or in a stand-alone player
	 * for example).
	 * <p>
	 * The <code>FPSBeacon</code> provides an access to a global instance
	 * of the class, concret <code>TickListener</code> may use that instance
	 * by default when starting or stopping their animations.
	 * </p>
	 * @author	Cédric Néhémie
	 * @see		TickBeacon
	 */
	public class FPSBeacon implements TickBeacon
	{
		/*-----------------------------------------------------
		 * 	CLASS MEMBERS
		 *-----------------------------------------------------*/
		
		private static var _oInstance : FPSBeacon;
		
		private static const TICK : String = "onTick";
		
		/**
		 * Provides an access to a global instance of the 
		 * <code>FPSBeacon</code> class. That doesn't mean
		 * that the FPSBeacon class is a singleton, it simplify
		 * the usage of that beacon into concret <code>TickListener</code>
		 * implementation, which would register to a FPSBeacon instance.
		 * 
		 * @return a global instance of the <code>FPSBeacon</code> class
		 */
		public static function getInstance() : FPSBeacon
		{
			if( !_oInstance ) _oInstance = new FPSBeacon();
			return _oInstance;
		}
		
		/**
		 * Stops and the delete the current global instance
		 * of the <code>FPSBeacon</code> class.
		 */
		public static function release () : void
		{
			_oInstance.stop();
			_oInstance = null;
		}
		
		/*-----------------------------------------------------
		 * 	INSTANCE MEMBERS
		 *-----------------------------------------------------*/
		
		private var _oShape : Shape; 
		private var _bIP : Boolean;
		private var _oED : EventDispatcher;
		
		/**
		 * Creates a new <code>FPSBeacon</code>.
		 */
		public function FPSBeacon ()
		{
			_oShape = new Shape();
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
				_oShape.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
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
				_oShape.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
		}
		/**
		 * Returns <code>true</code> if this beacon is currently running.
		 * A FPSBeacon is considered as running when it receive events
		 * from its internal <code>Shape</code> object.
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
		 * Handles the <code>ENTER_FRAME</code> from the internal
		 * <code>Shape</code> object, and dispatch the <code>onTick</code>
		 * event to its listeners.
		 * 
		 * @param	e	event dispatched by the Shape object
		 */
		public function enterFrameHandler ( e : Event = null ) : void
		{
			var evt : BasicEvent = new BasicEvent( TICK, this );
			_oED.dispatchEvent( evt );
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