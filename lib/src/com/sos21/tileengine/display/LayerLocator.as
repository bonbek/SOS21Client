/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.display {
	
	import de.polygonal.ds.HashMap;
	
	import com.sos21.tileengine.display.ILayer;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  03.12.2007
	 */
	public class LayerLocator {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LayerLocator( access : PrivateConstructor )
		{
			
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _oI : LayerLocator;
		private var _hashMap : HashMap;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function getLayer( sname : String ) : ILayer
		{
			var l : ILayer = _hashMap.find( sname ) as ILayer;
			
			return l;
		}
		
		public function getLayerName( o : ILayer ) : String
		{
			return _hashMap.findKey( o ) as String;
		}
		
		public function registerLayer( sname : String, o : ILayer ) : Boolean
		{
			if ( _hashMap == null ) _hashMap = new HashMap();
			
			if ( _hashMap.containsKey( sname ) || !_hashMap.insert( sname, o ) ) return false;
			
			return true;
		}
		
		public function unregisterLayer( sname : String ) : void
		{
			_hashMap.remove( sname );
		}
		
		public function isRegistered( o : ILayer ) : Boolean
		{
			return _hashMap.contains( o );
		}
		
		/*
		 *	Singelton
		 */
		public static function getInstance() : LayerLocator
		{	
			if ( _oI == null ) _oI = new LayerLocator( new PrivateConstructor() );
			
			return _oI;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}

internal final class PrivateConstructor {}