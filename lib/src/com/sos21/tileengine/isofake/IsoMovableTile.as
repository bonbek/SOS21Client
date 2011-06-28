/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.isofake {
	
	import flash.geom.Point;
	
	import caurina.transitions.Tweener;
	
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.motion.IUMovable;
	import com.sos21.tileengine.core.AbstractTile;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  14.12.2007
	 */
	public class IsoMovableTile extends AbstractTile implements IUMovable {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function IsoMovableTile(	p : UPoint = null,
												assets : Array = null,
												v : ITileView = null )
		{

			super( p, assets, v );
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _speed : int;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get speed() : int 	// vitesse de deplacement pixels par seconde
		{
			return _speed;
		}
		public function set speed( val : int ) : void
		{
			_speed = val;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function uMoveTo( upt : UPoint ) : void
		{
			var nNode : UPoint = _myPath.shift();
			_myNode = nNode;
			var ptu : UPoint = _myPath[0];

			if ( isToUpdateUData( ptu.xu, ptu.yu, ptu.zu ) ) updateUData( ptu.xu, ptu.yu, ptu.zu );
			contener.zsort( this );
			updateUData( ptu.xu, ptu.yu, ptu.zu );
//			_view.loop();

			var pt : Point = drawer.getPixPos( upos );
			var t : Number = Point.distance( new Point(x, y), pt ) / _speed;
			trace( "time: " + t );
			Tweener.addTween( this, {x:pt.x, y:pt.y, time:t, transition:"linear", onComplete:nextPathStep} );
		}
		
		public function moveTo( pt : Point ) : void
		{
			
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function isToUpdateUData( nxu : Number, nyu : Number, nzu : Number ) : Boolean
		{	
			// tile se déplace en +X on prend coordonnée X de la case destination pour calcule zdepth
			// sinon on prend coordonnée X de la case actuelle
			var res : Boolean;
			
			if ( nxu != upos.xu ) {
				nxu > upos.xu ? res = true : res = false;
			} else {
				nyu > upos.yu ? res = true : res = false;
			}	
			
			return res;
			
		}
		
	}
	
}
