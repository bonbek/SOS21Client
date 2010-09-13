package ddgame.vo {

	import ddgame.vo.ITheme;

	/**
	 *	Objet theme
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class Theme implements ITheme {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function Theme (id:int, color:uint, label:String)
		{
			_id = id;
			_color = color;
			_label = label;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _id:int;
		private var _color:uint;
		private var _label:String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get id () : int {
			return _id;
		}
		
		public function get color () : uint {
			return _color;
		}
		
		public function get label () : String {
			return _label
		}
		
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

