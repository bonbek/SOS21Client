package ddgame.commands {

	import flash.events.Event;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.triggers.TriggerLocator;
	import ddgame.proxy.TileTriggersProxy;
	import ddgame.proxy.DatamapProxy;
	import ddgame.proxy.LibProxy;
	import ddgame.scene.PlayerHelper;
	import ddgame.proxy.PlayerProxy;
	import ddgame.events.EventList;
	
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
		
		public function execute (event:Event) : void
		{
			if (event.type == EventList.SCENE_BUILDED)
			{
				if (event.isDefaultPrevented()) return;

				// patch lancement des triggers à l'init des map
				var trigProxy:TileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
				trigProxy.triggersEnabled = true;
				trigProxy.fireOnInitMapTriggers();
			}
			else
			{
				var dmProxy:DatamapProxy = DatamapProxy(facade.getProxy(DatamapProxy.NAME));
				trace("Info: Build: place", dmProxy.mapId, this);
			
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
			
				PlayerProxy(facade.getProxy(PlayerProxy.NAME)).setPlace(String(dmProxy.mapId));
				// lance la construction
				dmProxy.parseData();
				}
		}
				
	}
	
}
