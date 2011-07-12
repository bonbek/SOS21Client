package ddgame.triggers {
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import com.sos21.events.BaseEvent;	
	import ddgame.triggers.AbstractTrigger;

	/**
	 *	Trigger dispatch event
	 *	dispatch un event en lui passant les
	 *	propriétés du trigger en paramètres
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class DispatchEventTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 10;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _eventType:String;
		private var _eventContent:Object = {};
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	Retourne le type d'event à dispatcher
		 */
		public function get eventType() : String {
			return _eventType;
		}
		
		/**
		 *	retourne le contenu de l'event à dispatcher
		 */
		public function get eventContent () : Object {
			return _eventContent;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 *	construction de l'event à dispatcher
		 */
		override public function initialize () : void
		{			
			var args:Dictionary = properties.arguments;
			var val:*;
			
			for (var p:String in args)
			{
				val = args[p];
				// on test savoir si on est sur la prop type d'event
				if (p != "evt")
				{
					// on test si valeur est un tableau
					if (val is String && val.indexOf("[") == 0)
					{
						// on construit le tableau (forme String: [val1#val2#val3...])
						var aval:Array = val.substring(1, val.length - 2).split("#");
						_eventContent[p] = aval;
					} else {
						_eventContent[p] = val;
					}
				} else {
					_eventType = val;			
				}
			}
			
			super.initialize();
		}
		
		/**
		 *	@inheritDoc
		 *	dispatch de l'event
		 */
		override public function execute (event:Event = null) : void
		{
			// on dispatch
			if (!isPropertie("evt"));
				sendEvent(new BaseEvent(eventType, eventContent));
			// et voilou...
			complete();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}

}

