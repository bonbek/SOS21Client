package com.bourre.commands
{
	import com.bourre.transitions.FPSBeacon;
	
	public class CommandManagerFPS extends CommandFPS
	{
		private static var _oInstance:CommandManagerFPS;
	
		public static function getInstance() : CommandManagerFPS
		{
			return (_oInstance) ? _oInstance : CommandManagerFPS._init();
		}
		private static function _init() : CommandManagerFPS
		{
			_oInstance = new CommandManagerFPS( new PrivateCommandManagerFPSConstructorAccess() );
			return _oInstance;
		}
		public static function release() : void
		{
			FPSBeacon.getInstance().removeTickListener( _oInstance );
			_oInstance = null;
		}
		public function CommandManagerFPS ( o : PrivateCommandManagerFPSConstructorAccess )
		{}
	}
}
internal class PrivateCommandManagerFPSConstructorAccess {}