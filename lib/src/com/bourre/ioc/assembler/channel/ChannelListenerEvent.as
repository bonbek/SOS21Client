package com.bourre.ioc.assembler.channel
{
	import com.bourre.events.*;
	import com.bourre.log.*;

	public class ChannelListenerEvent 
		extends BasicEvent
	{
		public static const onBuildChannelListenerEVENT : String = "onBuildChannelListener";
		private var _oChannelListener : ChannelListener;
		
		public function ChannelListenerEvent( channelListener : ChannelListener )
		{
			super ( ChannelListenerEvent.onBuildChannelListenerEVENT );
			
			_oChannelListener = channelListener ;
		}
		
		public function getChannelListener() : ChannelListener
		{
			return _oChannelListener ;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}