/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.server.proxy {
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import org.as3yaml.YAML;
//	import dupin.parsers.yaml.YAML;	
	
	import com.sos21.debug.log;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.net.Service;
	import com.sos21.net.ServiceCall;
	import com.sos21.net.ServiceEvent;
	import com.sos21.events.BaseEvent;

	import ddgame.server.events.PublicServerEventList;
	import ddgame.server.proxy.DataParserProxy;
	
	/**
	 *	Remoting amf php
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class RemotingProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "remotingProxy";
		
		public static var dataMapCall:ServiceCall = new ServiceCall("loadMap");
		public static var dataQuizCall:ServiceCall = new ServiceCall("getQuiz");
		public static var mapListCall:ServiceCall = new ServiceCall("getMapList");
		public static var dataContentCall:ServiceCall = new ServiceCall("getContent");
		public static var saveDataContentCall:ServiceCall = new ServiceCall("saveContent");
		public static var userDataCall:ServiceCall = new ServiceCall("getUserData");
		public static var updateUserCall:ServiceCall = new ServiceCall("updateUser");
		public static var createPlayerCall:ServiceCall = new ServiceCall("createPlayer");
		public static var playerDataCall:ServiceCall = new ServiceCall("getPlayerData");
		public static var updatePlayerCall:ServiceCall = new ServiceCall("updatePlayer");
		public static var playerBonusCall:ServiceCall = new ServiceCall("playerBonus");
		public static var triggerExecutedCall:ServiceCall = new ServiceCall("triggerExecuted");
		public static var playerEnvCall:ServiceCall = new ServiceCall("playerEnv");
		public static var globalsCall:ServiceCall = new ServiceCall("Globals");
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function RemotingProxy()
		{
			super(NAME);
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _service:Service = new Service();
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get service () : Service
		{ return _service; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function getMapList():void
		{
			_service.callService(mapListCall);
		}
		
		public function getDataMap(nid:int, entryPoint:String, removeTriggers:String) : void
		{			
			_service.callService(dataMapCall, nid, entryPoint, removeTriggers);
		}
		
		public function getDataQuiz (nid:int) : void
		{
			_service.callService(dataQuizCall, nid);
		}
		
		public function getDataContent (nid:int) : void
		{
			_service.callService(dataContentCall, nid);
		}
		
		public function saveDataContent (nid:int, data:String) : void
		{
			_service.callService(saveDataContentCall, nid, data);
		}
		
		/**
		 * Lance le chargement des données d'un utilisateur
		 *	@param semail String			email de connection
		 *	@param spassword String		mot de passe encrypté
		 */
		public function getUserData (semail:String, sencPassword:String) : void
		{
			_service.callService(userDataCall, semail, sencPassword, true);
		}
		
		/**
		 * Mise à jour des data utilisateur
		 *	@param oUpdate Object propritées à mettre à jour ex: {username:"bob", }
		 */
		public function updateUser (userId:int, oUpdate:Object):void
		{
			_service.callService(updateUserCall, oUpdate);
		}
		
		/**
		 * Ajout de bonus au pour le joueur
		 *	@param bonus Object
		 */
		public function updatePlayer (playerId:int, props:Object) : void
		{
			_service.callService(updatePlayerCall, playerId, props);
		}
		
		/**
		 * Crée un nouveau joueur pour un utilisateur
		 *	@param userId int
		 *	@param dataPlayer Object
		 *	@param autoLink Boolean
		 */
		public function createPlayer (userId:int, dataPlayer:Object = null, autoLink:Boolean = true):void
		{
			_service.callService(createPlayerCall, userId, dataPlayer, autoLink);
		}
		
		/**
		 * Lance la récup des data d'un joueur
		 *	@param playerId int
		 */
		public function getPlayerData (playerId:int):void
		{
			_service.callService(playerDataCall, playerId);
		}
		
		// TEMP
		public function playerBonus (bonus:Object):void
		{
			_service.callService(playerBonusCall, bonus);
		}
		
		public function triggerExecuted (mapId:int, triggerId:int) : void
		{
			_service.callService(triggerExecutedCall, mapId, triggerId);
		}
		
		public function playerEnv (domain:String, key:String, value:*) : void 
		{
			_service.callService(playerEnvCall, domain, key, value);
		}
		
		public function Globals (operation:String, params:Object = null) : ServiceCall
		{
			_service.callService(globalsCall, operation, params);

			return globalsCall;
		}
		
		public function connect (gatewayURL:String, credentials:Object = null):void
		{
			_service.connect(gatewayURL);
			
			if (credentials)
				setCredentials(credentials.login, credentials.password);
			else
				setCredentials("lapin", "bleu");
		}
		
		public function setCredentials(login:String, password:String):void
		{
			_service.setCredentials(login, password);
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function mapLoaderHandler(event:Event):void
		{
			var yamlMap : Dictionary = YAML.decode(event.target.data) as Dictionary;
			sendPublicEvent(new BaseEvent(PublicServerEventList.ON_DATAMAP, yamlMap));
		}
		
		private function handleServiceCall (event:ServiceEvent) : void
		{
			var sc:ServiceCall = event.serviceCall;
//			removeServiceListener(sc);
			
			if (event.failed)
			{
				trace("ServiceCall [" + event.serviceCall.method + "] failed: " + event.error);
				return;
			}
			
			// TODO dispatcher erreur pour éviter freeze de l'application
			
//			trace("-- data reçues @" + this);
			
//			var o:Object = event.result;
//			for each(var so:Object in o)
//				trace(so);
			
			switch (sc)
			{
				case mapListCall :
				{
					sendPublicEvent(new BaseEvent(PublicServerEventList.ON_MAPLIST, event.result));
					break;
				}
				case dataMapCall :
				{
					var yamlMap : Dictionary = YAML.decode(String(event.result)) as Dictionary;
					sendPublicEvent(new BaseEvent(PublicServerEventList.ON_DATAMAP, yamlMap));
//					sendPublicEvent(new BaseEvent(PublicServerEventList.ON_DATAMAP, event.result));
					break;
				}
				case dataQuizCall :
				{
//					trace(event.result);
					sendPublicEvent(new BaseEvent(PublicServerEventList.ON_DATAQUIZ, event.result));
					break;
				}
				case dataContentCall :
				{
					sendPublicEvent(new BaseEvent(PublicServerEventList.ON_DATACONTENT, event.result));
					break;
				}
				case saveDataContentCall :
				{
					sendPublicEvent(new BaseEvent(PublicServerEventList.ON_DATACONTENT, event.result));
					break;
				}
				case userDataCall :
				{
					sendEvent(new BaseEvent(PublicServerEventList.ON_USER_LOADED, event.result));
					break;
				}
				case createPlayerCall :
				{
					sendEvent(new BaseEvent(PublicServerEventList.ON_PLAYER_CREATED, event.result));
					break;
				}
				case playerDataCall :
				{
					sendEvent(new BaseEvent(PublicServerEventList.ON_PLAYER_LOADED, event.result));
					break;
				}
				case playerBonusCall :
				{
					sendEvent(new BaseEvent(PublicServerEventList.ON_BONUS_ADDED, event.result));
					break;
				}
				default :
				{
					trace(name + ": no matching ServiceCal");
					break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function addServiceListener (sc:ServiceCall) : void
		{
			_service.addServiceListener(sc, handleServiceCall, false, 0, true);
		}
		
		private function removeServiceListener (sc:ServiceCall) : void
		{
			_service.removeServiceListener(sc, handleServiceCall);
		}
		
		override public function initialize():void
		{
				// Services
			_service.service = "sos21Services";
			addServiceListener(dataMapCall);
			addServiceListener(dataQuizCall);
			addServiceListener(dataContentCall);			
			addServiceListener(saveDataContentCall);			
			addServiceListener(userDataCall);			
			addServiceListener(updateUserCall);			
			addServiceListener(updatePlayerCall);			
			addServiceListener(createPlayerCall);			
			addServiceListener(playerDataCall);			
			addServiceListener(playerBonusCall);			
		}
		
	}
	
}
