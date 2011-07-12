package com.bourre.ioc.parser
{
	import com.bourre.collection.HashMap;
	import com.bourre.log.PixlibStringifier ;
	
	public class ContextNodeNameList
	{
		private static var _oI 					: ContextNodeNameList;
		
		public static var BEANS 				: String = "beans";
		public static var DEFAULT 				: String = "default";
		public static var PROPERTY 				: String = "property";
		public static var ARGUMENT 				: String = "argument";
		public static var ROOT 					: String = "root";
		public static var APPLICATION_LOADER 	: String = "application-loader";
		public static var DLL 					: String = "dll";
		public static var METHOD_CALL 			: String = "method-call";
		public static var LISTEN 				: String = "listen";
		
		private var _mNodeName:HashMap;
		
		public static function getInstance() : ContextNodeNameList
		{
			if ( !(ContextNodeNameList._oI is ContextNodeNameList) ) ContextNodeNameList._oI = new ContextNodeNameList( new PrivateConstructorAccess() );
			return ContextNodeNameList._oI;
		}
		
		public function ContextNodeNameList(access:PrivateConstructorAccess)
		{
			init();
		}
		
		public function init() : void
		{
			_mNodeName = new HashMap();
			
			addNodeName( ContextNodeNameList.BEANS, "" );
			addNodeName( ContextNodeNameList.DEFAULT, "" );
			addNodeName( ContextNodeNameList.PROPERTY, "" );
			addNodeName( ContextNodeNameList.ARGUMENT, "" );
			addNodeName( ContextNodeNameList.ROOT, "" );
			addNodeName( ContextNodeNameList.APPLICATION_LOADER, "" );
			addNodeName( ContextNodeNameList.METHOD_CALL, "" );
			addNodeName( ContextNodeNameList.LISTEN, "" );
			//TODO import BasicXMLDeserializer
			//addNodeName( BasicXMLDeserializer.ATTRIBUTE_TARGETED_PROPERTY_NAME, "" );
			addNodeName( "attribute", "" );
		}
		
		public function addNodeName( nodeName : String, value:* ) : void
		{
			_mNodeName.put( nodeName, value );
		}
		
		public function nodeNameIsReserved( nodeName:* ) : Boolean
		{
			return _mNodeName.containsKey( nodeName );
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
internal class PrivateConstructorAccess {}