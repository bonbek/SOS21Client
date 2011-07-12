package com.sos21.tileengine.display {
	
	import com.sos21.tileengine.display.ILayer;	
	import com.sos21.tileengine.core.IUDrawable;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface ILayerContainer extends IUDrawable {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function addLayer(l:ILayer):Boolean
		function removeLayer(sname:String = "_ME_"):Boolean
		function findLayer(sname:String):ILayer
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function get name():String
		function set name(val:String):void
		
	}
	
}
