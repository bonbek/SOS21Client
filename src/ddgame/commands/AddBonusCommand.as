package ddgame.commands {
	
	import flash.events.Event;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	
	import ddgame.proxy.PlayerProxy;

	/**
	 *	Command gain / perte de points et
	 * niveau du joeur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AddBonusCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			var bonus:Object = BaseEvent(event).content;
			
			// Gain / perte niveau du joueur
			if ("level" in bonus) {
				PlayerProxy(facade.getProxy(PlayerProxy.NAME)).level += bonus.level;
			}			
			// Gain / perte points du joueur
			if ("index" in bonus && "value" in bonus) {
				PlayerProxy(facade.getProxy(PlayerProxy.NAME)).addBonus(bonus.index, bonus.value);
			}
		}
				
	}
	
}
