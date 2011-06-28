/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.ui {
	
	import flash.utils.*;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import ddgame.events.EventList;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  11.03.2008
	 */
	public class ProgressLogoHelper extends AbstractHelper {
		
		[Embed(source="../../../assets/progress_loader.swf", symbol="ProgressLogo")]
		private var assetClass:Class;
		
//		private var assetClass:Class = DDgameFactory.assetClass;
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
				
		public static const NAME : String = "progressLogoHelper";

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function ProgressLogoHelper(sname:String = null)
		{
			super(sname == null ? NAME : sname);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		private function get component():MovieClip
		{
			return MovieClip(_component);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/**
		 * Default Event handler
		 */
		override public function handleEvent(event:Event):void
		{
			switch(event.type)
			{
				case EventList.GFXLIB_UPDATESTART :
				{
					_component = new assetClass();
					component.x = stage.stage.stageWidth / 2;
					component.y = stage.stage.stageHeight / 2;
					component.maskLogo.width = 0;
					stage.addChild(component);
					break;
				}
				case EventList.GFXLIB_PROGRESS :
				{
//					component.progressBar.width = int(BaseEvent(event).content) * 2;
					component.maskLogo.scaleX = component.maskLogo.scaleY = (int(BaseEvent(event).content) + 2) / 100;
					break;
				}
				case EventList.GFXLIB_COMPLETE :
				{
					stage.removeChild(component);
					_component = null;
					break;
				}
				default :
				{
					break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		override public function initialize():void
		{
			suscribeEvent(EventList.GFXLIB_UPDATESTART, null, true);
			suscribeEvent(EventList.GFXLIB_PROGRESS, null, true);
			suscribeEvent(EventList.GFXLIB_COMPLETE, null, true);			
		}
		
		/**
		 * Call by super class
		 * List the Event interest this Helper is interested in
		 */
		override protected function listInterest() : Array
		{
			return [];
		}

	}
	
}
