/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.server.commands {
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.server.proxy.RemotingProxy;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  01.04.2008
	 */
	public class GetMapListCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event):void
		{
			RemotingProxy(facade.getProxy(RemotingProxy.NAME)).getMapList();
		}
				
	}
	
}
