/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.triggers {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  03.03.2008
	 */
	public class BaseTriggerList {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function listTriggers():Array /* of Class */
		{
			return	[
							ddgame.client.triggers.ChangeMapTrigger,
							ddgame.client.triggers.PopupTrigger,
							ddgame.client.triggers.QuizTrigger,
							ddgame.client.triggers.ContextMenuTrigger,
//							ddgame.client.triggers.RessourcesTrigger,
							ddgame.client.triggers.MoveTileTrigger,
							ddgame.client.triggers.ToolTipTrigger,
							ddgame.client.triggers.VideoPlayerTrigger,
							ddgame.client.triggers.HtmlPopupTrigger,
							ddgame.client.triggers.DispatchEventTrigger,
							ddgame.client.triggers.MiniGameTrigger,
							ddgame.client.triggers.VimeoPlayerTrigger,
							ddgame.client.triggers.AddBonusTrigger,
							ddgame.client.triggers.ReachTrigger,
							ddgame.client.triggers.TileActionTrigger
							/*ddgame.client.triggers.ScriptTrigger*/
						]
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
