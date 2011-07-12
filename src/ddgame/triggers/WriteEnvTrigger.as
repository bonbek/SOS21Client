package ddgame.triggers {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import ddgame.events.EventList;
	import ddgame.triggers.AbstractTrigger;

	/**
	 *	Trigger écriture de variable
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  30.12.2010
	 */
	public class WriteEnvTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 107;
			
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function execute (e:Event = null) : void
		{
			var tw:Array = getPropertie("tw");
			if (tw)
			{
				for each (var o:Object in tw)
					sendEvent(new BaseEvent(EventList.WRITE_ENV, o));

				complete();
			}
			else
			{ cancel(); }
		}
	
	
	}

}

