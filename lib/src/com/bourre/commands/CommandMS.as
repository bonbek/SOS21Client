package com.bourre.commands { 
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
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import com.bourre.log.PixlibStringifier;	

	public class CommandMS
	{
		protected var _oT:Object;
		protected var _nID:Number;
		protected var _nL : Number;
			
		protected static var _EXT:String = '_C_';
		
		public function CommandMS()
		{
			_oT = new Object();
			_nID = 0;
			_nL = 0;
		}
		
		public function push(oC:Command, nMs:Number) : String
		{
			var sN:String = _getNameID();
			if (_oT.hasOwnProperty(sN)) _remove(sN);
			
			return _push( oC, nMs, sN );
		}
		
		public function pushWithName(oC:Command, nMs:Number, sN:String=null) : String
		{
			if (sN == null) 
			{
				sN =_getNameID();
			} 
			else if (_oT.hasOwnProperty(sN)) 
			{
				_remove(sN);
			}
			
			return _push( oC, nMs, sN );
		}
		
		public function delay(oC:Command, nMs:Number) : void
		{
			var sN:String = _getNameID();
			var o:Object = _oT[sN] = new Object();
			o.cmd = oC;
			o.ID = setInterval( _delay, nMs, sN);
		}
		
		public function remove(oC:Command) : Boolean
	  	{
			for (var s:String in _oT) if (_oT[s].cmd == oC) return _remove(s);
			return false;
	  	}
		
		public function removeWithName(sN:String) : Boolean
		{
			return (_oT.hasOwnProperty(sN)) ? _remove(sN) : false;
		}
		
		public function stop(oC:Command) : Boolean
		{
			for (var s:String in _oT) if (_oT[s].cmd == oC) return _stop(s);
			return false;
		}

		public function stopWithName(sN:String) : Boolean
		{
			return (_oT.hasOwnProperty(sN)) ? _stop(sN) : false;
		}
		
		public function resume(oC:Command) : Boolean
		{
			for (var s:String in _oT) if (_oT[s].cmd == oC) return _notify(s);
			return false;
		}
		
		public function resumeWithName(sN:String) : Boolean
		{
			return (_oT.hasOwnProperty(sN)) ? _notify(sN) : false;
		}
		
		public function getLength() : Number
		{
			return _nL;
		}
		
		public function removeAll() : void
		{
			for (var s:String in _oT) _remove(s);
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		//
		protected function _push(oC:Command, nMs:Number, sN:String) : String
		{
			var o:Object = new Object();
			o.cmd = oC;
			o.ms = nMs;
			o.ID = setInterval( oC.execute , nMs);
			_oT[sN] = o;
			_nL++;
			
			oC.execute();
			
			return sN;
		}
		
		protected function _getNameID() : String
		{
			while (_oT.hasOwnProperty(CommandMS._EXT + _nID)) _nID++;
			return CommandMS._EXT + _nID;
		}
		
		protected function _remove(s:String) : Boolean
		{
			clearInterval(_oT[s].ID);
			delete _oT[s];
			_nL--;
			return true;
		}
		
		protected function _stop(s:String) : Boolean
		{
			clearInterval(_oT[s].ID);
			return true;
		}
		
		protected function _notify(s:String) : Boolean
		{
			_oT[s].ID = setInterval( Command(_oT[s].cmd).execute, _oT[s].ms);
			return true;
		}
		
		protected function _delay(sN:String) : void
		{
			var o:Object = _oT[sN];
			clearInterval(o.ID);
			o.cmd.execute();
			delete _oT[sN];
		}
	}
}