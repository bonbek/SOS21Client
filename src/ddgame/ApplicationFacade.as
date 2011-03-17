/* AS3
	Copyright 2008 toffer.
*/
package ddgame {
	
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import com.sos21.facade.Facade;
	import com.sos21.events.EventChannelDispatcher;
	import com.sos21.events.EventChannel;
	import com.sos21.events.BaseEvent;
	import ddgame.events.EventList;
	import ddgame.server.events.PublicServerEventList;
	import ddgame.commands.*;
	
	/*
	 *	front controller de l'appli
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ApplicationFacade extends Facade {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private static const CHANNEL:EventChannel = new EventChannel("ddgameChannel");
		
		//--------------------------------------
		//  SINGLETON CONSTRUCTION
		//--------------------------------------
				
		public static function getInstance():ApplicationFacade
		{
			if (!_oI) _oI = new ApplicationFacade(new PrivateConstructor());
			return _oI;
		}
		
		/**
		*	@constructor
		*/
		public function ApplicationFacade(acces:PrivateConstructor)
		{
			super(CHANNEL);
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _oI:ApplicationFacade;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function startup (stage:DisplayObjectContainer, clientServer:Object, userCredentials:Object):void
		{
			sendEvent(new BaseEvent(EventList.APPLICATION_INIT, {documentRoot:stage, clientServer:clientServer, userCredentials:userCredentials}));
			unregisterCommand(EventList.APPLICATION_INIT);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		override protected function initialize():void
      {
			registerCommand(EventList.APPLICATION_INIT, ddgame.commands.AppInitCommand);
			registerCommand(EventList.APPLICATION_STARTUP, ddgame.commands.AppStartupCommand);
			registerCommand(EventList.REFRESH_USER, ddgame.commands.LoadUserCommand);
			registerCommand(PublicServerEventList.ON_USER_LOADED, ddgame.commands.UserInitCommand);
			registerCommand(PublicServerEventList.ON_PLAYER_CREATED, ddgame.commands.PlayerInitCommand);
			registerCommand(PublicServerEventList.ON_PLAYER_LOADED, ddgame.commands.PlayerInitCommand);
      }
		
	}

}

internal final class PrivateConstructor {}