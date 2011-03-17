package ddgame.commands {
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	
	import ddgame.server.events.PublicServerEventList;
	import ddgame.proxy.ProxyList;
	import ddgame.server.IClientServer;
	import ddgame.proxy.UserProxy;
	import ddgame.view.FirstConnexionHelper;
		
	/**
	 *	Commande initialisation d'un utilsateur / joueur
	 * Cette command est executée deux fois en cas de première connexion utilsateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class UserInitCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
      public function execute (event:Event) : void
		{
			// recup des data utilisateur
			var userData:Object = BaseEvent(event).content;
			if (userData)
			{	
				var userProxy:UserProxy = UserProxy(facade.getProxy(ProxyList.USER_PROXY));
				if (!userProxy)
				{
					// initialisation proxy utilisateur
					userProxy = new UserProxy(ProxyList.USER_PROXY);
					facade.registerProxy(ProxyList.USER_PROXY, userProxy);
				}
				// passage des datas utilisateur
				userProxy.setData(userData);
				
				var serverProxy:IClientServer = IClientServer(facade.getProxy(ProxyList.SERVER_PROXY));
								
				// > utilisateur invité
				if (userProxy.credentials.login == "guest")
				{
					var so:SharedObject = SharedObject.getLocal("g");
					if (so.data.id)
					{
						serverProxy.getPlayerData(so.data.id);
						return;
					}
					else
					{
						serverProxy.createPlayer(0);
						return;
					}
				}
				else
				{
					// check si l'utilisateur à un player
					if (!userProxy.playerId)
					{
						// on lance la création d'un nouveau joueur pour l'utilisateur
						serverProxy.createPlayer(userProxy.userId, null, true);
					}
					else
					{
						// recup des data joueur de l'utilisateur

						/*// > utilisateur invité
						if (userProxy.credentials.login == "guest")
						{
							var so:SharedObject = SharedObject.getLocal("g");
							if (so.data.id)
							{
								rProxy.getPlayerData(so.data.id);
								return;
							}
							else
							{
								rProxy.createPlayer(0);
								return;
							}
						}*/

						serverProxy.getPlayerData(userProxy.playerId);
					}
				}
				

			}
			else
			{
				throw new Error("Aucune données utilisteur, application stoppée");
			}
			
		}
				
	}
	
}
