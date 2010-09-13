/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.proxy {
	import flash.events.Event;
	
	import com.sos21.debug.log;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.lib.GLib;
	
	import ddgame.client.proxy.DatamapProxy;
	import ddgame.client.proxy.LibProxy;
	import com.sos21.proxy.ConfigProxy;
		
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.structures.UPoint;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  27.02.2008
	 */
	public class TileProxy extends AbstractProxy {
		
		
		// TODO class offline, à réparer ???
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "tileProxy";

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function TileProxy(odata:Object, tile:AbstractTile)
		{
			/*super(String( NAME + odata.id ), odata);
			_tile = tile;*/
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		/*private var _tile:AbstractTile;
		private var _refId:int;
		private var _facingPoint:UPoint;*/
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/*public function get refId():int
			{
				return _refId;
			}
			
			public function get tile():AbstractTile
			{
				return _tile;
			}
			
			public function get assets():Array
			{
				return _tile.assets;
			}
			
				// return original data ( pointer )
			public function get data():Object
			{
				return _data;
			}
			
			public function get facingPoint():UPoint
			{
				var tp:Array = _data.facingOffset.split("/");
				if (tp.length < 2)
					return null;
					
				var up:UPoint = _tile.upos.clone();
				up.sum(new UPoint(tp[0], tp[1], tp[2]));
				
				return up;
			}
			
			public function hasFacingPoint():Boolean
			{
				return String(_data.facingOffset).indexOf("/") > -1;
			}*/
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
/*		private function _parse():void
		{
			var tp:Array = _data.facingOffset.split("/");
			var up:UPoint = new UPoint(tp[0]
			_facingPoint = _tile.UPoint.clone().substract(up);
		} */
		
	}
	
}
