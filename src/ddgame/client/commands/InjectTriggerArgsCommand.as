package ddgame.client.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.client.proxy.TileTriggersProxy;

	/**
	 *	Commande injection d'arguments de trigger
	 * Permet depuis un map d'injecter de arguments à un trigger se trouvant
	 * dans une autre map
	 * Format de l'event content :
	 * {
	 * 	tmap:int			l'identifiant de la map ou se trouve le trigger (optionel)
	 * 	tId:int			l'identifiant du trigger ciblé
	 * 	tArgs:Object	les arguments à remplacer sur le trigger ciblé
	 * }
	 *
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class InjectTriggerArgsCommand extends Notifier implements ICommand {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event):void
		{
			var ocontent:Object = BaseEvent(event).content;
			var triggerProxy:TileTriggersProxy = facade.getProxy(TileTriggersProxy.NAME) as TileTriggersProxy;
			var tmap:int = ocontent.hasOwnProperty("tmap") ? ocontent.tmap : 0;
			triggerProxy.addSpecMapReplaceTriggerArgs(ocontent.tId, ocontent.tArgs, tmap);
		}
	
	}

}

