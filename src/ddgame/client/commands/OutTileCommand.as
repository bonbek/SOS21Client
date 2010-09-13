/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.commands {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.client.proxy.TileTriggersProxy;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  04.03.2008
	 */
	public class OutTileCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event):void
		{
			var tile:AbstractTile = AbstractTile(BaseEvent(event).content);
			TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)).launchTileTrigger(tile, MouseEvent.MOUSE_OUT);
		}
				
	}
	
}
