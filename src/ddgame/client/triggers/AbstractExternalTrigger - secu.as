package ddgame.client.triggers {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IEventDispatcher;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import com.sos21.helper.AbstractHelper;
	import com.sos21.events.EventChannel;
	import com.sos21.facade.Facade;
	import ddgame.client.events.EventList;
 	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.events.TriggerEvent;
	import ddgame.client.triggers.ITrigger;
	import ddgame.client.triggers.TriggerProperties;
	import ddgame.client.triggers.TriggerDifferer;

	/**
	 *	Class description.
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AbstractExternalTrigger extends Sprite implements ITrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function AbstractExternalTrigger()
		{
			super();
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _id:int;
		protected var _properties:TriggerProperties;
		protected var _starget:Object;
		protected var _differer:TriggerDifferer;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function set sourceTarget(val:Object):void
		{
			_starget = val;
		}
		
		public function get sourceTarget():Object
		{
			return _starget;
		}
		
		public function set properties(val:TriggerProperties):void
		{ 
			_properties = val;
		}
		
		public function get properties():TriggerProperties
		{ 
			return _properties;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function isPropertie(prop:String):Boolean
		{
			return _properties.arguments[prop] != null;
		}
		
		public function getPropertie(prop:String):*
		{
			return _properties.arguments[prop];
		}
		
		public function setPropertie(prop:String, val:*):void
		{
			_properties.arguments[prop] = val;
		}
		
		public function differ(evtType:String):void
		{
			_differer = new TriggerDifferer(evtType, channel, this);
		}
		
		override public function get stage():Stage
		{ 
			return AbstractHelper.stage.stage;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		public function execute(event:Event = null):void
		{
			trace(".execute() should be implemented in your subClass@" + toString());
		}
		
		public function initialize():void
		{
//			var evtType:String = eventTypeList[properties.fireType];
			var evtType:String = properties.fireEventType;
			if (evtType!= null)
			{
				var tevent:TriggerEvent = new TriggerEvent(evtType, this, true, true);
				sendEvent(tevent);
				if (tevent.isDefaultPrevented())
				{
					sendEvent(new TriggerEvent(TriggerEvent.CANCELED, this));
					// TODO appel fonction canceled dans les instances
					return;
				}
			}
			if (_differer == null)
			{
				execute(new Event(Event.INIT));
				// patch pour recup signal juste après que le trigger soit executé
				sendEvent(new TriggerEvent(TriggerEvent.EXECUTE, this));
			} else {
				onDiffer();
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function complete(event:Event = null):void
		{
			sendEvent(new TriggerEvent(TriggerEvent.COMPLETE, this));
		}
		
		protected function onDiffer():void
		{
			trace(".onDiffer() should be implemented in your subClass@" + toString());
		}
		
		
		// ******************** implémentation notifier ***********************
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/*
		*	Return Facade instance associated to the EventChannel assigned
		*	to this Notifier instance
		*	@return	Facade
		*/
		public function get facade():Facade
		{
			return Facade.getFacade(channel);
		}
		
		/*
		*	Notify Observers
		*	@param	e : Event
		*/
		final public function sendEvent(event:Event):void
		{
			facade.sendEvent(event);
		}
		
		/*
		*	Notify public Observers ( ApplicationChannel Observers )
		*	@param	e : Event
		*/
		final public function sendPublicEvent(event:Event):void
		{
			facade.sendPublicEvent(event)
		}
				
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		private var _c : EventChannel;
		
		/*
		*	Set the EventChannel this Notifier belong to
		*	Usualy set by a Facade instance during notifycation process (when a Command extends Notifier)
		*	or register Proxy process
		*	@param	ac : EventChannel
		*/
		public function set channel(ec:EventChannel):void
		{ 
			_c = ec;
		}
		
		/*
		*	@return	EventChannel
		*/
		public function get channel():EventChannel
		{ 
			return _c;
		}
		
	}
	
}
