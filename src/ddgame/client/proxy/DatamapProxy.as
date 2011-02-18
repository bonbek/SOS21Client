/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.proxy {
	import flash.events.Event;
	import flash.display.DisplayObject;	
	import com.sos21.debug.log;
	import com.sos21.collection.TypedGrid;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.proxy.ConfigProxy;
	import com.sos21.lib.GLib;	
	import com.sos21.tileengine.structures.UPoint;
	import ddgame.client.events.EventList;
	import ddgame.client.proxy.LibProxy;
	import ddgame.client.proxy.CollisionGridProxy;
	import ddgame.client.proxy.TileFactoryProxy;
	import ddgame.client.proxy.TileTriggersProxy;
	import ddgame.client.proxy.ProxyList;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  22.02.2008
	 */
	public class DatamapProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = ProxyList.DATAMAP_PROXY;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function DatamapProxy(sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _entryPoint:UPoint;
		private var _lastMapId:int = -100;
		private var tileFactoryProxy:TileFactoryProxy;
		private var tileTriggersProxy:TileTriggersProxy;
		private var tileGridProxy:TileGridProxy;
		private var collisionGridProxy:CollisionGridProxy;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get externalTriggers():Array
		{
			return _data.externalTriggers;
		}
		
		public function get collisionGrid():TypedGrid
		{
			return collisionGridProxy.grid;
		}
		
		public function get tileGrid():TypedGrid
		{
			return tileGridProxy.grid;
		}
		
		public function get tileList():Array
		{
			return _data.tileList;
		}
		
		public function get title():String
		{
			return _data.title;
		}
		
		public function get ambientSoundFile():String {
			return _data.ambientSound;
		}
		
		public function get foregroundFile():String {
			return _data.foregroundFile;
		}
		
		public function get backgroundFile():String {
			return _data.backgroundFile;
		}
		
		public function get entryPoint():UPoint {
			return _entryPoint;
		}
				
		public function get dimx():int {
			return _data.dimx;
		}
		
		public function get dimy():int {
			return _data.dimy;
		}
		
		public function get dimz():int {
			return _data.dimz;
		}
		
		public function get tilew():int {
			return _data.tilew;
		}
		
		public function get tileh():int {
			return _data.tileh;
		}
		
		public function get tiled():int {
			return _data.tileh;
		}
		
		public function get sceneOffsetX () : Number {
			return ("sceneOffsetX" in _data) ? _data.sceneOffsetX : 0;
		}
		
		public function get sceneOffsetY () : Number {
			return ("sceneOffsetY" in _data) ? _data.sceneOffsetY : 0;
		}
		
		public function get avatarFactor():Number {
			return _data.avatarFactor;
		}
		
		public function get enableNoMouseEventInAlpha():Boolean {
			if (_data.hasOwnProperty("enableNoMouseEventInAlpha"))
				return _data.enableNoMouseEventInAlpha;
			
			return true;
		}
		
		public function get location () : Object {
			return ("location" in _data) ? _data.location : {adress:"",lat:0,lon:0};
		}
		
		public function get env () : Array
		{ return ("env" in _data) ? _data.env : []; }
		
		public function set data (value:Object):void {
			if (_data)
			{
				_lastMapId = _data.id;
			}
			_data = value;
		}
		
		/**
		 * Retourne l'identifiant de la map
		 */
		public function get mapId ():int
		{
			return _data.id;
		}
		
		/**
		 * Retourne l'identifiant de la dernière map
		 * visitée
		 */
		public function get lastMapId ():int
		{
			return _lastMapId;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function parseData():void
		{
			
			parseEntryPoint();
			
			collisionGridProxy.resetGrid(dimx, dimy, dimz);
			
			// désérialisation des triggers
			tileTriggersProxy.parse(_data.triggers);
			
			tileGridProxy.resetGrid(dimx, dimy, dimz);
			collisionGridProxy.parse(_data.collisions);
			
			tileFactoryProxy.clear();
			tileFactoryProxy.tileDims = new UPoint (0, 0, 0, tilew, tileh, tiled);
			tileFactoryProxy.parseTileList(_data.tileList);
			
			sendEvent(new Event(EventList.DATAMAP_PARSED));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/*
		*	Parse the entry point of the map for Avatar / player placement
		*/
		private function parseEntryPoint():void
		{
			var p:Object = _data.entryPoint;
			_entryPoint = new UPoint(p.x, p.y, p.z);
		}
		
		/**
		 * Initialize Grids proxys
		 *	Cache references to TileFactoryProxy & TileTriggersProxy;
		 */
		override public function initialize():void
		{
			collisionGridProxy = new CollisionGridProxy();
			facade.registerProxy(CollisionGridProxy.NAME, collisionGridProxy);
			tileGridProxy = new TileGridProxy();
			facade.registerProxy(TileGridProxy.NAME, tileGridProxy);
			tileFactoryProxy = TileFactoryProxy(facade.getProxy(TileFactoryProxy.NAME));
			tileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
		}

	}
	
}
