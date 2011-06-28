package ddgame.display.ui {
	
	import flash.display.Sprite;
	
	/**
	 *	Interface à implémenter par les widgets
	 * de l'interface utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface IUIWidget extends IUIComponent {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Accesseur titre du widget
		 */
		function get title () : String;
		function set title (val:String) : void;
		
		/**
		 * Retourne le sprite du composant
		 */
		function get sprite () : Sprite;
	
	}

}

