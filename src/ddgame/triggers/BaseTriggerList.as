/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.triggers {

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
							ddgame.triggers.EmptyTrigger,						
							ddgame.triggers.ChangeMapTrigger,
							ddgame.triggers.PopupTrigger,
							ddgame.triggers.QuizTrigger,
							ddgame.triggers.ContextMenuTrigger,
//							ddgame.triggers.RessourcesTrigger,
							ddgame.triggers.MoveTileTrigger,
							ddgame.triggers.ToolTipTrigger,
							ddgame.triggers.VideoPlayerTrigger,
							ddgame.triggers.HtmlPopupTrigger,
							ddgame.triggers.DispatchEventTrigger,
							ddgame.triggers.MiniGameTrigger,
							ddgame.triggers.VimeoPlayerTrigger,
							ddgame.triggers.AddBonusTrigger,
							ddgame.triggers.ReachTrigger,
							ddgame.triggers.TileActionTrigger,
							ddgame.triggers.WriteEnvTrigger,
							ddgame.triggers.SoundTrigger
							/*ddgame.triggers.ScriptTrigger*/
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
