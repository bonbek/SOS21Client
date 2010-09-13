/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.proxy {
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.collection.HashMap;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.client.triggers.ITrigger;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.triggers.TriggerLocator;
	import ddgame.client.triggers.BaseTriggerList;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  28.02.2008
	 */
	public class TileTriggersProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "tileTiggersProxy";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function TileTriggersProxy(sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
//		private var _triggersMap:HashMap /* of int/ITrigger */ = new HashMap();
		private var _triggersMap:Array /* of Array */ = [];
		private var triggerLocator:TriggerLocator = TriggerLocator.getInstance();
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------		

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function parse(tlist:Array /* of Object */):void
		{
				// Store original data;
			_data = tlist;
			var l:int = tlist.length;
			while (--l > -1)
			{
				try
				{
					var o:Object = tlist[l];
					var classRef:Class = triggerLocator.findTriggerClass(o.classId);				
					var trigger:ITrigger = new classRef();
					trigger.fireType = o.fireType;
					trigger.parseArguments(o.arguments);
					var tileRef:int = o.tileRefId;
//					_triggersMap.insert(o.tileRefId, [trigger]);
					if (!_triggersMap[tileRef])
						_triggersMap[tileRef] = [];
					_triggersMap[tileRef][trigger.fireType] = trigger;
				}
				catch (error:Error)
				{
					trace(error.message + " @" + toString());
				}
				
			}
			trace("-- tile triggers parsed @" + toString());
		}
		
		public function hasTrigger(t:AbstractTile):Boolean
		{
//			return _triggersMap.find(t.ID);
			return _triggersMap[t.ID] is Array;
		}
		
		public function getTriggerList(t:AbstractTile):Array /* of Trigger */
		{
//			return _triggersMap.find(t.ID) as Array;
			var ao:Array = _triggersMap[t.ID] as Array;
			var a:Array = [];
			var n:int = ao.length;
			while (--n > -1)
			{
				ao[n] != null ? a.push(ao[n]) : void;
			}
			
			return a;
		}
		
		public function getTrigger(t:AbstractTile, fireEventType:String):ITrigger
		{
			return _triggersMap[t.ID][AbstractTrigger.fireTypeList.indexOf(fireEventType)];
		}
		
		public function fireTrigger(refId:int, fireEventType):void
		{
			var data:TriggerProperties = 
			var classRef:Class = _triggersMap[t.ID][AbstractTrigger.fireTypeList.indexOf(fireEventType)];
			var trigger:ITrigger = new classRef();
			classRef.initialize()
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
		override public function initialize():void
		{
				// Register the base Tile Triggers
			var tlist:Array /* of Class */ = BaseTriggerList.listTriggers();
			var n:int = tlist.length;
			while (--n > -1)
			{
				var classRef:Class = tlist[n];
				triggerLocator.registerTriggerClass(classRef.CLASS_ID,classRef);
			}
		}

	}
	
}
