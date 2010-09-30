package ddgame.client.proxy {

	import flash.geom.Matrix;
	import flash.events.Event;	
	import flash.display.*;
	import flash.text.TextField;
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.*;
	import com.sos21.collection.HashMap;
	import com.sos21.lib.GLib;	
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.*;

	import ddgame.client.events.EventList;
	import ddgame.client.proxy.*;

	/**
	 *	CHANGED 2010-07-17 suppression des TileProxy, !! Aucun test sur les bugs
	 * engendrés par cette modif
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  28.02.2008
	 */
	public class TileFactoryProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "tileFactoryProxy";

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------	 
		
		public function TileFactoryProxy(sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var lib:LibProxy;
		private var _tileProxyMap:HashMap /* of AbstractTile/TileProxy */ = new HashMap();
		private var _tileList:Array /* of AbstractTile */ = [];
		public var tileDims:UPoint;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get tileProxyList () : Array /* of TileProxy */
		{
			return _tileProxyMap.toArray();
		}
		
		public function get tileList() : Array /* of AbstractTile */
		{
//			return _tileProxyMap.keyToArray();
			return _tileProxyMap.toArray();
		}

		public function findTileProxy (o:AbstractTile) : TileProxy
		{
			return TileProxy(_tileProxyMap.find(o));
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function clear () : void
		{ _tileProxyMap.clear(); }
				
		// PATCH --
		public function parseTileList (olist:Array /* of Object */) : void
		{
			var n:int = olist.length;
			var aspath:String = ConfigProxy.getInstance().getContent("tiles_path");
			var furl:String;
			var o:Object;
			var dob:Loader;
			var tv:ITileView;
			var tp:TileProxy;
			var t:AbstractTile;
			var sheet:Array;
			while( --n > -1 )
			{
				o = olist[n];
//				var da:Array /* of DisplayObject */ = [];
				
				// on test si tile est un mur ou objet plat dans une dimension
				/*if (o.width < 1 && o.depth > 1) 				// tile plat en x
				{
//					trace("--- mur sur l'axe Y ---");
					createWall(o);
				} else if (o.depth < 1 && o.width > 1) {	// tile plat en y
//					trace("--- mur sur l'axe X ---");
					createWall(o)
				} else if (o.height < 1) { // tile plat en z
//					trace("--- mur sur l'axe Z ---");
				} else {			*/		// tile "normal"
					furl = aspath + String(o.assets[0]);
					
					/*if ("pnj" in o) {
						trace(this, "pnj", o);
						// --> Patch pour scale du pnj
						var dataMapProxy = DatamapProxy(facade.getProxy(DatamapProxy.NAME));
						var factor:Number = dataMapProxy.avatarFactor;
						var tview:MovieClip = MCTileView(component.getView()).asset;
						tview.scaleX = tview.scaleY = factor;
						tview.y = dataMapProxy.tileh / 2;

						// ajout du tile dans la scène
						IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).addAvatar(component);
						component.mouseEnabled = true;
						component.buttonMode = true;
					}*/
					
					// check de l'extension 
//					trace(furl.substring(furl.length - 3, furl.length));

					if (o.pnj)
					{
//						tv = new TileView(dob);
						var cl:Class = lib.lib.getClassFrom(furl, o.title);				
						var mc:MovieClip = new cl();					
						var dataMapProxy:DatamapProxy = DatamapProxy(facade.getProxy(DatamapProxy.NAME));
						var factor:Number = dataMapProxy.avatarFactor;
						mc.scaleX = mc.scaleY = factor;
						mc.y = dataMapProxy.tileh / 2;
						tv = new MCTileView(MovieClip(mc));
					}
					else if (o.sheet)
					{
						trace(this, "HAS SHEET", o.sheet);
						// serialisé sous forme :
						// frameWidth:frameHeight:label:nframes:nrotations:label:nframes:nrotations...
//						dob = lib.lib.getLoader(aspath + String(o.assets[0]));
						dob = lib.getTileAsset(o.assets[0]);
//						trace(this, dob);
//						trace(this, dob.content);
//						var bitmapdata:BitmapData = new BitmapData(dob.content.width, dob.content.height, true, 0);
//						var bitmp:Bitmap = new Bitmap(bitmapdata);
//						bitmapdata.draw(dob);
//						continue;
						sheet = o.sheet.split(":");
						sheet.unshift(o.ofsY);
						sheet.unshift(o.ofsX);
						tv = new AnimatedTileView(dob.content, sheet);
//						dob.x = o.ofsX;
//						dob.y = o.ofsY;
					} else {
						dob = lib.lib.getLoader(aspath + String(o.assets[0]));
						tv = new TileView(dob);
						dob.x = o.ofsX;
						dob.y = o.ofsY;						
					}
					
					t = new AbstractTile (String(o.id),new UPoint(o.pos.x, o.pos.y, o.pos.z, tileDims.xFactor, tileDims.yFactor, tileDims.zFactor), tv);
					t.rotation = o.pos.r;
					// patch pnj
					t.gotoAndStop("stand");
					t.setFrame(o.pos.f);
					t.upos.width = o.width;
					t.upos.height = o.height;
					t.upos.depth = o.depth;
					t.name = o.title;
//					tp = new TileProxy(o, t);
//					if (!registerTile(tp))
//						sendEvent(new BaseEvent(EventList.TILEFACTORY_PARSE_ERROR, tp.tile));
					if (!registerTile(t))
						sendEvent(new BaseEvent(EventList.TILEFACTORY_PARSE_ERROR, t));
//				}
			}

			sendEvent(new BaseEvent(EventList.TILEFACTORY_TILELIST_PARSED, tileList));
		}
		
		public function createWall( o:Object) : AbstractTile
		{			
			var aspath:String = ConfigProxy.getInstance().getContent("tiles_path");

			var dob:Loader = lib.getTileAsset(o.assets[0]);
			var bitmapdata:BitmapData = new BitmapData(dob.content.width, dob.content.height, true, 0);
			var mtx:Matrix = new Matrix();
			var bounds:Object = dob.getBounds(dob);
			mtx.translate(-bounds.left, -bounds.top);
			bitmapdata.draw(dob, mtx);

			var wwidth:int;	// largeur morceau mur en x
			var wdepth:int;	// largeur morceau mur en y
			var wl:int;			// "longeur" du mur (en x ou y)
			var ofsY:Number;	// décalage bit
			if (o.depth > 0) 
			{
				wwidth = 0;
				wdepth = 1;
				wl = o.depth;
			} else {
				wwidth = 1;
				wdepth = 0;
				wl = o.width;		
			}
			
			var owner:AbstractTile;
			var t:AbstractTile;
			var sid:String;
			var m:Matrix = new Matrix();
			for (var i:int = 0; i < wl; i++) {
				m.identity();

				var sp:Sprite = new Sprite();
				if (wwidth) {
					m.translate(-(i * 30), 0);
				} else {
					m.translate(((i+1) * 30), 0);
					sp.x = -30;
				}

				sp.graphics.beginBitmapFill(bitmapdata, m, true);
        		sp.graphics.drawRect(0, 0, 30, dob.content.height);
          	sp.graphics.endFill();
				sp.y = bounds.top - (i*15);

				var up:UPoint = new UPoint(Number(o.pos.x) + (i * wwidth), Number(o.pos.y) + (i * wdepth), o.pos.z, tileDims.xFactor, tileDims.yFactor, tileDims.zFactor);
				up.width = wwidth;
				up.depth = wdepth;
				
				if (i > 0)
				{
//					sid = "_w_" + o.id + "_" + i;
					sid = o.id + "_" + i;	
					t = new AbstractTile(sid, up, new TileView(sp));
					t.groupWith(owner);
				} else {
//					sid = "_w_" + o.id;
					sid = o.id;
					t = new AbstractTile(sid, up, new TileView(sp));
					owner = t;
				}
				
				t.name = o.title
				
//				var sid:String = i > 0 ? "_w_" + o.id + "-" + i : "_w_" + o.id;

//				var t:AbstractTile = new AbstractTile(sid, up, new TileView(sp));
				
				/*var tp:TileProxy = new TileProxy(o, t);
				if (!registerTile(tp))
					sendEvent(new BaseEvent(EventList.TILEFACTORY_PARSE_ERROR, tp.tile));				*/
				
				if (!registerTile(t))
					sendEvent(new BaseEvent(EventList.TILEFACTORY_PARSE_ERROR, t));				
			}
			return owner;
		}
		
		
/*		public function parseTile(o:Object):void
		{
			var tp:TileProxy = _parseTileAndProxy(o);
			if (registerTile(tp))
				sendEvent(new BaseEvent(EventList.TILEFACTORY_TILE_PARSED, tp.tile));
			else
				sendEvent(new BaseEvent(EventList.TILEFACTORY_PARSE_ERROR, tp.tile));
		} */
		

		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/*private function registerTile(tp:TileProxy):Boolean
		{
			if (_tileProxyMap.insert(tp.tile, tp))
				return true;
				
			trace("can't register tile -> " + tp.tile.toString() + " " + toString());
			return false;
		}*/
		
		private function registerTile (t:AbstractTile) : Boolean
		{
			if (_tileProxyMap.insert(t.ID, t))
				return true;
				
			trace("can't register tile -> " + t.toString() + " " + toString());
			return false;
		}
			
		/**
		 * Called by ClientFacade
		 */
		override public function initialize():void
		{
				// Cache reference to GLib
			lib = LibProxy(facade.getProxy(LibProxy.NAME));
		}
		
	}
	
}
