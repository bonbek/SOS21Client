package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;	
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;

	/**
	 *	Command d'arrêt de l'application
	 * TODO
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.04.2011
	 */
	public class AppAbortCommand extends Notifier implements ICommand {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			trace("Error:", BaseEvent(event).content.msg);
		}
		
	}

}

