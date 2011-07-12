package com.bourre.ioc.assembler.property
{
	import com.bourre.ioc.assembler.property.PropertyEvent;
	
	public interface PropertyExpertListener
	{
		function onBuildProperty( e : PropertyEvent ) : void ;
	}
}