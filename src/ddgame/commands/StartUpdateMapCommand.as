package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.triggers.TriggerLocator;
	import ddgame.proxy.TileTriggersProxy;
	import ddgame.proxy.DatamapProxy;
	import ddgame.proxy.LibProxy;
	import com.sos21.debug.log;
	
	/**
	 *	Départ de la mise à jour d'une map (après un changement de map)
	 *	Passe les data brutes au Datamap, prépare la librairie (gfx, triggers)
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class StartUpdateMapCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event):void
		{
			// objet data map
			var o:Object = BaseEvent(event).content;
			
			trace("info", this, " Start update Lib");
			// on prépare la librairie
			var libProxy:LibProxy = LibProxy(facade.getProxy(LibProxy.NAME));
			libProxy.clear();
			
			var dataMapProxy:DatamapProxy = DatamapProxy(facade.getProxy(DatamapProxy.NAME));
			// ------> triggers externes
			var triggerProxy:TileTriggersProxy = facade.getProxy(TileTriggersProxy.NAME) as TileTriggersProxy;
			var trigLocator:TriggerLocator = TriggerLocator.getInstance();
			var triggerList:XMLList = ConfigProxy.getInstance().data.triggers;
			// on recup la liste des triggers de la map et on teste ceux à loader
			var tlist:Array = o.triggers;
			// > patch recup des triggers injectées depuis autres map sur la map courante
			var injectTList:Array = triggerProxy.getSpecMapTriggers(o.id);
			if (injectTList)
				tlist = tlist.concat(injectTList);
			
			var n:int = tlist.length;
			var toPLoad:Array;
			var n2:int;
			var dtrigger:Object;
			var ftrigger:String;
			o.externalTriggers = [];	// on crée la liste des triggers externes dans le datamap
			while (--n > -1)
			{
				dtrigger = tlist[n];
				if (dtrigger)
				{
					// > patch assets à préloader
					if (dtrigger.arguments.hasOwnProperty('pload'))
					{
						toPLoad = dtrigger.arguments.pload;
						n2 = toPLoad.length;
						while (--n2 > -1) {
							libProxy.createLoader(toPLoad[n2]);
						}
					}
					
					ftrigger = triggerList.trigger.(@id == dtrigger.classId).@url;
					if (o.externalTriggers.indexOf(dtrigger.classId) > -1)
						continue;
					if (ftrigger && !trigLocator.isRegisteredId(dtrigger.classId))
					{
						// on place le trigger externe en chargement
						libProxy.createLoader(ftrigger);					
						// on stock son id ref dans le datamap
						o.externalTriggers.push(dtrigger.classId);
					}
				}
			}
			
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
			
			// **** MAP 0 *****
			if (o.id == 0)
			{
				dataMapProxy.data = o;
				triggerProxy.parse(o.triggers);
				dataMapProxy.data = null;
				return;
			}
			
			
			// ------> assets
			// liste des tiles
			tlist = o.tileList;	// liste des datas tiles			
			n = tlist.length;
			var dtile:Object;		// data tile
			var nasset:int;		// nombre d'assets du tiles
			var asseturl:String;	// url asset
			while (--n > -1)
			{
				dtile = tlist[n];
				if (dtile.pnj || dtile.sheet)
				{
					libProxy.createLoader(libProxy.tilesPath + dtile.assets[0]);
				}
				else
				{
					nasset = dtile.assets.length;
					while (--nasset > -1)
					{
						asseturl = dtile.assets[nasset];
						// Patch mur ou objet plat
//						if ((dtile.width < .1 && dtile.depth > .1) || dtile.height < .1 || (dtile.depth < .1 && dtile.width > 1))
//							libProxy.addTileAssetLoader(asseturl, false);
//						else
							libProxy.addTileAssetLoader(asseturl);
					}
				}
			}
			
			
			if(o.foregroundFile)
				libProxy.createLoader(libProxy.layersPath + o.foregroundFile);
			
			if (o.backgroundFile)
				libProxy.createLoader(libProxy.layersPath + o.backgroundFile, true);
			
			// TODO à charger une seule fois (premiere map ?)
			libProxy.createLoader(libProxy.spritesPath + "AvatarSkins.swf");
			libProxy.createLoader(libProxy.spritesPath + "moveMarker.swf");
//			libProxy.createLoader("uis/widgets.swf");
			libProxy.createLoader(libProxy.libPath + "HtmlPopup.swf");
						
			// on lance le chargement
			libProxy.load();
			trace(this, " end update Lib");
			
			// on passe les datas au DatamapProxy
			dataMapProxy.data = o;
		}
				
	}
	
}
