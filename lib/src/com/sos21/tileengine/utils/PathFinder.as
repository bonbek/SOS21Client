/* AS3
	Copyright 2007 toffer.
*/
package com.sos21.tileengine.utils {
	import flash.geom.Point;
	import flash.utils.getTimer;	
	import com.sos21.debug.log;
	import com.sos21.collection.Grid;
	import com.sos21.collection.TypedGrid;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.structures.CollisionCell;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  07.10.2007
	 */
	public class PathFinder {
		
		
		public var defaultCost : int = 10;
//		private var _grid : AbstractGrid;
		private var _grid : TypedGrid;
//		private var _tgrid : Array3;
		private var _tgrid : Grid;
		private var _aOpenList : Array;
		private var _aCloseList : Array;
		
		public function PathFinder(grid:TypedGrid = null)
		{
			if(grid != null)
				_grid = grid;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set grid (val:TypedGrid) : void
		{ _grid = val }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function findPath(ups:UPoint, upt:UPoint):Array
		{
			var execTime:Number = getTimer();

			// coordonnées départ
			var xS:int = ups.xu;
			var yS:int = ups.yu;
			var zS:int = ups.zu;
			
			// coordonnées d'arrivée
			var xE:int = upt.xu;
			var yE:int = upt.yu;
			var zE:int = upt.zu;

			_aOpenList = new Array();
			_aCloseList = new Array();
//			_tgrid = new Array3( _grid.width, _grid.height, _grid.depth );
			_tgrid = new Grid(_grid.width, _grid.height, _grid.depth);
			
			// noeud de départ
			var firstNode : Object = new Object();
			firstNode.x = xS;
			firstNode.y = yS;
			firstNode.z = zS;
			firstNode.cost = 0;
			firstNode.destCost = distanceCost( xS, yS, xE, yE );
			
			// ajout du noeud de départ dans la liste ouverte
			_aOpenList.push( firstNode );
			// ajout du noeud de départ dans la grille temporaire
			_tgrid.set( firstNode.x, firstNode.y, firstNode.z, firstNode );

			// noeud en cours
			var tmpNode:Object = new Object();
			// boucle de recherche
			while( _aOpenList.length > 0 ) {

				var minCost : int = int.MAX_VALUE;
				var betterNodeI : int;
				var nodeI : int = _aOpenList.length;
				
				// recherche dans la liste ouverte le noeud ayant le meilleur coût
				while ( nodeI-- ) {
//					tmpNode = _aTmpMap[_aOpenList[nodeI].y][_aOpenList[nodeI].x];
					tmpNode = _tgrid.get( _aOpenList[nodeI].x, _aOpenList[nodeI].y, _aOpenList[nodeI].z );
					var totalCost : int = tmpNode.cost + tmpNode.destCost;
					if (totalCost < minCost) {
						betterNodeI = nodeI;
						minCost = totalCost;
					}
				}

				// attribution du noeud en cours
				tmpNode = _aOpenList[betterNodeI];
				tmpNode.closed = true;
				tmpNode.opened = false;
//				trace( tmpNode );
				
				// arrêt de la recherche si le noeud en cours correspond au noeud d'arrivée
				if (tmpNode.x == xE && tmpNode.y == yE) break;

				// ajout du noeud ayant le meilleur coût dans la liste fermée
				_aCloseList.push( tmpNode );

				// suppression de celui-ci de la liste ouverte
				_aOpenList.splice( betterNodeI, 1 );
				
				first : for (var i:int = -1 ; i <= 1 ; i++) {
					sec : for (var j:int = -1 ; j <=1 ; j++) {
						// Cooronnées de la case testée
						var nX : int = tmpNode.x + j;
						var nY : int = tmpNode.y + i;						
						var nZ : int = tmpNode.z;
						
						// test si prochain noeud sort des limites de la grille
						if ( nY >= _grid.height || nX >= _grid.width ) continue sec;
						if ( nY < 0 || nX < 0 ) continue sec;

						if ( Object( _tgrid.get( nX, nY, nZ )).closed ) continue sec;
//trace( "i: " + i + " j: " + j + " (i&&j): " + (i && j) + " : " + Boolean(i&&j) );
						var ty : CollisionCell = _grid.getCell(tmpNode.x, nY, nZ);
						var tx : CollisionCell = _grid.getCell(nX, tmpNode.y, nZ);
						if ( (i && j) && ( ty.collision || tx.collision ) && !ty.throwable && !tx.throwable) continue sec;

						var tc : CollisionCell = _grid.getCell(nX, nY, nZ);
						if ( (i || j) && !tc.collision ) {
							// calcule du coût pour case testée
							var distCost : int = tmpNode.cost + tc.cost + Math.round( Math.sqrt(Math.abs(i) + Math.abs(j)) );
							var to : Object = Object( _tgrid.get(nX, nY, nZ) );		
							if ( to.opened ) {
								//trace("déja dans la liste : " + nX + " - " + nY);
								if (distCost < to.cost) {
									to.father = tmpNode;
									to.cost = distCost;
								}

							} else {
								//trace("pas dans la liste : " + nX + " - " + nY);
								var newNode : Object = { x:nX, y:nY, z:nZ, cost:distCost, destCost:distanceCost(nX,nY,xE,yE), opened:true, closed:false, father:tmpNode};
								_tgrid.set(nX, nY, nZ, newNode );
								_aOpenList[_aOpenList.length] = newNode;								
							}
							
						}
						
					}
				}
				
			
			}
				
			// Fin de la recherche
			var _aResult : Array = new Array();
			// retourne un tableau vide si le path n'à pas été trouvé;
			if (tmpNode.x == xE && tmpNode.y == yE) {
				_aResult.push(new UPoint(tmpNode.x, tmpNode.y, tmpNode.z));
				while (tmpNode.father) {
					tmpNode = tmpNode.father;
					_aResult.push(new UPoint(tmpNode.x, tmpNode.y, tmpNode.z));
				}
				_aResult.reverse();
			}
			
			_aOpenList = null;
			_aCloseList = null;
			_tgrid = null;
			tmpNode = null;
			
/*			trace("pathfinder.findPath exec time: " + String(getTimer() - execTime)); */
			return _aResult;
			
		}
		
				
		/*
		 * retourne le coût de la distance entre deux points (calculé sur une distance de manathan)
		 */	 
		private function distanceCost(xS : int, yS : int, xE : int, yE : int) : int {
			return ( Math.abs(xE-xS) + Math.abs(yE-yS) )*defaultCost;
		}

	
	}
	
}

