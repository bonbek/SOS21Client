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
	import com.bourre.commands.Suspendable;		

	/**
	 * The <code>Tween</code> interface defines a tween, a property animation
	 * performed on a target object over a period of time. That animation
	 * can be a change in position, a change in size, a change in visibility,
	 * or other types of animations.
	 * <p>
	 * When defining tween effects, you typically create an instance of
	 * a concret <code>Tween</code> class. A tween instance accepts the
	 * startValue, endValue, and duration properties, and an optional
	 * easing function to define the animation.
	 * </p><p>
	 * Concret tweens doesn't specifically work on a special member type.
	 * A tween should work for both properties and methods of an object.
	 * See the <a href='../commands/Accessor.html'>Accessor</a> interface
	 * for a description of members access.
	 * </p> 
	 * @author	Cédric Néhémie
	 * @see		com.bourre.code.Accessor
	 * @see		com.bourre.commands.TimelineCommand
	 */
	public interface Tween extends Suspendable
	{
		/**
		 * Defines the easing function used by this <code>Tween</code> object.
		 * <p>
		 * Easing function can't be null, concret implementation must provide
		 * a default function if no function is defined, or if the passed-in
		 * function is <code>null</code>.
		 * </p>
		 * @param	f	easing function for this tween, the function must implements
		 * 				the following signature :
		 * 				<listing>function easingFunc( t : Number, b : Number, c : Number, d : Number ) : Number</listing>
		 * 				Where : <ul>
		 * 				<li><code>t</code> is the elapsed time since start in milliseconds</li>		 * 				<li><code>b</code> is the the start value</li>		 * 				<li><code>c</code> is the size of the value range such <code>c = endValue - startValue</code></li>		 * 				<li><code>d</code> is the duration of the tween in milliseconds</li>		 * 				<li>the returned value is the the interpolated value</li>
		 * 				</ul>
		 */
		function setEasing( f : Function ) : void;
	}
}