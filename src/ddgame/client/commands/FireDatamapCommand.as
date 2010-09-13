/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.commands {
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.client.proxy.DatamapProxy;
	
	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  25.02.2008
	 */
	public class FireDatamapCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event):void
		{
			var o:Object = BaseEvent(event).content;
			DatamapProxy(facade.getProxy(DatamapProxy.NAME)).data = o;
		}
				
	}
	
}
