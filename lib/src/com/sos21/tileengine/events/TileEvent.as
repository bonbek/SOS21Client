/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.events {
	
	import flash.events.Event;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.structures.UPoint;
	
	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  08.11.2007
	 */
	public class TileEvent extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const PLAY_COMPLETE : String = "te.playComplete";
		public static const MOVE_COMPLETE : String = "te.moveComplete";
		public static const MOVE_CANCELED : String = "te.moveCanceled";
		public static const MOVE : String = "te.move";
		public static const ENTER_CELL : String = "enterCell";
		public static const LEAVE_CELL : String = "leaveCell";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@constructor
		 */
		public function TileEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public var data:Object;
		
		// retourne le target casté
		public function getTarget():Object {
			return target;
		}
		
		// retourne le UPoint coordonnée grille, pour les events ENTER_CELL et LEAVE_CELL
		public function getCell () : UPoint {
			return UPoint(data);
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function clone() : Event {
			return new TileEvent(type, data, bubbles, cancelable);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
