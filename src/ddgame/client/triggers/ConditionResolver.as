
package ddgame.client.triggers {
	
	import flash.utils.Dictionary;
	import ddgame.client.triggers.Condition;
//	import org.osflash.signals.Signal;
	
	/**
	 *	Essaie de classe résolution de conditions
	 * implémentation conditionalité
	 * TODO impléménter objets "rules", comme ça on ne pourrais avoir une même instance
	 * de règle sur plusieurs conditions ?
	 * 
	 * note :
	 * 
	 * 
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ConditionResolver implements Condition {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@constructor
		 * 
		 * 
		 * 
		 * cond: 
		 *  -
		 *     m: méthode  : > < = ?
		 *     t: cible    : p "player", t "tile", d "date"
		 *     p: propriété : p "points", x "coordonnée", t "time", "month", d "day"
		 * 
		 *   	 m:  0 > aucune des conditions
       *      1 > au moins 1 des conditions
       *      3 > toutes les conditions
       *   p: 0|>|50
       * 
      *		ppu: [null, null, 50, null]
      *		msg: il te faut plus de points
      *		m: 0
      *		c: []
      *		e: il te faut plus de points
		 */
		public function ConditionResolver (rule:Object = "all", ruleParams:Object = null, methods:Object = null) : void
		{
			this.rule = rule;
			this.ruleParams = ruleParams;
			if (methods) { _mds = methods;
			} else {
				_mds = new Dictionary(true);
				_mds[">"]	= function (v1:*, v2:*) : Boolean { return v1 > v2 };
				_mds["<"]	= function (v1:*, v2:*) : Boolean { return v1 < v2 };
				_mds[">="]	= function (v1:*, v2:*) : Boolean { return v1 >= v2 };
				_mds["<="]	= function (v1:*, v2:*) : Boolean { return v1 <= v2 };
				_mds["="]	= function (v1:*, v2:*) : Boolean { return v1 == v2 };
				_mds["!="]	= function (v1:*, v2:*) : Boolean { return v1 != v2 };
			}
		}
	
		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------
		
		// "acteurs" partagés entre toutes les instances
		protected var _actors:Dictionary = new Dictionary(true);
		// "méthodes" de vérif partagées entre toutes les instances
		protected var _mds:Object;

		// liste des conditions de cette instance
		protected var _conds:Array = [];
		// ...
		protected var _prop:Object;
		protected var _actor:Object;
		
		
		public var rule:Object;
		public var ruleParams:Object;
		
		protected var _vfProp:*;
		protected var _vfValue:*;
//		protected var _parentResolver:
		
//		public var valided:Signal;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set prop (val:*) : void {
			_prop = val;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Ajout d'une conditionalité
		 * TODO documenter
		 * 
		 *	@param actor Object
		 *	@param prop *
		 *	@param rule Object
		 *	@return Condition
		 */
		public function create (actor:Object, prop:*, rule:Object = "all", ruleParams:Object = null) : Condition
		{
			var cond = new ConditionResolver(rule, ruleParams, _mds);
			cond.prop = prop;
			
			// on n'est pas une valeur primitive ?
			if (!(actor === int || actor === Number || actor === String || actor === Array)) {
				// au quel cas on est sur une propriété d'objet
				cond.setActor(actor);
			}
			
			_conds.push(cond);
			return cond;
		}
		
		/**
		 * TODO documenter
		 *	@param md Object		la méthode >,=...
		 *	@param vVal Object
		 *	@param vProp Object
		 */
		public function add (md:Object, vVal:Object, vProp:Object = null) : void
		{
			md = _mds[md];
			if (!md) return;
			_conds.push(new SimpleCondition(md, vVal, vProp));
		}
		
		/**
		 * TODO documenter
		 *	@param arg le ruleParams
		 *	@return Boolean
		 */
		public function verify (arg:* = void) : Boolean
		{
			if (_actors[arg]) return (_actors[arg].verify());
			var res:Boolean;
			var v1:* = _actor ? _actor[_prop] : _prop;
			if (v1 is Function) v1 = v1();
			if (v1 is Array) return verifyArray(v1, arg);
			var c:Object;
			var m:Object = (arg !== void) ? arg : ruleParams;
			var n:int;
			switch (rule)
			{
				// Toutes les conditions vérifiées
				case "all" :
					res = true;
					for each (c in _conds)
						if (!c.verify(v1)) return false;
					break;
				// Les conditions id 0, 3... sont vérifiées
				case "match" :
					res = true;
					if (m is String) m = m.split(",");
					for each (c in m)
						if (!_conds[c].verify(v1)) return false;
					break;
				// Plus de n conditions sont vérifiées
				case "more" :
					res = false;
					n = m != null ? int(m) + 1 : 1;
					for each (c in _conds)
						if ((n-= int(c.verify(v1))) <= 0) return true;
					break;
				// Moins de n conditions vérifiées
				case "less" :
					res = true;
					n = 0;
					var n1:int = m != null ? int(m) : 0;
					// TODO voir si je peux pas trouvé un algo pour ne pas avoir
					// à vérifier toutes les conditions
					for each (c in _conds) n+= int(c.verify(v1, void));
					if (n >= n1 || !n) return false;
					break;
				// Au moins n conditions vérifiées
				case "least" :
					res = false;
//					m = (arg !== void) ? arg : 1;
					n = m != null ? int(m) : 1;
					for each (c in _conds)
						if ((n-= int(c.verify(v1))) == 0) return true;
					break;
			}

			return res;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function verifyArray (a:Array, arg:* = void) : Boolean
		{
			var res:Boolean;
			var v:*;
			switch (rule)
			{
				case "all" :
					res = true;
					for each (v in a)
						if (!verify(v)) return false;
					break;
			}
			return res;
		}
		
		/**
		 * @private
		 * Utilisé en interne
		 */
		public function setActor (val:Object) : void
		{
			_actor = val;
		}
		
		/**
		 *	@private
		 */
		/*public function setSignal (val:Signal) : void
		{
			_valided = val;
		}*/
		
	}

}

/**
 *	Verificateur condition de base
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author toffer
 */
internal class SimpleCondition {

	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------

	public function SimpleCondition (method:Object, vVal:Object, vProp:Object = null) : void
	{
		this.method = method;
		this.vfValue = vProp != null ? vProp : vVal;
		this.vfProp = vProp;
	}
	
	//---------------------------------------
	// PUBLIC VARIABLES
	//---------------------------------------
	
	public var method:Object;

	public var vfProp:Object;
	public var vfValue:Object;

	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------
	
	public function verify (v1:*) : Boolean
	{
		if (vfProp)
			return method(v1, vfValue[vfProp]);

		return method(v1, vfValue);
	}
	
}


