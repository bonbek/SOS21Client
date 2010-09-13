/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.triggers {
	
	import flash.events.Event;
	import com.sos21.observer.INotifier;
	import ddgame.client.triggers.TriggerProperties;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface ITrigger extends INotifier {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function execute(event:Event = null):void;
		function isPropertie(prop:String):Boolean;
		function getPropertie(prop:String):*;
		function setPropertie(prop:String, val:*):void;
		function differ(evtType:String):void;
		function initialize():void;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function set sourceTarget(val:Object):void;
		function get sourceTarget():Object;
		function set properties(val:TriggerProperties):void;
		function get properties():TriggerProperties;
		
	}
	
}
