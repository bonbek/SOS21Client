package ddgame.commands {
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	
	import ddgame.server.events.PublicServerEventList;
	import ddgame.server.proxy.RemotingProxy;
	import ddgame.client.proxy.PlayerProxy;
	import ddgame.events.EventList;
	import ddgame.proxy.UserProxy;
	import ddgame.proxy.ProxyList;
	import ddgame.view.UIHelper;
	import ddgame.view.FirstConnexionHelper;
		
	/**
	 *	Commande initialisation d'un joueur
	 * Cette command est executée deux fois en cas de première connexion utilsateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class PlayerInitCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
      public function execute (e:Event):void
		{
			// recup des data player
			var playerData:Object = BaseEvent(e).content;
			if (playerData)
			{					
				// proxy joueur
				var playerProxy:PlayerProxy = PlayerProxy(facade.getProxy(ProxyList.PLAYER_PROXY));
				if (!playerProxy)
				{
					// initialisation proxy joueur
					playerProxy = new PlayerProxy(ProxyList.PLAYER_PROXY);
					facade.registerProxy(ProxyList.PLAYER_PROXY, playerProxy);
				}
				// passage des datas joueur
				playerProxy.setData(playerData);
				
				// proxy utilisateur
				var userProxy:UserProxy = UserProxy(facade.getProxy(ProxyList.USER_PROXY));
				
				// test si le player chargé est bien associé à l'utilisateur connecté
				if (userProxy.userId == playerProxy.userId)
				{
					var username:String = userProxy.username;
					if (!username)
					{
						// pas de pseudo pour l'utilisateur, on lance module première connection
						// (pour l'instant le seul permetant de choisir son pseudo)
						UIHelper(facade.getObserver(UIHelper.NAME)).component.enabled = false;
						var fch:FirstConnexionHelper = new FirstConnexionHelper();
						facade.registerObserver(FirstConnexionHelper.NAME, fch);
						fch.load();
					}
					else
					{
						switch (e.type)
						{
							// > un player à été crée pour un utilisteur ayant déjà un pseudo
							// (utilsateur à dejà fini le jeu :))
							case PublicServerEventList.ON_PLAYER_CREATED :
							{
								if (userProxy.username)
								{
									// entrée pour un un utilisateur déjà configuré
									// recommencer une partie ?
								}
								break;
							}
							// > les vérifs on été faites, le joueur reflète l'utilisateur connecté
							case PublicServerEventList.ON_PLAYER_LOADED :
							{
								// suppression éventuelle du module première connection
								if (facade.getObserver(FirstConnexionHelper.NAME))
								{
									FirstConnexionHelper(facade.getObserver(FirstConnexionHelper.NAME)).release();
									// relache de l'ui
									UIHelper(facade.getObserver(UIHelper.NAME)).component.enabled = true;
								}
								
								// passage du username
								playerProxy.username = username;
								// démarrage de l'appli
								sendEvent(new BaseEvent(EventList.APPLICATION_STARTUP));
								break;
							}
						}
					}
				}
				else
				{
					if (userProxy.credentials.login == "guest")
					{
						// passage du username
						playerProxy.username = userProxy.username;
						// TODO kk cookie
						var so:SharedObject = SharedObject.getLocal("g");
						if (!so.data.id)
						{
							so.data.id = playerProxy.id;
							so.flush();
						}
						// démarrage de l'appli
						sendEvent(new BaseEvent(EventList.APPLICATION_STARTUP));
					}
				}
			}
			else
			{
				throw new Error("pas de data player, application stoppée");
			}
			
		}
				
	}
	
}
