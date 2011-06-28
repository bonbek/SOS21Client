package com.sos21.debug {
	
	import flash.external.ExternalInterface;
	import flash.utils.*;
	import com.luminicbox.log.*;
	
	public class log {
		
		public static var isOn:Boolean = true;
		private static var _oI:log;
		private static var _logger:Logger;		
		
		public static function LOG(...args:Array):void
		{
			if (!log.isOn) return;
			for (var i:int; i<args.length; i++) {				
				trace(args[i]);
//				_logger.log( args[i] );
			}
		}
		
		public static function DEBUG(...args:Array):void
		{
			if (!log.isOn) return;
			for (var i:int; i<args.length; i++) {
				trace(args[i]);
//				_logger.log( args[i] );
			}
		}
		
		public static function INFO(...args:Array):void
		{
			if (!log.isOn) return;
			for (var i:int; i<args.length; i++) {
				trace(args[i]);
//				_logger.log( args[i] );
			}
		}
		
		
		public static function WARN(...args:Array):void
		{
			if (!log.isOn) return;
			for (var i:int; i<args.length; i++) {
				trace(args[i]);
//				_logger.log( args[i] );
			}
		}

		public static function ERROR(...args:Array):void
		{
			if (!log.isOn) return;
			for (var i:int; i<args.length; i++) {
				trace(args[i]);
//				_logger.log( args[i] );
			}
		}

		public static function FATAL(...args:Array):void
		{
			if (!log.isOn) return;
			for (var i:int; i<args.length; i++) {
				trace(args[i]);
//				_logger.log( args[i] );
			}
		}

		
		/**
		 * Initialisation du log
		 *
		 * une seule instance possible
		 */
		public static function initialize():log
		{
			if (_oI == null)
			{
				_oI = new log(arguments.callee);
				_logger = new Logger();
				_logger.addPublisher(new ConsolePublisher());
			}
			
			return _oI;
		}
		
		
		public function log(caller:Function = null)
		{			
			if (caller != log.initialize)
				throw new Error ( "sos21MMO.tools est un Singelton, utillisez log.initialize() à la place" );
			
			if (log._oI != null)
				throw new Error( "Une seule instanciation de log est possible" );
		}
		
		
	}
	
	
}