package ddgame.server {

	import ddgame.server.IDatabaseDocument;

	/**
	 *	Services des documents de données IDatabaseDocument
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  18.04.2011
	 */
	public interface IDocumentServices {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Service de chargement de document de données IDatabaseDocument
		 * Ce service doit renvoyer un ou des IDatabaseDocument en cas de succès.
		 *	@param params				paramètres de chargement
		 * 								{	keys:String / Array
		 * 									match:Object
		 * 									fields:Array }
		 *	@param successCallBack 	foncion de rappel en cas reussite
		 *	@param faultCallBack 	function de rappel en cas d'echec
		 */
		function load (params:Object, successCallBack:Function = null, faultCallBack:Function = null) : void;

		/**
		 * Service de création du document
		 * Le document crée ne doit pas être référencé côté
		 * serveur, ce référencement intervenant lors de la sauvegarde
		 * du document (depuis le docuement lui même).
		 * @return		Un document adapté au domaine du service
		 */
		function create (data:Object = null) : IDatabaseDocument;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
	}

}

