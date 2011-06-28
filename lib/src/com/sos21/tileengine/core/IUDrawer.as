/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.core {
	
	import flash.geom.Point;
	import com.sos21.tileengine.structures.IUPositionable;
	import com.sos21.tileengine.display.UAbstractDrawable;
	import com.sos21.tileengine.display.Layer;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  05.12.2007
	 */
	public interface IUDrawer {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function findPoint(o:IUPositionable):Point
		function findGridPoint(p:Point , o:IUPositionable):Point
		function findFloatGridPoint(p:Point, o:IUPositionable):Point
		function computeGridPoint(p:Point , o:IUPositionable):Point
		function findDepth(o:Object):Number
		
		function followPath(target:UAbstractDrawable, path:Array /* define in concrete class */, params:Object = null):void
		
		function render (layer:Layer) : void;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	}
	
}
