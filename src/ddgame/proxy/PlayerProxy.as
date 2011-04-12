package ddgame.proxy {
	
	import flash.utils.Dictionary;
	
	import flash.net.SharedObject;
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.AbstractProxy;
	import ddgame.server.IClientServer;
	import ddgame.events.EventList;
	import ddgame.vo.ITheme;
	import ddgame.vo.IBonus;
	import ddgame.vo.Bonus;
	
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
	
		/**
		 *	@constructor
		 */
		public function PlayerProxy (sname:String = null, odata:Object = null)
		{
			super(sname == null ? NAME : sname, new Object());
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		// liste des points
		protected var _bonus:Array = [];
		protected var _currentPlace:int;
		protected var _lastPlace:int;
		protected var _username:String;
		protected var _locals:Object;

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/*public function get cookie () : SharedObject
		{
			return SharedObject.getLocal("player" + _data.id);
		}*/
		
		public function get username () : String
		{
			return _username;
		}
		
		public function set username (val:String) : void
		{
			if (val != _username)
			{
				_username = val;
			}
		}
		
		/**
		 * Identifiant joueur
		 */
		public function get id () : int
		{ return _data.id; }
		
		/**
		 * Niveau
		 */
		public function get level () : int
		{ return _bonus[0]; }
		
		public function set level (val:int) : void
		{ _bonus[0] = val; }
		
		/**
		 * Classe
		 */
		public function get classe () : String
		{ return _data.profile.classe; }
	
		public function set classe (val:String) : void
		{ _data.profile.classe = val; }
		
		/**
		 * Retourne points en économie
		 */
		public function get pir () : int
		{ return _bonus[1]; }
		
		/**
		 * Retourne points en économie
		 */
		public function get soc () : int
		{ return _bonus[2]; }
		
		/**
		 * Retourne points en économie
		 */
		public function get eco () : int
		{ return _bonus[3]; }
		
		/**
		 * Retourne points en environnement
		 */
		public function get env () : int
		{ return _bonus[4]; }		
		
		/**
		 *	Retourne true si l'ustilisateur est en
		 *	mode invité
		 */
		public function get isGuest () : Boolean
		{
			return username != null;
		}
		
		/**
		 * Retourne l'identifiant de l'utilisateur lié
		 */
		public function get userId ():int
		{
			return _data.uid;
		}
		
		/**
		 * l'identifiant de la dernière map vistée
		 * ????
		 */
		public function get lastVisitedMapId () : int
		{
			return _lastPlace;
		}
		
		/**
		 * Retourne l'identifaint de la map "maison du joueur"
		 */
		public function get homeId ():int
		{
			return _data.home;
		}
		
		/**
		 * Retourne l'identifiant de classe d'apparence de
		 * l'avatar
		 */
		public function get skinId ():int
		{
			return _data.avatar;
		}
		
		public function get allBonus () : Array /* de Bonus */
		{
			var ab:Array = [];
			var n:int = _bonus.length
			for (var i:int = 1; i < n; i++ ) {
				ab.push(new Bonus(i, _bonus[i]));
			}
			
			return ab;
		}
		
		public function get allPoints () : Array
		{
			return _bonus.slice(1);
		}				
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Ajoute au bonus
		 *	@param bonus IBonus
		 */
		public function addBonus (bonus:Object) : void
		{
			var npoints:int = bonus.gain;
			if (!npoints || npoints == 0) return;
			var opoints:int = _bonus[bonus.theme];
			opoints += npoints;
			var evt:BaseEvent = new BaseEvent(npoints > 0 ? EventList.PLAYER_BONUS_GAIN : EventList.PLAYER_BONUS_LOSS, bonus);
			sendEvent(evt);
			
			if (!evt.isDefaultPrevented())
			{
				_bonus[bonus.theme] = opoints;
			}
			
			// WIP stockage points dans cookie
			/*if (!evt.isDefaultPrevented())
			{
				if (!cookie.data.bonus) cookie.data.bonus = [];
				
				if (!cookie.data.bonus[bonus.theme])
					cookie.data.bonus[bonus.theme] = 0;

				cookie.data.bonus[bonus.theme]+= npoints;
				cookie.flush();
			}*/
		}
		
		public function setBonus (bonus:Object) : void
		{
			_bonus[bonus.theme] = bonus.gain;
			sendEvent(new BaseEvent(EventList.PLAYER_BONUS_CHANGED, bonus));
		}
		
		public function getBonus (theme:int) : IBonus
		{
			var points:int = _bonus[theme];
//			if (points) {
				return new Bonus(theme, points);
//			}
			
			return null;
		}
		
		public function getGlobalEnv (key:String) : *
		{ return _data.globals[key]; }
		
		public function setGlobalEnv (key:String, value:*) : void
		{
			if (value == "_|DEL|_") delete _data.globals[key];				
			else
				_data.globals[key] = value;

			IClientServer(facade.getProxy(ProxyList.SERVER_PROXY)).playerEnv("g", key, value);
		}

		public function getLocalEnv (key:String) : *
		{  return _locals[key]; }

		public function setLocalEnv (key:String, value:*) : void
		{
			if (value == "_|DEL|_") delete _locals[key];
			else
				_locals[key] = value;

			IClientServer(facade.getProxy(ProxyList.SERVER_PROXY)).playerEnv("l", key, value);
		}
		
		
		public function setPlace (id:int) : void
		{
			_lastPlace = _currentPlace;
			_currentPlace = id;

			var scope:String = String(_currentPlace);
			_locals = _data.locals[scope];
			if (!_locals) _data.locals[scope] = _locals = {};
		}
		
		/**
		 *	@param o Object
		 */
		public function setData (o:Object) : void
		{			
			var notify:Boolean = _data;
			_data = o;
			
			/*trace(_data.globals);
			for (var v:String in _data.globals);
				trace(this, v);*/
			
			// ... points
//			_bonus.push(null);
//			_bonus.push(_data.profile.level);
			// niveau
			_bonus.push(_data.profile.bonus[0]);
			// points piraniak
			_bonus.push(_data.profile.bonus[1]);
			// points social
			_bonus.push(_data.profile.bonus[2]);
			// points éco
			_bonus.push(_data.profile.bonus[3]);
			// points environnement
			_bonus.push(_data.profile.bonus[4]);
			
			if (notify)
				sendEvent (new BaseEvent(EventList.PLAYER_REFRESHED));			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

