package com.sos21.tileengine.structures {
	
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  03.12.2007
	 */
	public interface IUPositionable {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function updatePos(nx:Number , ny:Number , nz:Number):void;
		function updateFactors(xf:Number, yf:Number, zf:Number):void;
		function updateOffsets(xo:Number, yo:Number, zo:Number):void;
		function posToString():String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
				
		/*function get width():Number;
		function get height():Number;
		function get depth():Number;
		function set width(val:Number):void;
		function set height(val:Number):void;
		function set depth(val:Number):void;*/
		
		function get xu():Number
		function set xu(val:Number):void
		function get yu():Number
		function set yu(val:Number):void
		function get zu():Number
		function set zu(val:Number):void
		
		function get xFactor():Number
		function set xFactor(val:Number):void
		function get yFactor():Number
		function set yFactor(val:Number):void
		function get zFactor():Number
		function set zFactor(val:Number):void
		
		function get xoffset():Number
		function set xoffset(val:Number):void
		function get yoffset():Number
		function set yoffset(val:Number):void
		function get zoffset():Number
		function set zoffset(val:Number):void
		
		function set zindex(val:int):void
		function get zindex():int
		
	}
	
}
