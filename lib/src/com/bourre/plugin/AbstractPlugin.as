package com.bourre.plugin
{
	import flash.events.Event;
	
	import com.bourre.commands.FrontController;
	import com.bourre.events.*;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;

	public class AbstractPlugin
		implements Plugin
	{
		private var _oABExternal : ApplicationBroadcaster;
		private var _oEBPublic : EventBroadcaster;
		private var _oEBPrivate : EventBroadcaster;

		private var _oController : FrontController;
		private var _oModelLocator : ModelLocator;
		private var _oViewLocator : ViewLocator;

		public static const onInitPluginEVENT : String = "onInitPlugin";
		public static const onReleasePluginEVENT : String = "onReleasePlugin";

		public function AbstractPlugin() 
		{
			_initialize();
		}
		
		protected function _initialize() : void
		{
			_oController = new FrontController( this );
			_oModelLocator = ModelLocator.getInstance( this );
			_oViewLocator = ViewLocator.getInstance( this );
				
			_oABExternal = ApplicationBroadcaster.getInstance();
			_oEBPublic = ApplicationBroadcaster.getInstance().getChannelDispatcher( getChannel(), this );
			_oEBPrivate = getController().getBroadcaster();
			
			if( _oEBPublic ) _oEBPublic.addListener( this );
		}
		
		public function fireOnInitPlugin() : void
		{
			firePublicEvent( new Event( AbstractPlugin.onInitPluginEVENT ) );
		}
		
		public function fireOnReleasePlugin() : void
		{
			firePublicEvent( new Event( AbstractPlugin.onReleasePluginEVENT ) );
		}
		
		public function getChannel() : EventChannel
		{
			return ChannelExpert.getInstance().getChannel( this );
		}
		
		public function getController() : FrontController
		{
			return _oController;
		}
		
		public function getModelLocator() : ModelLocator
		{
			return _oModelLocator;
		}
		
		public function getViewLocator() : ViewLocator
		{
			return _oViewLocator;
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( this );
		}
		
		public function fireExternalEvent( e : Event, externalChannel : EventChannel ) : void
		{
			if ( externalChannel != getChannel() ) 
			{
				_oABExternal.broadcastEvent( e, externalChannel );
				
			} else
			{
				getLogger().error( this + ".fireExternalEvent() failed, '" + externalChannel + "' is its public channel." );
			
			}
		}
		public function handleEvent ( e : Event = null ):void
		{
			
		}
		public function firePublicEvent( e : Event ) : void
		{
			if( _oEBPublic ) _oEBPublic.broadcastEvent( e );
			else PixlibDebug.WARN( this + " doesn't have public dispatcher");
		}
		
		public function firePrivateEvent( e : Event ) : void
		{
			_oEBPrivate.broadcastEvent( e );
		}
		
		public function release() : void
		{
			
			_oController.release( );
			_oModelLocator.release( );
			_oViewLocator.release();

			BeanFactory.getInstance().unregisterBean( this );
			fireOnReleasePlugin();
			
			_oEBPrivate.removeAllListeners();
			_oEBPublic.removeAllListeners();

			ApplicationBroadcaster.getInstance().releaseChannelDispatcher( getChannel() );
			PluginDebug.release( this );
			ChannelExpert.getInstance().releaseChannel( this );
		}

		public function addListener( listener : PluginListener ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.addListener( listener );
				
			} else 
			{
				PixlibDebug.WARN( this + " doesn't have public dispatcher");
				return false;
			}
		}
		
		public function removeListener( listener : PluginListener ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.removeListener( listener );
			} else 
			{
				PixlibDebug.WARN( this + " doesn't have public dispatcher");
				return false;
			}
		}
		
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.addEventListener.apply( _oEBPublic, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
			
			} else 
			{
				PixlibDebug.WARN( this + " doesn't have public dispatcher");
				return false;
			}
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.removeEventListener( type, listener );
				
			} else 
			{
				PixlibDebug.WARN( this + " doesn't have public dispatcher");
				return false;
			}
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