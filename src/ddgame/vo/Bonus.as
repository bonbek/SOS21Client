package ddgame.vo {

	import flash.utils.getTimer;
	import ddgame.vo.ISessionWritable;

	/**
	 *	Vo Bonus de base
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class Bonus implements ISessionWritable, IBonus {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function Bonus (t:int, g:int)
		{
			_time = getTimer();			
			_theme = t;
			_gain = g;
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		// theme concerné (social, économique, environement...)
		protected var _theme:int;
		// gain numéraire du bonus
		protected var _gain:int
		// valueur representé par ce bonus
		protected var _value:*;
		// ...
		protected var _time:int;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		/**
		 * Retourne le theme du bonus
		 */
		public function get theme () : int
		{
			return _theme;
		}
		
		/**
		 * Retourne le gain representé par ce bonus
		 * Peut être un objet autre qu'un entier
		 */
		public function get gain () : int
		{
			return _gain;
		}
		
		/**
		 * Retourne la valeur numéraire representée
		 * par le bonus
		 */
		public function get value () : *
		{
			return _value;
		}
		
		/**
		 * Retourne le chrono, instant ou à été déclaré le bonus
		 */
		public function get time () : int {
			return _time;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * 
		 */
		public function toString () : String {
			return "à implémenter";
		}
		
		/**
		 *	Retourne la valeur primitive de cette objet
		 *	@return int
		 */
		public function valueOf () : Object {
			return _value;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

