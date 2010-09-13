/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.commands {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.sos21.debug.log;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.events.BaseEvent;0
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.client.events.EventList;
	import ddgame.client.proxy.TileProxy;
	import ddgame.client.proxy.TileFactoryProxy;
	import ddgame.client.triggers.ITrigger;
	import ddgame.client.events.TriggerEvent;
	import ddgame.client.proxy.TileTriggersProxy;
	import com.sos21.tileengine.structures.UPoint;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ClickTileCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			// TODO commande offline, à réparer ???
			
			/*var trigger:ITrigger = TriggerEvent(event).trigger;
			var tile:AbstractTile = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)).findTileByTrigger(trigger);
			var tileProxy:TileProxy = TileProxy(TileFactoryProxy(facade.getProxy(TileFactoryProxy.NAME)).findTileProxy(tile));
			if (tileProxy.hasFacingPoint())
			{
				trigger.differ(EventList.PLAYER_MOVE_COMPLETE);
				sendEvent(new BaseEvent(EventList.MOVE_PLAYER_TO_TILE, tile));
			}*/
		}
				
	}
	
}
