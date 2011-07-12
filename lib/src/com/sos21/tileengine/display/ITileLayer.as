/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.display {
	
	import com.sos21.tileengine.core.ITile;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.core.IUDrawable;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  30.11.2007
	 */
	public interface ITileLayer extends IUDrawable {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function addTile(t:AbstractTile):void
		function removeTile(t:AbstractTile):void
		function removeAllTile():void
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	}
	
}
