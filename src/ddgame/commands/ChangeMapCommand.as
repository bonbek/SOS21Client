package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.events.EventList;
	import ddgame.events.ServerEventList;
	import ddgame.scene.IsosceneHelper;
	import ddgame.proxy.TileTriggersProxy;
	import ddgame.proxy.CollisionGridProxy;
	import ddgame.proxy.DatamapProxy;
	import ddgame.proxy.PlayerProxy;

	/**
	 *	Changement de map
	 *	Nettoie la map actuelle (graphique, data, triggers)
	 * Lance le chargement des datas de la nouvelle map
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ChangeMapCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			var o:Object = BaseEvent(event).content;
			// TODO cleané "à la main" ?
			sendEvent(new Event(EventList.CLEAR_MAP));
			
			// nettoyage
			// -> la scène affichée
			IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).clearScene();
			// -> les triggers
			var trigProxy:TileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
			trigProxy.removeCurrentMapTriggers();
			trigProxy.triggersEnabled = false;
						
			sendPublicEvent(new BaseEvent(ServerEventList.GET_DATAMAP, o));
		}
				
	}
	
}
