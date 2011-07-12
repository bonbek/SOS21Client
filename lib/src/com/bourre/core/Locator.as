package com.bourre.core
{
	import flash.utils.Dictionary;	
	
	public interface Locator
	{
		function isRegistered( key : String ) : Boolean;
		function locate( key : String ) : Object;
		function add( d : Dictionary ) : void;
	}
}