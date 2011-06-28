package com.bourre.utils {
	import flash.events.SecurityErrorEvent;	import flash.events.StatusEvent;	import flash.net.LocalConnection;	import flash.utils.clearInterval;	import flash.utils.getQualifiedClassName;	import flash.utils.setInterval;		import com.bourre.log.LogEvent;	import com.bourre.log.LogListener;	import com.bourre.log.PixlibStringifier;	
	public class AirLoggerLayout implements LogListener
	{
		/*---------------------------------------------------------------
				STATIC MEMBERS
		----------------------------------------------------------------*/
		
		private static var _oI : AirLoggerLayout = null;
		
		protected static const LOCALCONNECTION_ID : String = "_AIRLOGGER_CONSOLE";
		protected static const OUT_SUFFIX : String = "_IN";
		protected static const IN_SUFFIX : String = "_OUT";
		
		static protected var ALTERNATE_ID_IN : String = "";
		
		public static function getInstance () : AirLoggerLayout
		{
			if( _oI == null )
				_oI = new AirLoggerLayout ( new PrivateConstructorAccess() );
				
			return _oI;
		}
		public static function release () : void
		{
			_oI.close();
			_oI = null;
		}
		
		/*---------------------------------------------------------------
				INSTANCE MEMBERS
		----------------------------------------------------------------*/
		
		protected var _lcOut : LocalConnection;
		protected var _lcIn : LocalConnection;
		protected var _sID : String;
		
		protected var _bIdentified : Boolean;
		protected var _bRequesting : Boolean;
		
		protected var _aLogStack : Array;
		protected var _nPingRequest : Number;
		
		protected var _sName : String;
		
		public function AirLoggerLayout ( access : PrivateConstructorAccess )
		{
            try
            {
            	_lcOut = new LocalConnection();
				_lcOut.addEventListener( StatusEvent.STATUS, onStatus, false, 0, true);
	            _lcOut.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
	            
	            _lcIn = new LocalConnection();
	            _lcIn.client = this;
	            _lcIn.allowDomain( "*" );
	            
				connect();
	            
	            _aLogStack = new Array();
	            
	            _bIdentified = false;
				_bRequesting = false;
            }
            catch ( e : Error )
            {
            	// TODO Notifier le AirLogger que le channel de requete est déja occupé
            	// se reconnecter sur un autre
            }
		}
		
		protected function connect () : void
		{
			var b : Boolean = true;
			
			while( b )
			{
				try
				{
		           _lcIn.connect( _getInConnectionName( ALTERNATE_ID_IN ) );
		           
		           b = false;
		           break;
				}
				catch ( e : Error )
				{
					_lcOut.send( _getOutConnectionName(), "mainConnectionAlreadyUsed", ALTERNATE_ID_IN );
					
					ALTERNATE_ID_IN += "_";
				}
			}
		}
		
		public function close() : void
		{
			_lcIn.close();
		}
		
		public function focus() : void
		{
			_send ( new AirLoggerEvent ( "focus" ) );
		}
		
		public function clear() : void
		{
			_send ( new AirLoggerEvent ( "clear" ) );
		}
		
		public function setName ( s : String ) : void
		{
			_sName = s;
			
			if( _bIdentified )
			{
				_lcOut.send( _getOutConnectionName( _sID ), "setTabName", _sName  );
			}
		}
		
		public function setID ( id : String ) : void
		{
			try
			{
				clearInterval( _nPingRequest );
				_sID = id;
				
				_lcIn.close();
				_lcIn.connect( _getInConnectionName( _sID ) );
				
				_lcOut.send( _getOutConnectionName() , "confirmID", id, _sName  );
				
				_bIdentified = true;
				_bRequesting = false;
				
				var l : Number = _aLogStack.length;
				if( l != 0 )
				{
					for(var i : Number = 0; i < l; i++ )
					{
						_send( _aLogStack.shift() as AirLoggerEvent );
					}
				}
			}
			catch ( e : Error )
			{
				_lcIn.connect( _getInConnectionName( ALTERNATE_ID_IN ) );
				
				_lcOut.send( _getOutConnectionName() , "idAlreadyUsed", id );
			} 
		}
		
		public function pingRequest () : void
		{
			_lcOut.send( _getOutConnectionName() , "requestID", ALTERNATE_ID_IN  );
		}
		
		public function isRequesting () : Boolean
		{
			return _bRequesting;
		}
		
		public function isIdentified () : Boolean
		{
			return _bIdentified;
		}
		
		protected function _send ( evt : AirLoggerEvent ) : void
		{
			if( _bIdentified )
			{
				_lcOut.send( _getOutConnectionName( _sID ), evt.type, evt );
			}
			else
			{
				_aLogStack.push( evt );
				
				if( !_bRequesting )
				{					
					pingRequest();
					_nPingRequest = setInterval( pingRequest, 1000 );
					_bRequesting = true;
				}
			}
		}		
		protected function _getInConnectionName ( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + IN_SUFFIX;
		}
		protected function _getOutConnectionName ( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + OUT_SUFFIX;
		}
		
		/*---------------------------------------------------------------
				EVENT HANDLING
		----------------------------------------------------------------*/
		
		public function onLog( e : LogEvent ) : void
		{
			if( !e ) return;
			
			var evt : AirLoggerEvent = new AirLoggerEvent ( "log", 
															e.message,
															e.level.getLevel(),
															new Date(),
															getQualifiedClassName( e.message ) ); 
			
			_send( evt );
		}
		
		private function onStatus( event : StatusEvent ) : void 
		{
         	// trace( "onStatus( " + event + ")" );
        }

        private function onSecurityError( event : SecurityErrorEvent ) : void 
        {
            // trace( "onSecurityError(" + event + ")" );
        }
        
        public function toString () : String
        {
        	return PixlibStringifier.stringify( this );
        }
	}
}
import com.bourre.events.BasicEvent;
internal class AirLoggerEvent extends BasicEvent
{
	public var message : *;
	public var level : uint;
	public var date : Date;
	public var messageType : String;
	
	public function AirLoggerEvent( sType : String, message : * = null, level : uint = 0, date : Date = null, messageType : String = null ) 
	{
		super( sType, null );
		
		this.message = message;
		this.level = level;
		this.date = date;
		this.messageType = messageType;
	}
}

internal class PrivateConstructorAccess {}