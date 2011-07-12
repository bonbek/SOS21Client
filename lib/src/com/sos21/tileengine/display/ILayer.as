package com.sos21.tileengine.display {
	
	import flash.display.DisplayObject;	
	import com.sos21.tileengine.display.ILayerContainer;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface ILayer extends ILayerContainer {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function addGfx(dO : DisplayObject):void
		function removeAllGfx():void
		
		function moveTo():void
		function scroll():void
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	}
	
}
