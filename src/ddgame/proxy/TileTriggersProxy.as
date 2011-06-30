/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.proxy {
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.net.SharedObject;
	import flash.utils.*;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.collection.HashMap;
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.events.*;
	import ddgame.commands.*;
	import ddgame.triggers.*;
	import ddgame.proxy.*;
	import ddgame.server.IClientServer;

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

		public function TileTriggersProxy (sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, odata);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var tileTriggerProps:Dictionary = new Dictionary(true);
		private var triggerLocator:TriggerLocator = TriggerLocator.getInstance();
		private var tileTriggerInstances:Array = [];
		private var _triggersEnabled:Boolean = true;
		
		// timer pour trigger basés sur temps
		private var tick:Timer;
		// temps écoulé depuis entrée dans une scène
		private var lElapsedTime:int;
		// triggers à lancer au chargement
		private var oninitMapTriggersProps:Array = [];
		// triggers de la map encours basés sur un lancement timer
		private var tickMapTriggersProps:Array = [];
		
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
		
		// Pour debug
		public var tickExec:int;
		public var initMapExex:int;
		public var hasValidExec:int;
		
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

		public function get serverProxy () : IClientServer
		{
			return IClientServer(facade.getProxy(ProxyList.SERVER_PROXY));
		}
		
		public function get envProxy () : EnvProxy
		{
			return EnvProxy(facade.getProxy(EnvProxy.NAME));
		}
		
		public function set triggersEnabled (val:Boolean) : void
		{
			if (val) tick.start();
			else
			tick.stop();

			_triggersEnabled = val;
		}

		public function get triggersEnabled () : Boolean {
			return _triggersEnabled;
		}
		
		/**
		 * Liste de tous les triggers, scène encours plus triggers
		 * persistants
		 */
		public function get allTriggers () : Array
		{
			var list:Array = [];
			for each (var o:Object in TriggerProperties.list)
				list.push(o);
				
			return list;
		}
		
		/**
		 * Liste des triggers de la scène en cours
		 */
		public function get currentMapTriggers () : Array
		{
			var list:Array = [];
			for each (var o:Object in TriggerProperties.list) {
				if (!o.persist) list.push(o);
			}
				
			return list;			
		}
		
		/**
		 * Liste de tous les triggers persistants
		 */
		public function get persistantTriggers () : Array
		{
			var list:Array = [];
			for each (var o:Object in TriggerProperties.list) {
				if (o.persist) list.push(o);
			}
				
			return list;
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
					trace("error", this, error.toString());
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
			var li:Array = allTriggers;
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
			if ("fromM" in o)
				triggerProps.activeFromMaps = o.fromM;
			
			if ("cond" in o)
				triggerProps.cond = o.cond;
			
			if ("dis" in o)
				triggerProps.disable = o.dis;
				
			if ("title" in o)
				triggerProps.title = o.title;
			
			if ("exec" in o)
				triggerProps.fireCount = o.exec;
				
			if ("lev" in o)
				triggerProps.level = o.lev;
			
			if (triggerProps.fireEventType)
			{
				// un trigger est déjà enregistré pour cette source
				if (isTrigger(o.tileRefId, triggerProps.fireEventType))
				{
					tileTriggerProps[triggerProps.fireEventType].find(o.tileRefId).push(triggerProps);
				}
				else
				{
					// patch triggers à lancer à l'initialisation de la map et triggers
					// en continus
					if (triggerProps.fireType == 8)
					{
						oninitMapTriggersProps.push(triggerProps);
					}
					else if (triggerProps.fireType == 9)
					{
						tickMapTriggersProps.push(triggerProps);
					}
					else
					{
						tileTriggerProps[triggerProps.fireEventType].insert(String(o.tileRefId), [triggerProps]);
					}
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
		public function onTriggerPropertieChange (triggerProps:TriggerProperties, prop:String, newVal:*) : void
		{
			switch (prop)
			{
				case "fireType" :
				{
					var tid:String = triggerProps.refId;
					
					if (triggerProps.fireType == 8)
					{
						for each (var t:Object in oninitMapTriggersProps) {
							if (t.id == triggerProps.id) {
								oninitMapTriggersProps.splice(oninitMapTriggersProps.indexOf(triggerProps), 1);
								break;
							}
						}
					}
					else if (triggerProps.fireType == 9)
					{
						for each (t in tickMapTriggersProps) {
							if (t.id == triggerProps.id) {
								tickMapTriggersProps.splice(tickMapTriggersProps.indexOf(triggerProps), 1);
								break;
							}
						}
					}
					else
					{
						var fevt:String = triggerProps.fireEventType;
						if (fevt)
						{
							var al:Array = tileTriggerProps[fevt].find(tid);
							var ind:int = al.indexOf(triggerProps);
							if (ind > -1) al.splice(ind, 1);
						}						
					}
					
					// mise à jour de la référence

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
							else if (newVal == 9)
								tickMapTriggersProps.push(triggerProps);
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
			var li:Array = allTriggers;
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
			for each (var t:Object in tileTriggerInstances)
			{
				if (!t.properties.persist)
				{
					t.cancel();
					_forgetTriggerInstance(t);
				}
			}
			
			// mise à z
			for each (t in TriggerProperties.list)
			{
				if (!t.persist) delete TriggerProperties.list[t.id];
			}
			
//			TriggerProperties.list = new Dictionary(true);
			TriggerProperties.lastHighestId = 5000;
			TriggerProperties.linkedTriggerList = [];
//			tileTriggerInstances = [];
			tickMapTriggersProps = [];
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
//			for (var at:Object in tileTriggerInstances)
			for each (var at:Object in tileTriggerInstances)
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
			for each (var tr:Object in tileTriggerInstances)
			{
				if (tr.sourceTarget == tile)
					if (tr.properties.fireEventType == fireEvtType) return true;
			}
			
			return false;
		}
		
		/**
		 * Flag trigger est en instance d'execution
		 *	@param t TriggerProperties
		 *	@return Boolean
		 */
		public function isActiveTrigger (t:TriggerProperties) : Boolean
		{
			for each (var tr:Object in tileTriggerInstances)
				if (tr.properties == t) return true;

			return false;
//			return tileTriggerInstances.indexOf(t) != null;
		}
		
		/**
		 * Retourne la validité du trigger, le fait qu'il puisse être
		 * executé ou pas
		 *	@param t *	un identifiant de trigger ou un TriggerProperties
		 *	@return Boolean
		 */
		public function isValidTrigger (t:*) : Boolean
		{
			if (!(t is TriggerProperties)) t = TriggerProperties.list[t];
			if (!t) return false;
			var cond:Boolean = t.cond ? envProxy.resolve(t.cond) : true;
			return	t.fireCount < t.maxFireCount
						&& isValidForCurrentMap(t)
						&& !t.disable
						&& (!t.level || t.level == playerProxy.level)
						&& cond;
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
			
			var li:Array = allTriggers;
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
			var ti:int = getTimer();
//			if (tile.inGroup) tile = AbstractTile(tile.inGroup.owner);
			if ("inGroup" in tile) {
				if (tile.inGroup)
					tile = AbstractTile(tile.inGroup.owner);
			}
			
			var li:Array = allTriggers;
			var tid:String = tile.ID;
			var n:int = li.length;
			var t:TriggerProperties;
			
			var hs:Boolean = false;
			while (--n > -1) {
				t = li[n];
				if (t.refId == tid) {
					if (isValidTrigger(t)) {
						hs = true;
						break;
					}
				}
			}
			hasValidExec = getTimer() - ti;
			return hs;
		}
		
		public function hasTriggerId (id:String) : Boolean
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
		
		
		public function findTileByTrigger(trigger:ITrigger) : AbstractTile
		{ return trigger.sourceTarget as AbstractTile; }
		
		
		/**
		 * Retourne tous les TriggerProperties pour une source
		 * 
		 *	@param id String identifiant de la source
		 *	@return Array de TileTriggersProxy
		 */
		public function getAllTriggers (tid:String) : Array
		{
			var tList:Array = [];
			var tp:Object;
			var li:Array = allTriggers;
			var n:int = li.length;
			
			while (--n > -1)
			{
				tp = li[n];
				if (tp.refId == tid) tList.push(tp);
			}
			
			return tList;
		}
		
		/**
		 * Retourne un trigger depuis son id
		 *	@param trid int
		 *	@return TriggerProperties
		 */
		public function getTrigger (id:int) : TriggerProperties
		{
			return TriggerProperties.list[id];
		}
		
		/**
		 * Lance les triggers associé à la source et au type d'event donné
		 *	@param tile AbstractTile
		 *	@param fireEvtType String
		 */
		public function launchTileTrigger (tile:AbstractTile, fireEvtType:String) : void
		{
			// TODO, cette vérif est à mettre autre part
			if (tile.inGroup) tile = AbstractTile(tile.inGroup.owner);
			
			// fire
			for each (var tr:TriggerProperties in getTriggerList(tile.ID, fireEvtType))
				launchTrigger(tr, tile);
		}
		
		/**
		 *	Lance l'execution d'un trigger
		 */
		public function launchTrigger (triggerProps:TriggerProperties, sourceObj:Object = null) : void
		{

			if (!triggersEnabled) return;

			// Test de validité
			if (!isValidTrigger(triggerProps)) return;
			
			_launchTrigger(triggerProps, sourceObj);
		}
		
		/**
		 *	Lance l'execution d'un trigger sans tests de validité
		 * Utile en interne quand test de validité est effectué en amont
		 */
		private function _launchTrigger (triggerProps:TriggerProperties, sourceObj:Object = null) : void
		{
			var props:TriggerProperties = triggerProps;
			// Test si trigger est un racourci vers un autre trigger
			if (triggerProps.symbLinkId != -1)
			{
//				trace("info", "LINKED", triggerProps.symbLinkId);
				var slink:TriggerProperties = TriggerProperties.list[triggerProps.symbLinkId];
				if (slink != null)
				{
					if (!isValidTrigger(slink)) return;
					props = slink;
				}
			}

			// Passage d'arguments
			if (sourceObj is ITrigger || slink != null)
			{
				var sourceProps:TriggerProperties = slink != null ? triggerProps : sourceObj.properties;
				if (sourceProps.arguments["passArgs"] && sourceProps.arguments["passVals"])
				{
					var args:Array = String(sourceProps.arguments["passArgs"]).split(",");
					var vals:Array = String(sourceProps.arguments["passVals"]).split(",");
					var n:int = args.length;
					while (--n > -1)
						props.arguments[args[n]] = vals[n];
				}
			}

			// On init l'execution du trigger
			var classRef:Class = triggerLocator.findTriggerClass(props.triggerClassId);
			if (classRef)
			{
				var trigger:ITrigger = new classRef();
				trigger.channel = channel;
				trigger.properties = props;
				trigger.sourceTarget = sourceObj;
				tileTriggerInstances.push(trigger);
				trigger.initialize();
			}
			else
			{ trace("Warning: class ", props.triggerClassId, " not found", " action", props.id); }
		}
		
		/**
		 *	@private
		 * Execute les triggers du début de scène
		 */
		public function fireOnInitMapTriggers () : void
		{
			var t:int = getTimer();
			for each (var tr:TriggerProperties in oninitMapTriggersProps)
				launchTrigger(tr);

			oninitMapTriggersProps = [];

			initMapExex = getTimer() - t;	
		}
		
		/**
		 *	Execute un trigger depuis son identifiant target et son type de déclenchement.
		 *	Si le trigger n'existe pas l'éxecution n'a pas lieu
		 */
		public function launchTriggerByRef (id:String, fireEvtType:String, sourceObj:Object = null) : void
		{
			var atProps:Array = getTriggerList(id, fireEvtType);
			if (!atProps) return;
			
			// Tri des trigger valides à pour une source sur un type d'event cet instant t
			// pour éviter un confli de type : 2 actions sur un click la première est conditionée sur
			// la seconde et modifie la condition, la deuxieme est conditionnée sur la premiere et modifie
			// la condition > résultat : les deux actions vont se lancer alors que le but recherché est d'avoir
			// un flag qui nous permet de lancer soit l'une, soit l'autre
			var vatProps:Array = [];
			for each (var p:TriggerProperties in atProps)
			{
				if (isValidTrigger(p)) vatProps.push(p);
			}

			for each (p in vatProps)
				launchTrigger(p, sourceObj);
		}
		
		public function launchTriggerByID (id:int, sourceObj:Object = null) : void
		{
			var triggerProps:TriggerProperties = TriggerProperties.list[id];
			if (triggerProps != null)
				launchTrigger(triggerProps, sourceObj);
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


			if (event.isDefaultPrevented()) return;
						
			switch (event.type)
			{
				case TriggerEvent.EXECUTE :
				{
					// incrémentation nombre d'execution
					trigger.properties.fireCount++;					
					// on lance les overrides
					writeOverrideTrigger(trigger, 0);
					
					// Test send action
					serverProxy.getServices("action").create(	{player:playerProxy.getData(),
																			place:dataMapProxy.getData(),
																			action:trigger.properties}).save(null);
					playerProxy.actionExecuted(trigger.properties.id, trigger.properties.persist ? "0" : String(currentMap));

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
					var ind:int = tileTriggerInstances.indexOf(trigger);
					_forgetTriggerInstance(trigger);
					break;
				}
				case TriggerEvent.CANCELED :
				{
					// on lance les overrides
					writeOverrideTrigger(trigger, 2);
					_forgetTriggerInstance(trigger);
					break;
				}
				default :
				{ break; }
			}
			
		}
		
		private function onTick (e:Event) : void
		{
			var ti:int = getTimer();
			for each (var t:TriggerProperties in tickMapTriggersProps) {
				launchTrigger(t);
			}

			tickExec = getTimer() - ti;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function _forgetTriggerInstance (trigger:Object) : void
		{
			var ind:int = tileTriggerInstances.indexOf(trigger);
			if (ind > -1)
				tileTriggerInstances.splice(ind, 1);
		}
		
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
		public function getTriggerList (sourceId:String, fireEvtType:String) : Array
		{ 
			var props:Object = tileTriggerProps[fireEvtType];
			return props ? props.find(sourceId) : null;
		}
				
		/**
		 * Call by super class
		 */
		override public function initialize () : void
		{
			// Reférencement des class de triggers
			var tlist:Array /* of Class */ = BaseTriggerList.listTriggers();
			for each (var classRef:Class in tlist)
				triggerLocator.registerTriggerClass(classRef.CLASS_ID, classRef);
			
			// Initialize Tile Triggers Properties "HashMap"
			for each (var fireType:String in TriggerProperties.fireTypeList)
				tileTriggerProps[fireType] = new HashMap();
			
			// Passage ref proxy
			TriggerProperties.triggersProxy = this;

			// timer pour firetype 9
			tick = new Timer(100);
			tick.addEventListener("timer", onTick);
//			tick.start();
			
			// Ecoute execution de triggers
			channel.addEventListener(TriggerEvent.EXECUTE, triggerHandler);
			channel.addEventListener(TriggerEvent.COMPLETE, triggerHandler);
			channel.addEventListener(TriggerEvent.CANCELED, triggerHandler);
			
			// ref playerProxy
			playerProxy = PlayerProxy(facade.getProxy(PlayerProxy.NAME));
			
		}
	}
	
}
