package ddgame.display.ui {

	import flash.events.Event;
	import ddgame.display.ui.IUIComponent;

	/**
	 *	Event interface utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class UIEvent extends Event {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const TOOLTIP_CREATE:String = "tooltipCreate";
		public static const CLOSE_HELPSCREEN:String = "closeHelpScreen";
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function UIEvent (type:String, tc:IUIComponent = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_tc = tc;
		}
			
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var data:Object;
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		private var _tc:IUIComponent;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * Retourne le composant concerné par l'event
		 */
		public function get targetComponent () : IUIComponent
		{
			return _tc;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function clone () : Event
		{
			return new UIEvent(type, _tc, bubbles, cancelable);
		}
			
	}

}

