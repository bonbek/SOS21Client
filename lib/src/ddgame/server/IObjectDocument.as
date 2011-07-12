package ddgame.server {

	/**
	 *	Interface pour les données de type modèle d'objet
	 * Pour l'instant basé sur l'ancien modèle AMF
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  31.03.2011
	 */
	public interface IObjectDocument extends IDatabaseDocument {
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		/**
		 * Intitulé
		 */
		function get title () : String;
		function set title (val:String) : void;
		/**
		 * Ressources graphiques
		 */
		function get assets () : Object;
		function set assets (val:Object) : void;
		/**
		 * Nom de la classification
		 */
		function get category () : String;
		function set category (val:String) : void;
		/**
		 * Largeur
		 */
		function get width () : Number;
		function set width (val:Number) : void;
		/**
		 * Hauteur
		 */
		function get height () : Number;
		function set height (val:Number) : void;
		/**
		 * Profondeur
		 */
		function get depth () : Number;
		function set depth (val:Number) : void;
		/**
		 * Personnage non joueur
		 */
		function get pnj () : Boolean;
		function set pnj (val:Boolean) : void;
		/**
		 * Décalage X de positionnement
		 */
		function get ofsX () : Number;
		function set ofsX (val:Number) : void;
		/**
		 * Décalage Y de positionnement
		 */		
		function get ofsY () : Number;
		function set ofsY (val:Number) : void;
	}

}

