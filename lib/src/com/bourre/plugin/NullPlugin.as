package com.bourre.plugin {
	import flash.events.Event;
	
	import com.bourre.events.ApplicationBroadcaster;
	import com.bourre.events.EventChannel;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;	

	public class NullPlugin 
		implements Plugin
	{
		private static var _oI : NullPlugin =null;

		public function NullPlugin(access : PrivateConstructorAccess )
		{
			
		}

		public static function getInstance() : NullPlugin
		{
			if ( !(NullPlugin._oI is NullPlugin) ) NullPlugin._oI = new NullPlugin(new PrivateConstructorAccess() );
			return NullPlugin._oI;
		}

		public function fireOnInitPlugin() : void
		{
			
		}

		public function fireOnReleasePlugin() : void
		{
			
		}

		public function fireExternalEvent( e : Event, channel : EventChannel ) : void
		{
			
		}

		public function firePublicEvent( e : Event ) : void
		{
			
		}

		public function firePrivateEvent( e : Event ) : void
		{
			
		}

		public function getChannel() : EventChannel
		{
			return ApplicationBroadcaster.getInstance().NO_CHANNEL;
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( this );
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}

		public function getModelLocator() : ModelLocator
		{
			return ModelLocator.getInstance( this );
		}
		
		public function getViewLocator() : ViewLocator
		{
			return ViewLocator.getInstance( this );
		}
	}
}
internal class PrivateConstructorAccess {}