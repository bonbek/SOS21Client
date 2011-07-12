package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.events.*;
	import ddgame.commands.*;
	import ddgame.proxy.*;
	import ddgame.scene.*;
	import ddgame.server.IClientServer;
	import ddgame.ui.FirstConnexionHelper;
	
	/**
	 *	Commande démarrage, switch sur module première connexion utilsateur
	 * ou lancement du jeu.
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
		
      public function execute (event:Event) : void
		{
			// chargement place 0 (données globales) TODO
			IClientServer(facade.getProxy(ProxyList.SERVER_PROXY)).getServices("place").load({keys:0},
																														onGlobalsLoaded, onGlobalsLoaded);
		}
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		/**
		 * Réception chargement des data globales (place 0)
		 *	@param result Object
		 */
		private function onGlobalsLoaded (document:Object) : void
		{
			// initialiation de la partie client
			facade.registerCommand(EventList.GFXLIB_COMPLETE, ddgame.commands.BuildMapCommand, true);
			
			facade.registerCommand(EventList.MOVE_PLAYER, ddgame.commands.MovePlayerCommand);
			facade.registerCommand(EventList.MOVE_TILE, ddgame.commands.MoveTileCommand);
			facade.registerCommand(EventList.GOTO_MAP, ddgame.commands.ChangeMapCommand);
			facade.registerCommand(EventList.ADD_BONUS, ddgame.commands.AddBonusCommand);
			facade.registerCommand(EventList.LAUNCH_TRIGGER, ddgame.commands.LaunchTriggerCommand);
			facade.registerCommand(EventList.PLAYER_ENTER_CELL, ddgame.commands.CheckGridTriggerCommand);
			facade.registerCommand(EventList.PLAYER_LEAVE_CELL, ddgame.commands.CheckGridTriggerCommand);
			facade.registerCommand(EventList.PLAY_SOUND, ddgame.commands.PlayStopSoundCommand);
			facade.registerCommand(EventList.STOP_SOUND, ddgame.commands.PlayStopSoundCommand);
			facade.registerCommand(EventList.PLAYSTOP_SOUND, ddgame.commands.PlayStopSoundCommand);
			facade.registerCommand(EventList.INJECT_TRIGGER, ddgame.commands.InjectTriggerCommand);
			facade.registerCommand(EventList.INJECT_TRIGGERARGS, ddgame.commands.InjectTriggerArgsCommand);
			facade.registerCommand(EventList.WRITE_ENV, ddgame.commands.WriteEnvCommand);
			facade.registerCommand(EventList.SCENE_BUILDED, ddgame.commands.BuildMapCommand);
						
			// Register Proxys
			facade.registerProxy(LibProxy.NAME, new LibProxy());
			facade.registerProxy(EnvProxy.NAME, new EnvProxy(document ? document : null));
			facade.registerProxy(TileFactoryProxy.NAME, new TileFactoryProxy());
			facade.registerProxy(TileTriggersProxy.NAME, new TileTriggersProxy());
			facade.registerProxy(DatamapProxy.NAME, new DatamapProxy());
			facade.registerProxy(ObjectBuilderProxy.NAME, new ObjectBuilderProxy());
			
			// Register Helpers
			facade.registerObserver(IsosceneHelper.NAME, new IsosceneHelper());
			facade.registerObserver(PlayerHelper.NAME, new PlayerHelper());
			
			// init data globales
			// TODO trouver mieux
			if (document)
			{
				DatamapProxy(facade.getProxy(DatamapProxy.NAME)).data = document;
				TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)).parse(document.actions);
				DatamapProxy(facade.getProxy(DatamapProxy.NAME)).data = null;		
			}
			
			// on lance la chargement première scène
			// > 1ére connection, le home du joueur, 2e et autre : dernière scène vistée
			var playerProxy:PlayerProxy = PlayerProxy(facade.getProxy(ProxyList.PLAYER_PROXY));
			var entryMap:String;
			var fc:int = ConfigProxy.getInstance().data.maptoload.@force;
			if (fc)
			{
				entryMap = ConfigProxy.getInstance().getContent("maptoload");
			}
			else if (playerProxy.lastPlace)
			{
				entryMap = playerProxy.lastPlace;
			}
			else if (playerProxy.homePlace)
			{
				entryMap = playerProxy.homePlace;
			}
			else
			{
				entryMap = ConfigProxy.getInstance().getContent("maptoload");
			}

			// Dispatch démarrage
			sendEvent(new Event(EventList.APPLICATION_STARTUP));
			sendPublicEvent(new Event(EventList.APPLICATION_STARTUP));			
			
			// Chargement scène initiale
			sendEvent(new BaseEvent(EventList.GOTO_MAP, {mapId:entryMap}));
		}
	}
	
}
