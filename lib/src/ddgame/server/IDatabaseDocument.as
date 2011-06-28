package ddgame.server {

	/**
	 *	Interface de base des objets renvoyés par
	 * le ClientServer.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  31.03.2011
	 */
	public interface IDatabaseDocument {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Sauvegarde de tout ou partie de données du document.
		 *	@param params				paramètres de sauvegarde
		 * 								en l'état, un tableau des proprités ex : ["title","hidden"]
		 * 								ou null pour une sauvegarde de tout le document.
		 *	@param successCallBack 	foncion de rappel en cas reussite
		 *	@param faultCallBack 	function de rappel en cas d'echec
		 */
		function save (params:Object = null, successCallBack:Function = null, faultCallBack:Function = null) : void;

		/**
		 * Suppression du document côté serveur
		 * La suppression côté client reste à la charge de l'application
		 *	@param successCallBack 	foncion de rappel en cas reussite
		 *	@param faultCallBack 	function de rappel en cas d'echec
		 */
		function destroy (successCallBack:Function = null, faultCallBack:Function = null) : void;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Identifiant (dans son domaine) unique
		 * du document
		 */
		function get id () : String;
	
	}

}

