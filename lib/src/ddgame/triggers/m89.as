package ddgame.triggers {
	
	import flash.display.MovieClip;

	/**
	 * Trigger map id 89 Espace entreprise 2
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m89 extends dynStand {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m89 ():void
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
			updateTile("panneau1", ecran1Container);
			// > panneau 2
			updateTile("panneau2", ecran2Container);
			// > prospectus
			updateTile("panneau3", ecran3Container);
			// > prospectus
			updateTile("prospectus", null);
			// > présentoir
			updateTile("presentoir", null);

			// > video temp
			var videoScreen:Object = isosceneHelper.getTile("ecranVideo");
			videoScreen.mouseEnabled = true;
			videoScreen.mouseChildren = true;
			videoScreen.addChild(videoPlayer);
			videoPlayer.source = data.inject.obj.(@id == "ecranVideo").video[0];
		}
		
	}

}