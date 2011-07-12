package ddgame.commands {

	import flash.events.Event;

	import com.sos21.events.BaseEvent;	
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;

	import ddgame.proxy.*;
	import ddgame.server.IClientServer;
	import ddgame.events.EventList;
	import ddgame.commands.AppStartupCommand;
	
	/**
	 *	Commnande de démarrage du jeu en mode
	 * invité
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.04.2011
	 */
	public class StartupGuestModeCommand extends Notifier implements ICommand {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			var content:Object = BaseEvent(event).content;
			trace("Info: Start in Guest mode with player", content.playerId, this);
			
			// Câblage recéption data joueur avec commande de démarrage
			facade.registerCommand(EventList.PLAYER_LOADED, ddgame.commands.AppStartupCommand);
			
			// Décalaration proxy joueur et lancement récup data
			var serverProxy:IClientServer = facade.getProxy(ProxyList.SERVER_PROXY) as IClientServer;
			var playerProxy:PlayerProxy = new PlayerProxy(serverProxy.getServices("player"));
			facade.registerProxy(PlayerProxy.NAME, playerProxy);
			playerProxy.load(content.playerId);
		}
		
	}

}

