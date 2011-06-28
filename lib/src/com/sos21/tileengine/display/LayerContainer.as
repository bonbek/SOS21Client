/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.display {
	import flash.utils.Dictionary;
	import com.sos21.debug.log;	
	import com.sos21.tileengine.display.ILayerContainer;
	import com.sos21.tileengine.display.ILayer;
	import com.sos21.tileengine.display.Layer;
	import com.sos21.tileengine.display.UAbstractDrawable;
	import com.sos21.tileengine.display.LayerLocator;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class LayerContainer extends UAbstractDrawable implements ILayerContainer {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _layerList:Array/* of ILayer */ = [];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*
		*	Add to display and register a ILayer
		*	Do zsorting from his IDrawer
		*	@param : ILayer instance
		*/
		public function addLayer(o:ILayer):Boolean
		{
			if (!LayerLocator.getInstance().isRegistered(o))
				return false;
			
			o.contener = this;			
			_layerList.push(o);		
			registerChild(o);
			o.move(o.drawer.findPoint(o.upos));
			zsort(o);
			
			return true;
		}
		
		/*
		*	Retrieve a ILayer by is name
		*	@param sname : ILayer name
		*	@return ILayer
		*/
		public function findLayer(sname:String):ILayer
		{
			return ILayer(LayerLocator.getInstance().getLayer(sname));
		}
		
		/*
		*	Remove from display and unregister ILayer
		*	If no param passed to method the ILayer remove itself
		*	@param : ILayer name
		*	@return true if succes
		*/
		public function removeLayer(sname:String = ""):Boolean
		{
			if (sname == "")
				return Layer(contener).removeLayer(name);
			
			var layer:Layer = Layer(findLayer(sname));
			if (!LayerLocator.getInstance().isRegistered(findLayer(sname)))
				return false;			
			
			unregisterChild(layer);
			LayerLocator.getInstance().unregisterLayer(sname);			
			var ind:uint = _layerList.indexOf(layer);
			_layerList.splice(ind, 1);
			removeChild(layer);

			return true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/*
		*	Register a ILayer reference to LayerLocator
		*	@param	o : ILayer
		*	@return true if succes
		*/
		protected function registerLayer(o:ILayer):Boolean
		{
			if (!LayerLocator.getInstance().registerLayer(o.name,o))
			{
//				trace("can't register Layer : " + o.toString() + " @" + toString());
				return false;
			}
			return true;
		}		
		
		
		private function redrawLayers() : void 		// TODO corriger la méthode redrawLayers()
		{
/*			for ( var i:int = 0; i < _layerList.length; i++ ) {
				var l : Layer = _layerList[i];
				l.zdepth = l.drawer.getDepth( l );
			}
			
			_layerList.sortOn("zdepth", Array.NUMERIC);
			
			for ( var j:int = 0; j < _layerList.length; j++ ) {
				var dO : Layer = _layerList[j];
				dO.move( dO.drawer.getPixPos(dO) );
				addChild( dO );
			}			*/
		}
		
		
		
		
	}
	
}
