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
	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	
	import com.bourre.log.PixlibStringifier;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class MultiTweenMS 
		extends AbstractMultiTween
		implements Tween, TickListener
	{
		protected var _nCurrentMS:Number;
		protected var _nM : Number;
		
		public function MultiTweenMS( 	t : Object, 
										p : Array, 
										e : Array, 
										n : Number, 
										s : Array = null, 
										f : Function = null,
										gP : Array = null )
		{
			super( t, p, e, n, s, f, gP );
			_oBeacon = FPSBeacon.getInstance();
		}
		
		/**
		 * Start tweening.
		 * 
		 * <p>{@link AbstractTween#execute} overridding.
		 * 
		 * <p>{@link com.bourre.commands.Command} polymorphism.
		 */
		public override function execute( e : Event = null ) : void
		{
			_nCurrentMS = getTimer();
			super.execute();		
		}
		public override function resume() : void
		{
			_nCurrentMS = getTimer() - (_nM - _nCurrentMS);
			super.resume();
		}
		public override function stop() : void
		{
			super.stop();
			_nM = getTimer();
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		//
		public override function isMotionFinished() : Boolean
		{
			return getTimer() - _nCurrentMS >= _nRate;
		}
	
		public override function onUpdate( sV : Number, eV : Number ) : Number
		{
			return _fE( getTimer() - _nCurrentMS, sV, eV - sV, _nRate );
		}
	}
}