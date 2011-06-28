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
package com.bourre.transitions {
	import flash.events.Event;
	
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.core.AccessorComposer;
	import com.bourre.core.AccessorFactory;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.utils.ClassUtils; 

	public class AbstractMultiTween extends AbstractSyncCommand
									implements AdvancedTween, TickListener
	{	
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		protected var _aS:Array; 
		protected var _aE:Array;
		protected var _aRS:Array;
		protected var _aRE:Array;
		protected var _nRate:Number;
		protected var _fE:Function;
		
		protected var _oSetter : AccessorComposer;
		protected var _oBeacon : TickBeacon;
		
		protected var _eOnStart : TweenEvent;
		protected var _eOnStop : TweenEvent;
		protected var _eOnMotionChanged : TweenEvent;
		protected var _eOnMotionFinished : TweenEvent;
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		public function AbstractMultiTween( 
									   		oT : Object, 
									   		sP : Array, 
									   		aE : Array, 
									   		nRate : Number, 
									   		aS : Array = null, 
									   		fE : Function = null,
									   		gP : Array = null )
		{
			if( !ClassUtils.isImplementedAll( this, "com.bourre.transitions:AbstractMultiTween", "isMotionFinished", "onUpdate" ) )
			{
				PixlibDebug.ERROR ( this + " have to implements virtual methods : isMotionFinished & onUpdate" );
				throw new UnimplementedVirtualMethodException ( this + " have to implements virtual methods : isMotionFinished & onUpdate" );
			}
			_buildAccessor( oT, sP, gP, aS );
			
			_bIsRunning = false;
			_aRE = aE;
			_nRate = nRate;
			setEasing(fE);
			
			_eOnStart = new TweenEvent ( TweenEvent.onStartEVENT, this );
			_eOnStop = new TweenEvent ( TweenEvent.onStopEVENT, this );
			_eOnMotionChanged = new TweenEvent ( TweenEvent.onMotionChangedEVENT, this );
			_eOnMotionFinished = new TweenEvent ( TweenEvent.onMotionFinishedEVENT, this );
		}
		
		public static function noEasing( t : Number,  b : Number,  c : Number, d : Number ) : Number 
		{
			return c * t / d + b;
		}
		
		public function onTick( e : Event = null ) : void
		{
			if ( isMotionFinished() )
			{
				_onMotionEnd();
			} 
			else
			{
				_update();
			}
		}
		
		public function isMotionFinished () : Boolean
		{	
			return false;
		}
		
		public function onUpdate ( sV : Number, eV : Number ) : Number
		{
			return 0;
		}
		
		public function _update() : void
		{
			var a : Array = new Array();
			var l : Number = _aE.length;
			for ( var i : Number= 0; i < l; i++ ) a.push( onUpdate( _aS[i], _aE[i] ) );
			_oSetter.setValue( a );
			_oEB.broadcastEvent( _eOnMotionChanged );	
		}
		
		public function setEasing( f : Function ) : void
		{
			_fE = ( f != null ) ?  f : AbstractTween.noEasing;
		}
		
		public function getEasing() : Function
		{
			return _fE;
		}
		
		public function getDuration() : Number
		{
			return _nRate;
		}

		
		public function reset() : void
		{}
		
		public function start() : void
		{
			execute();
			_oEB.broadcastEvent( _eOnStart );
		}
		
		public function yoyo() : void
		{
			stop();
			
			setEndValue( _aRS );
			setStartValue( _oSetter.getValue() );
			
			start();
		}
		
		public function stop() : void
		{
			_oBeacon.removeTickListener(this);
			_bIsRunning = false;
			_oEB.broadcastEvent( _eOnStop );
		}
		
		public function resume() : void
		{
			_bIsRunning = true;
			_oBeacon.addTickListener(this);
			
		}
		
		public override function execute( e : Event = null ) : void
		{
			if ( !_aRS ) 
			{
				PixlibDebug.FATAL( this + " has no start value." );
				
			} else
			{
				_aS = _aRS;
				_oSetter.setValue( _aS );
				_aE = _aRE;
				_bIsRunning = true;
				_oBeacon.addTickListener(this);
			}
		}

		public function getTarget () : Object
		{
			return _oSetter.getTarget();
		}
		
		public function setStartValue( a : Array ) : void
		{
			_aRS = a;
		}
		
		public function getStartValue () : Array
		{
			return _aRS;
		}
		
		public function setEndValue( a : Array ) : void
		{
			_aRE = a;
		}
		
		public function getEndValue () : Array
		{
			return _aRE;
		}

		
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}

		public function setDuration( n : Number ) : void
		{
			_nRate = n;
		}
		
		public function addListener( listener : TweenListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : TweenListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		protected function _buildAccessor( o : Object, sP  : Array, gP : Array = null, nS : Array = null ) : void
		{
			_oSetter = AccessorFactory.getMultiAccessor( o, sP, gP );
			if (nS) _aRS = nS;
			else _aRS = _oSetter.getValue();
		}
		
		protected function _onMotionEnd() : void
		{
			_bIsRunning = false;
			_oBeacon.removeTickListener( this );
			
			_update();
			_oSetter.setValue( _aE );
			
			fireCommandEndEvent();
			_oEB.broadcastEvent( _eOnMotionFinished );
		}
	}
}