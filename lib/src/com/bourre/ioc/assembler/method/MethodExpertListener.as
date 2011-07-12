package com.bourre.ioc.assembler.method
{
	import com.bourre.ioc.assembler.method.MethodEvent ;
	
	public interface MethodExpertListener
	{
		function onBuildMethod( e : MethodEvent ) : void;
	}
}