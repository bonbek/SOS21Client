package com.bourre.model
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
	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	import flash.events.Event;
	
	import com.bourre.events.EventBroadcaster;
	import com.bourre.events.StringEvent;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;	

	public class AbstractModel 
	{
		public static const onInitEVENT : String = "onInit";
		
		private var _oEB : EventBroadcaster;
		private var _sName : String;
		private var _owner : Plugin;
		
		public function AbstractModel( owner : Plugin = null, name : String = null ) 
		{
			_oEB = new EventBroadcaster( this );
			
			setOwner( owner );
			if ( name ) setName( name );
		}
		
		public function setListenerType( type : Class ) : void
		{
			_oEB.setListenerType(type);
		}

		public function handleEvent( e : Event ) : void
		{
			
		}
		
		protected function onInit() : void
		{
			notifyChanged( new StringEvent( AbstractModel.onInitEVENT, getName() ) );
		}
		
		public function setName( name : String ) : void
		{
			var ml : ModelLocator = ModelLocator.getInstance( getOwner() );
			
			if ( !( ml.isRegistered( name ) ) )
			{
				if ( getName() != null && ml.isRegistered( getName() ) ) ml.unregisterModel( getName() );
				if ( ml.registerModel( name, this ) ) _sName = name;
				
			} else
			{
				getLogger().error( this + ".setName() failed. '" + name + "' is already registered in ModelLocator." );
			}
		}
		
		public function getOwner() : Plugin
		{
			return _owner;
		}
		
		public function setOwner( owner : Plugin ) : void
		{
			_owner = owner ? owner : NullPlugin.getInstance();
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}
		
		public function notifyChanged( e : Event ) : void
		{
			_getBroadcaster().broadcastEvent( e );
		}
		
		public function getName() : String
		{
			return _sName;
		}
		
		public function release() : void
		{
			_getBroadcaster().removeAllListeners();
			ModelLocator.getInstance( getOwner() ).unregisterModel( getName() );
			_sName = null;
		}
	
		public function addListener( listener : Object ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : Object ) : Boolean
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
		
		//
		protected function _getBroadcaster() : EventBroadcaster
		{
			return _oEB;
		}
		
		protected function _firePrivateEvent( e : Event ) : void
		{
			getOwner().firePrivateEvent( e );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}