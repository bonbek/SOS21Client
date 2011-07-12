/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.structures {
	
	import com.sos21.tileengine.structures.IUPositionable;
	
	/** TODO : implémnter méthodes bourre.structures.Point like
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  05.12.2007
	 */
	public class UPoint extends Object implements IUPositionable {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function UPoint(	nxu:Number = 0,
										nyu:Number = 0,
										nzu:Number = 0,
										nxFactor:Number = 0,
										nyFactor:Number = 0,
										nzFactor:Number = 0,
										nxoffset:Number = 0,
										nyoffset:Number = 0,
										nzoffset:Number = 0,
										nzindex:int = 0 )
		{
			
			super();
			
			xu = nxu;
			yu = nyu;
			zu = nzu;
			
			xFactor = nxFactor;
			yFactor = nyFactor;
			zFactor = nzFactor;
			
			xoffset = nxoffset;
			yoffset = nyoffset;
			zoffset = nzoffset;

			zindex = nzindex;			
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _xu:Number;
		private var _yu:Number;
		private var _zu:Number;

		private var _xFactor:Number;
		private var _yFactor:Number;
		private var _zFactor:Number;

		private var _xoffset:Number;
		private var _yoffset:Number;
		private var _zoffset:Number;
		
		private var _zindex:int;
		
		
		public var width:Number = 1;
		public var height:Number = 1;
		public var depth:Number = 1;
		
		/*private var _w:Number = 1;
		private var _h:Number = 1;
		private var _d:Number = 1;
		
		// PATCH
		public function get width():Number {
			return _w;
		}
		public function get height():Number {
			return _h;
		}
		public function get depth():Number {
			return _d;
		}
		
		public function set width(val:Number):void {
			_w = val;
		}
		public function set height(val:Number):void {
			_h = val;
		}
		public function set depth(val:Number):void {
			_d = val;
		}*/
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public function get xu():Number { return _xu; }
		public function set xu(val:Number):void { _xu = val; }
		
		public function get yu():Number { return _yu; }
		public function set yu(val:Number):void { _yu = val; }
		
		public function get zu():Number { return _zu; }
		public function set zu(val:Number):void { _zu = val; }
		
		public function get xFactor():Number { return _xFactor; }
		public function set xFactor(val:Number):void { _xFactor = val; }
		
		public function get yFactor():Number { return _yFactor; }
		public function set yFactor(val:Number):void { _yFactor = val; }
		
		public function get zFactor():Number { return _zFactor; }
		public function set zFactor(val:Number):void { _zFactor = val; }
		
		public function get xoffset():Number { return _xoffset; }
		public function set xoffset(val:Number):void { _xoffset = val; }

		public function get yoffset():Number { return _yoffset; }
		public function set yoffset(val:Number):void { _yoffset = val; }
		
		public function get zoffset():Number { return _zoffset; }
		public function set zoffset(val:Number):void { _zoffset = val; }
		
		public function set zindex(val:int):void { _zindex = val; }
		public function get zindex():int { return _zindex; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function matchPosf(p:UPoint):void 
		{                                             
			xu = p.xu;                                 
			yu = p.yu;                                 
			zu = p.zu;                                 
		}
		
		public function updatePos(nx:Number , ny:Number , nz:Number):void
		{
			xu = nx;
			yu = ny;
			zu = nz;
		}
		
		public function substract(p:UPoint):void
		{
			_xu-= p.xu;
			_yu-= p.yu;
			_zu-= p.zu;
		}
		
		public function add(p:UPoint):void
		{
			xu+= p.xu;
			yu+= p.yu;
			zu+= p.zu;			
		}
		
		public function updateFactors(xf:Number, yf:Number, zf:Number):void
		{
			xFactor = xf;
			yFactor = yf;
			zFactor = zf;
		}
		
		public function updateOffsets(xo:Number, yo:Number, zo:Number):void
		{
			xoffset = xo;
			yoffset = yo;
			zoffset = zo;
		}
		
		public function matchPos(p:UPoint):void 
		{                                             
			xu = p.xu;                                 
			yu = p.yu;                                 
			zu = p.zu;                                 
		}
		
		public function isMatchPos(p:UPoint):Boolean
		{
			return p.xu == xu && p.yu == yu && p.zu == zu;
		}
		
		/**
		 *	Retourne l'angle formé par 2 UPoint
		 */
		public function computeAngle(p:UPoint):int
		{
		 	var deltaX:int = p.xu - xu;
			var deltaY:int = p.yu - yu;
			var rot:int = Math.atan2(deltaY ,  deltaX) * 180 / Math.PI;
			
			return rot < 0 ? rot + 360 : rot;
		}
		
		public function clone():UPoint              
		{                                             
			return new UPoint(xu, yu, zu, xFactor, yFactor, zFactor, xoffset, yoffset, zoffset, zindex);
		}
		
		public function posToString():String
		{
			return "xu:" + _xu + " yu:" + _yu + " zu:" + _zu;
		}
		
		public function sum(p:UPoint):void
		{
			xu += p.xu;
			yu += p.yu;
			zu += p.zu; 
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}