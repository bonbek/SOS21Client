/* AS3
	Copyright 2008 toffer.
*/
package ddgame {
	
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import com.sos21.facade.Facade;
	import com.sos21.events.*;
	import com.sos21.proxy.*;
	import ddgame.commands.*;
	import ddgame.proxy.*;
	import ddgame.events.EventList;
	import ddgame.server.IClientServer;
	
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
		
		private static const CHANNEL:EventChannel = new EventChannel(ApplicationChannels.CLIENT_CHANNEL);
		
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
		
		/**
		 * Point d'initialisation de l'application
		 *	@param stage DisplayObjectContainer
		 *	@param clientServer Object
		 *	@param userCredentials Object
		 */
		public function startup (stage:DisplayObjectContainer, clientServer:Object, userCredentials:Object):void
		{
			// Init de l'appli
			sendEvent(new BaseEvent(EventList.APPLICATION_INIT, {documentRoot:stage}));

			// Connection et recup utilisateur
			registerProxy(ProxyList.SERVER_PROXY, clientServer as IClientServer);
			clientServer.config = ConfigProxy.getInstance().getData().mods.services[0];
			clientServer.connect(userCredentials, handleConnection);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception connection / data utilisateur
		 *	@param user Object
		 */
		private function handleConnection (user:Object) : void
		{
			if (user)
			{
				// Démarrage en mode invité / ou utilisateur
				sendEvent(new BaseEvent(user.isGuest 	? EventList.STARTIN_GUEST_MODE
																	: EventList.STARTIN_USER_MODE, user));	
			}
			else {
				sendEvent(new BaseEvent(EventList.APPLICATION_ABORT, {msg:"Vous n'êtes pas un autorisé"}));
			}
			
			unregisterCommand(EventList.APPLICATION_INIT);
			unregisterCommand(EventList.STARTIN_GUEST_MODE);
			unregisterCommand(EventList.STARTIN_USER_MODE);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		override protected function initialize():void
      {
			registerCommand(EventList.APPLICATION_INIT, ddgame.commands.AppInitCommand);
			registerCommand(EventList.APPLICATION_ABORT, ddgame.commands.AppAbortCommand);
			registerCommand(EventList.STARTIN_GUEST_MODE, ddgame.commands.StartupGuestModeCommand);
			registerCommand(EventList.STARTIN_USER_MODE, ddgame.commands.StartupUserModeCommand);
      }
		
	}

}

internal final class PrivateConstructor {}