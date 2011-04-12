/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.commands {

	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.proxy.ProxyList;
	import ddgame.server.IClientServer;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  01.04.2008
	 */
	public class GetDataQuizCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			var nid:int = BaseEvent(event).content;
			IClientServer(facade.getProxy(ProxyList.SERVER_PROXY)).getDataQuiz(nid);
		}
				
	}
	
}
