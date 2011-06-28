package com.bourre.ioc.assembler.constructor
{
	import com.bourre.log.PixlibStringifier ;
	
	public class Constructor
	{
		public var 		id 		: String;
		public var 		type 		: String;
		public var 		arguments : Array;
		public var 		factory 	: String;
		public var 		singleton : String;
		public var 		channel 	: String;

		
		public function Constructor(	id : String, 
										type : String = null, 
										args : Array = null, 
										factory : String = null, 
										singleton : String = null,
										channel : String = null) //access:PrivateConstructorAccess)
		{
			this.id = id;
			this.type = type;
			this.arguments = args;
			this.factory = factory;
			this.singleton = singleton;
			this.channel = channel;
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

