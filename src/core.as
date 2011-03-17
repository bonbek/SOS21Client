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
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		public function core ()
		{
			super();
		}

		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------

		private var _facade:ApplicationFacade;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Point de lancement de l'application
		 *	@param config XML		configuration de l'application
		 * @param clientServer	module IClientServer
		 *	@param credentials 	Object identifiants utilisateur loggé (email et mot de passe encrypté)
		 */
		public function startup (config:XML, clientServer:Object, userCredentials:Object = null) : void
		{
			ConfigProxy.getInstance().setData(config);
			_facade = ApplicationFacade.getInstance();
			_facade.startup(this, clientServer, userCredentials ? userCredentials : {login:"guest", password:"35675e68f4b5af7b995d9205ad0fc43842f16450"});
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
		
	}
	
}
