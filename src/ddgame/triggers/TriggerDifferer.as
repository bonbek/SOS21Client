package ddgame.triggers {

	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import com.sos21.debug.log;
	import ddgame.triggers.ITrigger;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  04.03.2008
	 */
	public class TriggerDifferer {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function TriggerDifferer(evtType:String, dispatcher:IEventDispatcher, trigger:ITrigger)
		{
			_eT = evtType;
			_oD = dispatcher;
			_t = trigger;
			_oD.addEventListener(_eT, eventHandler);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _eT:String;
		private var _oD:IEventDispatcher;
		private var _t:ITrigger;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function eventHandler(event:Event):void
		{
//			trace(event.type + " @ TriggerDifferer");
			_oD.removeEventListener(_eT, eventHandler);
			_t.execute(event);
			_oD = null;
			_t = null;
		}
		
	}
	
}
