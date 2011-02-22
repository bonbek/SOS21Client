package ddgame.client.commands {
	
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.events.BaseEvent;
	import com.sos21.tileengine.events.TileEvent;
	import ddgame.client.events.EventList;
	import com.sos21.tileengine.structures.UPoint;
	import ddgame.client.proxy.TileTriggersProxy;
	
	/**
	 *	Vérif et execution des traggers asociés à
	 *	la grille
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class CheckGridTriggerCommand extends Notifier implements ICommand {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
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
		
		public function execute(event:Event):void
		{
			var proxy:TileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
			var cell:Object = BaseEvent(event).content;
			var id:String = String(cell.xu + "-" + cell.yu + "-" + cell.zu);
			
			var etype:String = event.type == EventList.PLAYER_ENTER_CELL ? TileEvent.ENTER_CELL : TileEvent.LEAVE_CELL;
//			trace("check: ", etype);
			if (proxy.isTrigger(id, etype))
			{
//				trace("is trigger")
				proxy.launchTriggerByRef(id, etype, id);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

