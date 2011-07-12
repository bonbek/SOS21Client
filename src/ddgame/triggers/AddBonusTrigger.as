package ddgame.triggers {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import ddgame.events.EventList;
	import ddgame.triggers.AbstractTrigger;

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
			// > niveau
			var level:int = getPropertie("plev");
			if (level)
				sendEvent(new BaseEvent(EventList.ADD_BONUS, {level:level}));
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
		
		private function sendPBonus (i:int, b:int) : void
		{
			if (b)
				sendEvent(new BaseEvent(EventList.ADD_BONUS, {index:i, value:b}));
		}
		
	}

}

