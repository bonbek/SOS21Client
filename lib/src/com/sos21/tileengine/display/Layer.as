package com.sos21.tileengine.display {
		
	import com.sos21.tileengine.structures.UPoint;
	import flash.display.DisplayObject;	
	import com.sos21.tileengine.display.ILayer;
	import com.sos21.tileengine.display.LayerContainer;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class Layer extends LayerContainer implements ILayer {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Layer(sname:String, nzindex:int = void)
		{
			// TODO trouver une soluce pour empiler un Layer crée sans zindex au plus haut de la pile des layers existants dans le même conteneur
/*			if ( contener && !nzindex ) {
				trace( this + " nzindex == void " );
				nzindex = layersCount;
			} */

//			if ( upos == null ) upos = new UPoint();
			if (nzindex)
				upos.zindex = nzindex;
				
			name = sname;
			registerLayer(this);
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _assets:Array = [];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function addGfx(dO:DisplayObject):void
		{
			_assets.push(dO);
			addChild(dO);
		}
		
		public function removeAllGfx():void
		{
			while (_assets.length > 0)
			{
				removeChild(DisplayObject(_assets.shift()));
			}
		}
		
		public function moveTo() : void
		{
			
		}
				
		public function scroll() : void
		{
			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
