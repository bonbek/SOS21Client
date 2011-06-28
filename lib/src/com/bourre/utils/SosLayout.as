/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Francis Bourre
 * @version 1.0
 */

package com.bourre.utils {
	import flash.events.*;
	import flash.net.XMLSocket;
	
	import com.bourre.collection.*;
	import com.bourre.log.*;	

	public class SosLayout 
		implements LogListener
	{
		private var _oXMLSocket : XMLSocket;
		private var _bIsConnected : Boolean;
		private var _aBuffer : Array;
		private var _mFormat : HashMap;
		
		public static var IP : String = "localhost";
		public static var PORT : Number = 4445;
		
		public static const DEBUG_FORMAT:String = "DEBUG_FORMAT";
		public static const INFO_FORMAT:String = "INFO_FORMAT";
		public static const WARN_FORMAT:String = "WARN_FORMAT";
		public static const ERROR_FORMAT:String = "ERROR_FORMAT";
		public static const FATAL_FORMAT:String = "FATAL_FORMAT";
		
		public static var DEBUG_KEY:String = '<setKey><name>' + SosLayout.DEBUG_FORMAT + '</name><color>' + 0x1394D6 + '</color></setKey>\n';
		public static var INFO_KEY:String = '<setKey><name>' + SosLayout.INFO_FORMAT + '</name><color>' + 0x12C9AC + '</color></setKey>\n';
		public static var WARN_KEY:String = '<setKey><name>' + SosLayout.WARN_FORMAT + '</name><color>' + 0xFFCC00 + '</color></setKey>\n';
		public static var ERROR_KEY:String = '<setKey><name>' + SosLayout.ERROR_FORMAT + '</name><color>' + 0xFF6600 + '</color></setKey>\n';
		public static var FATAL_KEY:String = '<setKey><name>' + SosLayout.FATAL_FORMAT + '</name><color>' + 0xFF0000 + '</color></setKey>\n';
		
		private static var _oI : SosLayout = null;
		
		public function SosLayout( access : PrivateConstructorAccess )
		{
			_aBuffer = new Array();
			_buildColorKeys();
			_oXMLSocket = new XMLSocket();
			
			_oXMLSocket.addEventListener( Event.CLOSE, onClose );
            _oXMLSocket.addEventListener( Event.CONNECT, onConnect );
            _oXMLSocket.addEventListener( DataEvent.DATA, onDataReceived );
            _oXMLSocket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
            _oXMLSocket.addEventListener( ProgressEvent.PROGRESS, onProgress );
            _oXMLSocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
            
            _oXMLSocket.connect (SosLayout.IP, SosLayout.PORT);
		}
		
		public static function getInstance() : SosLayout
		{
			if ( !(SosLayout._oI is SosLayout) ) 
			{
				SosLayout._oI = new SosLayout( new PrivateConstructorAccess() );
			}
			return SosLayout._oI;
		}
		
		public function getFoldMessage( sTitre : String, sMessage : String, level : LogLevel ) : String
		{
			var s:String = "";
			s += '<showFoldMessage key="' + _mFormat.get( level ) + '">';
			s += '<title>' + sTitre + '</title>';
			s += '<message>' + sMessage + '</message></showFoldMessage>';
			return s;
		}
		
		public function output(  o : Object, level : LogLevel ) : void
		{
			// TODO check if sLevel is important
//			var sLevel : String = level? _mFormat.get( level ) : SosLayout.DEBUG_FORMAT;
			
			var s:String = getFoldMessage	(
												unescape( String(o) ), 
												level.getName() + " " + String(o),
												level
											);

			if (_bIsConnected)
			{
				_output( s );
				
			} else
			{	
				_buffer( s );
			}
		}
		
		public function clearOutput() : void
		{
			_oXMLSocket.send( "<clear/>\n" );
		}
		
		public function onLog( e : LogEvent ) : void
		{
			output( e.message, e.level );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		//
		private function _buildColorKeys() : void
		{
			_mFormat = new HashMap();
	
			_mFormat.put( LogLevel.DEBUG, SosLayout.DEBUG_FORMAT );
			_mFormat.put( LogLevel.INFO, SosLayout.INFO_FORMAT );
			_mFormat.put( LogLevel.WARN, SosLayout.WARN_FORMAT );
			_mFormat.put( LogLevel.ERROR, SosLayout.ERROR_FORMAT );
			_mFormat.put( LogLevel.FATAL, SosLayout.FATAL_FORMAT );
			
			_buffer( SosLayout.DEBUG_KEY );
			_buffer( SosLayout.INFO_KEY );
			_buffer( SosLayout.WARN_KEY );
			_buffer( SosLayout.ERROR_KEY );
			_buffer( SosLayout.FATAL_KEY );
		}
		
		
		private function _buffer( s : String ) : void
		{
			_aBuffer.push( s );
		}
	
		private function _output( s : String ) : void
		{
			_oXMLSocket.send( s );
		}
		
		private function _emptyBuffer() : void
		{
			var l : Number = _aBuffer.length;
			for (var i : Number = 0; i<l; i++) _output( _aBuffer[i] );
		}
		
		//
		private function onClose( event : Event ) : void 
		{
            trace( "onClose(" + event + ")" );
        }

        private function onConnect( event : Event ) : void 
        {
            trace( "onConnect(" + event + ")" );
            
            _emptyBuffer();
			_bIsConnected = true;
        }

        private function onDataReceived( event : DataEvent ) : void 
        {
            trace( "onDataReceived(" + event + ")" );
        }

        private function onIOError( event : IOErrorEvent ) : void 
        {
            trace( "onIOError(" + event + ")" );
        }

        private function onProgress( event : ProgressEvent ) : void 
        {
            trace( "onProgress( loaded:" + event.bytesLoaded + ", total: " + event.bytesTotal + ")" );
        }

        private function onSecurityError( event : SecurityErrorEvent ) : void 
        {
            trace( "onSecurityError(" + event + ")" );
        }
	}
}

internal class PrivateConstructorAccess {}