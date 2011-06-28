/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package components.quiz {
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  16.03.2008
	 */
	public class QuestionItem {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function QuestionItem() {}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		[Inspectable(type="String", defaultValue="")]
		public var label:String;

		[Inspectable(type="String", defaultValue="")]		
		public var title:String;

		[Inspectable(type="Boolean", defaultValue="false")]
		public var good:Boolean;
				
		public function toString():String {
			return "[QuestionItem: "+label+","+title+","+good+"]";	
		}
		
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
		
	}
	
}
