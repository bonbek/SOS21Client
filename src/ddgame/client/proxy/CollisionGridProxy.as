package ddgame.client.proxy {
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.collection.TypedGrid;
	import com.sos21.tileengine.utils.PathFinder;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.structures.IUPositionable;
	import com.sos21.tileengine.structures.CollisionCell;
	import ddgame.client.events.EventList;
	import ddgame.client.proxy.ProxyList;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  27.02.2008
	 */
	public class CollisionGridProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		public static const NAME:String = ProxyList.COLLISIONGRID_PROXY;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function CollisionGridProxy(sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _grid:TypedGrid;
		private var _pathFinder:PathFinder = new PathFinder();
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get grid():TypedGrid
		{ return _grid; }

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function addCell(x:int, y:int, z:int, cell:CollisionCell):void
		{
			if (!_grid.addCell(x, y, z, cell))
				trace("impossible d'insérer: cell - x:" + x + " y:" + y + " z:" + z);
		}
		
		public function removeCellAt(x:int, y:int, z:int):void
		{
			_grid.replaceCell(x, y, z, null);
		}
		
		public function isCollisionCell(p:UPoint):Boolean 
		{ return _grid.getCell(p.xu, p.yu, p.zu).collision; }
				
		public function findPath(startPoint:UPoint, endPoint:UPoint):Array /* of Object */
		{ return _pathFinder.findPath(startPoint, endPoint); }
		
		/*
		*	Clear the CollisionGid
		*/
		public function resetGrid(w:int, h:int, d:int):void
		{ 
			_grid = new TypedGrid(w, h, d, CollisionCell, new CollisionCell(0));
		}
		
		/*
		*	Parse the collision grid
		*	@param	w : width of the grid
		*	@param	h : height of the grid
		*	@param	d : depth of the grid
		*	@param	clist : Array of Objects { x, y, z, type , cost }
		*/
		public function parse(clist:Array):void
		{
			_data = clist		// set the serialized data
			
			var n:int = clist.length;
			while (--n > -1)
			{
				var o:Object = clist[n];
				var c:CollisionCell = new CollisionCell(o.type);
				c.cost = o.cost ? o.cost : 0;
				if (!_grid.addCell(o.x, o.y, o.z, c))
					trace("impossible d'insérer: cell - ux:" + o.x + " uy:" + o.y + " uz:" + o.z + " type collision:" + o.type);
//				else
//					trace("cell - ux:" + o.y + " uy:" + o.y + " uz:" + o.z + " type collision:" + o.type);
			}
			
			_pathFinder.collisionGrid = _grid;
			sendEvent(new Event(EventList.COLLISIONGRID_PARSED));
		}
		
		/**
		 *	Retourne le point coordonnées qui n'est pas une collision
		 *	le plus proche
		 *	@param	cell	 le "point coordonnées" à partir du quel est éffctué le test
		 *	@param	radius	le rayon de test (en unité case de la grille)
		 */
		public function findNearestNoCollisionPoint(cell:UPoint, radius:int = 20):UPoint
		{
			var ox:int = cell.xu;
			var oy:int = cell.yu;
			var tx:int;
			var ty:int;
			var r:int;
			first : for (r = 1; r <= radius; r++) {
				for (var i:int = -1 ; i <= 1 ; i++)
				{
					for (var j:int = -1 ; j <= 1 ; j++)
					{
						tx = ox + (i * r);
						ty = oy + (j * r);
						if (!_grid.getCell(tx, ty, 0).collision) {
							break first;
						}
					}
				}
			}

			return new UPoint(tx, ty, 0);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
