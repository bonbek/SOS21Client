/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.commands {
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.client.proxy.TileTriggersProxy;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  05.03.2008
	 */
	public class LaunchTileTrigger extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event):void
		{
			var o:Object = BaseEvent(event).content;
			TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)).launchTileTrigger(o.tile, o.fireEventType);
		}
				
	}
	
}
