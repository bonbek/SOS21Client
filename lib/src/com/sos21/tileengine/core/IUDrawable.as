/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.core {
	import flash.geom.Point;	
	import com.sos21.tileengine.core.IUDrawer;
	import com.sos21.tileengine.display.UAbstractDrawable;
	import com.sos21.tileengine.structures.UPoint;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  30.11.2007
	 */
	public interface IUDrawable {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		function zsort(o:IUDrawable):void
		function findGridPoint(p:Point):Point
		
		function computeZdepth():void
		
		function move(p:Point):void
		function umove(nup:UPoint, grouped:Boolean = true):void
		
		function remove():void
		
		function toString():String
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function get upos():UPoint
		function set upos(val:UPoint):void
		
		function get contener():UAbstractDrawable
		function set contener(val:UAbstractDrawable):void
		
		function get drawer():IUDrawer
		function set drawer(val:IUDrawer):void
		
		function set zdepth(val:Number):void
		function get zdepth():Number
		
		function set rZdepth(val:uint):void
		function get rZdepth():uint
				
	}
	
}
