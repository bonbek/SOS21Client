package ddgame.client.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.proxy.UserProxy;
	import ddgame.client.events.EventList;
	import ddgame.server.events.PublicServerEventList;
	import ddgame.client.events.PublicIsoworldEventList;
	import ddgame.client.commands.*;
	import ddgame.client.proxy.*;
	import ddgame.client.view.*;
	import ddgame.client.proxy.ObjectBuilderProxy;
	
	/**
	 *	Commande d'initialisation partie client (the jeu)
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  22.02.2008
	 */
	public class IsoworldInitCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			facade.registerCommand(PublicServerEventList.ON_DATAMAP, ddgame.client.commands.StartUpdateMapCommand, true);
			facade.registerCommand(PublicIsoworldEventList.GFXLIB_COMPLETE, ddgame.client.commands.BuildMapCommand, true);
			facade.registerCommand(PublicServerEventList.ON_BONUS_ADDED, ddgame.client.commands.AddBonusCommand, true);
						
			facade.registerCommand(EventList.MOVE_PLAYER, ddgame.client.commands.MovePlayerCommand);
			facade.registerCommand(EventList.MOVE_PLAYER_TO_TILE, ddgame.client.commands.MovePlayerToTileCommand);
			facade.registerCommand(EventList.MOVE_TILE, ddgame.client.commands.MoveTileCommand);
			facade.registerCommand(EventList.MOVE_TILE_TO_TILE, ddgame.client.commands.MoveTileToTileCommand);
			facade.registerCommand(EventList.GOTO_MAP, ddgame.client.commands.ChangeMapCommand);
			facade.registerCommand(EventList.DISPLAY_HOURGLASS, ddgame.client.commands.DisplayHourglassCommand);
			facade.registerCommand(EventList.ADD_BONUS, ddgame.client.commands.AddBonusCommand);
			facade.registerCommand(EventList.LAUNCH_TRIGGER, ddgame.client.commands.LaunchTriggerCommand);
			facade.registerCommand(EventList.PLAYER_ENTER_CELL, ddgame.client.commands.CheckGridTriggerCommand);
			facade.registerCommand(EventList.PLAYER_LEAVE_CELL, ddgame.client.commands.CheckGridTriggerCommand);
			facade.registerCommand(EventList.PLAY_SOUND, ddgame.client.commands.PlayStopSoundCommand);
			facade.registerCommand(EventList.STOP_SOUND, ddgame.client.commands.PlayStopSoundCommand);
			facade.registerCommand(EventList.PLAYSTOP_SOUND, ddgame.client.commands.PlayStopSoundCommand);
			facade.registerCommand(EventList.INJECT_TRIGGER, ddgame.client.commands.InjectTriggerCommand);
			facade.registerCommand(EventList.INJECT_TRIGGERARGS, ddgame.client.commands.InjectTriggerArgsCommand);
						
			// Register Proxys
			facade.registerProxy(LibProxy.NAME, new LibProxy());
			facade.registerProxy(TileFactoryProxy.NAME, new TileFactoryProxy());
			facade.registerProxy(TileTriggersProxy.NAME, new TileTriggersProxy());
			facade.registerProxy(DatamapProxy.NAME, new DatamapProxy());
//			facade.registerProxy(PlayerProxy.NAME, new PlayerProxy());
			facade.registerProxy(SocketProxy.NAME, new SocketProxy());
			facade.registerProxy(ObjectBuilderProxy.NAME, new ObjectBuilderProxy());
			
			// Register Helpers
			facade.registerObserver(IsosceneHelper.NAME, new IsosceneHelper());
			
			// on retrouve la classe skin de l'avatar
			var skinId:int = PlayerProxy(facade.getProxy(ProxyList.PLAYER_PROXY)).skinId;
			var skinClass:String = ConfigProxy.getInstance().data..skin.(@id == skinId)[0];
//			trace("skin", skinClass);
			facade.registerObserver(PlayerHelper.NAME, new PlayerHelper({className:skinClass}));
//			facade.registerObserver(SoundHelper.NAME, new SoundHelper());
//			facade.registerObserver(UIHelper.NAME, new UIHelper());
		}
		
	}
	
}