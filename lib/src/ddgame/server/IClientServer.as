package ddgame.server {
	
	import com.sos21.proxy.IProxy;
	import ddgame.server.IDocumentServices;
	
	/**
	 *	Interface ClientServer.
	 * Utilisée depuis le client pour manipuler les données.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  16.03.2011
	 */
	 public interface IClientServer extends IProxy {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Retourne les services d'un domaine
		 * @param	scope		domaine des services
		 * 						player	: domaine joueurs
		 * 						place		: domaine lieus / scène
		 * 						object	: domaine modèles d'objets
		 * 						action ?
		 */
		function getServices (scope:String) : IDocumentServices;
		
		/**
		 * Connection aux services
		 * Cet appel doit retouner un IUser en cas de succès.
		 * @param credentials	 	identifiants de connexion
		 *	@param successCallBack 	foncion de rappel en cas reussite
		 *	@param faultCallBack 	function de rappel en cas d'echec
		 */
		function connect (credentials:Object = null, successCallBack:Function = null, faultCallBack:Function = null) : void;
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @private
		 * Injection données de configuration
		 * depuis le client.
		 */
		function set config (val:Object) : void;
	
	}

}

