/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.proxy {
	import flash.events.Event;

	import com.sos21.proxy.AbstractProxy;
	import com.sos21.collection.TypedGrid;
	
	import com.sos21.tileengine.core.AbstractTile;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  27.02.2008
	 */
	public class TileGridProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "tileGridProxy";

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function TileGridProxy(sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _grid:TypedGrid;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get grid():TypedGrid
		{
			return _grid;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function resetGrid(w:int, h:int, d:int):void
		{
			_grid = new TypedGrid(w, h, d, AbstractTile, null);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------

	}
	
}
