package ddgame.triggers {
	
	import flash.display.MovieClip;

	/**
	 * Trigger map id 91 Espace entreprise 3
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m91 extends dynStand {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m91 ():void
		{
			super();			
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function run (data:XML):void
		{
			super.run(data);
			
			// > panneau 1
			updateTile("panneau1", panneau1Container);
			// > panneau 2
			updateTile("panneau2", panneau2Container);
			// > prospectus
			updateTile("prospectus", prospectusContainer);
			// > mapemonde
			updateTile("mapemonde", null, false);
			
			// > video temp
			var videoScreen:Object = isosceneHelper.getTile("ecranVideo");
			videoScreen.mouseEnabled = true;
			videoScreen.mouseChildren = true;
			videoScreen.addChild(videoPlayer);
			videoPlayer.source = data.inject.obj.(@id == "ecranVideo").video[0];
		}
		
	}

}