package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.proxy.UserProxy;
	import ddgame.events.EventList;
	import ddgame.events.ServerEventList;
	import ddgame.commands.*;
	import ddgame.proxy.*;
	import ddgame.scene.*;
	import ddgame.proxy.ObjectBuilderProxy;
	
	/**
	 *	Commande d'initialisation partie scene de jeu
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
			facade.registerCommand(ServerEventList.ON_DATAMAP, ddgame.commands.StartUpdateMapCommand, true);
			facade.registerCommand(EventList.GFXLIB_COMPLETE, ddgame.commands.BuildMapCommand, true);
			facade.registerCommand(ServerEventList.ON_BONUS_ADDED, ddgame.commands.AddBonusCommand, true);
						
			facade.registerCommand(EventList.MOVE_PLAYER, ddgame.commands.MovePlayerCommand);
			facade.registerCommand(EventList.MOVE_TILE, ddgame.commands.MoveTileCommand);
			facade.registerCommand(EventList.GOTO_MAP, ddgame.commands.ChangeMapCommand);
			facade.registerCommand(EventList.DISPLAY_HOURGLASS, ddgame.commands.DisplayHourglassCommand);
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
			facade.registerProxy(EnvProxy.NAME, new EnvProxy());
			facade.registerProxy(TileFactoryProxy.NAME, new TileFactoryProxy());
			facade.registerProxy(TileTriggersProxy.NAME, new TileTriggersProxy());
			facade.registerProxy(DatamapProxy.NAME, new DatamapProxy());
			facade.registerProxy(ObjectBuilderProxy.NAME, new ObjectBuilderProxy());
			
			// Register Helpers
			facade.registerObserver(IsosceneHelper.NAME, new IsosceneHelper());
			
			// on retrouve la classe skin de l'avatar
			var skinId:int = PlayerProxy(facade.getProxy(ProxyList.PLAYER_PROXY)).skinId;
			var skinClass:String = ConfigProxy.getInstance().data..skin.(@id == skinId)[0];
			facade.registerObserver(PlayerHelper.NAME, new PlayerHelper({className:skinClass}));
		}
		
	}
	
}