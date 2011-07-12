package ddgame.commands {
	
	import flash.net.*;
	import flash.events.*;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import com.sos21.events.BaseEvent;	
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.*;
	import com.sos21.helper.AbstractHelper;
	import ddgame.events.EventList;
	import ddgame.ApplicationChannels;
	import ddgame.proxy.*;
	import ddgame.server.IClientServer;
	
	/**
	 *	Commande de démarrage en mode utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.04.2011
	 */
	public class StartupUserModeCommand extends Notifier implements ICommand {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			var content:Object = BaseEvent(event).content;
			trace("Info: Start in User mode with player", content.playerId);
			if (!content.playerId)
			{
				// Pas de joueur défini pour l'utilisateur, on lance le module
				// de première connexion

				var fcf:String = ConfigProxy.getInstance().getData().mods.firstConnection.@file;
				if (!fcf)
				{
					// pas de module défini
					sendEvent(new BaseEvent(	EventList.APPLICATION_ABORT,
														{msg:"First connection mod not defined, can't create player"})	);
				}
				else
				{
					// chargement du module
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFirstConnectionModLoaded, false);
					loader.load(new URLRequest(fcf));
				}
			}
			else
			{
				// TODO
			}
		}
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		/**
		 * Réception chargement du module de première
		 * connexion
		 *	@param event Event
		 */
		private function onFirstConnectionModLoaded (event:Event) : void
		{
			event.target.removeEventListener(Event.COMPLETE, onFirstConnectionModLoaded, false);
			var firstConnectionMod:Object = Loader(event.target.loader ).content as Object;
			firstConnectionMod.start(	ApplicationChannels.CLIENT_CHANNEL,
												onFirstInitComplete, onFirstInitFault	);
 		}
		
		/**
		 *	@param playerId Object
		 */
		private function onFirstInitComplete (playerId:String) : void
		{
			trace("onFirstInitComplete", playerId);
			// Câblage recéption data joueur avec commande de démarrage
			facade.registerCommand(EventList.PLAYER_LOADED, ddgame.commands.AppStartupCommand);
			// Décalaration proxy joueur et lancement récup data
			var serverProxy:IClientServer = facade.getProxy(ProxyList.SERVER_PROXY) as IClientServer;
			var playerProxy:PlayerProxy = new PlayerProxy(serverProxy.getServices("player"));
			facade.registerProxy(PlayerProxy.NAME, playerProxy);
			playerProxy.load(playerId);
		}
		
		/**
		 *	@param fault Object
		 */
		private function onFirstInitFault (fault:Object) : void
		{
			// TODO
		}
		
	}

}

