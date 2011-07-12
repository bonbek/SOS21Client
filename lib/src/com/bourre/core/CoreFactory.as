package com.bourre.core
{
	import com.bourre.log.PixlibDebug;
	import flash.utils.getDefinitionByName;

	public class CoreFactory
	{
		private static var _A : Array = [	_build0,_build1,_build2,_build3,_build4,_build5,_build6,_build7,_build8,_build9,
											_build10,_build11,_build12,_build13,_build14,_build15,_build16,_build17,_build18,_build19,
											_build20,_build21,_build22,_build23,_build24,_build25,_build26,_build27,_build28,_build29,
											_build30];
							
		public function CoreFactory( access : PrivateCoreFactoryAccess )
		{
			
		}

		public static function buildInstance( qualifiedClassName : String, aArgs : Array = null, factoryMethod : String = null, singletonAccess : String = null ) : Object
		{
			var clazz : Class = getDefinitionByName( qualifiedClassName ) as Class;
			if ( !clazz ) 
			{
				PixlibDebug.FATAL( clazz + "' class is not available in current domain" );
				return null;
			}

			var o : Object;
	
			if ( factoryMethod )
			{
				if ( singletonAccess )
				{
					var i : Object;
					
					try
					{
						i = clazz[ singletonAccess ].call();
						
					} catch ( eFirst : Error ) 
					{
						PixlibDebug.FATAL( qualifiedClassName + "." + singletonAccess + "()' singleton access failed." );
						return null;
					}
					
					try
					{
						o = i[factoryMethod].apply( i, aArgs );
					
					} catch ( eSecond : Error ) 
					{
						PixlibDebug.FATAL( qualifiedClassName + "." + singletonAccess + "()." + factoryMethod + "()' factory method call failed." );
						return null;
					}
					
				} else
				{
					try
					{
						o = clazz[factoryMethod].apply( clazz, aArgs );
						
					} catch( eThird : Error )
					{
						PixlibDebug.FATAL( qualifiedClassName + "." + factoryMethod + "()' factory method call failed." );
						return null;
					}

				}
			} else
			{
				o = _buildInstance( clazz, aArgs );
			}

			return o;
		}
		
		private static function _buildInstance( clazz : Class, aArgs : Array = null ) : Object
		{
			var f : Function = _A[ aArgs? aArgs.length : 0 ];
			var args : Array = [clazz];
			if ( aArgs ) args = args.concat( aArgs );
			return f.apply( null, args );
		}
		
		private static function _build0( clazz : Class ) : Object
		{
			return new clazz();
		}

		private static function _build1( clazz : Class ,a1:* ) : Object{ return new clazz( a1 ); }
		private static function _build2( clazz : Class ,a1:*,a2:* ) : Object{ return new clazz( a1,a2 ); }
		private static function _build3( clazz : Class ,a1:*,a2:*,a3:* ) : Object{ return new clazz( a1,a2,a3 ); }
		private static function _build4( clazz : Class ,a1:*,a2:*,a3:*,a4:* ) : Object{ return new clazz( a1,a2,a3,a4 ); }
		private static function _build5( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:* ) : Object{ return new clazz( a1,a2,a3,a4,a5 ); }
		private static function _build6( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6 ); }
		private static function _build7( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7 ); }
		private static function _build8( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8 ); }
		private static function _build9( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9 ); }
		private static function _build10( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10 ); }
		private static function _build11( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11 ); }
		private static function _build12( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12 ); }
		private static function _build13( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13 ); }
		private static function _build14( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14 ); }
		private static function _build15( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15 ); }
		private static function _build16( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16 ); }
		private static function _build17( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17 ); }
		private static function _build18( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18 ); }
		private static function _build19( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19 ); }
		private static function _build20( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20 ); }
		private static function _build21( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21 ); }
		private static function _build22( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22 ); }
		private static function _build23( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23 ); }
		private static function _build24( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24 ); }
		private static function _build25( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25 ); }
		private static function _build26( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26 ); }
		private static function _build27( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27 ); }
		private static function _build28( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28 ); }
		private static function _build29( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:*,a29:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29 ); }
		private static function _build30( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:*,a29:*,a30:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30 ); }
	}
}

internal class PrivateCoreFactoryAccess {}