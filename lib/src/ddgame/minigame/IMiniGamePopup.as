package ddgame.minigame {
	
	import org.osflash.signals.ISignal;
	import flash.display.Sprite;
	
	/**
	 *	Interface à impléménter pour les popup dans
	 * les mini-jeux
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface IMiniGamePopup {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Ajoute un contenu
		 */
		function addContent (val:Object) : void;
				
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * titre
		 */
		function set title (val:String) : void;
		
		/**
		 * définit le texte
		 */
		function set text (val:String) : void;
		
		/**
		 * label du bouton valider
		 */
		function set validateLabel (val:String) : void; 
		
		/**
		 * label du bouton annuler
		 */
		function set cancelLabel (val:String) : void;
		
		/**
		 * Affichage du bouton fermer
		 */
		function set showCloseButton (val:Boolean) : void;
		
		function get theme () : Object;
		function set theme (val : Object) : void;
		
		/**
		 * Retourne la vue
		 */
		function get sprite () : Sprite;
		
		function get buttonClicked () : ISignal;

	}

}

