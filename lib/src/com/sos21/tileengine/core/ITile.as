/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.core {
	
	import flash.display.DisplayObject;
	
	import com.sos21.tileengine.core.IUDrawable;
	import com.sos21.tileengine.display.ITileView;
	import com.sos21.tileengine.display.TileView;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  06.11.2007
	 */
	public interface ITile extends IUDrawable {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
//		function moveTo( ixu : Number, iyu : Number, izu : Number ) : void
//		function pathTo( path : Array ) : void
		function release():void
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
//		function get ID() : int
		function get ID():String
		
		function addAsset(dO:DisplayObject):void
//		function drawView():void
		
	}
	
}
