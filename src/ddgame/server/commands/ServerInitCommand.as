package ddgame.server.commands {

	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.server.proxy.RemotingProxy;
	import ddgame.server.events.PublicServerEventList;
	import ddgame.server.commands.*;
	
	/**
	 *	Commande initialisation partie remoting
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ServerInitCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public function execute (e:Event):void
		{
			// on enregistre les commandes
			facade.registerCommand(PublicServerEventList.GET_DATAMAP, ddgame.server.commands.GetDataMapCommand, true);
			facade.registerCommand(PublicServerEventList.GET_DATAQUIZ, ddgame.server.commands.GetDataQuizCommand, true);
			facade.registerCommand(PublicServerEventList.GET_MAPLIST, ddgame.server.commands.GetMapListCommand, true);
			
			// initialisation connection remoting
			var oconnect:Object = BaseEvent(e).content;
			var rproxy:RemotingProxy = new RemotingProxy();
			rproxy.connect(oconnect.servicePath, oconnect.credentials ? oconnect.credentials : null);
			
			facade.registerProxy(RemotingProxy.NAME, rproxy);
		}
		
	}
	
}
