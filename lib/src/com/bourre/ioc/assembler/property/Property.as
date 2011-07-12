package com.bourre.ioc.assembler.property
{
	import com.bourre.log.PixlibStringifier ;
	
	
	public class Property
	{
		public var ownerID : String;
		public var name : String;
		public var value : String;
		public var type : String;
		public var ref : String;
		public var method : String;
		
		public function Property( 	ownerID : String, 
									name 	: String = null, 
									value 	: String = null, 
									type 	: String = null, 
									ref 	: String = null, 
									method 	: String = null 
								)
		{
			this.ownerID = ownerID;
			this.name = name;
			this.value = value;
			this.type = type;
			this.ref = ref;
			this.method = method;
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