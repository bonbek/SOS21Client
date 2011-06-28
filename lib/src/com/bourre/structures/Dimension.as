package com.bourre.structures 
{
	import com.bourre.log.PixlibStringifier;	
	
	/**
	 * @author Cédric Néhémie
	 */
	public class Dimension 
	{
		public var width : Number;
		public var height : Number;
		
		public function Dimension ( width : Number = 0, height : Number = 0 )
		{
			this.width = width;
			this.height = height;
		}

		public function equals ( dimension : Dimension ) : Boolean
		{
			return (width == dimension.width && height == dimension.height );
		}
		
		public function setSize ( dimension : Dimension ) : void
		{
			width = dimension.width;
			height = dimension.height;
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify ( this ) + "[" + width + ", " + height +"]";
		}	
	}
}
