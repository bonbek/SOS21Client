package com.bourre.core
{
	import flash.utils.Dictionary;
	
	public class HashCodeFactory
	{
		static protected const _oHashTable : Dictionary = new Dictionary( true );
		
		static private var _nKEY : Number = 0;
		
		static public function getKey ( o : * ) : String
		{
			if( !hasKey ( o ) )
				_oHashTable[ o ] = getNextKey ();
			
			return _oHashTable[ o ] as String;
		}
		
		static public function hasKey ( o : * ) : Boolean
		{
			return _oHashTable[ o ] != null;
		}
		
		static public function getNextKey () : String
		{
			return "KEY" + _nKEY++;
		}
		
		static public function previewNextKey () : String
		{
			return "KEY" + _nKEY;
		}
	}
}