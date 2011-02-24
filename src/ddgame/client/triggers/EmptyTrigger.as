package ddgame.client.triggers {
	
	import flash.events.Event;
	import ddgame.client.triggers.AbstractTrigger;

	/**
	 *	Trigger vide, utiles comme conteneur d'autres actions
	 * ou lien symbolique
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class EmptyTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 0;
			
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function execute (e:Event = null) : void
		{
			complete();
		}		
		
	}

}

