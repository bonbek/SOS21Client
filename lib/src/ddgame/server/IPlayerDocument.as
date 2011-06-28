package ddgame.server {

	/**
	 *	Interface des données pour les documents de type joueur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  11.04.2011
	 */
	public interface IPlayerDocument extends IDatabaseDocument {
			
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		/**
		 * Retourne le pseudo du joueur
		 */
		function get pseudo () : String;
		
		/**
		 * Retourne la classe du joueur
		 */
		function get classe () : String;
		function set classe (val:String) : void;
		
		/**
		 * Niveau
		 */
		function get level () : int;
		function set level (val:int) : void;
		
		/**
		 * Liste des bonus
		 * par ordre d'indexation
		 */
		function get bonus () : Array;
		function set bonus (val:Array) : void;
		
		/**
		 * Accesseur de l'enveloppe de l'avatar
		 * du joueur
		 * @param	val	TODO pour l'instant un objet
		 * formaté : {id:int, classDef:String nom de class}
		 */
		function get avatarSkin () : Object;
		function set avatarSkin (val:Object) : void;
		
		/**
		 * Retourne l'indentifiant de la scène
		 * "lieu de vie du joeur"
		 */
		function get homePlace () : String;
		
		/**
		 * Flag joueur connecté
		 */
		function get loggedOn () : Boolean;
		
		/**
		 * Pointeurs / variables
		 * @return		TODO pout l'instant objet
		 */
		function get globals () : Object;
		function get locals () : Object;
		function get actions () : Object;
		
	}

}

