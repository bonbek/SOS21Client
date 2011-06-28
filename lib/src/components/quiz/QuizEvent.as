/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package components.quiz {
	import flash.events.Event;
	
	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  03.04.2008
	 */
	public class QuizEvent extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const COMPLETE:String = "quizComplete";
		public static const RESPONSE_SELECT:String = "quizResponseSelect";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function QuizEvent( type:String, isGood:Boolean = false, bonus:Object = null, bubbles:Boolean = true, cancelable:Boolean = false )
		{
			this.isGood = isGood;
			this.bonus = bonus;
			super(type, bubbles, cancelable);		
		}

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public var isGood:Boolean;
		public var bonus:Object;

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function clone():Event
		{
			return new QuizEvent(type, isGood, bonus, bubbles, cancelable);
		}
		
	}
	
}
