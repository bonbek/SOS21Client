package ddgame.client.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.client.events.EventList;
	import ddgame.server.events.PublicServerEventList;
	import ddgame.client.view.IsosceneHelper;
	import ddgame.client.proxy.TileTriggersProxy;
	import ddgame.client.proxy.CollisionGridProxy;
	import ddgame.client.proxy.DatamapProxy;
	import ddgame.client.proxy.PlayerProxy;

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
			// TODO cleané "à la main"
			sendEvent(new Event(EventList.CLEAR_MAP));
			
			// nettoyage
			// -> la scène affichée
			IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).clearScene();
			// -> les triggers
			TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)).removeCurrentMapTriggers();
			
			// -> patch injection de propriétées triggers
			if (o.injectTP)
			{
				var aitp:Array = o.injectTP;
				for (var i:int = 0; i < aitp.length; i++)
					trace(this, "INJECT trigger ", aitp[i].id);
			}
			
			// WIP TEST cookie
			trace(this, '------- TEST COOKIE ---------');
			var cookie:Object = PlayerProxy(facade.getProxy(PlayerProxy.NAME)).cookie;
			if (cookie.data.hasOwnProperty("triggers"))
			{
				for each (var t:Object in cookie.data.triggers)
				{
					trace("> trigger", t);
					for (var p:String in t)
						trace(p, t[p]);
				}			
			}
			if (cookie.data.hasOwnProperty("bonus"))
			{
				trace("bonus ",  cookie.data.bonus.length);
				for each (var b:Object in cookie.data.bonus)
				{
					trace("> bonus", b);
					for (p in b)
						trace(p, b[p]);
				}				
			}
			trace(this, '------------------------------');
			
//			sendPublicEvent(new BaseEvent(PublicServerEventList.GET_MAPLIST));
			sendPublicEvent(new BaseEvent(PublicServerEventList.GET_DATAMAP, o));
		}
				
	}
	
}
