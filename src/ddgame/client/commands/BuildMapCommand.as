package ddgame.client.commands {

	import flash.events.Event;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.client.triggers.TriggerLocator;
	import ddgame.client.proxy.TileTriggersProxy;
	import ddgame.client.proxy.DatamapProxy;
	import ddgame.client.proxy.LibProxy;
	import ddgame.client.view.PlayerHelper;
	import ddgame.client.proxy.PlayerProxy;
	
	/**
	 *	
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class BuildMapCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			var dmProxy:DatamapProxy = DatamapProxy(facade.getProxy(DatamapProxy.NAME));
			
			// > triggers externes (voir StartUpdateMapCommand)
			// recupération des classe de triggers externes pour enregistrement
			// dans le locator
			var trigLocator:TriggerLocator = TriggerLocator.getInstance();
			var lib:LibProxy = LibProxy(facade.getProxy(LibProxy.NAME));
			var triggerList:XMLList = ConfigProxy.getInstance().data.triggers;
			
			var extTriggers:Array = dmProxy.externalTriggers;
			var n:int = extTriggers.length;
			var trId:int;			// id de la classe trigger
			var classDef:Class;	// définition de la classe trigger
			while (--n > -1)
			{
				trId = extTriggers[n];
				// on recup la définition
				classDef = lib.getDefinitionFrom(triggerList.trigger.(@id == trId).@url, triggerList.trigger.(@id == trId).@name);
				// enregistre la classe
				trigLocator.registerTriggerClass(trId, classDef);
			}

			dmProxy.parseData();
			
			// mise à jour du cookie
//			var cookie:Object = PlayerProxy(facade.getProxy(PlayerProxy.NAME)).cookie;
//			cookie.data.map = dmProxy.mapId;
//			cookie.data.triggers = [];
//			cookie.flush();
			
			// patch lancement des triggers à l'init des map
			TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)).fireOnInitMapTriggers();
		}
				
	}
	
}
