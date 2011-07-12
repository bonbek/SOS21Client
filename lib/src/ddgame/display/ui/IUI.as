package ddgame.display.ui {
	
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	
	/**
	 *	Interface à implémenter par
	 * l'interface utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface IUI extends IUIComponent {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Crée une fenêtre
		 */
		function createWindow () : Object;
		
		/**
		 * Ouvre l'écran d'aide
		 */
		function openHelpScreen () : void;
		
		/**
		 * Ferme l'écran d'aide
		 */
		function closeHelpScreen () : void;
		
		/**
		 * Mets à jour le widget bonus
		 * @param	theme	 thématique du bonus
		 * @param	value	 valeur du bonus
		 * @param	notify	 affiche la valeur
		 */
		function updateBonus (gauge:int, val:int, notify:Boolean = true) : void;
		
		/**
		 * Ajoute au widget bonus
		 * @param	theme	 thématique du bonus
		 * @param	value	 valeur du bonus
		 * @param	notify	 affiche la valeur
		 */
		function appendBonus (gauge:int, val:int, notify:Boolean = true) : void;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retounre le rectangle de la zone affichable
		 * de la vue (scène iso)
		 */
		function get viewporBounds () : Rectangle;
		
		/**
		 * Retourne le sprite de l'interface
		 * utilisateur
		 */
		function get sprite () : Sprite;
		
		/**
		 * Définit le titre de la scène
		 */
		function set sceneTitle (val:String) : void;
		
		/**
		 * Définit le nom d'utilsateur
		 */
		function set username (val:String) : void;

		/**
		 * Retourne le widget bonus
		 */		
		function get bonusWidget () : IUIWidget;

		/**
		 * Retourne le widget titre
		 */
		function get titleWidget () : IUIWidget;

		/**
		 * Retourne le widget nom d'utilisateur
		 */		
		function get usernameWidget () : IUIWidget;
		
		/**
		 * Retourne le bouton son
		 */
		function get soundButton () : IUIButton;
		
		/**
		 * Retourne le bouton parametres
		 */
		function get parametersButton () : IUIButton;
		
		/**
		 * Retourne le bouton bousole
		 */
		function get compassButton () : IUIButton;
		
		/**
		 * Retourne le bouton lien web
		 */
		function get weblinkButton () : IUIButton;
		
		/**
		 * Retourne l'écran d'aide
		 */
		function get helpScreen () : IUIComponent;
		
	
	}

}

