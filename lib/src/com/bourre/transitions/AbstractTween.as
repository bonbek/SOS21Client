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
	import flash.events.Event;
	
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.core.Accessor;
	import com.bourre.core.AccessorFactory;
	import com.bourre.core.PropertyAccessor;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.utils.ClassUtils;	

	/**
	 * 
	 */
	public class AbstractTween extends AbstractSyncCommand implements AdvancedTween, TickListener
	{	
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		protected var _nS:Number; 
		protected var _nE:Number;
		protected var _nRS:Number;
		protected var _nRE:Number;
		protected var _nRate:Number;
		protected var _fE:Function;
		
		protected var _oSetter:Accessor;
		protected var _oBeacon : TickBeacon;
		
		protected var _eOnStart : TweenEvent;
		protected var _eOnStop : TweenEvent;
		protected var _eOnMotionChanged : TweenEvent;
		protected var _eOnMotionFinished : TweenEvent;
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		public function AbstractTween( oT : Object, 
									   sP : String, 
									   nE : Number, 
									   nRate : Number, 
									   nS : Number = NaN, 
									   fE : Function = null,
									   gP : String = null )
		{			
			if( !ClassUtils.isImplementedAll( this, "com.bourre.transitions:AbstractTween", "isMotionFinished", "onUpdate" ) )
			{
				PixlibDebug.ERROR ( this + " have to implements virtual methods : isMotionFinished & onUpdate" );
				throw new UnimplementedVirtualMethodException ( this + " have to implements virtual methods : isMotionFinished & onUpdate" );
			}
			
			_buildAccessor( oT, sP, gP, nS );
			
			_bIsRunning = false;
			_nRE = nE;
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
				onUpdate();
			}
		}
		
		public function isMotionFinished () : Boolean
		{	
			return false;
		}
		
		public function onUpdate () : void
		{
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
		}
		
		public function yoyo() : void
		{
			stop();
			
			setEndValue( _nRS );
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
			if ( isNaN(_nRS) ) 
			{
				PixlibDebug.FATAL( this + " has no start value." );
				
			} else
			{
				_nS = _nRS;
				_oSetter.setValue( _nS );
				_nE = _nRE;
				_bIsRunning = true;
				_oBeacon.addTickListener(this);
				_oEB.broadcastEvent( _eOnStart );
			}
		}
		
		public function getTarget() : Object
		{
			return _oSetter.getTarget();
		}
		
		public function setTarget( o : Object ) : void
		{
			if ( isRunning() )
			{
				PixlibDebug.WARN( this + ".setTarget() invalid call while playing." );
			} else
			{
				_buildAccessor( o, _oSetter.getSetterHelper(), _oSetter.getGetterHelper() );
			}
		}
		
		public function getProperty() : String
		{
			return PropertyAccessor(_oSetter).getProperty();
		}
		
		public function setProperty( p : String ) : void
		{
			if ( isRunning() )
			{
				PixlibDebug.WARN( this + ".setProperty() invalid call while playing." );
			} else
			{
				var target : Object = _oSetter.getTarget();
				_buildAccessor( target, p,  target[p] );
			}
		}		
		
		public function setStartValue( n : Number ) : void
		{
			_nRS = n;
		}
		
		public function getStartValue () : Number
		{
			return _nRS;
		}
		
		public function setEndValue( n : Number ) : void
		{
			_nRE = n;
		}
		
		public function getEndValue () : Number
		{
			return _nRE;
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
		
		protected function _buildAccessor( o : Object, sP : String, gP : String = null, nS : Number = NaN ) : void
		{
			_oSetter = AccessorFactory.getAccessor( o, sP, gP );
			if (!isNaN(nS)) _nRS = nS;
			else _nRS = _oSetter.getValue();
		}
		
		protected function _onMotionEnd() : void
		{
			_bIsRunning = false;
			_oBeacon.removeTickListener( this );
			
			onUpdate();
			_oSetter.setValue( _nE );
			
			fireCommandEndEvent();
			_oEB.broadcastEvent( _eOnMotionFinished );
		}
	}
}