package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.triggers.TriggerLocator;
	import ddgame.events.*;
	import ddgame.scene.*;
	import ddgame.proxy.*;
	import ddgame.server.IClientServer;

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
			// TODO cleané "à la main" ?			
			if (DatamapProxy(facade.getProxy(DatamapProxy.NAME)).getData())
			{
				// nettoyage
				sendEvent(new Event(EventList.CLEAR_MAP));
				// -> les triggers
				var trigProxy:TileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
				trigProxy.removeCurrentMapTriggers();
				trigProxy.triggersEnabled = false;
			}
			
			// Recup IPlaceDocument
			var params:Object = BaseEvent(event).content;
			// Patch point d'entrée
			if (params.entryPoint) entryPoint = params.entryPoint;
			IClientServer(facade.getProxy(ProxyList.SERVER_PROXY)).getServices("place").load({keys:params.mapId},
																														onPlaceDocumentLoaded, onPlaceDocumentLoaded);
		}
		
		private var entryPoint:String;
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		/**
		 * TEMP
		 *	@param result Object
		 */
		private function onPlaceDocumentLoaded (document:Object) : void
		{
			if (document)
			{
				// objet data map
				var o:Object = document;

				trace("Info: Start update place ", o.id, this);
				// on prépare la librairie
				var libProxy:LibProxy = LibProxy(facade.getProxy(LibProxy.NAME));
				libProxy.clear();

				var dataMapProxy:DatamapProxy = DatamapProxy(facade.getProxy(DatamapProxy.NAME));
				var playerProxy:PlayerProxy = PlayerProxy(facade.getProxy(PlayerProxy.NAME));
				
				// ------> triggers externes
				var triggerProxy:TileTriggersProxy = facade.getProxy(TileTriggersProxy.NAME) as TileTriggersProxy;
				var trigLocator:TriggerLocator = TriggerLocator.getInstance();
				var triggerList:XMLList = ConfigProxy.getInstance().data.triggers;

				// on recup la liste des triggers de la map et on teste ceux à loader
				var tlist:Array = o.actions;
				
				// > patch recup des triggers injectées depuis autres map sur la map courante
				var injectTList:Array = triggerProxy.getSpecMapTriggers(o.id);
				if (injectTList)
					tlist = tlist.concat(injectTList);

				var n:int = tlist.length;
				var n2:int;
				var toPLoad:Array; // Assets à pré charger
				var dtrigger:Object;
				var ftrigger:String;
				var execCount:int;
				// Liste des trigger externes (modules)
				var externalTriggers:Array = [];
				
				while (--n > -1)
				{
					dtrigger = tlist[n];
					if (dtrigger)
					{
						// > Remplacement du nombre d'éxecutions effectué
						// sur cette action par le joeur
						execCount = playerProxy.actionExecutedCount(dtrigger.id, document.id);
						if (execCount) {
							dtrigger.exec = execCount;
						}
						
						// > On check si assets à préloader pour l'action
						if (dtrigger.arguments.hasOwnProperty('pload'))
						{
							toPLoad = dtrigger.arguments.pload;
							n2 = toPLoad.length;
							while (--n2 > -1) {
								libProxy.createLoader(toPLoad[n2]);
							}
						}

						// Test si le trigger est externe et déjà dans la liste
						if (externalTriggers.indexOf(dtrigger.classId) > -1)
							continue;

						ftrigger = triggerList.trigger.(@id == dtrigger.classId).@url;					
						if (ftrigger && !trigLocator.isRegisteredId(dtrigger.classId))
						{
							// on place le trigger externe en chargement
							libProxy.createLoader(ftrigger);
							// on stock son id ref dans le datamap
							externalTriggers.push(dtrigger.classId);
						}
					}
				}
				
				// Stockage dans dataMapProxy
				dataMapProxy.externalTriggers = externalTriggers;

				// > patch preload des assets sur les arguments remplacé de trigger
				var replaceArgList:Array = triggerProxy.getSpecMapReplaceTriggerArgs(o.id)
				if (replaceArgList)
				{
					n = replaceArgList.length;
					var tArgs:Object;
					while (--n > -1)
					{
						tArgs = replaceArgList[n];
						if (tArgs.hasOwnProperty('pload'))
						{
							toPLoad = tArgs.pload;
							n2 = toPLoad.length;
							while (--n2 > -1)
							{
								libProxy.createLoader(toPLoad[n2]);
							}
						}
					}
				}

				// ------> assets
				// liste des tiles
				tlist = o.objects;	// liste des datas tiles			
				n = tlist.length;
				var dtile:Object;		// data tile
				var nasset:int;		// nombre d'assets du tiles
				var asseturl:String;	// url asset
				while (--n > -1)
				{
					dtile = tlist[n];
					if (int(dtile.pnj) > 0 || dtile.sheet)
					{
						libProxy.createLoader(libProxy.tilesPath + dtile.assets[0]);
					}
					else
					{
						nasset = dtile.assets.length;
						while (--nasset > -1)
						{
							asseturl = dtile.assets[nasset];
							libProxy.addTileAssetLoader(asseturl);
						}
					}
				}


				if(o.foreground)
					libProxy.createLoader(libProxy.layersPath + o.foreground);

				if (o.background)
					libProxy.createLoader(libProxy.layersPath + o.background, true);

				// TODO à charger une seule fois (premiere map ?)
				libProxy.createLoader(libProxy.spritesPath + "AvatarSkins.swf");
				libProxy.createLoader(libProxy.spritesPath + "moveMarker.swf");
				libProxy.createLoader(libProxy.libPath + "HtmlPopup.swf");

				// on lance le chargement
				libProxy.load();
				
				
				// Patch entryPoint
				if (entryPoint)
				{
					var et:Array = entryPoint.split("/");
					o.entrance = {x:et[0],y:et[1],z:et[2]};
				}
				// on passe les datas au DatamapProxy
				dataMapProxy.data = o;
			}
			else
			{
				trace("Error: No place document found");
			}
		}
				
	}
	
}
