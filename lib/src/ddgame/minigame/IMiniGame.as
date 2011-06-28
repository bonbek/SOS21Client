package ddgame.minigame {
	
	import flash.display.Sprite;
	import org.osflash.signals.ISignal
	
	/**
	 *	Interface à implémenter par les mini-jeux
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface IMiniGame {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Lance l'éxecution initiale
		 * @param	params	 paramètres d'execution
		 */
		function start (params:Object = null) : void;
		
		/**
		 * Stop l'éxecution
		 */
		function stop () : void;
		
		/**
		 * Met en pause
		 */
		function pause () : void;
		
		/**
		 * Reprend
		 */
		function resume () : void;
		
		/**
		 * Définit un état
		 * @param	state	 "identifiant"
		 */
		function setState (state:String) : void;
		
		/**
		 * Définit la configuration
		 * @param	val	 objet de configuration
		 */
		function setConfig (val:Object) : void;
		
		/**
		 * Définit les données
		 * @param	val	 objet données
		 */
		function setData (val:Object) : void;
		
		/**
		 * Définit le trigger / controleur
		 */
		function setTrigger (val:Object) : void;
		
		function release () : void;
						
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne l'identifiant
		 */
		function get id () : String;
		
		/**
		 * Retourne la vue
		 */
		function get view () : Sprite;
		
		/**
		 * Retourne le niveau (difficulté)
		 */
		function get level () : int;
		
		/**
		 * Définit le niveau de difficulté
		 */
		function set level (val:int) : void;
		
		function get leave () : ISignal;
		
//		function get 
		
		/**
		 * Retourne la configuration
		 */
//		function get config () : Object;
		
		/**
		 * Retourne l'intitulé
		 */
//		function get title () : String;
		
		/**
		 * Retourne les règles
		 */
//		function get rules () : String;
		
		/**
		 * Retourne l'état "en execution"
		 */
//		function get runing () : Boolean;
		
		/**
		 * Retourne l'état actuel
		 */
//		function get currentState () : String;
	
	}

}

