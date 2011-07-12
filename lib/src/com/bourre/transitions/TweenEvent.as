package com.bourre.transitions 
{ 
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
	
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;
	
	/**
	 * <code>TweenEvent</code> defines event model for Tween API.
	 * <p>
	 * Based on <code>com.bourre.events.BasicEvent</code> class.
	 * </p><p>
	 * <code>TweenEvent</code> events are broadcasted by <code>Tween</code>
	 * instances. 
	 * </p>
	 * @author Francis Bourre
	 */
	
	public class TweenEvent extends BasicEvent
	{
		/**
		 * Broadcasted to listeners when tween starts.
		 */
		public static var onStartEVENT:String = "onStart";
		
		/**
		 * Broadcasted to listeners when tween stops.
		 */
		public static var onStopEVENT:String = "onStop";
		
		/**
		 * Broadcasted to listeners when tween is finished.
		 */
		public static var onMotionFinishedEVENT:String = "onMotionFinished";
		
		/**
		 * Broadcasted to listeners when property value is updated.
		 */
		public static var onMotionChangedEVENT:String = "onMotionChanged";
		
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		
		private var _oTween:AdvancedTween;
		
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Constructs a new <code>TweenEvent</code> instance broadcasted by <code>Tween</code> 
		 * family classes.
		 * 
		 * @param	e		name of the event type.
		 * @param	tween 	<code>Tween</code> instance which trigger the event.
		 * @example
		 * <listing>
		 *   var e:TweenEvent = new TweenEvent( TweenEvent.onMotionFinishedEVENT, this );
		 * </listing>
		 */
		public function TweenEvent( e : String, tween : AdvancedTween )
		{
			super(e);
			_oTween = tween;
		}
		
		/**
		 * Returns <code>Tween</code> event source.
		 * 
		 * @return <code>Tween</code> instance
		 * @example 
		 * <listing>
		 *   var t:TweenMS = e.getTween();
		 * </listing>
		 */
		public function getTween() : AdvancedTween
		{
			return _oTween;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * <p>
		 * <code>com.bourre.events.BasciEvent#toString</code> overridding
		 * </p>
		 * @return <code>String</code> representation of this instance
		 */
		public override function toString() : String
		{
			return PixlibStringifier.stringify( this ) + type + ', ' + getTween();
		}
	}
}