/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.proxy {
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.collection.HashMap;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.client.events.*;
	import ddgame.client.commands.*;
	import ddgame.client.triggers.*;
	import ddgame.client.proxy.*;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class TileTriggersProxy extends AbstractProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = ProxyList.TRIGGERS_PROXY;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function TileTriggersProxy(sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var tileTriggerProps:Dictionary = new Dictionary(true);
		private var triggerLocator:TriggerLocator = TriggerLocator.getInstance();
		private var tileTriggerInstances:Dictionary = new Dictionary(true);
		private var _triggersEnabled:Boolean = true;
		
		private var timer:Timer;
		private var oninitMapTriggersProps:Array = [];		// triggers à lancer au chargement
		
		// triggers en attente ciblé sur des maps
		// > patch ajout de triggers via InjectTriggerCommand
		private var specMapTriggersProps:Dictionary = new Dictionary(true);
		// > patch passage d'arguments à un trigger depuis une autre map (via InjectTriggerPropsCommand)
		private var specMapReplaceTriggerArgs:Dictionary = new Dictionary(true);
		private var currentSpecMapReplaceTriggerArgs:Array;
		// map courante
		private var currentMap:int;
		// cookie
		private var _cookie:SharedObject;
		
		public var playerProxy:PlayerProxy;
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------		
		
		// trigger exécuté depuis la map en cours
		public var executedTrigger:Array = [];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------		
		
		public function set cookie (val:SharedObject) : void
		{
			_cookie = val;
		}
		
		public function get dataMapProxy () : DatamapProxy
		{
			return DatamapProxy(facade.getProxy(DatamapProxy.NAME));
		}
		
		public function set triggersEnabled (val:Boolean) : void {
			_triggersEnabled = val;
		}

		public function get triggersEnabled () : Boolean {
			return _triggersEnabled;
		}
		
		public function get allTriggersInMap() : Array
		{
			var ret:Array = [];
			var li:Dictionary = TriggerProperties.list;
			for each (var o:Object in li)
				ret.push(o);
				
			return ret;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Parse une liste de triggers
		 *	@param tlist Array
		 */
		public function parse (tlist:Array /* of Object */) : void
		{
			// on stock l'id de la map courante
			currentMap = dataMapProxy.mapId;
			currentSpecMapReplaceTriggerArgs = specMapReplaceTriggerArgs[currentMap];
			
			var n:int = tlist.length;
			while (--n > -1)
			{
				var o:Object = tlist[n];
				if (!o) continue;
									
				try
				{
					createTrigger(o);
				}
				catch (error:Error)
				{
					trace(error.toString() + " @" + toString());
				}
				
			}
			
			// > patch injection triggers d'une map vers une / des autres
			// on lance le parsing pour map active
			var toInject:Array = specMapTriggersProps[currentMap];
			if (toInject)
			{
				// TODO pas bon de supprimer l'existant, faire en sorte que les triggers à injecter
				// s'ajoutent à ceux existants
				delete specMapTriggersProps[currentMap];
				parse(toInject);
			}
				
			
			trace("-- tile triggers parsed @" + toString());
		}
		
		public function getSpecMapTriggers (mapId:int):Array
		{
			return specMapTriggersProps[mapId];
		}
		
		public function getSpecMapReplaceTriggerArgs (mapId:int):Array
		{
			return specMapReplaceTriggerArgs[mapId];
		}
		
		public function addSpecMapReplaceTriggerArgs (targetTriggerId:int, args:Object, mapId:int):void
		{
			var argsList:Array = specMapReplaceTriggerArgs[mapId];
			if (!argsList) specMapReplaceTriggerArgs[mapId] = [];
			
			args.ttr = targetTriggerId;
			argsList = specMapReplaceTriggerArgs[mapId];
			if (argsList.indexOf(args) == -1)
				argsList.push(args);
		}
		
		/**
		 * Supprime les triggers associés à une source
		 * 
		 *	@param id String identifiant de la source
		 *	@return Array de TileTriggersProxy
		 */
		public function removeAllTriggers (tid:String) : void
		{
			var t:Object;
			var li:Array = allTriggersInMap;
			var n:int = li.length;			
			while (--n > -1)
			{
				t = li[n];
				if (t.refId == tid) removeTrigger(t.id);
			}
		}
		
		public function createEmptyTrigger (id:int) : TriggerProperties {
			return new TriggerProperties(id, 0, 0, "");
		}
		
		/**
		 * Crée et enregistre un nouveau trigger
		 * 
		 *	@param o Object
		 *	@return TriggerProperties
		 */
		public function createTrigger (o:Object, targetMap:int = 0) : TriggerProperties
		{
			// > patch injection trigger dans une map
			if ("tmap" in o)
			{
				var tmap:int = o.tmap;
				if (o.tmap != currentMap)
				{
					if (!specMapTriggersProps[tmap]) specMapTriggersProps[tmap] = [];
					specMapTriggersProps[tmap].push(o);
					return null;
				}
			}
			
			var triggerProps:TriggerProperties = new TriggerProperties(o.id, int(o.classId), int(o.fireType), String(o.tileRefId));
			triggerProps.parseArguments(o.arguments);
			
			// > patch injection d'arguments depuis map externe
			if (currentSpecMapReplaceTriggerArgs)
			{
				var n:int = currentSpecMapReplaceTriggerArgs.length;
				var tArgs:Object;
				while (--n > -1)
				{
					tArgs = currentSpecMapReplaceTriggerArgs[n];
					if (tArgs.ttr == triggerProps.id)
					{
						for (var p:String in tArgs)
							triggerProps.arguments[p] = tArgs[p];
						
						currentSpecMapReplaceTriggerArgs.splice(n, 1);
						break;
					}
				}
			}
			
			// trigger valide si la map précendente n'est pas
			if ("notFM" in o) {
				triggerProps.inactiveFromMaps = o.notFM;
			}
				
			// trigger valide si la map précedente est
			if ("fromM" in o) {
				triggerProps.activeFromMaps = o.fromM;
			}
			
			if (("cond" in o)) {
				triggerProps.cond = o.cond;
			}
			
			if ("dis" in o)
				triggerProps.disable = o.dis;
				
			if ("title" in o)
				triggerProps.title = o.title;

			if (triggerProps.fireEventType)
			{
				// un trigger est déjà enregistré pour cette source
				if (isTrigger(o.tileRefId, triggerProps.fireEventType))
				{
					tileTriggerProps[triggerProps.fireEventType].find(o.tileRefId).push(triggerProps);
				}
				else
				{
					// patch triggers à lancer à l'initialisation de la map
					if (triggerProps.fireType == 8)
						oninitMapTriggersProps.push(triggerProps);
					else
						tileTriggerProps[triggerProps.fireEventType].insert(String(o.tileRefId), [triggerProps]);
				}
			}
			
			return triggerProps;
		}
		
		/**
		 * Appelé au changement d'une propriété d'un TriggerProperties
		 *  
		 *	@param triggerProp	le TriggerProperties
		 *	@param prop String	la propriété qui change
		 * @param newVal			la nouvelle valeur de la propriété
		 */
		public function onTriggerPropertieChange(triggerProps:TriggerProperties, prop:String, newVal:*):void
		{
			switch (prop)
			{
				case "fireType" :
				{
					// mise à jour de la référence
					var tid:String = triggerProps.refId;
					var fevt:String = triggerProps.fireEventType;
					if (fevt)
					{
						var al:Array = tileTriggerProps[fevt].find(tid);
						al.splice(al.indexOf(triggerProps), 1);
					}

					fevt = TriggerProperties.fireTypeList[newVal];
					if (fevt)
					{
						if (isTrigger(tid, fevt))
						{
							tileTriggerProps[fevt].find(tid).push(triggerProps);
						} else {
							// patch triggers à lancer à l'initialisation de la map
							if (newVal == 8)
								oninitMapTriggersProps.push(triggerProps);
							else
								tileTriggerProps[fevt].insert(tid, [triggerProps]);
						}
					}
					break;
				}
			}
		}
		
		/**
		 * Supprime un trigger
		 * vérifie si celui-ci est linké ou en paramètre onComplete
		 * sur d"autres triggers et effectue le nettoyage de leur argument onComplete & slid
		 * sa propriété fireType sera passé à -1 
		 *	@param tid int
		 *	@return Boolean
		 */
		public function removeTrigger (tid:int) : void
		{
			var toRem:Boolean = true;
			var li:Array = allTriggersInMap;
			var n:int = li.length;
			var tr:TriggerProperties;
			var ind:int;
			var args:Array;
			// patch
			var sargs:*;
			while (--n > -1)
			{
				tr = li[n];
				sargs = tr.arguments["onComplete"];
				if (sargs is String)
				{
					args = sargs.split(",");
				} else if (sargs is int ) {
					args = [sargs];
				} else {
					args = sargs;
				}
					
				if (args)
				{
					ind = args.indexOf(tid);
					if (ind > -1)
						args.splice(ind, 1);
				}
				if (tr.linkageId == tid) tr.linkageId = -1;
			}
			
			delete TriggerProperties.list[tid];
		}
		
		/**
		 *	Supprime les triggers de la map encours
		 *	// TODO implémenté localisation des triggers par
		 *	rapport à la map encours
		 */
		public function removeCurrentMapTriggers():void
		{
			// annulation des triggers en cours  d'execution
			for (var t:Object in tileTriggerInstances)
			{
				if (!t.properties.persist) t.cancel();
			}
			
			TriggerProperties.list = new Dictionary(true);
			TriggerProperties.lastHighestId = 5000;
			TriggerProperties.linkedTriggerList = new Array();			
			tileTriggerInstances = new Dictionary(true);
			var n:int = TriggerProperties.fireTypeList.length;
			while (--n > -1)
			{
				var fireType:String = TriggerProperties.fireTypeList[n];
				tileTriggerProps[fireType].clear();
			}
		}
		
		// TODO
		public function findTrigger (id:String) : void
		{
			
		}
		
		/**
		 *	Retrouve un trigger actif de la map
		 *	courante depuis son identifiant
		 */
		public function findActiveTrigger (id:int) : ITrigger
		{
			for (var at:Object in tileTriggerInstances)
				if (at.properties.id  == id) return at as ITrigger;
			
			return null;
		}
		
		/**
		 *	// TODO
		 */
		public function removeMapTriggers (mapId:int) : void
		{
			
		}
		
		/**
		 *	@param tile AbstractTile
		 *	@param fireEvtType String
		 *	@return Boolean
		 */
		public function isActiveTileTrigger (tile:*, fireEvtType:String) : Boolean
		{
			for (var tr:Object in tileTriggerInstances)
			{
				if (tr.sourceTarget == tile)
					if (tr.properties.fireEventType == fireEvtType) return true;
			}
			
			return false;
		}
		
		public function isActiveTrigger (t:TriggerProperties) : Boolean
		{
			return tileTriggerInstances[t] != null;
		}
		
		/**
		 * Retourne la validité du trigger, le fait qu'il puisse être
		 * executé ou pas
		 *	@param t *	un identifiant de trigger ou un TriggerProperties
		 *	@return Boolean
		 */
		public function isValidTrigger (t:*) : Boolean
		{
//			trace(t, "disable", t.disable);
			if (!(t is TriggerProperties)) t = TriggerProperties.list[t];
			if (!t) return false;
			return t.fireCount < t.maxFireCount && isValidForCurrentMap(t) && !t.disable;
		}
		
		/**
		 * Retourne la validité d'un trigger pour la map en cours
		 *	@param t TriggerProperties
		 *	@return Boolean
		 */
		public function isValidForCurrentMap (t:TriggerProperties) : Boolean
		{
			var lastMid:String = String(dataMapProxy.lastMapId);

			// trigger valide si la map précendente n'est pas
			if (t.inactiveFromMaps) {
				var inact:Array = t.inactiveFromMaps;
				if (inact.indexOf(lastMid) > -1) {
					return false;
				}
			}
			
			// trigger valide si la map précedente est
			if (t.activeFromMaps) {
				if (t.activeFromMaps.indexOf(lastMid) == -1) {
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * Check si un tile à au moins un trigger
		 * 
		 *	@param tile AbstractTile
		 *	@return Boolean
		 */
		public function hasTrigger (tile:*) : Boolean
		{
//			if (tile.inGroup) tile = AbstractTile(tile.inGroup.owner);
			if ("inGroup" in tile) {
				if (tile.inGroup)
					tile = AbstractTile(tile.inGroup.owner);
			}
			
			var li:Array = allTriggersInMap;
			var tid:String = tile.ID;
			var n:int = li.length;
			
			while (--n > -1) {
				if (li[n].refId == tid) return true;
			}
			
			return false;
		}
		
		/**
		 * Retourne true si au moins un trigger est valide pour un tile
		 * c'est à dire si au moins un trigger peut être déclenché
		 *	@param tile AbstractTile
		 *	@return Boolean
		 */
		public function hasValidTrigger (tile:*) : Boolean
		{
//			if (tile.inGroup) tile = AbstractTile(tile.inGroup.owner);
			if ("inGroup" in tile) {
				if (tile.inGroup)
					tile = AbstractTile(tile.inGroup.owner);
			}
			
			var li:Array = allTriggersInMap;
			var tid:String = tile.ID;
			var n:int = li.length;
			var t:TriggerProperties;
			
			while (--n > -1) {
				t = li[n];
				if (t.refId == tid) {
					if (isValidTrigger(t)) return true;
				}
			}
			
			return false;
		}
		
		public function hasTriggerId(id:String):Boolean
		{
			for each (var p:HashMap in tileTriggerProps)
			{
				if (p.containsKey(id))
					return true;
			}
			return false;		
		}
		
		public function isTrigger(id:String, firetype:String):Boolean
		{
			return tileTriggerProps[firetype].find(id) != null;
		} 
		
		/**
		 *	Retourne la liste des ITrigger associés
		 *	à un tile
		 */
//		public function getTriggerPropertieList(tile:AbstractTile):Array /* of Trigger */
/*		{
			var a:Array = [];
//			var id:int = tile.ID;
			var id:String = tile.ID;
			for each (var p:HashMap in tileTriggerProps)
			{
				var tp:Object = p.find(id);
				tp != null ? a.push(tp) : void;
			}
			return a;
		}*/
		
		
		public function findTileByTrigger(trigger:ITrigger):AbstractTile
		{ return tileTriggerInstances[trigger]; }
		
		
		/**
		 * Retourne tous les TriggerProperties pour une source
		 * 
		 *	@param id String identifiant de la source
		 *	@return Array de TileTriggersProxy
		 */
		public function getAllTriggers(tid:String):Array
		{
			var tList:Array = [];
			var tp:Object;
			var li:Array = allTriggersInMap;
			var n:int = li.length;
			
			while (--n > -1)
			{
				tp = li[n];
				if (tp.refId == tid) tList.push(tp);
			}
			
			return tList;
		}
		
		public function getTrigger(trid:int):TriggerProperties
		{
			return TriggerProperties.list[trid];
		}
		
		public function launchTileTrigger(tile:AbstractTile, fireEvtType:String):void
		{
			if (tile.inGroup) tile = AbstractTile(tile.inGroup.owner);
//			var triggerProps:TriggerProperties = tileTriggerProps[fireEvtType].find(tile.ID);
//			launchTrigger(triggerProps, tile);
			var atProps:Array = getTriggerList(tile.ID, fireEvtType);			
			var n:int = atProps.length;
			while(--n > -1)
				launchTrigger(atProps[n], tile);
		}
		
		/**
		 *	Lance l'execution d'un trigger 
		 */
		public function launchTrigger (triggerProps:TriggerProperties, sourceObj:Object = null) : void
		{
			if (!triggersEnabled) return;

			if (!isValidTrigger(triggerProps)) return;
			
			// on test si le trigger est un lien symbolique
			var slink:TriggerProperties = TriggerProperties.list[triggerProps.symbLinkId];
			var props:TriggerProperties = triggerProps;
			if (slink != null)
			{
				if (!isValidTrigger(slink)) return;
				props = slink;
			}

			// var props:TriggerProperties =  slink != null ? slink : triggerProps;
			
			// test sur conditions
			/*if (!conditionResolver(props)) {
				trace(this, "conditions requises", props.getCond("msg"));
				return;
			}*/
			
			// test passage d'arguments
			if (sourceObj is ITrigger || slink != null)
			{
				var sourceProps:TriggerProperties = slink != null ? triggerProps : sourceObj.properties;
				if (sourceProps.arguments["passArgs"] && sourceProps.arguments["passVals"])
				{
					var args:Array = String(sourceProps.arguments["passArgs"]).split(",");
					var vals:Array = String(sourceProps.arguments["passVals"]).split(",");
					var n:int = args.length;
					while (--n > -1) {
						props.arguments[args[n]] = vals[n];
					}
				}
			}
			
			// test sur le nombre de fois que le trigger peut être executé
			// l'incrémenation des executions est faite dans triggerHandler

//			if (props.fireCount == props.exec)
			/*if (props.fireCount == props.maxFireCount)
				return;*/

			// on execute le trigger
			var classRef:Class = triggerLocator.findTriggerClass(props.triggerClassId);
			if (classRef)
			{
				var trigger:ITrigger = new classRef();
				trigger.channel = channel;
				trigger.properties = props;
				trigger.sourceTarget = sourceObj;
				tileTriggerInstances[trigger] = sourceObj;
				trigger.initialize();
			} else {
				trace("-- réf de classe [Trigger].CLASS_ID:" + props.triggerClassId + " non trouvée @" + this);
			}
		}
		
		public function fireOnInitMapTriggers () : void
		{
			var n:int = oninitMapTriggersProps.length;
			while (--n > -1)
				launchTrigger(oninitMapTriggersProps[n]);
				
			oninitMapTriggersProps = [];
		}
		
		/**
		 *	Execute un trigger depuis son identifiant target et son type de déclenchement.
		 *	Si le trigger n'existe pas l'éxecution n'a pas lieu
		 */
		public function launchTriggerByRef (id:String, fireEvtType:String, sourceObj:Object = null) : void
		{
			var atProps:Array = getTriggerList(id, fireEvtType);
			if (!atProps) return;
			
			var n:int = atProps.length;
			while (--n > -1) launchTrigger(atProps[n], sourceObj);
		}
		
		public function launchTriggerByID (id:int, sourceObj:Object = null) : void
		{
			var triggerProps:TriggerProperties = TriggerProperties.list[id];
			if (triggerProps != null)
				launchTrigger(triggerProps, sourceObj);
		}
		
		// --- WIP ---
		public function conditionResolver (t:TriggerProperties) : Boolean
		{
			// condition sur points du joueur
			
			// > "player points up" points du joeur suppérieur à
			var b:Array = playerProxy.allPoints;
			var c:* = t.getCond("ppu");
			trace(this, "condition", c);
			if (c)
			{
				for (var i:int = 0; i < 4; i++)
				{
					if (!c[i]) continue;
					if (b[i] < c[i]) return false;
				}
			}
			
			return true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Handler quand un trigger à mis fin à son execution
		 *	un test est éffectué pour savoir si un chainage existe
		 *	avec un autre trigger, si oui le trigger chainé est executé
		 */
		protected function triggerHandler (event:TriggerEvent) : void
		{
			var trigger:ITrigger = event.trigger;
			delete tileTriggerInstances[trigger];
			/*trigger.channel = null;
			trigger.properties = props;
			trigger.sourceTarget = sourceObj;*/

			if (event.isDefaultPrevented()) return;
						
			switch (event.type)
			{
				case TriggerEvent.EXECUTE :
				{
					// incrémentation nombre d'execution
					trigger.properties.fireCount++;					
					// on lance les overrides
					writeOverrideTrigger(trigger, 0);
					break;
				}
				case TriggerEvent.COMPLETE :
				{
					// on lance les overrides
					writeOverrideTrigger(trigger, 1);
					// lancement des triggers chainés
					var linkTriggerProps:TriggerProperties = TriggerProperties.linkedTriggerList[trigger.properties.id];
					if (linkTriggerProps is TriggerProperties)
					{
						launchTrigger(linkTriggerProps);
					}
					else if (trigger.isPropertie("onComplete"))
					{
						var tlist:Array = String(trigger.getPropertie("onComplete")).split(",");
						var l:int = tlist.length;
						for (var i:int = 0; i < l; i++)
							launchTriggerByID(tlist[i]);
					}
					break;
				}
				case TriggerEvent.CANCELED :
				{
					// on lance les overrides
					writeOverrideTrigger(trigger, 2);
					break;
				}
				default :
				{ break; }
			}
			
			/*if (event.type == TriggerEvent.COMPLETE)
			{
				// incrémentation du nombre d'éxcutions
//				trigger.properties.exec++;
				var p:Object = trigger.properties;
				var fc:int = ++p.fireCount;

				// injection de propriétés dans un autre trigger
				// argument ovTrig "override trigger" :
            // 	- type:Array
				//		- entrées : evnt|eid|tid|prop|val|prop|val...
				//				evnt	actif depuis
				//						0 l'injection se fera à l'init du trigger
				//						1 l'injection se fera àu complete du trigger
				//						2 l'injection se fera àu cancel du trigger
				//				eid	identifiant execution, -1 pour que l'écrasement des propriétées se
				//						fasse à chaque fois
				//				tid 	identifiant du trigger sur lequel les propriétées / arguments seront remplacées
				//				prop	propriété argument à remplacer
				//				val	valeur de remplacement
				//		ex:
				//			_ovT
				//				- 1|3|maxFireCount|0  	< à toutes les exec le trigger va mettre la prop maxFireCount du trigger 3 à 0
				//				- 3|2|url|toto.com		< à la 3 exec le trigger va mettre la prop url à toto.com
								
				
				var ova:Array = trigger.getPropertie("_ovT");
				if (ova)
				{		
					var o:Array;
					var toi:Object;
					for each (var ov:Object in ova)
					{
						// on regarde si le fireCount actuel correspond au "remplacement"
						var indCount:int = int(ov.substring(0, ov.indexOf("|")));
						if (indCount == fc || indCount == 0)
						{
							o = ov.split("|");
							toi = getTrigger(o[1]);
							if (toi)
							{
								for (var j:int = 2; j < o.length; j+=2) {
									toi.setArgument(o[j], o[j+1]);
//									trace("override", o[j], o[j+1]);
								}
							}
						}
					}
				}
				
				// lancement des triggers chainés
				var linkTriggerProps:TriggerProperties = TriggerProperties.linkedTriggerList[trigger.properties.id];
				if (linkTriggerProps is TriggerProperties)
				{
					launchTrigger(linkTriggerProps);
				}
				else if (trigger.isPropertie("onComplete"))
				{
					var tlist:Array = String(trigger.getPropertie("onComplete")).split(",");
					var l:int = tlist.length;
					for (var i:int = 0; i < l; i++)
						launchTriggerByID(tlist[i]);
				}
			}
			else
			{
				// on est sur un trigger annulé
			}*/
			// nettoyage
//			trigger.release();
			
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// injection de propriétés dans un autre trigger
		// argument ovTrig "override trigger" :
      // 	- type:Array
		//		- entrées : evnt|eid|tid|prop|val|prop|val...
		//				evnt	actif depuis
		//						0 l'injection se fera à l'init du trigger
		//						1 l'injection se fera àu complete du trigger
		//						2 l'injection se fera àu cancel du trigger
		//				eid	identifiant execution, -1 pour que l'écrasement des propriétées se
		//						fasse à chaque fois
		//				tid 	identifiant du trigger sur lequel les propriétées / arguments seront remplacées
		//				prop	propriété argument à remplacer
		//				val	valeur de remplacement
		//		ex:
		//			_ovT
		//				- 1|3|maxFireCount|0  	< à toutes les exec le trigger va mettre la prop maxFireCount du trigger 3 à 0
		//				- 3|2|url|toto.com		< à la 3 exec le trigger va mettre la prop url à toto.com
		private function writeOverrideTrigger (trigger:ITrigger, evt:int) : void
		{
			var ova:Array = trigger.getPropertie("_ovT");
			if (ova)
			{		
				var o:Array;
				var toi:Object;
				var indCount:int;
				var fc:int = trigger.properties.fireCount;

				for each (var ov:Object in ova)
				{
					o = ov.split("|");
					// on regarde si l'evnt type ecr&sement correspond (execute, complete ou cancel)
					if (int(o.shift()) != evt) continue;
				
					// on regarde si le fireCount actuel correspond au "remplacement"
					indCount = o.shift();
					if (indCount == fc || indCount == 0) // firecount corespond ou override est chaque exec
					{
						// recup du trigger à overrider
						toi = getTrigger(o.shift());
						if (toi)
						{
							for (var j:int = 0; j < o.length; j+=2)
								toi.setArgument(o[j], o[j+1]);
						}
					}
				}
			}
		}
				
		/**
		 *	@private
		 *	retourne la liste des triggers associé à une source
		 *	pour un fireEventType donné
		 */
		private function getTriggerList (sourceId:String, fireEvtType:String) : Array
		{
			return tileTriggerProps[fireEvtType].find(sourceId);
		}
				
		/**
		 * Call by super class
		 */
		override public function initialize () : void
		{
				// Register the base Tile Triggers
			var tlist:Array /* of Class */ = BaseTriggerList.listTriggers();
			var n:int = tlist.length;
			while (--n > -1)
			{
				var classRef:Class = tlist[n];
				triggerLocator.registerTriggerClass(classRef.CLASS_ID, classRef);
			}
			
				// Initialize Tile Triggers Properties "HashMap"
			n = TriggerProperties.fireTypeList.length;
			while (--n > -1)
			{
				var fireType:String = TriggerProperties.fireTypeList[n];
				tileTriggerProps[fireType] = new HashMap();
			}
			
			// timer pour fire type 9
			// timer = new Timer();
			
			
			channel.addEventListener(TriggerEvent.EXECUTE, triggerHandler);
			channel.addEventListener(TriggerEvent.COMPLETE, triggerHandler);
			channel.addEventListener(TriggerEvent.CANCELED, triggerHandler);
			
			playerProxy = PlayerProxy(facade.getProxy(PlayerProxy.NAME));
			
		}
	}
	
}
