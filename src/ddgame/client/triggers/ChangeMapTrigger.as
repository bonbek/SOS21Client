/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.triggers {
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.events.EventList;
	import ddgame.server.events.PublicServerEventList;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ChangeMapTrigger extends AbstractTrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 1;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function execute (event:Event = null) : void
		{
//			var mapId:int = int(properties.arguments["mapid"]);
						
			sendEvent(new BaseEvent(EventList.DISPLAY_HOURGLASS, false));
//			trace("change map trigger id:" + getPropertie("mapid") + " entryPoint: " + getPropertie("entryPoint"));
			
			var o:Object = {	mapId:getPropertie("mapid"),
									entryPoint:isPropertie("entryPoint") ? getPropertie("entryPoint") : null,
									removeTriggers:getPropertie("removeTriggers")	};
									
			sendEvent(new BaseEvent(EventList.GOTO_MAP, o));
			complete();
		}
		
		override protected function onDiffer () : void
		{
			sendEvent(new Event(EventList.FREEZE_SCENE));
			sendEvent(new BaseEvent(EventList.DISPLAY_HOURGLASS, true));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
					
		
	}
	
}
