package ddgame.proxy {

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
	import ddgame.scene.PNJHelper;

	import ddgame.events.EventList;
	import ddgame.proxy.*;

	/**
	 *	Factory créatrice des tiles
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
		
		public static const NAME:String = ProxyList.TILEFACTORY_PROXY;

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
		public var tileDims:UPoint;
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function clear () : void
		{ }
			
		/**
		 * Construit les tiles définis par les descripteurs
		 *	@param olist Array liste des data descripteurs
		 */
		public function parseTileList (olist:Array) : void
		{
			var tileList:Array = [];
			var n:int = olist.length;
			var aspath:String = ConfigProxy.getInstance().getContent("tiles_path");
			var furl:String;
			var o:Object;
			var dob:Loader;
			var tv:ITileView;
			var t:AbstractTile;
			var sheet:Array;
			while( --n > -1 )
			{
				o = olist[n];
			
				furl = aspath + String(o.assets[0]);

				if (int(o.pnj) > 0)
				{
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
					dob = lib.getTileAsset(o.assets[0]);
					sheet = o.sheet.split(":");
					sheet.unshift(o.ofsY);
					sheet.unshift(o.ofsX);
					tv = new AnimatedTileView(dob.content, sheet);
				} else {
					dob = lib.lib.getLoader(aspath + String(o.assets[0]));
					tv = new TileView(dob);
					dob.x = o.ofsX;
					dob.y = o.ofsY;						
				}
				
				t = new AbstractTile (String(o.id),new UPoint(o.pos.x, o.pos.y, o.pos.z, tileDims.xFactor, tileDims.yFactor, tileDims.zFactor), tv);
				t.data = o;
				t.rotation = o.pos.r;
				
				// patch pnj
				t.gotoAndStop("stand");
				t.setFrame(o.pos.f);
				t.upos.width = o.width;
				t.upos.height = o.height;
				t.upos.depth = o.depth;
				t.name = o.title;
				
				// tile caché
				if (o.hi) t.visible = false;
				
				tileList.push(t);
			}

			sendEvent(new BaseEvent(EventList.TILEFACTORY_TILELIST_PARSED, tileList));
		}
						
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
			
		/**
		 * @inheritDoc
		 */
		override public function initialize () : void
		{
			// Cache reference to GLib
			lib = LibProxy(facade.getProxy(LibProxy.NAME));
		}
		
	}
	
}
