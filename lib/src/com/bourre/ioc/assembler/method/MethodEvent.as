package com.bourre.ioc.assembler.method
{
	import com.bourre.events.BasicEvent;
	import com.bourre.ioc.assembler.method.Method ;
	import com.bourre.log.PixlibStringifier ;

	public class MethodEvent extends BasicEvent
	{
		public static var onBuildMethodEVENT : String = "onBuildMethod" ;
		private var _oMethod : Method ;
		
		public function MethodEvent( oMethod : Method )
		{
			super( MethodEvent.onBuildMethodEVENT );
			
			_oMethod = oMethod;
		}
		
		public function getMethod() : Method
		{
			return _oMethod;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}