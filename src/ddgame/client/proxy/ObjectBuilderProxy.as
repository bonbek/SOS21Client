package ddgame.client.proxy {
	
	import com.sos21.proxy.AbstractProxy;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import ddgame.client.view.PNJHelper;
	import com.sos21.tileengine.display.MCTileView;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.TileView;
	import com.sos21.tileengine.display.ITileView;
	import ddgame.client.proxy.ProxyList;
	import com.sos21.tileengine.structures.UPoint;
	
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  01.09.2009
	 */
	public class ObjectBuilderProxy extends AbstractProxy {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		public static const NAME:String = ProxyList.OBJECTBUILDER_PROXY;
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function ObjectBuilderProxy()
		{
			super(NAME);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@param x Number
		 *	@param y Number
		 *	@param z Number
		 *	@return UPoint
		 */
		public function createUPoint(x:Number = 0, y:Number = 0, z:Number = 0):UPoint
		{
			return new UPoint(x, y, z);
		}
		
		/**
		 *	@param dob DisplayObject
		 *	@return TileView
		 */
		public function createTileView(dob:DisplayObject = null):TileView
		{
			return new TileView(dob);
		}
		
		/**
		 *	@param mc MovieClip
		 *	@return MCTileView
		 */
		public function createMCTileView(mc:MovieClip):MCTileView
		{
			return new MCTileView(mc);
		}
		
		/**
		 *	@param sid string
		 *	@param x Number
		 *	@param y Number
		 *	@param z Number
		 *	@param view ITileView
		 *	@return AbstractTile
		 */
		public function createAbstractTile(sid:String, x:Number, y:Number, z:Number, view:ITileView):AbstractTile
		{			
			return new AbstractTile(sid, new UPoint(x, y, z, 60, 30, 30, 0, 0, 0), view);
		}
		
		/**
		 *	@param name String
		 *	@param tile AbstractTile
		 *	@return PNJHelper
		 */
		public function createPNJHelper(name:String, tile:AbstractTile):PNJHelper
		{
			return new PNJHelper(name, tile);
		}
		
		/*public function createGLib():GLib
		{
			return new GLib();
		}*/
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}