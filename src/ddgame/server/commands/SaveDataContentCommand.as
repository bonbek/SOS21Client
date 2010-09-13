package ddgame.server.commands {
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.server.proxy.RemotingProxy;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class SaveDataContentCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event):void
		{
			var o:Object = BaseEvent(event).content;
			RemotingProxy(facade.getProxy(RemotingProxy.NAME)).saveDataContent(o.id, o.data);
		}
				
	}
	
}
