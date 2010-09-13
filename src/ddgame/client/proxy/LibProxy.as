package ddgame.client.proxy {
	
	import flash.events.Event;
	import flash.display.Loader;
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.lib.GLib;
	import com.sos21.lib.GLibEvent;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.client.proxy.DatamapProxy;
	import ddgame.client.events.PublicIsoworldEventList;
	import ddgame.client.events.EventList;
	import ddgame.client.proxy.ProxyList;
	import com.sos21.debug.log;
	
	/**
	 *	Proxy librairie des fichiers ressources
	 *	chargement en masse des fichiers
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class LibProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = ProxyList.LIB_PROXY;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function LibProxy(sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _lib:GLib = new GLib();
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
	
		public var tilesPath:String;	// chemin racine bibliotheque des tiles
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		/**
		 * Additional getter to return the correct data type
		 */
		public function get lib():GLib
		{
			return _lib;
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Ajoute un fichier à charger à la librairie
		 *	@param	url	 url du fichier
		 */
		public function createLoader(url:String, forceBinary:Boolean = false):void
		{
			_lib.addFile(url, forceBinary);
		}
		
		/**
		 *	Ajoute un loader de ressource graphique pour tile
		 *	@param	url	 url de la ressource
		 */
		public function addTileAssetLoader (file:String, forceBinary:Boolean = true):void
		{
			_lib.addFile(tilesPath + file, forceBinary);
		}

		/**
		 *	Retourne un IGloader
		 *	@param	url	 url de la ressource
		 */		
		public function getIGLoader (file:String):Object
		{
			return _lib.getGLoader(file);
		}
		
		/**
		 *	Retourne un loader de ressource graphique pour tile
		 *	@param	url	 url de la ressource
		 */
		public function getTileAsset (file:String):Loader
		{
			return _lib.getLoader(tilesPath + file);
		}
		
		/**
		 *	Retourne une définition de classe
		 *	@param	url	 url du fichier ressource
		 *	@param	name	 nom de la définition
		 */
		public function getDefinitionFrom(file:String, name:String):Class
		{
			return _lib.getClassFrom(file, name);
		}
		
		/**
		 *	Lance le chargement
		 */
		public function load():void
		{
			// TODO Gestion erreur sur le chargement de la lib
			_lib.addEventListener(GLibEvent.ON_LIB_COMPLETE, glibHandler, false, 0, true);
			_lib.addEventListener(GLibEvent.ON_PROGRESS, glibHandler, false, 0, true);
			_lib.load();
			sendPublicEvent(new Event(PublicIsoworldEventList.GFXLIB_UPDATESTART));
		}
		
		/**
		 *	Efface toutes les références (chargées ou non)
		 */
		public function clear():void
		{
			_lib.clear();
		}
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Reception des events progression du chargement
		 */
		private function glibHandler(event:GLibEvent):void
		{
			switch (event.type)
			{
				case GLibEvent.ON_PROGRESS :
				{
					sendPublicEvent(new BaseEvent(PublicIsoworldEventList.GFXLIB_PROGRESS, int(event.bytesLoaded / event.bytesTotal * 100)));
					break;
				}
				case GLibEvent.ON_LIB_COMPLETE :
				{
					trace("-- Lib complete @" + toString());
					_lib.removeEventListener(GLibEvent.ON_LIB_COMPLETE, glibHandler);
					_lib.removeEventListener(GLibEvent.ON_PROGRESS, glibHandler);

					sendPublicEvent(new Event(PublicIsoworldEventList.GFXLIB_COMPLETE));
					break;
				}
			}
		}
						
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		override public function initialize():void
		{
			tilesPath = ConfigProxy.getInstance().getContent("tiles_path");
		}

	}
	
}
