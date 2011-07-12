package ddgame.events {
	
	/**
	 *	Liste des events de l'application
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class EventList {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		// Application
		public static const APPLICATION_INIT:String = "ddgInit";
		public static const APPLICATION_ABORT:String = "ddgAbort";
		public static const STARTIN_GUEST_MODE:String = "ddgStartGuest";
		public static const STARTIN_USER_MODE:String = "ddgStartUser";
		public static const APPLICATION_STARTUP : String = "ddgStartupEvt";
		
		// PlayerProxy
				
		// reprise ddgame.client.events.ISOSCENE_BUILDED:String;
		public static const SCENE_BUILDED:String = "iscBuilded";
		
		// @ PlayerProxy
		public static const PLAYER_LOAD_ERROR:String = "playerLoadError";
		public static const PLAYER_LOADED:String = "playerLoaded";
		// > Hausse du niveau
		public static const PLAYER_LEVEL_UP:String = "playerLevelUp";
		// > Baisse du niveau
		public static const PLAYER_LEVEL_DOWN:String = "playerLevelUp";
		// > Les points on été modifiés
		public static const PLAYER_BONUS_CHANGED:String = "playerBonusChange";
		// > Gain de points
		public static const PLAYER_BONUS_GAIN:String = "playerBonusGain";
		// > Perte de points
		public static const PLAYER_BONUS_LOSS:String = "playerBonusLoss";
		
		// dispatcher par AudioHelper à l'évenement sur l'objet music
		public static const MUSIC_EVENT:String = "amusicEvent";
		// dispatcher par AudioHelper à l'évenement sur un objet son
		public static const SOUND_EVENT:String = "asoundEvent";

		// ouverture map de déplacement
		public static const OPEN_MAPSCREEN:String = "openMapScreen";
		
		public static const ISOWORLD_INIT:String = "isoworldInit";
		
			// send by DatamapProxy
		public static const DATAMAP_PARSED:String = "datamapParsed";
		
			// send by CollisionGridProxy
		public static const COLLISIONGRID_PARSED:String = "collisionGridParsed";
		
			// send by TileFactoryProxy
		public static const TILEFACTORY_TILELIST_PARSED:String = "tFactoryTilelistParsed";
		public static const TILEFACTORY_TILE_PARSED:String = "tFactoryTileParsed";
		public static const TILEFACTORY_PARSE_ERROR:String = "tFactoryParseError"
		
			// send by IsosceneHelper ClickTileCommand
		public static const ISOSCENE_BUILDED:String = "iscBuilded";
		public static const ISOSCENE_TILE_ADDED:String = "iscTileAdded";
		public static const MOVE_PLAYER:String = "movePlayer";		
		public static const MOVE_TILE:String = "moveTile";
		
		// send by PlayerProxy
		public static const PLAYER_SKIN_CHANGED:String = "playerSkinChanged";

			// send by PlayerHelper
		public static const PLAYER_MOVE_COMPLETE:String = "playerMoveComplete";
		public static const PLAYER_MOVE:String = "playerMove";
		public static const PLAYER_LEAVE_CELL:String = "playerLeaveCell";
		public static const PLAYER_ENTER_CELL:String = "playerEnterCell";
		
		public static const GOTO_MAP:String = "gotoMap";
		public static const CLEAR_MAP:String = "clearMap";
		
		public static const FREEZE_SCENE:String = "freezeScene";
		public static const UNFREEZE_SCENE:String = "unfreezeScene";
		public static const DISPLAY_HOURGLASS:String = "displayHourglass";
		
		public static const ADD_BONUS:String = "addBonus";
		public static const WRITE_ENV:String = "writeEnv";
		
		public static const LAUNCH_TRIGGER:String = "launchTrigger";
		
		public static const PLAY_SOUND:String = "playSound";
		public static const STOP_SOUND:String = "stopSound";
		public static const PLAYSTOP_SOUND:String = "playStopSound";
		
		public static const INJECT_TRIGGER:String = "injectTrigger";
		public static const INJECT_TRIGGERARGS:String = "injectTriggerArgs";
		
		// dispatché avant chaque éxecution d'un noeud ia des pnj
		public static const PNJ_FIRETRIGGER:String = "pnjFireTrigger";
		// dispatché au click sur des liens dans les ballon des pnj
		public static const PNJ_BALLONEVENT:String = "pnjBallonEvent";
		public static const PNJ_BALLON_LINKCLICKED:String = "pnjBallonLinkClicked";
		public static const PNJ_BALLON_CLOSED:String = "pnjBallonClose";
		
			// send by LibProxy
		public static const GFXLIB_UPDATESTART:String = "gfxLibUpdateStart";
		public static const GFXLIB_PROGRESS:String = "gfxlibProgress";
		public static const GFXLIB_COMPLETE:String = "gfxlibComplete";
		
	}
	
}
