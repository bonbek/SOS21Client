package com.bourre.ioc.assembler.method
{
	import com.bourre.log.PixlibStringifier;
	
	public class Method
	{
		public var ownerID	:String ;
		public var name		:String ;
		public var args		:Array ;
		
		
		public function Method (ownerID:String, name:String, args:Array)
		{
			this.ownerID	= ownerID ;
			this.name		= name ;
			this.args		= args ;
		}
		
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