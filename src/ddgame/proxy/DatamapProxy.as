/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.proxy {
	import flash.events.Event;
	import flash.display.DisplayObject;	
	import com.sos21.debug.log;
	import com.sos21.collection.TypedGrid;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.proxy.ConfigProxy;
	import com.sos21.lib.GLib;	
	import com.sos21.tileengine.structures.UPoint;
	import ddgame.events.EventList;
	import ddgame.proxy.LibProxy;
	import ddgame.proxy.CollisionGridProxy;
	import ddgame.proxy.TileFactoryProxy;
	import ddgame.proxy.TileTriggersProxy;
	import ddgame.proxy.ProxyList;

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
		private var collisionGridProxy:CollisionGridProxy;
		public var externalTriggers:Array;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get collisionGrid():TypedGrid
		{ return collisionGridProxy.grid; }
		
		public function get tileList():Array
		{ return _data.objects; }
		
		public function get title():String
		{ return _data.title; }
		
		public function get ambientSoundFile():String
		{ return _data.music; }
		
		public function get foregroundFile () : String
		{ return _data.foreground; }
		
		public function get backgroundFile ():String
		{ return _data.background; }
		
		public function get entryPoint () : UPoint
		{ return _entryPoint; }
				
		public function get dimx () : int
		{ return _data.cellsNumber.x; }
		
		public function get dimy () :int
		{ return _data.cellsNumber.y; }
		
		public function get dimz () : int
		{ return _data.cellsNumber.z; }
		
		public function get tilew () : int
		{ return _data.cellsSize.width; }
		
		public function get tileh () : int
		{ return _data.cellsSize.height; }
		
		public function get tiled () : int
		{ return _data.cellsSize.depth; }
		
		public function get sceneOffsetX () : int
		{ return _data.camera.xOffset; }
		
		public function get sceneOffsetY () : int
		{ return _data.camera.yOffset; }
		
		public function get avatarFactor () : Number
		{ return _data.scaleFactor; }
		
		public function get enableNoMouseEventInAlpha () : Boolean
		{ return true; }
		
		public function get location () : Object
		{
			return _data.location	? _data.location
											: {adress:"",lat:0, lon:0};
		}
		
		public function get env () : Array
		{ return _data.variables ? _data.variables : []; }
		
		public function set data (value:Object):void
		{
			if (_data)
				_lastMapId = _data.id;

			_data = value;
		}
		
		/**
		 * Retourne l'identifiant de la map
		 */
		public function get mapId ():int
		{ return _data.id; }
		
		/**
		 * Retourne l'identifiant de la dernière map
		 * visitée
		 */
		public function get lastMapId ():int
		{ return _lastMapId; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function parseData():void
		{
			
			parseEntryPoint();
			
			collisionGridProxy.resetGrid(dimx, dimy, dimz);
			
			// désérialisation des triggers
			tileTriggersProxy.parse(_data.actions);

			collisionGridProxy.parse(_data.collisions);
			
			tileFactoryProxy.clear();
			tileFactoryProxy.tileDims = new UPoint (0, 0, 0, tilew, tileh, tiled);
			tileFactoryProxy.parseTileList(_data.objects);
			
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
			var p:Object = _data.entrance;
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
			tileFactoryProxy = TileFactoryProxy(facade.getProxy(TileFactoryProxy.NAME));
			tileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
		}

	}
	
}
