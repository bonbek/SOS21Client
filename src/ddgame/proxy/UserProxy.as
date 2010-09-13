package ddgame.proxy {
	
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.AbstractProxy;
	import ddgame.proxy.ProxyList;
	import ddgame.events.EventList;
	
	/**
	 *	Proxy utilisteur courant
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class UserProxy extends AbstractProxy {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function UserProxy(sname:String, odata:Object = null)
		{
			super(sname, odata);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne l'identifiant de l'utilisateur
		 */
		public function get userId ():int
		{
			return _data.id;
		}
		
		/**
		 * Retourne le nom d'utilisateur (pseudo)
		 */
		public function get username ():String
		{
			return _data.username;
		}
		
		/**
		 * Retourne l'identifiant joueur associé à l'utilisateur
		 */
		public function get playerId ():int
		{
			return _data.current_player;
		}
		
		/**
		 * Retourne les identifiants de connection;
		 */
		public function get credentials ():Object
		{
			return {login:_data.email, password:_data.password};
		}
		
		/**
		 * Retourne les préférences utilisateur
		 */
		/*public function getUserPref (pref:):UserPrefs
		{
			return userPrefs;
		}*/
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*public function setUserPref ()*/
		
		public function setData (o:Object):void
		{
			var notify:Boolean = _data;
			_data = o;
			if (notify)
				sendEvent(new BaseEvent(EventList.USER_REFRESHED));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

