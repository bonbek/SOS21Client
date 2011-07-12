package com.bourre.ioc.assembler.property {
	import com.bourre.events.BasicEvent;
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.log.PixlibStringifier;	

	public class PropertyEvent extends BasicEvent
	{
		public static var onBuildPropertyEVENT : BasicEvent = new BasicEvent( "onBuildProperty" );
		private var _oProp : Property;
		private var _sOwnerID : String;
		private var _sRefID : String;
		
		public function PropertyEvent( o : Property, ownerID : String, refID : String = null )
		{
			super( PropertyEvent.onBuildPropertyEVENT.type );
			
			_oProp = o;
			_sOwnerID = ownerID;
			_sRefID = refID;
		}
		
		public function getProperty() : Property
		{
			return _oProp;
		}
		
		public function getOwnerID() : String
		{
			return _sOwnerID;
		}
		
		public function getRefID() : String
		{
			return _sRefID;
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