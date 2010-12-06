package ddgame.server.commands {
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.server.proxy.RemotingProxy;
	import com.sos21.debug.log;
	/**
	 *	Lance le chargement d'un map data
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class GetDataMapCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			var o:Object = BaseEvent(event).content;
			try {
				RemotingProxy(facade.getProxy(RemotingProxy.NAME)).getDataMap(o.mapId, o.entryPoint, o.removeTriggers);
			} catch (e:Error) {
				
			}
		}
		
	}
	
}