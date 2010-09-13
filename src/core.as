/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package {
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	import com.sos21.facade.Facade;
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.ApplicationChannels;
	import ddgame.ApplicationFacade;
	import ddgame.events.EventList;
	import com.sos21.events.BaseEvent;
	
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.ITileView;
	import com.sos21.tileengine.display.TileView;
	import com.sos21.tileengine.structures.CollisionCell;
	
	/**
	 *	Point d'entrée de l'application
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	[SWF(width="980", height="576", backgroundColor="#000000", frameRate=25)]

	public class core extends Sprite {
		
		/**
		 *	@Constructor
		 */
		public function core ()
		{
			super();
			// addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		private var _facade:ApplicationFacade;
		
//		private var userIds:Object;		// identifiants de l'utilisateur connecté
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		public function setConfig (val:XML):void
		{
			// mise à jour du xml de configuration en function des params
			// passés au swf
			// >> Effectué depuis le loader.swf
/*
			var flashVars:Object = root.loaderInfo.parameters;
			for (var key:String in flashVars)
			{
				if (key == "mapId")
				{
					val["maptoload"][0].attribute("force")[0] = 1;
					val["maptoload"][0] = flashVars[key];
				}					

				if (key == "entryPoint")
					val["entryPoint"][0] = flashVars[key];

				if (key == "debug")
					val["debug"][0] = flashVars[key];

				if (key == "spy")
					val["spy"][0] = flashVars[key];
			}
*/
			// passage du xml qu proxy configuration
			ConfigProxy.getInstance().setData(val);
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Point de lancement de l'application
		 *	@param config XML				configuration de l'application
		 *	@param credentials Object identifiants utilisateur loggé (email et mot de passe encrypté)
		 */
		public function startup (config:XML, userCredentials:Object = null):void
		{
			setConfig(config);
			_facade = ApplicationFacade.getInstance();
			_facade.startup(this, userCredentials ? userCredentials : {login:"guest", password:"35675e68f4b5af7b995d9205ad0fc43842f16450"});
			
			// patch editeur
			dispatchEvent(new Event("applicationInitialized"));
		}
		
		
		
		// ######## Pour editeur (flex kk) ##########
		
		public function get facade () : ApplicationFacade {
			return _facade;
		}
		
		public function get clientFacade():ApplicationFacade {
			return _facade;
		}
		
		public function get serverFacade():ApplicationFacade {
			return _facade;
		}
		
		public function sendBaseEvent (type:String, data:Object):void
		{
			facade.sendEvent(new BaseEvent(type, data));
		}
	
		public function createUPoint(	nxu:Number = 0, nyu:Number = 0, nzu:Number = 0, nxFactor:Number = 0, nyFactor:Number = 0, nzFactor:Number = 0,
												nxoffset:Number = 0, nyoffset:Number = 0, nzoffset:Number = 0, nzindex:int = 0 ):UPoint
		{
			return new UPoint(	nxu, nyu, nzu, nxFactor, nyFactor, nzFactor,
										nxoffset, nyoffset, nzoffset, nzindex );
		}
		
		public function createTileView(asset:DisplayObject = null):ITileView {
			return new TileView(asset);
		}
		
		public function createAbstractTile(id:String, p:UPoint = null, view:ITileView = null):AbstractTile {
			return new AbstractTile(id, p, view);
		}
		
		public function createCollisionCell(val:int = 0, cost:int = 0):CollisionCell
		{
			return new CollisionCell(val, cost);
		}
		
		// ----------------------------------
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		private function onConfigLoaded(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, onConfigLoaded);			
			startup(new XML(event.currentTarget.data));
			// patch editeur
			dispatchEvent(new Event("applicationInitialized"));
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			if (_facade)
				return;
			
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, onConfigLoaded, false, 0, true);
			l.load(new URLRequest("config.xml"));
		}
		
	}
	
}
