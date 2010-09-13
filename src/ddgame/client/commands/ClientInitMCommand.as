/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.commands {
	import com.sos21.commands.MacroCommand;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  15.04.2008
	 */
	public class ClientInitMCommand extends MacroCommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override protected function initialize():void
		{
			addCommand(ddgame.client.commands.IsoworldInitCommand);
			addCommand(ddgame.client.commands.UIInitCommand);
		}
				
	}
	
}
