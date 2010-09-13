/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.triggers {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.*;
	import com.sos21.events.BaseEvent;
	import com.sos21.debug.log;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.events.EventList;
	import ddgame.client.view.UIRessourcesHelper;
	import ddgame.client.view.components.UIRessourceItem;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  18.04.2008
	 */
	public class RessourcesTrigger extends AbstractTrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 5;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function RessourcesTrigger()
		{ }

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var resList:Array;
		private var labList:Array;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public var UIRes:UIRessourcesHelper;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function execute(event:Event = null):void
		{
			resList = properties.arguments["rlink"].split("#");	// Ressources Link
			labList = properties.arguments["rlabel"].split("#");	// Labels
			var l:int = resList.length;
			if (l <= 0)
				return;
			
			UIRes = UIRessourcesHelper(facade.getObserver(UIRessourcesHelper.NAME));
			UIRes.clearAllRessourceItems();
			
			for (var i:int = 0; i < l; i++)
			{
				var iurl:String = resList[i];
				var iconType:String = iurl.substring(iurl.lastIndexOf(".") + 1);
				var rItem:UIRessourceItem = new UIRessourceItem(iconType, labList[i]);
				rItem.addEventListener(MouseEvent.CLICK, resItemMouseHanlder);
				UIRes.pushRessourceItem(rItem);
//				sendEvent(new BaseEvent(EventList.ADD_RESSOURCES));
			}
			//UIRes.openRessourceList();
			UIRes.displayBallon("Des Ressources sont Disponibles");
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function resItemMouseHanlder(event:MouseEvent):void
		{
			var ind:int = labList.indexOf(UIRessourceItem(event.target).label);
			var sUrl:String = "http://" + resList[ind];
//			trace(sUrl);
			navigateToURL(new URLRequest(sUrl), "_blank");
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
