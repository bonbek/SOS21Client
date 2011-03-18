package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.proxy.TileTriggersProxy;
	
	/**
	 *	Commande injection de trigger(s) dans une map
	 * params de l'event content :
	 *	{
	 * 	tList: array avec liste des triggers > prop tmap (map ciblée) à passer dans chaque trigger
	 * } 
	 *
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class InjectTriggerCommand extends Notifier implements ICommand {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			var triggerProxy:TileTriggersProxy = facade.getProxy(TileTriggersProxy.NAME) as TileTriggersProxy;
			var triggerList:Array = BaseEvent(event).content.tList as Array;
			
			triggerProxy.parse(triggerList);			
		}
		
	}

}

