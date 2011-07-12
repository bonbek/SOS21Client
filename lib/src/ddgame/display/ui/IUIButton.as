package ddgame.display.ui {
	
	import flash.display.SimpleButton;
	
	/**
	 *	Interface à implémenter par les boutons
	 * de l'interface utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface IUIButton extends IUIComponent {
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Accesseurs état selectionné du bouton
		 */
		function get selected () : Boolean;
		function set selected (val:Boolean) : void;
		
		/**
		 * Retourne le boutton associé
		 */
		function get button () : SimpleButton;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
	}

}

