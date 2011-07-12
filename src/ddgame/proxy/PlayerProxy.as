package ddgame.proxy {
	
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.AbstractProxy;
	import ddgame.server.IClientServer;
	import ddgame.server.IPlayerDocument;
	import ddgame.server.IDocumentServices;
	import ddgame.events.EventList;
	
	/**
	 *	Proxy joueur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class PlayerProxy extends AbstractProxy {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = ProxyList.PLAYER_PROXY;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function PlayerProxy (services:IDocumentServices)
		{ 
			super(NAME);
			this.services = services;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _currentPlace:String;
		protected var _lastPlace:String;
		protected var _locals:Object;
		
		// Wip utilisation du client serveur en attendant de voir
		// pour un service spécialisé joueur.
		protected var services:IDocumentServices;

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Identifiant unique du joueur
		 */
		public function get id () : int
		{ return _data.id; }

		/**
		 * Pseudo du joueur
		 */
		public function get pseudo () : String
		{ return _data.pseudo; }
		
		/**
		 * Classe du joueur
		 */
		public function get classe () : String
		{ return _data.classe; }
	
		public function set classe (val:String) : void
		{ _data.classe = val; }
		
		// --- TODO à supprimer --
		
		/**
		 * Retourne points en économie
		 */
		public function get pir () : int
		{ return getBonus(0); }
		
		/**
		 * Retourne points en économie
		 */
		public function get soc () : int
		{ return getBonus(1); }
		
		/**
		 * Retourne points en économie
		 */
		public function get eco () : int
		{ return getBonus(2); }
		
		/**
		 * Retourne points en environnement
		 */
		public function get env () : int
		{ return getBonus(3); }		
				
		/**
		 *	Retourne true si l'utilisateur est en
		 *	mode invité
		 */
		/*public function get isGuest () : Boolean
		{
			return username != null;
		}*/
		
		/**
		 * Identifiant du dernier lieu visité
		 * ????
		 */
		public function get lastPlace () : String
		{ return _lastPlace; }
		
		/**
		 * Identifaint de la scène
		 * "lieu de vie du joueur"
		 */
		public function get homePlace () : String
		{ return _data.homePlace; }
		
		/**
		 * Retourne le descripteur d'apparence de
		 * l'avatar du joeur
		 */
		public function get avatarSkin () : Object
		{ return _data.avatarSkin; }
		
		/**
		 * Niveau
		 */
		public function get level () : int
		{ return _data.level; }
		
		public function set level (val:int) : void
		{
			if (level == val) return;
			
			// Dispatch gain perte de niveau
			var evt:BaseEvent = new BaseEvent(val > level	? EventList.PLAYER_LEVEL_UP
																			: EventList.PLAYER_LEVEL_DOWN, {value:val - level});
			sendEvent(evt);
			
			if (!evt.isDefaultPrevented())
			{
				_data.level = val;
				_data.save(["level"]);
			}
		}
		
		/**
		 * Liste des bonus
		 */
		public function get allBonus () : Array 
		{ return _data.bonus.slice(); }		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Retourne le bonus pour l'index spécifié
		 *	@param index int index du bonus
		 *	@return int valeur du bonus
		 */
		public function getBonus (index:int) : int
		{ return _data.bonus[index]; }
		
		/**
		 * Ajoute / soustrai au bonus
		 *	@param index int index du bonus
		 *	@param bonus
		 */
		public function addBonus (index:int, value:int) : void
		{
			if (!value || value == 0) return;
			// Bonus originel
			var opoints:int = getBonus(index);		
			// Dispatch gain / perte nouveau bonus
			var evt:BaseEvent = new BaseEvent(value > 0	? EventList.PLAYER_BONUS_GAIN
																		: EventList.PLAYER_BONUS_LOSS,
																		{index:index, value:value});
			sendEvent(evt);
			
			if (!evt.isDefaultPrevented()) setBonus(index, opoints + value);
		}
		
		/**
		 * Définit un bonus
		 *	@param index int index du bonus
		 *	@param value int nouvelle valeur du bonus
		 */
		public function setBonus (index:int, value:int) : void
		{
			if (_data.bonus[index] != value)
			{
				_data.bonus[index] = value;
				sendEvent(new BaseEvent(	EventList.PLAYER_BONUS_CHANGED,
													{index:index, value:value})	);

				_data.save(["bonus"]);
			}
		}
		
		/**
		 * TODO Est ce que cette méthode est nécéssaie ?
		 *	@param key String
		 */
		public function setPlace (key:String) : void
		{
			_lastPlace = _currentPlace;
			_currentPlace = key;

			_locals = _data.locals[_currentPlace];
			if (!_locals) {
				_data.locals[_currentPlace] = _locals = {};
			}
		}
		
		/**
		 * Chargement des données joueur (IPlayerDocument)
		 *	@param key Sring indentifiant joueur
		 */
		public function load (key:String) : void
		{
			services.load({keys:key}, handleData, handleData);
		}
		
		// ---- TODO ------
		
		/**
		 * Retourne la valeur d'une variable globale
		 * du joueur
		 *	@param key String
		 *	@return 
		 */
		public function getGlobalEnv (key:String) : *
		{ return _data.globals[key]; }
		
		/**
		 * Définit une variable globale du joueur
		 * Sauvegarde par le bias du IPlayerDocument (_data)
		 * Si la valeur de variable passée est "_|DEL|_" la variable
		 * est supprimée.
		 *	@param key String
		 *	@param value *
		 */
		public function setGlobalEnv (key:String, value:*) : void
		{
			if (value == "_|DEL|_") delete _data.globals[key];				
			else
				_data.globals[key] = value;

			_data.save(["globals"]);
		}
		
		/**
		 * Retourne la valeur d'une variable locale
		 * du joueur
		 *	@param key String
		 *	@return 
		 */
		public function getLocalEnv (key:String) : *
		{  return _locals[key]; }
		
		/**
		 * Définit une variable locale du joueur
		 * Sauvegarde par le bias du IPlayerDocument (_data)
		 * Si la valeur de variable passée est "_|DEL|_" la variable
		 * est supprimée.
		 *	@param key String
		 *	@param value *
		 */
		public function setLocalEnv (key:String, value:*) : void
		{
			if (value == "_|DEL|_") delete _locals[key];
			else
				_locals[key] = value;

			_data.save(["locals"]);
		}
		
		/**
		 * 
		 *	@param actionId String
		 */
		public function actionExecuted (actionId:String, place:String) : void
		{
			var actions:Object = _data.actions;
			
			if (!actions[place])
			{
				actions[place] = {};
				actions[place][actionId] = 0;
			}
			else if (!actions[place][actionId])
			{
				actions[place][actionId] = 0;
			}
			
			actions[place][actionId]++;
			_data.save(["actions"]);
		}
		
		public function actionExecutedCount (actionId:String, place:String) : int
		{
			if (!_data.actions[place]) return null;

			return _data.actions[place][actionId];	
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception des datas initiales
		 *	@param result Object IPlayerDocument
		 */
		private function handleData (result:Object) : void
		{
			if (!result) {
				sendEvent(new BaseEvent(EventList.PLAYER_LOAD_ERROR));
			} 
			else {
				_data = result;
				sendEvent(new BaseEvent(EventList.PLAYER_LOADED));
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

