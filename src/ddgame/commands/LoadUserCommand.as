package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.server.events.PublicServerEventList;
	import ddgame.server.proxy.RemotingProxy;
	import ddgame.proxy.ProxyList;
	import ddgame.proxy.UserProxy;
		
	/**
	 *	Commande récupération des data utilsateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class LoadUserCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
      public function execute (event:Event):void
		{
			// recup des ids utilisateur
			var userCredentials:Object = BaseEvent(event).content;
			
			// on essaie de rafraîchir l'utilisateur courant (utile pour module première connexion)
			if (!userCredentials || !userCredentials.hasOwnProperty("login") || !userCredentials.hasOwnProperty("password"))
			{
				var userProxy:UserProxy = UserProxy(facade.getProxy(ProxyList.USER_PROXY));
				userCredentials = userProxy.credentials;
			}
			
			// on lance la recup des data utilisateur
			// -> retour du résultat lance ddgame.commands.AppStartupCommand
			RemotingProxy(facade.getProxy(RemotingProxy.NAME)).getUserData(userCredentials.login, userCredentials.password);
		}
				
	}
	
}
