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
package com.bourre.commands 
{
	import flash.events.Event;
	
	import com.bourre.log.PixlibStringifier;
	import com.bourre.transitions.FPSBeacon;
	import com.bourre.transitions.TickListener;	

	/**
	 * 
	 */
	public class CommandFPS	implements TickListener
	{
		protected var _oT : Object;
		protected var _oS : Object;
		protected var _nID : Number;
		protected var _nL : Number;
		
		public function CommandFPS()
		{
			_oT = new Object();
			_oS = new Object();
			_nID = 0;
			_nL = 0;
			FPSBeacon.getInstance().addTickListener(this);
		}
		
		public function onTick( e : Event = null ) : void
		{
			for (var s:String in _oT) _oT[s].execute();
		}
		
		public function push(oC:Command) : String
		{
			return _push( oC, _getNameID() );
		}

		public function pushWithName(oC:Command, sN:String = null) : String
		{
			sN = (sN == null) ? _getNameID() : sN;
			return _push(oC, sN);
		}
		
		public function delay(oC:Command) : void
		{
			var sN:String = _getNameID();
			var d:Delegate = new Delegate( _delay, oC, sN);
			_oT[sN] = d;
		}
		
		public function remove(oC:Command) : Boolean
	  	{
			for(var s:String in _oT) if (_oT[s] == oC) return _remove(s);
			return false;
	  	}
	
		public function removeWithName(sN:String) : Boolean
		{
			return _oT.hasOwnProperty(sN) ? _remove(sN) : false;
		}
			
		public function stop(oC:Command) : Boolean
		{
			for (var s:String in _oT) if (_oT[s] == oC) return _stop(s);
			return false;
		}
		
		public function stopWithName(sN:String) : Boolean
		{
			return (_oT.hasOwnProperty(sN)) ? _stop(sN) : false;
		}
	
		public function resume(oC:Command) : Boolean
		{
			for (var s:String in _oS) if (_oS[s] == oC) return _resume(s);
			return false;
		}
		
		public function resumeWithName(sN:String) : Boolean
		{
			return (_oS.hasOwnProperty(sN)) ? _resume(sN) : false;
		}

		public function getLength() : Number
		{
			return _nL;
		}
		
		public function removeAll() : void
		{
			_oT = new Object();
			_oS = new Object();
			_nL = 0;
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		//
		protected function _push(oC:Command, sN:String) : String
		{
			if( _oT.hasOwnProperty( sN ) )
			{
				_oT[sN] = oC;
			}
			else
			{
				_oT[sN] = oC;
				_nL++;
			}
			
			oC.execute();
			return sN;
		}
		
		protected function _getNameID() : String
		{
			while (_oT.hasOwnProperty('_C_' + _nID)) _nID++;
			return '_C_' + _nID;
		}
		
		protected function _remove(s:String) : Boolean
		{
			delete _oT[s];
			_nL--;
			return true;
		}
		
		protected function _stop(s:String) : Boolean
		{
			_oS[s] = _oT[s];
			delete _oT[s];
			return true;
		}
		
		protected function _resume(s:String) : Boolean
		{
			var oC:Command = _oS[s];
			delete _oS[s];
			oC.execute();
			_oT[s] = oC;
			return true;
		}
		
		protected function _delay(oC:Command, sN:String) : void
		{
			removeWithName(sN);
			oC.execute();
		}
	}
}