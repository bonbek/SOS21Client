package com.bourre.load
{
	import com.bourre.collection.HashMap;
	import flash.geom.Point ;
	import com.bourre.log.PixlibDebug ;
	import com.bourre.core.CoreFactory;
	import com.bourre.error.UnsupportedNodeAttributeException;
	
	public class XMLToObjectDeserializer implements XMLLoaderDeserializer
	{
		private var _m:HashMap ;
		
		private var _bDeserializeAttributes : Boolean;
		
		public var pushInArray : Boolean;
	
		public static var DEBUG_IDENTICAL_NODE_NAMES : Boolean = false;
		public static var PUSHINARRAY_IDENTICAL_NODE_NAMES : Boolean = true;
		public static var ATTRIBUTE_TARGETED_PROPERTY_NAME : String = null;
		public static var DESERIALIZE_ATTRIBUTES : Boolean = false;
		
		public function XMLToObjectDeserializer ()
		{
			_m = new HashMap() ;
			
			addType("Number", getNumber);
			addType("String", getString);
			addType("Array", getArray);
			addType("Boolean", getBoolean);
			addType("Class", getInstance);
			addType("Point", getPoint);
			addType("", getObject);
			
			pushInArray = XMLToObjectDeserializer.PUSHINARRAY_IDENTICAL_NODE_NAMES;
			deserializeAttributes = XMLToObjectDeserializer.DESERIALIZE_ATTRIBUTES;
		}
		
		/**
		* Lancement du parcours du xml
		*/
		public function deserialize(target:Object, xml:XML):Object
		{
			for each (var property:XML in xml.*)
			{
				deserializeNode(target,property) ;
			}
			return target ;
		}
		
		public function	deserializeNode (target:Object, node:XML):Object
		{
			var member:String = node.name();
			var obj:Object = {} ;
			
			if (node.attribute("type").length()== 0 && !node.hasSimpleContent())
			{
				obj =_getData( node );
			}
			else
			{
				obj["value"] = _getData( node ) ;
			}
				
			obj["attribute"] = {} ;
			for (var i:int = 0 ; i < node.attributes().length() ; i++)
			{
				var nom:String = String(node.attributes()[i].name());
				obj["attribute"][nom] = node.attributes()[i] ;
			}
			
			if ( target[member] ) 
			{
				target[member] = XMLToObjectDeserializer._getNodeContainer( target, member );
				target[member].push(obj) ;
			} 
			else
			{
				target[member] = obj ;
			}

			return target ;
		}
		
		/**
	 	* Add new type to deserializer
	 	*/
		public function addType( type : String, parsingMethod : Function ) : void
		{
			_m.put( type, parsingMethod) ;
			//PixlibDebug.DEBUG( "added type '" + type + "':"+parsingMethod+" to "+ this );
		}
	
	  	private function _getData( node:XML ):*
		{
			var dataType:String = node.attribute("type");
			
			if (_m.containsKey( dataType ))
			{
				var d:Function = _m.get( dataType );
				return d.apply(this, [node]);
					
			} else
			{
				PixlibDebug.WARN( dataType + ' type is not supported!' );
				return null;
			}
		}

	  	private static function _getNodeContainer( target:*, member : String ) : Array
	  	{
	  		var temp : Object = target[ member ] ;
	  		
	  		if ( temp.__nodeContainer )
	  		{
	  			return target[member] as Array;
	  			
	  		} else
	  		{
	  			var a : Array = new Array();
	  			a["__nodeContainer"] = true;
	  			
	  			a.push( temp );
	  			return a;
	  		}
	  	}

		
		/**
		 * Explode string to arguments array.
		 */
		public function getArguments( sE:String ) : Array 
		{
	  		var t:Array = split(sE);
	  		
	  		var aR:Array = new Array();
	  		var l:Number = t.length;
	  		for (var y:int=0; y<l; y++) 
			{
				var s:String = stripSpaces(t[y]);
				if (s == 'true' || s == 'false')
				{
					aR.push( s == 'true' );
				} else
				{
					if (s.charCodeAt(0) == 34 || s.charCodeAt(0) == 39) // " ou '
					{
						aR.push( s.substr(1, s.length-2) );
					} else
					{
						aR.push( Number(s) );
					}
				}
			}
	 		return aR;
	  	}
		
	/*
	* setters - parsers's behaviors
	*/
	  	
	  	public function getNumber ( node:XML ) : Number
	  	{
	  		return Number( XMLToObjectDeserializer.stripSpaces( node ) );
	  	}
	  	
	  	public function getString ( node:XML ) : String
	  	{
	  		return node ;
	  	}
	  	
	  	public function getArray (  node:XML  ) : Array
	  	{
	  		return getArguments( node );
	  	}
	  	
	  	public function getBoolean (  node:XML  ) : Boolean
	  	{
	  		var s:String = XMLToObjectDeserializer.stripSpaces( node );
			
			return new Boolean( s == "true" || !isNaN(Number(s))&&Number(s)!=0 );
	  		
	  		//return ( s == "true" || Number( s ) == 1 );
	  	}
	  	
	  	public function getObject ( node:XML ) : Object
		{
			var data:XML = node ;	  		
	  		return data.hasSimpleContent()? data : deserialize( {}, node );
		}
		
		public function getInstance(  node:XML  ) : Object
	  	{
	  		var obj:Object ;
	  		var args : Array = getArguments( node );
			var sPackage:String = args[0]; 
			args.splice(0, 1);
			try 
			{
				obj = CoreFactory.buildInstance( sPackage, args );
			}
			catch (e:Error)
			{
				PixlibDebug.FATAL("XMLToObjectDeserializer : can't build class instance specified in xml node ["+sPackage+"]") ;
				throw new UnsupportedNodeAttributeException("Wrong package name in getInstance") ;
			}
			return  obj ;
	  	}
	  	
		public function getPoint (  node:XML  ) : Point
	  	{
	  		var args:Array = getArguments( node );
	  		if (args[1] == null)
	  			throw new UnsupportedNodeAttributeException("Missing an argument in childnode for creating Point instance") ;
			return new Point(args[0], args[1]);
	  	}
	  	
	  	public function getObjectWithAttributes ( node:XML ) : Object
		{
			var data:XML = node;
			
			var o : Object = new Object();
	
			var attribTarget : Object;
			var s : String = XMLToObjectDeserializer.ATTRIBUTE_TARGETED_PROPERTY_NAME;
			if ( s.length > 0 ) attribTarget = o[s] = new Object();
			
	    	for ( var p : String in node.attributes() ) 
	    	{
	    		if (!(_m.containsKey(p))) 
	    		{
	    			if ( attribTarget )
	    			{
	    				attribTarget[p] = node.attributes[p];
	    			
	    			} else
	    			{
	    				o[p] = node.attributes[p];
	    			}
	    		}
	    	}
			
			return data? data : deserialize( o, node );
		}
	  	
	  	public static function stripSpaces(s:String) : String 
		{
	        var i:Number = 0;
			while(i < s.length && s.charCodeAt(i) == 32) i++;
			var j:Number = s.length-1;
			while(j > -1 && s.charCodeAt(j) == 32) j--;
	        return s.substr(i, j-i+1);
	  	}
	  	
	  	public static function split(sE:String) : Array
	  	{
	  		var b:Boolean = true;
	  		var a:Array = new Array();
	  		var l:Number = sE.length;
	  		var n:Number;
	  		var s:String = '';
	  		
	  		for (var i:Number = 0; i<l; i++)
	  		{
	  			var c:Number = sE.charCodeAt(i);
	  			if ( b && (c == 34 || c == 39))
	  			{
	  				b = false;
	  				n = c;
	  			} else if (!b && n == c)
	  			{
	  				b = true;
	  				n = undefined;
	  			}
	  			
	  			if (c == 44 && b)
	  			{
	   				a.push(s);
	  				s = '';
	  			} else
	  			{
	  				s += sE.substr(i, 1);	
	  			}
	  		}
	  		a.push(s);
	  		return a;
	  	}
	  	
	  	public function get deserializeAttributes () : Boolean
		{
			return _bDeserializeAttributes;
		}
		
		public function set deserializeAttributes ( b : Boolean ) : void
		{
			if ( b != _bDeserializeAttributes )
			{
				if ( b )
				{
					addType( "", getObjectWithAttributes );
				} else
				{
					addType( "", getObject );
				}
			}
		}
	  	
	}
}