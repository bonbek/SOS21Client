/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.events {

	/*import flash.utils.*;*/
	import flash.events.Event;

	/*import com.sos21.events.EventChannelDispatcher;
	import com.sos21.events.EventChannel;*/
	
	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  04.02.2008
	 */
	public class BaseEvent extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const EVENT_NAME : String = "baseEvent";
		
		/**
		 *	@constructor
		 */
		public function BaseEvent( type : String,
											ocontent : * = null,
											bubbles : Boolean = true, cancelable : Boolean = true )
		{
			super( type, bubbles, cancelable );
			_content = ocontent;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/*public var kind:String;
				
		public function get channel() : EventChannel
		{ return EventChannelDispatcher.getInstance().getChannel( _ecName ) }*/
		
		public function get content() : *
		{ return _content }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function setChannelName( s : String ) : void
		{ _ecName = s } 
		
		/*public function getInt() : int
		{ return int( _content ) }
		
		public function getString() : String
		{ return String( _content ) }
		
		public function contentAsArray() : Array
		{ return _content as Array }*/
		
		override public function clone() : Event
		{
			return new BaseEvent( type, _content, bubbles, cancelable );
		}
				
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _content : *;
		private var _ecName : String;
				
	}
	
}
