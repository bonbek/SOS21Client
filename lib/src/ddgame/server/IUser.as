package ddgame.server {

	/**
	 *	Interface data utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.04.2011
	 */
	public interface IUser {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Etat invité
		 */
		function get isGuest () : Boolean;
		
		/**
		 * Identifiant du joueur attaché à
		 * cet utilistateur
		 */
		function get playerId () : String;
	
	}

}

