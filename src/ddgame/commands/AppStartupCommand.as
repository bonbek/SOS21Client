package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.events.EventList;
	import ddgame.client.events.EventList;
	import ddgame.client.commands.IsoworldInitCommand;
	import ddgame.server.events.PublicServerEventList;
	import ddgame.client.proxy.PlayerProxy;
	import ddgame.view.FirstConnexionHelper;
	import ddgame.proxy.ProxyList;
	import ddgame.proxy.UserProxy;
	import ddgame.client.proxy.TileTriggersProxy;
	
	/**
	 *	Commande démarrage, switch sur module première connexion utilsateur
	 * ou lancement du jeu. Cette command est lancée à partir de retour LOAD_USER (ON_USERLOADED)
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AppStartupCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
      public function execute (event:Event):void
		{
			// initialiation de la partie client (jeu)
			facade.registerCommand(ddgame.client.events.EventList.ISOWORLD_INIT, ddgame.client.commands.IsoworldInitCommand);
			sendEvent(new BaseEvent(ddgame.client.events.EventList.ISOWORLD_INIT));
			facade.unregisterCommand(ddgame.client.events.EventList.ISOWORLD_INIT);
			
			// on lance la chargement première scène
			// > 1ére connection, le home du joueur, 2e et autre : dernière scène vistée
			var playerProxy:PlayerProxy = PlayerProxy(facade.getProxy(ProxyList.PLAYER_PROXY));
			var entryMap:int;
			var fc:int = ConfigProxy.getInstance().data.maptoload.@force;			
			if (fc)
			{
				entryMap = int(ConfigProxy.getInstance().getContent("maptoload"));
			}
			else if (playerProxy.lastVisitedMapId)
			{
				entryMap = playerProxy.lastVisitedMapId;
			}
			else if (playerProxy.homeId)
			{
				entryMap = playerProxy.homeId;
			}
			else
			{
				entryMap = int(ConfigProxy.getInstance().getContent("maptoload"));
			}
			
//			trace(this, "entryMap: ", entryMap);
			// passage référence cookie au Proxy trigger
			//playerProxy.cookie.clear();
			//TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)).cookie = playerProxy.cookie;
			
			sendPublicEvent(new BaseEvent(PublicServerEventList.GET_DATAMAP, {mapId:entryMap}));
			
			// nettoyage des commandes à ne plus utiliser
			facade.unregisterCommand(ddgame.events.EventList.APPLICATION_INIT);
			facade.unregisterCommand(ddgame.events.EventList.APPLICATION_STARTUP);
			facade.unregisterCommand(PublicServerEventList.ON_USER_LOADED);
		}
	}
	
}
