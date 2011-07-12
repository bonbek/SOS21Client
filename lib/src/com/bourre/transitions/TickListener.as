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

	/**
	 * A <code>TickListener</code> object is an object which will
	 * change in time according to the <code>TickBeacon</code> it
	 * listen. A <code>TickListener</code> object is considered as
	 * playing only if it is registered as listener of a beacon, even
	 * if this beacon is not currently playing. It offers to the user
	 * two ways to handle interruption of animations within an 
	 * application, all objects could be paused or resume with a single
	 * call to the <code>start</code> or <code>stop</code> methods of a
	 * beacon, or they could be individually paused or resume by calling
	 * the corresponding methods onto the listeners themselves.
	 * <p>
	 * Concret implementations should provides methods which automatically
	 * register on unregister the object as listener of the specified beacon.
	 * </p><p>
	 * Concret implementations should also provides methods to defines onto
	 * which concret beacon object this object will register itself. 
	 * Implementers can choose to lock the type of beacon onto which the
	 * object register, but in that case the object may suffix its name
	 * with the type of beacon its support (see <a href='TweenFPS.html'>TweenFPS</a>
	 * and <a href='TweenMS.html'>TweenMS</a> for concret example of that rule).
	 * If the object supports all kind of beacon, it should provides methods to 
	 * dynamically change the beacon it will listen, even if it's already
	 * playing when the call occurs.
	 * </p> 
	 * @author 	Francis Bourre
	 * @author 	Cédric Néhémie
	 * @see		TickBeacon
	 */
	public interface TickListener 
	{
		/**
		 * Method called by the <code>TickBeacon</code> for each
		 * step of time according to its time slicing approach.
		 * <p>
		 * The <code>onTick</code> method is very similar to the
		 * old <code>onEnterFrame</code> method, but doesn't specifically
		 * occurs when entering in a new frame of a frame-based animation.
		 * The tick could be the result of a <code>setInterval</code> call,
		 * or a change in the timecode of a video.
		 * </p> 
		 * @param	e	event dispatched by the beacon object
		 */
		function onTick( e : Event = null ) : void;
	}
}