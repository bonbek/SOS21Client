package ddgame.client.triggers {

	import flash.events.IEventDispatcher;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import com.sos21.debug.log;
	import com.sos21.observer.Notifier;
	import com.sos21.helper.AbstractHelper;
	import ddgame.client.events.EventList;
	import ddgame.client.events.TriggerEvent;
	import ddgame.client.triggers.ITrigger;
	import ddgame.client.triggers.TriggerProperties;
	import ddgame.client.triggers.TriggerDifferer;

/*

<trigger id=int class=int target="t_1" firetype=int>
	<ressource id=1>chemin fichier</ressource>
	<ressource id=1>....
	<complete>
		
	</complete>
</trigger>

*/


	
	/**
	 *	Class description.
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AbstractTrigger extends Notifier implements ITrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "tileTrigger";
		public static const CLASS_ID:int = 0;
		
		/*
		* type de persistance */
		public static const MAP_PERSIST:int = 1;				// persiste durant l'existance d'une map
		public static const APPLICATION_PERSIST:int = 2;	// persiste pendant toute la durée de l'appli
		
			/* Correspondance avec les properties.fireEventType
			*	Evenements envoyés à l'initialisation du trigger */
		public static var eventTypeList:Array =	[
																	EventList.OVER_TILE_TRIGGER,		// properties.fireType 0
																	EventList.OUT_TILE_TRIGGER,		// properties.fireType 1
																	EventList.CLICK_TILE_TRIGGER		// properties.fireType 2
																]
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function AbstractTrigger()
		{
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
		
		public function get stage():Stage
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
		
	}
	
}
