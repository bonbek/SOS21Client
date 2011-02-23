package ddgame.client.proxy {
	
	import com.sos21.utils.ConditionResolver;
	import com.sos21.utils.Condition;
	import com.sos21.proxy.AbstractProxy;
	import ddgame.client.proxy.*;
	import ddgame.server.proxy.*;

	/**
	 *	Proxy variables environement
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  19.12.2010
	 */
	public class EnvProxy extends AbstractProxy {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		public static const NAME:String = ProxyList.ENV_PROXY;
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function EnvProxy (sname:String = null)
		{
			super(sname == null ? NAME : sname);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var globals:Object;
		private var resolver:ConditionResolver;
		private var operators:Array = ["<=",">=","<",">","!=","=","()","(!)"];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Vérification d'une condition encodée sous forme String ou
		 * un tableau liste de condition encodée sous forme String.
		 * Si un tableau est passé voir les règles s'appliquant à ConditionResolver
		 * 
		 * TODO
		 * décrire l'encodage et toutes ses options
		 * 
		 *	@return Boolean
		 */
		public function resolve (cond:Object, rule:Object = "all", ruleParams:Object = null) : Boolean
		{
//return true;
//			var st:int = getTimer();
			resolver = new ConditionResolver(rule, ruleParams);

			if (cond is Array)
			{
				// on est sur une liste de conditions
				for each (var c:String in cond)
					resolver.pushCondition(createResolver(c));
			}
			else
			{
				// on est sur une seule condition				
				resolver.pushCondition(createResolver(String(cond)));
			}

//			trace("info", this, "verify cond", cond, ".....", resolver.verify(), getTimer() - st);

			return resolver.verify();
		}

		/**
		 * Crée un ConditionResolver depuis un encodage texte
		 * // TODO documenter
		 * 
		 *	@param scond String
		 *	@return ConditionResolver
		 */	
		public function createResolver (scond:String) : ConditionResolver
		{
			var resolver:ConditionResolver;

			// > explosion sur les OR
			// Plusieurs resolver dont au moins 1 de bon

			var least:Array = scond.split("|");
			if (least.length > 1)
			{
				resolver = new ConditionResolver("least", 1);
				for each (var sc:String in least)
				{
					resolver.pushCondition(createResolver(sc));
				}

				return resolver;
			}

			// > explosion sur les AND ou condition simple
			// 1 seul resolver avec plusieurs conditions simple toutes bonnes

			var all:Array = scond.split("&");
			resolver = new ConditionResolver();
			var part:Array;
			var actorValue:*;
			for each (var sa:String in all)
			{
				for each (var op:String in operators)
				{
					if (sa.indexOf(op) > -1)
					{
						part = sa.split(op);
//trace("actor", part[0], "value:", get(part[0]));
//trace(op, get(part[1]));
						resolver.create(null, get(part[0])).add(op, get(part[1]));
						break;
					}
				}
			}

			return resolver;
		}
		
		/**
		 * Retourne la valeur d'une var depuis une clé (String pour l'instant)
		 * 
		 * p : var concernant joueur
		 * > p.g : var joueur globale. ex p.g.2 var globale joueur id 2
		 * > p.l : var joueur locale (scène). ex p.l.5 var locale joueur id 5
		 * > p.l.px : 
 		 * > p.eco : points eco joueur
		 * > p.soc : points social joueur
		 * > p.env : points environnement jour
		 * > p.pir : points piraniak joueur
		 * > p.level : niveau joueur
		 * > 
		 * TODO
		 * g : var globale. ex : g.1 variable globale id 1
		 * l : var locale (scène). ex : g.2 variable locale id 2
		 * d : var concernant la date
		 * > d.month
		 * > d.year
		 * > d.date
		 * 
		 *	@param key *
		 *	@return Object
		 */
		public function get (key:*) : Object
		{
			var part:Array = key.split(".");
			var value:*;

			switch (part.shift())
			{
				// on est sur une variable joueur
				case "p" :
				{
					var p:* = part.shift();
					switch (p)
					{
						// on est sur une variable globale
						case "g" :
							value = playerProxy.getGlobalEnv(part.shift());
							break;
						// on est sur une variable locale
						case "l" :
							value = playerProxy.getLocalEnv(part.shift());
							break;
						// on est sur une propriété PlayerProxy
						default :
							value = playerProxy[p];
							break;
					}
					break;
				}
				// on est sur une variable globale
				case "g" :
				{
					value = globals[part.shift()].value;
					break;
				}
				// on est sur une variable locale
				case "l" :
				{
					value = datamapProxy.env[part.shift()].value;
					break;
				}
				// par defaut la valeur est la clé que l'on essaie de parser / caster
				default :
				{
//					value = key is String ? JSON.decode(key) : key;
					value = key;
					if (int(key))
					{
						value = int(key);
					}
					else if (key is String)
					{
						if (key.charAt(0) == "[")
						{
							value = key.substring(1, key.length - 1).split(",");
							for (var i:int = 0; i < value.length; i++)
								value[i] = get(value[i]);
						}
					}
					break;
				}
			}
			
			return value;
		}
		
		/**
		 * Ecrit la valeur d'une variable depuis un clé "sérialisée"
		 * 
		 *	@private
		 *	@return 
		 */
		public function set (key:String, value:*) : void
		{
			var part:Array = key.split(".");
			var value:*;
			
			switch (part.shift())
			{
				// on est sur une variable joueur
				case "p" :
				{					
					switch (part.shift())
					{
						// on est sur une variable globale
						case "g" :
							playerProxy.setGlobalEnv(part.shift(), value);
							break;
						// on est sur une variable locale
						case "l" :
							playerProxy.setLocalEnv(part.shift(), value);
							break;
						default :
							trace(this, "pas params autre que global ou local pour écriture de vars");
							break;
					}
					break;
				}
				// on est sur une variable globale
				case "g" :
				{
					// TODO
					break;
				}
				// on est sur une variable locale
				case "l" :
				{
					// TODO
					break;
				}
			}
		}		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Reception de la liste des globals
		 *	@param e Object
		 */
		private function onGlobals (e:Object) : void
		{
			remotingProxy.service.removeServiceListener(RemotingProxy.globalsCall, onGlobals);
			
			if (e.failed) trace("info", this, "failed");
			else
				globals = [null].concat(e.result);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Refs
		protected function get playerProxy () : PlayerProxy
		{ return PlayerProxy(facade.getProxy(PlayerProxy.NAME)); }
		
		protected function get datamapProxy () : DatamapProxy
		{ return DatamapProxy(facade.getProxy(DatamapProxy.NAME)); }
		
		protected function get triggersProxy () : TileTriggersProxy
		{ return TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)); }
		
		protected function get remotingProxy () : RemotingProxy
		{ return RemotingProxy(facade.getProxy(RemotingProxy.NAME)); }
		
		/**
		 * @inheritDoc
		 */
		override public function initialize () : void
		{
			// recup des globals
			var rp:RemotingProxy = remotingProxy;
			rp.service.addServiceListener(RemotingProxy.globalsCall, onGlobals, false, 0, true);
			rp.service.callService(RemotingProxy.globalsCall, "list");
		}
	
	}

}

