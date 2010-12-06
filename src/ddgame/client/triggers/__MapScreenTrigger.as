package ddgame.client.triggers {

	import flash.events.Event;
	import ddgame.client.triggers.AbstractTrigger;
	import br.com.stimuli.loading.BulkLoader;
	
	/**
	 *	Trigger carte de déplacement
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  08.11.2010
	 */
	public class MapScreenTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 106;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var loader:BulkLoader;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (event:Event = null) : void
		{

		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		private function onAssetsLoaded (event:Event) : void
		{

		}
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}