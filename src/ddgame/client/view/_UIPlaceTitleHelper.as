/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.view {
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.sos21.debug.log;
	import com.sos21.helper.AbstractHelper;
	import ddgame.client.events.EventList;
	import ddgame.client.proxy.DatamapProxy;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  15.04.2008
	 */
	public class UIPlaceTitleHelper extends AbstractHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.UIPLACETITLE_HELPER;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function UIPlaceTitleHelper(oComponent:MovieClip)
		{
			super(NAME, oComponent);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		/**
		 * Additional getter to return the correct component type
		 */
		public function get component():MovieClip
		{
			return MovieClip(_component);
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function setTitle (val:String):void
		{
			if (!getVisible()) setVisible(true);
			component.textField.text = val;
			component.skinMiddle.width = component.textField.width;
			component.skinRight.x = component.skinMiddle.x + component.skinMiddle.width;
		}
		
		override public function initialize ():void
		{
			component.textField.autoSize = "left";
			setTitle("");
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/**
		 * Default Event handler
		 */
		override public function handleEvent(event:Event):void
		{
			switch( event.type ) {
				case EventList.DATAMAP_PARSED :
				{
					setTitle(DatamapProxy(facade.getProxy(DatamapProxy.NAME)).title);
					break;
				}
				case EventList.CLEAR_MAP :
				{
					setTitle("chargement :-)");
					break;
				}
				default :
				break;
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Call by super class
		 * List the Event interest this Helper is interested in
		 */
		override protected function listInterest() : Array
		{
			return [	EventList.DATAMAP_PARSED,
						EventList.CLEAR_MAP ];
		}

	}
	
}
