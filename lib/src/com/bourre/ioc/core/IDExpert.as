package com.bourre.ioc.core
{
	import flash.utils.Dictionary;
	
	import com.bourre.collection.*;
	import com.bourre.ioc.assembler.property.*;
	import com.bourre.log.*;
	import com.bourre.plugin.*;

	public class IDExpert
		implements PropertyExpertListener
	{
		private static var _oI : IDExpert;

		private var _d : Dictionary;
		private var _c : Set;
		private var _m : HashMap;

		/**
		 * @return singleton instance of IDExpert
		 */
		public static function getInstance() : IDExpert 
		{
			if (!_oI) _oI = new IDExpert();
			return _oI;
		}
		
		public static function release() : void
		{
			if ( IDExpert._oI is IDExpert ) IDExpert._oI = null;
		}

		public function IDExpert()
		{
			_d = new Dictionary( true );
			_c = new Set();
			_m = new HashMap();
		}

		public function onBuildProperty( e : PropertyEvent ) : void
		{
			var refID : String = e.getRefID();

			if ( refID != null ) 
			{
				if ( refID.indexOf(".") != -1 )
				{
					var a : Array = refID.split(".");
					refID = a[0];
				}
	
				_pushReference( refID, e.getOwnerID() );
			}
		}

		private function _pushReference( refID : String, ownerID : String ) : void
		{
			_c.add( refID );
			
			var nRef : int = _c.indexOf( refID );
			var nOwner : int = _c.indexOf( ownerID );
			
			if ( nRef > nOwner )
			{
				_c.removeAt( nRef );
				_c.addAt( nOwner, refID );
			}
		}

		public function getReferenceList() : Set
		{
			return _c;
		}
		
		// check for id conflicts
		public function register( id : String ) : Boolean
		{
			if (  _d[ id ] ) 
			{
				PluginDebug.getInstance().fatal( this + ".register(" + id + ") failed. This id was already registered, check conflicts in your config file." );
				return false;
				
			} else
			{
				_d[ id ] = true;
				_c.add( id );
				return true;
			}
		}
		
		public function unregister( id : String ) : Boolean
		{
			if (  _d[ id ] ) 
			{
				_d[ id ] = false;
				_c.remove( id );
				return true;

			} else
			{
				PluginDebug.getInstance().fatal( this + ".unregister(" + id + ") failed." );
				return false;
			}
		}

		/*
		public function storeContextID( id : String, target : Object ) : void
		{	PluginDebug.getInstance().warn("storeContextID("+id+")");
			if ( !_m.containsKey(id) ) _m.put( id, target );
		}

		public function getContextTarget( id : String ) : Object
		{	PluginDebug.getInstance().warn("getContextTarget("+id+")");
			return _m.get( id );
		}*/

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}