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
package com.bourre.events 
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import com.bourre.collection.*;
	import com.bourre.commands.Delegate;
	import com.bourre.error.*;
	import com.bourre.log.*;	

	/**
	 * The <code>EventBroadcaster</code> class is the cornerstone of
	 * the Lowra event system. The main reason which explain the presence
	 * of this object whereas the existence of the native <code>EventDispatcher</code>
	 * class is the lack of flexibility of that class :
	 * <ul>
	 * <li>It's not possible to add an object as listener for many events in a single call.</li>
	 * <li>It's not possible to force the presence of specific function in a listener object.</li>
	 * <li>It's not possible to reuse an event previously dispatched without having to create
	 * a custom event object which override the <code>clone</code> function.</li>
	 * </ul>
	 * <p>
	 * With the <code>EventBroadcaster</code> class its possible to work with many kinds
	 * of listeners, as listed below :
	 * <ul>
	 * <li>Method closure, or delegate method. You simply have to pass a reference to the
	 * function in function for register/unregister listeners, then that method is called
	 * with the event object as argument.</li>	 * <li>Objects implementing specific listener interface (as with Swing in java), in that
	 * case the function with the same name that the event type is called with the event
	 * object as argument.</li>
	 * <li>An object which implement the <code>handleEvent</code> function, in that case, 
	 * if the object doesn't have a function with a name corresponding to the event type
	 * the <code>handleEvent</code> function is called with the event object as argument.</li>
	 * </ul>
	 * </p><p>
	 * The Lowra's event broadcaster also offer many methods to dispath event from
	 * different type of events object. More formally, it's possible to dispatch 
	 * an event object, or an anonymous object which will be converted into a 
	 * <code>DynBasicEvent</code> before the broadcast, all of this properties are
	 * then copy into this event object.
	 * </p><p>
	 * Another big difference with the native dispatcher is the fact that listeners
	 * are systematically stored using weak references, restricting the usage of
	 * anonymous listeners which can't be unregistered due to the lack of reference
	 * to it. 
	 * </p><p>
	 * Composition is privileged over inheritance by the use of a source object 
	 * parameter for the broadcaster. That property, if set, result in that all
	 * event objects dispatched by the <code>EventBroadcaster</code> which have
	 * their <code>target</code> set to <code>null</code> will have that object
	 * as source instead of the dispatcher itself.
	 * </p><p>
	 * Optionally the <code>EventBroadcaster</code> can restrict the type 
	 * of listeners to a specific type, in that case the broadcaster only
	 * accept the registration of objects which implements or extends the
	 * specified <code>Class</code>.
	 * </p>
	 * @author Francis Bourre
	 */
	public class EventBroadcaster
	{
		private static var _oI : EventBroadcaster = null;

		private var _oSource : Object;
		private var _mAll : Collection;
		private var _mType : HashMap;
		private var _mEventListener : HashMap;
		private var _cType : Class;
		private var _mDelegate : HashMap;
		
		/**
		 * Creates an new <code>EventBroadcaster</code> object with the passed-in
		 * <code>source</code> object as source for events. If the <code>source</code>
		 * parameter is omitted the source of events will be this event broadcaster.
		 * <p>
		 * Optionnaly the type of listeners objects can be restricted, in that
		 * case you just have to pass the class of listener in the <code>type</code>
		 * parameter.
		 * </p> 
		 * @param	source	an object used as target instead of this event broadcaster
		 * 					for event object which have a <code>null</code> target
		 * @param	type	an optional class for listener
		 */		public function EventBroadcaster( source : Object = null, type : Class = null )
		{
			_oSource = ( source == null ) ? this : source;

			_mAll = new WeakCollection();
			_mType = new HashMap();
			_mEventListener = new HashMap();
			_mDelegate = new HashMap();

			setListenerType( type );
		}

		/**
		 * Returns a static instance of the class.
		 * <p>
		 * The presence of a <code>getInstance</code> method in the
		 * <code>EventBroadcaster</code> class doesn't mean that the class
		 * is a singleton, it's simply a convenient way to let application
		 * developers broadcasting events that correspond to user gestures
		 * and requests over the whole application.
		 * </p>
		 * 
		 * @return a static instance of the class
		 */
		public static function getInstance() : EventBroadcaster
		{
			if ( !(EventBroadcaster._oI is EventBroadcaster) ) EventBroadcaster._oI = new EventBroadcaster();
			return EventBroadcaster._oI;
		}

		/**
		 * Returns <code>true</code> if this event broadcaster has 
		 * listeners for the passed-in event type.
		 * 
		 * @param	type	name of the event for which look for listener
		 * @return	<code>true</code> if this event broadcaster has 
		 * 			listeners for the passed-in event type
		 */
		public function hasListenerCollection( type : String ) : Boolean
		{
			return _mType.containsKey( type );
		}

		/**
		 * Defines the type of listeners this event broadcaster support.
		 * Functions are not concerned by this restriction.
		 *  
		 * @param	type	the type of the listener this event broadcaster support
		 * @throws 	<code>IllegalArgumentException</code> — If one of the listener
		 * 			already contained in this event broadcaster doesn't match the
		 * 			passed-ni type
		 */
		public function setListenerType( type : Class ) : void
		{
			var i : Iterator = _mAll.iterator();
			while ( i.hasNext() )
			{
				if ( !(i.next() is type) )
				{
					var msg : String = this + ".setListenerType( " + type
					+ " ) failed, your listener must be '" + _cType + "' typed";

					PixlibDebug.ERROR( msg );
					throw( new IllegalArgumentException( msg ) );
				}
			}

			_cType = type;
		}

		/**
		 * Returns a <code>Collection</code> view of listeners for the passed-in
		 * event type. The returned collection is a reference to the internal collection
		 * of this event broadcaster, resulting that there's no guarantee that collection
		 * cannot be altered by another object. If the <code>type</code> parameter is
		 * omitted, the function returns the collection of global listeners objects (all
		 * objects that haven't register for a specific event).
		 * 
		 * @param	type	the event name for which get a collection, if not
		 * 					defined, the collection of global listeners  is returned
		 * @return	<code>Collection</code> of listeners corresponding to the
		 * 			passed-in event type
		 */
		public function getListenerCollection( type : String = null ) : Collection
		{
			return ( type != null ) ? _mType.get( type ) : _mAll;
		}

		/**
		 * Removes the complete collection of listeners for a specified
		 * event type.
		 * 
		 * @param	type	the event type for which remove all listeners
		 */
		public function removeListenerCollection( type : String ) : void
		{
			_mType.remove( type );
		}

		/**
		 * Returns <code>true</code> if the passed-in listener object is registered
		 * as listener for the passed-in event type. If the <code>type</code> parameter
		 * is omitted, the function returns <code>true</code> only if the listener is 
		 * registered as global listener.
		 * <p>
		 * Note : the listener could be either an object or a function.
		 * </p>
		 * 
		 * @param	listener	object to look for registration
		 * @param	type		event type to look at
		 * @return	<code>true</code> if the passed-in listener should receive notification
		 * 			of the passed-in event type
		 */
		public function isRegistered( listener : Object, type : String = null ) : Boolean
		{
			if (type == null)
			{
				if( listener is Function )
				{
					if( _mDelegate.containsKey( listener ) )
					{
						return _mAll.contains( _mDelegate.get( listener ) );
					}
					else return false;
				}
				else
				{
					return _mAll.contains( listener );
				}

			} else
			{
				if ( hasListenerCollection( type ) )
				{
					if( listener is Function )
					{ 
						if( _mDelegate.containsKey( listener ) )
						{
							return getListenerCollection( type ).contains( _mDelegate.get( listener ) );	
						}
						else return false;
					}
					else
					{
						return getListenerCollection( type ).contains( listener );
					}
					
				} else
				{
					return false;
				}
			}
		}

		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this event broadcaster. The function returns <code>true</code>
		 * if the listener have been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * <p>
		 * Note : The <code>addListener</code> function doesn't accept functions
		 * as listener, functions could only register for a single event.
		 * </p>
		 * @param	listener	the listener object to add as global listener
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		public function addListener( listener : Object ) : Boolean
		{
			if ( _cType != null && !( listener is _cType ) )
			{
				var msg0 : String = this + ".addListener( " + listener
				+ " ) failed, your listener must be '" + _cType + "' typed";
			
				PixlibDebug.ERROR( msg0 );
				throw( new IllegalArgumentException( msg0 ) );

			} else if ( listener is Function )
			{
				var msg1 : String = this + ".addListener( " + listener
				+ " ) failed, your listener can't be Function typed";
				
				PixlibDebug.ERROR( msg1 );
				throw( new IllegalArgumentException( msg1 ) );

			} else
			{
				if ( _mAll.add( listener ) ) 
				{
					_flushRef( listener );
					return true;

				} else
				{
					return false;
				}
			}
		}

		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		public function removeListener( listener : Object ) : Boolean
		{
			if ( listener is Function )
			{
				var msg : String = this + ".removeListener( " + listener
				+ " ) failed, your listener can't be Function typed";

				PixlibDebug.ERROR( msg );
				throw( new IllegalArgumentException( msg ) );

			} else
			{
				var b : Boolean = _flushRef( listener );
				b = b || _mAll.contains( listener );
				_mAll.remove( listener );
				return b;
			}
		}

		/**
		 * Adds an event listener for the specified event type.
		 * There is two behaviors for the <code>addEventListener</code>
		 * function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object must
		 * have a function with the same name than <code>type</code> or at least a
		 * <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * A <code>Delegate</code> object is created and then
		 * added as listener for the event type. There is no restriction on the name of 
		 * the function. If the <code>rest</code> is not empty, all elements in it is 
		 * used as additional arguments into the delegate object. 
		 * </ol>
		 * 
		 * @param	type		name of the event for which register the listener
		 * @param	listener	object or function which will receive this event
		 * @param	rest		additional arguments for the function listener
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * @throws 	<code>UnsupportedOperationException</code> — If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		public function addEventListener( type : String, listener : Object, ...rest ) : Boolean
		{
			if ( !( isRegistered( listener ) ) )
			{

				if ( listener is Function )
				{
					if ( _mDelegate.containsKey( listener ) ) 
					{
						return false;

					} else
					{
						var d : Delegate = new Delegate( listener as Function );
						if ( rest ) d.setArgumentsArray( rest );
						_mDelegate.put( listener, d );
						listener = d;
					}

				} else if ( listener.hasOwnProperty( type ) && ( listener[type] is Function ) )
				{
					//

				} else if ( listener.hasOwnProperty( "handleEvent" ) && listener.handleEvent is Function )
				{
					//

				} else
				{
					var msg : String;
					msg = this + ".addEventListener() failed, you must implement '" 
					+ type + "' method or 'handleEvent' method in '" + 
					getQualifiedClassName( listener ) + "' class";

					PixlibDebug.ERROR( msg );
					throw( new UnsupportedOperationException( msg ) );
				}

				if ( !(hasListenerCollection(type)) ) _mType.put( type, new WeakCollection() );

				if ( getListenerCollection( type ).add( listener ) ) 
				{
					_storeRef( type, listener );
					return true;

				} else
				{
					return false;
				}

			} else
			{
				return false;
			}
		}

		/**
		 * Removes the passed-in listener for listening the specified event. The
		 * listener could be either an object or a function.
		 * 
		 * @param	type		name of the event for which unregister the listener
		 * @param	listener	object or function to be unregistered
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			if ( hasListenerCollection( type ) )
			{
				var c : Collection = getListenerCollection( type );

				if ( listener is Function ) listener = _mDelegate.remove( listener );

				if ( c.remove( listener ) )
				{
					_removeRef( type, listener );
					if ( c.isEmpty() ) removeListenerCollection( type );
					return true;

				} else
				{
					return false;
				}

			} else
			{
				return false;
			}
		}

		/**
		 * Removes all listeners registered in this event broadcaster.
		 */
		public function removeAllListeners() : void
		{
			_mAll.clear();
			_mType.clear();
			_mEventListener.clear();
			_mDelegate.clear();
		}

		/**
		 * Returns <code>true</code> if this event broadcaster contains
		 * no listeners for any event.
		 * 
		 * @return 	<code>true</code> if this event broadcaster contains
		 * 			no listeners for any event.
		 */
		public function isEmpty() : Boolean
		{
			return _mAll.isEmpty() && _mType.isEmpty();
		}
		
		/**
		 * Broadcast an event using an anonymous object. 
		 * The only requirement for objects passed as argument in
		 * this function is that they must have a <code>type</code>
		 * property. The <code>target</code> property will be set
		 * with this event broadcaster's source if there is no source
		 * specified.
		 * <p>
		 * The concret event object broadcasted to listener is a
		 * <code>DynBasicEvent</code> decorated with the property
		 * of the passed-in object.
		 * </p>
		 * @param	o	an anonymous object used to decorate a
		 * 				<code>DynBasicEvent</code>
		 * @throws 	<code>UnsupportedOperationException</code> — If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		public function dispatchEvent( o : Object ) : void
		{
			if( o["type"] == null ) 
				PixlibDebug.WARN( "You attempt to broadcast an event which has no type, in " + this );

			var e : DynBasicEvent = new DynBasicEvent( o["type"] );
			for ( var p : String in o ) if (p != "type") e[p] = o[p];
			broadcastEvent( e );
		}

		/**
		 * Broadcast the passed-in event object to listeners
		 * according to the event's type. The event is broadcasted
		 * to both listeners registered specifically for this event
		 * type and global listeners in the broadcaster.
		 * <p>
		 * If the <code>target</code> property of the passed-in event
		 * is <code>null</code>, it will be set using the value of the
		 * source property of this event broadcaster.
		 * </p>
		 * @param	e	event object to broadcast
		 * @throws 	<code>UnsupportedOperationException</code> — If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		public function broadcastEvent( e : Event ) : void
		{
			if( e.target == null && e is BasicEvent ) (e as BasicEvent).target = _oSource;
			
			if ( hasListenerCollection(e.type) ) _broadcastEvent( getListenerCollection(e.type), e );
			if ( !(_mAll.isEmpty()) ) _broadcastEvent( _mAll, e );
		}

		/**
		 * Broadcast the passed-in event to the listeners contained in the passed-in
		 * <code>Collection</code>.
		 * 
		 * @param	c	<code>Collection</code> of listeners to which send the event
		 * @param	e	event to broadcast to listeners
		 * @throws 	<code>UnsupportedOperationException</code> — If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		protected function _broadcastEvent( c : Collection, e : Event ) : void
		{
			var type : String = e.type;
			var a : Array = c.toArray();
			var l : Number = a.length;

			while ( --l > -1 ) 
			{
				var listener : Object = a[l];

				if ( listener.hasOwnProperty( type ) && listener[ type ] is Function )
				{
					//PixlibDebug.DEBUG( "is a real listener for type " + type );
					listener[type](e);

				} else if ( listener.hasOwnProperty( "handleEvent" ) && listener.handleEvent is Function )
				{
					listener.handleEvent(e);

				} else 
				{
					var msg : String;
					msg = this + ".broadcastEvent() failed, you must implement '" 
					+ type + "' method or 'handleEvent' method in '" + 
					getQualifiedClassName(listener) + "' class";

					PixlibDebug.ERROR( msg );
					throw( new UnsupportedOperationException( msg ) );
				}
			}
		}

		/**
		 * Returns the <code>String</code> representation of
		 * this object. 
		 * <p>
		 * The function return a string like
		 * <code>com.bourre.events::EventBroadcaster&lt;ListenerType&gt;</code>
		 * for a typed broadcaster. The string between the &lt;
		 * and &gt; is the name of the type of the broadcaster's
		 * global listeners. If the broadcaster is an untyped broadcaster
		 * the function will simply return the result of the
		 * <code>PixlibStringifier.stringify</code> call.
		 * </p>
		 * @return <code>String</code> representation of
		 * 		   this object.
		 */
		public function toString() : String 
		{
			var hasType : Boolean = _cType != null;
			var parameter : String = "";
			
			if( hasType )
			{
				parameter = _cType.toString();
				parameter = "<" + parameter.substr( 7, parameter.length - 8 ) + ">";
			}
			
			return PixlibStringifier.stringify( this ) + parameter;
		}

		//
		private function _storeRef( type : String, listener : Object ) : void
		{
			if ( !(_mEventListener.containsKey( listener )) ) _mEventListener.put( listener, new HashMap() );
			_mEventListener.get( listener ).put( type, listener );
		}

		private function _removeRef( type : String, listener : Object ) : void
		{
			var m : HashMap = _mEventListener.get( listener );
			m.remove( type );
			if ( m.isEmpty() ) _mEventListener.remove( listener );
		}

		private function _flushRef( listener : Object ) : Boolean
		{
			var b : Boolean = false;
			var m : HashMap = _mEventListener.get( listener );
			if ( m != null )
			{
				var a : Array = m.getKeys();
				var l : Number = a.length;
				while( --l > -1 ) b = removeEventListener( a[l], listener ) || b;
				_mEventListener.remove( listener );
			}
			return b;
		}
	}
}