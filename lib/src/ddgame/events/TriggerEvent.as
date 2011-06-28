/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.events {
	
	import flash.events.Event;
	import ddgame.triggers.ITrigger;
	
	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  04.03.2008
	 */
	public class TriggerEvent extends Event {
		
		public static const EXECUTE:String = "triggerExecute";
		public static const COMPLETE:String = "triggerComplete";
		public static const CANCELED:String = "triggerCanceled";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TriggerEvent (type:String, trigger:ITrigger, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.trigger = trigger;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		protected var _mtype:String;
		override public function get type () : String {
			return _mtype ? _mtype : super.type;
		}
		
		public var trigger:ITrigger;
				
		/*public var msg:String;*/
		/*public function get trigger() : ITrigger
		{ return _trigger; }*/
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function morph (type:String) : TriggerEvent
		{
			_mtype = type;
			return this;
		}
		
		override public function clone () : Event
		{
			return new TriggerEvent(_mtype ? _mtype : type, trigger, bubbles, cancelable);
			/*if (cancel) e.cancel = cancel;*/
			/*return e;*/
		}
				
	}
	
}
