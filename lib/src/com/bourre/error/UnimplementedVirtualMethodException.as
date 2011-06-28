package com.bourre.error
{
	public class UnimplementedVirtualMethodException 
		extends Error
	{
		public function UnimplementedVirtualMethodException( message : String = "" )
		{
			super( message );
		}
	}
}