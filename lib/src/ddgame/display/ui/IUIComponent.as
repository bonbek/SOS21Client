package ddgame.display.ui {
	
	import flash.events.IEventDispatcher;
	
	/**
	 *	Interface à imlémenter par les composants
	 * de l'interface utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface IUIComponent extends IEventDispatcher {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Accesseurs activer/désactiver le composant
		 */
		function get enabled () : Boolean;
		function set enabled (val:Boolean) : void;
		
		/**
		 * Accesseur états du composant
		 */
		function get state () : String;
		function set state (val:String) : void;
	
	}

}

