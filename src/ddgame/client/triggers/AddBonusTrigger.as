package ddgame.client.triggers {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import ddgame.client.events.EventList;
	import ddgame.client.triggers.AbstractTrigger;

	/**
	 *	Trigger ajout bonus
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AddBonusTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 103;
			
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function execute (e:Event = null) : void
		{
			// > points piraniak
			sendPBonus(0, getPropertie("plev"));
			// > points piraniak
			sendPBonus(1, getPropertie("ppir"));
			// > points social
			sendPBonus(2, getPropertie("psoc"));
			// > points economie
			sendPBonus(3, getPropertie("peco"));
			// > points environnement
			sendPBonus(4, getPropertie("penv"));

			complete();
		}
		
		private function sendPBonus (t:int, b:int) : void
		{
			if (b)
				sendEvent(new BaseEvent(EventList.ADD_BONUS, {theme:t, bonus:b}));
		}
		
	}

}

