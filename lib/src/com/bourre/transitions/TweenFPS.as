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
 
package com.bourre.transitions 
{ 
	import com.bourre.log.PixlibStringifier;
	import flash.events.Event;
	
	
	public class TweenFPS extends AbstractTween
		implements TickListener
	{
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		
		protected var _nCurrentFPS:Number;		
	
		
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
	
		public function TweenFPS( 	oT : Object,
									sP : String, 
									nE:Number, 
									nRate:Number, 
									nS:Number = NaN, 
									fE:Function = null, 
									gP : String = null)
		{
			super( oT, sP, nE, nRate, nS, fE, gP );
			_oBeacon = FPSBeacon.getInstance();
		}

		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	
		public override function execute( e : Event = null ) : void
		{
			_nCurrentFPS = 0;
			super.execute();		
		}
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		public override function isMotionFinished() : Boolean
		{
			return ++_nCurrentFPS >= _nRate;
		}
		
		public override function onUpdate() : void
		{
			super.onUpdate();
			_oSetter.setValue( _fE( _nCurrentFPS, _nS, _nE - _nS, _nRate ) );
		}
	}
}