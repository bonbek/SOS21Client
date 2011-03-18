package ddgame.commands {

	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.ui.MapScreenHelper;
	import flash.events.Event;

	/**
	 *	Commande ouverture map de déplacement
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  08.11.2010
	 */
	public class OpenMapScreenCommand extends Notifier implements ICommand {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			MapScreenHelper(facade.getObserver(MapScreenHelper.NAME)).openMap();
		}	
	
	}

}