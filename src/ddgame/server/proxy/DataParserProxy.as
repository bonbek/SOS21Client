/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.server.proxy {
	import flash.events.Event;
	import com.sos21.proxy.AbstractProxy;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  28.02.2008
	 */
	public class DataParserProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME : String = "dataParserProxy";

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function DataParserProxy( sname : String = null, odata : Object = null )
		{
			super( sname == null ? NAME : sname, odata );
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function unserializeDatamap( o : Object ) : Object
		{
			var res : Object = o;
			res.collisions = unserializeCollisions( o.collisions );
			res.tileGrid = unserializeTileGrid( o.tileGrid );
			res.tileTriggers = unserializeTilTriggers( o.tileTriggers );
			
			return res;			
		}
		
		/*
		*	Unserialize tile grid
		*	serialized string format -> id:refId:x/y/z,...
		*	
		*	@return	Array of Objects
		*/
		public function unserializeTileGrid( tlist : String ) : Array
		{
			var al : Array = tlist.split( "," );
			var ares : Array = new Array();
			var l : int = al.length;
			while( --l > -1 ) {
				var arg : Array = al[l].split(":");
				var p : Array = arg[2].split("/");
				ares.push( { id:arg[0], refId:arg[1], x:p[0], y:p[1], z:p[2] } );
			}
			
			return ares;
		}
		
		/*
		*	Unserialize collisions
		*	serialized string format -> x/y/z:type:cost,...
		*	
		*	@return : Array of Objects
		*/
		public function unserializeCollisions( clist : String ) : Array
		{
			var al : Array = clist.split( "," );
			var ares : Array = new Array();
			var l : int = al.length;
			while( --l > -1 ) {
				var arg : Array = al[l].split(":");
				var p : Array = arg[0].split("/");
				ares.push( { x:p[0], y:p[1], z:p[2], type:arg[1], cost:arg[2] } );
			}
			
			return ares;
		}
		
		/*
		*	Unserialize tile triggers
		*	serialized string format ->	id:triggerClassId:tileRefid:launchType:var=val&...,...
		*											param int : id must be unique
		*	                              param int : TriggerClass reference id
		*	                              param uint : tile reference id. If negative, serve the trigger linkage
		*	                              param int ( binary op ) launch type ( rollOver, click, etc... )
		*	                              param... var : variable/value couple

		*	@return : Array of Objects
		*/
		public function unserializeTilTriggers( tlist : String ) : Array
		{
			var al : Array = tlist.split( "," );
			var ares : Array = new Array();
			var l : int = al.length;
			while( --l > -1 ) {
				var arg : Array = al[l].split(":");
				ares.push( { id:arg[0], classId:arg[1], tRefId:arg[2], fireType:arg[3], arguments:arg[4].split("&") } );
			}
			
			return ares;
			
		}
		
		/*
		*	Unserialize the entry point
		*	serialized string format : x/y/z
		*	@return : Object
		*/
		public function unserializeEntryPoint( sp : String ) : Object
		{
			var p : Array = sp.split("/");
			return { x:p[0], y:p[1], z:p[2] }
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Call by super class
		 */
		override protected function initialize() : void
		{ }

	}
	
}
