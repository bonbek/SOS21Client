package com.bourre.ioc.assembler.property {
	import com.bourre.collection.HashMap;
	import com.bourre.events.*;
	import com.bourre.ioc.bean.BeanEvent;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.bean.BeanFactoryListener;
	import com.bourre.ioc.control.BuildFactory;
	import com.bourre.ioc.core.IDExpert;
	import com.bourre.ioc.parser.ContextTypeList;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ObjectUtils;	

	public class PropertyExpert 
		implements BeanFactoryListener
	{
		private static var _oI : PropertyExpert;
		private var _oEB : EventBroadcaster;
		private var _mProperty : HashMap;

		public static function getInstance() : PropertyExpert
		{
			if ( !( _oI is PropertyExpert ) ) _oI = new PropertyExpert( new PrivateConstructorAccess() );
			return _oI;
		}
		
		public static function release() : void
		{
			if ( PropertyExpert._oI is PropertyExpert ) PropertyExpert._oI = null;
		}

		public function PropertyExpert( o : PrivateConstructorAccess )
		{
			_oEB = new EventBroadcaster( this );
			_mProperty = new HashMap();

			BeanFactory.getInstance().addListener( this );
			addListener( IDExpert.getInstance() );
		}

		public function setPropertyValue( p : Property, target : Object ) : void
		{
			target[ p.name ] = getValue( p ) ;
		}

		public function getValue( p : Property ) : Object
		{
			if ( p.method ) 
			{
				var a : Array = p.method.split(".");
				return BeanFactory.getInstance().locate( a[0] )[ a[1] ];

			} else if ( p.ref )
			{
				var ref : String = p.ref;

				if ( ref.indexOf(".") == -1 )
				{
					return BeanFactory.getInstance().locate( p.ref );
					
				} else
				{
					var args : Array = ref.split(".");
					var oRef : Object = BeanFactory.getInstance().locate( String( args.shift() ) );
					return ObjectUtils.evalFromTarget( oRef, args.join(".") );
				}

			} else
			{
				var type : String = p.type ? p.type : ContextTypeList.STRING;
				return BuildFactory.getInstance().getBuilder( type ).build( type, [p.value] );
			}
		}

		public function deserializeArguments( a : Array ) : Array
		{
			var r : Array;
			var l : Number = a.length;
			
			if ( l > 0 ) r = new Array();
			
			for ( var i : Number = 0; i < l; i++ ) r.push( getValue( a[i] ) );
			
			return r;
		}
		
		public function addProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null  ) : Property
		{
			var p : Property = new Property( ownerID, name, value, type, ref, method );
			
			if ( _mProperty.containsKey( ownerID ) )
			{
				( _mProperty.get( ownerID ) as Array ).push( p );

			} else
			{
				var a : Array = new Array();
				a.push( p );
				_mProperty.put( ownerID, a );
			}

			return p;
		}
/*
		public function getPropertyVO( ownerID : String, property ) : Array
		{
			var a : Array;
			
			if ( property )
			{
				a = new Array();
				var l : Number = property.length;
				
				if ( l > 0 ) 
				{
					for ( var i : Number = 0; i < l; i++ ) a.push( _buildProperty( ownerID, property[i].attribute) );
					
				} else
				{
					a.push( _buildProperty( ownerID, property.attribute ) );
				}
			}
			
			return a;
		}
		
		public function buildProperty( ownerID : String, property ) : void
		{
			_mProperty.put( ownerID, getPropertyVO( ownerID, property ) );
		}
		
		public function buildObjectProperty( ownerID : String, property ):void
		{
			_mProperty.put( ownerID, getPropertyVO( ownerID, property ) );
		}

		private function _buildProperty( ownerID : String, rawProperty : Object ) : Property
		{
			var p : Property =  new Property( 	
												ownerID,
												ContextAttributeList.getName( rawProperty ),
												ContextAttributeList.getValue( rawProperty ),
												ContextAttributeList.getType( rawProperty ),
												ContextAttributeList.getRef( rawProperty ),
												ContextAttributeList.getMethod( rawProperty )
											);
	
			_oEB.broadcastEvent( new PropertyEvent( p, p.ownerID, p.ref  ) );
			return p;
		}
*/
		/**
		 * Event system
		 */
		public function addListener( listener : PropertyExpertListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : PropertyExpertListener ) : Boolean
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

		/**
		 * IBeanFactoryListener callbacks
		 */
		public function onRegisterBean( e : BeanEvent ) : void
		{
			PixlibDebug.INFO( e.getID() + " -> onRegisterBean:" + e.getBean() );
			var id : String = e.getID();
			var bean : Object = e.getBean();

			if ( _mProperty.containsKey( id ) )
			{
				var props : Array = _mProperty.get( id );
				var l : Number = props.length;
				PixlibDebug.INFO( id + ":" + bean + ":" + l );
				while( -- l > - 1 ) setPropertyValue( props[ l ], bean );
			}
		}

		public function onUnregisterBean( e : BeanEvent ) : void
		{
			//
		}
	}
}

internal class PrivateConstructorAccess {}