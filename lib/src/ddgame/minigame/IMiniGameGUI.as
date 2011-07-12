package ddgame.minigame {
	
	import flash.display.Sprite;
	import ddgame.minigame.IMiniGamePopup;
	
	/**
	 *	Interface à impléménter pour l'interface graphique "principale"
	 * des mini-jeux
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface IMiniGameGUI {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Crée une popup
		 */
		function createPopup (descriptor:Object = null) : IMiniGamePopup;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function get enabled () : Boolean;
		function set enabled (val:Boolean) : void;
		function get showCountDown () : Boolean;
		function set showCountDown (val:Boolean) : void;
		function get countDownValue () : int;
		function set countDownValue (val:int) : void;
		function get theme () : Object;
		function set theme (val:Object) : void;
		function get sprite () : Sprite;
	
	}

}

