/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.server.commands {
	import flash.events.Event;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.events.BaseEvent;
	import ddgame.server.proxy.RemotingProxy;
	import com.sos21.debug.log;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  20.02.2008
	 */
	public class ConnectServerCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public function execute (e:Event):void
		{			
			var rURL:String = (e as BaseEvent).getString();
			RemotingProxy( facade.getProxy(RemotingProxy.NAME)).connect(rURL);
		}

	}
	
}
