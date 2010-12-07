package ddgame.client.triggers {
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.Dictionary;
	import ddgame.client.events.EventList;
	import com.sos21.tileengine.events.TileEvent;
	import ddgame.ApplicationFacade;
	import ddgame.client.proxy.TileTriggersProxy;
		
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class TriggerProperties {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static var fireTypeList:Array = [
																MouseEvent.MOUSE_OVER,			// 0
																MouseEvent.MOUSE_OUT,			// 1
																MouseEvent.CLICK,					// 2
																TileEvent.LEAVE_CELL,			// 3
																TileEvent.ENTER_CELL, 			// 4
																MouseEvent.MOUSE_DOWN,			// 5
																MouseEvent.MOUSE_UP,				// 6
																TextEvent.LINK,					// 7 (voir HtmlPopupTrigger)
																"initMap",							// 8 à l'initialisation de la map
																"timer"								// ...
															]
															
		public static var list:Dictionary = new Dictionary(true);
		public static var linkedTriggerList:Array = [];
		public static var lastHighestId:int;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function TriggerProperties (id:int, triggerClassId:int, fireType:int, srefId:String)
		{
			_id = id;
			refId = srefId;
			_triggerClassId = triggerClassId;
			_fireType = fireType;
			if (id && !list[_id])
			{
				list[_id] = this;
			}				
			else
			{
				_id = ++lastHighestId;
				list[_id] = this;
			}
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var title:String;
		private var _id:int;
		protected var _triggerClassId:int;
		protected var _target:Object;
		protected var _arguments:Dictionary = new Dictionary(true);
		protected var _fireType:int;
		protected var _linkageId:int = -1;
		
		protected var _notFM:String;
		protected var _fromM:String;
		// nbr execution maximum -1 pour infini
		protected var _mFireCount:int = -1;
		

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public var exec:int = 0;			// nombre de fois que le trigger à été exécuté
		
		public var symbLinkId:int = -1;	// lien symbolique à un autre trigger -1 = pas de lien
//		public var initLink:int = -1;		// lien vers trigger executé avant celui-ci -1 = pas de lien
//		public var completeLink:int = -1	// lien vers trigger après exécution de celui-ci -1 = pas de lien
		public var delay:int = 0;			// delai avant execution du trigger en millisecondes
//		public var repeatCount:int			// nombre d'execution répétées
		public var cond:Object;				// conditions
		public var disable:int = 0;		// activé ou pas
		/**
		 * Nombre d'execution du trigger pour la scène en cours
		 */
		public var fireCount:int = 0;
		
		public var refId:String;
		/*public var activeFromMaps:Array;
		public var inactiveFromMaps:Array;*/
		
		public function get triggersProxy () : TileTriggersProxy
		{
			return ApplicationFacade.getInstance().getProxy(TileTriggersProxy.NAME) as TileTriggersProxy;
		}
		
		/**
		 *	Retourne l'identifiant de cette instance
		 */
		public function get id() : int {
			return _id;
		}
		
		/**
		 * Retourne le nombre d'execution maximales
		 * pour ce trigger
		 */
		public function get maxFireCount () : int
		{
			if (_mFireCount == -1 || _mFireCount == int.MAX_VALUE) return int.MAX_VALUE;
			return _mFireCount;
		}
		
		/**
		 * Définit le nombre d'execution maximales
		 * pour ce trigger, passer une valeur de -1 pour que
		 * le trigger s'execute indéfiniement
		 */
		public function set maxFireCount (val:int) : void
		{
			_mFireCount = val;
		}
		
		/**
		 * TODO documenter
		 */
		public function set activeFromMaps(val:Array):void {
				_fromM = val ? val.join(",") : null;
		}
		
		public function get activeFromMaps():Array {
			return _fromM ? _fromM.split(",") : null;
		}
		
		public function set inactiveFromMaps(val:Array):void {
				_notFM = val ? val.join(",") : null;
		}
		
		public function get inactiveFromMaps():Array {
			return _notFM ? _notFM.split(",") : null;
		}
		
		public function getCond (k:String) : *
		{
			if (!cond) return null;
			if (k in cond) return cond[k];

			return null;
		}
		
		/**
		 *	Retourne l'identifiant des propriétées
		 *	du trigger au quel est lié symboliquement
		 *	cette instance
		 */
		public function get linkageId () : int
		{
			return _linkageId;
		}

		/**
		 *	Définit l'identifiant des propriétées
		 *	du trigger au quel est lié symboliquement
		 *	cette instance
		 */
		public function set linkageId(val:int):void
		{
			_linkageId = val;
			linkedTriggerList[_linkageId] = this;
		}
		
		/**
		 *	Flag persistance
		 */
		public function get persist () : Boolean
		{ return _arguments["persist"]; }
		
		public function set persist (val:Boolean) : void
		{
			if (val) _arguments["persist"] = true;
		 	else
				delete _arguments["persist"];
		}

		/**
		 *	Définit l'identifiant de la classe de trigger
		 *	associé à cette instance
		 */
		public function set triggerClassId (val:int) : void
		{
			_triggerClassId = val;
		}
		
		/**
		 *	Retourne l'identifiant de la classe de trigger
		 *	associé à cette instance
		 */
		public function get triggerClassId () : int
		{
			return _triggerClassId;
		}
		
		/**
		 *	Définit l'identifiant du type de déclenchement du trigger
		 *	associé à cette instance
		 *	(voir fireTypeList)
		 */
		public function set fireType(val:int):void
		{	
			if (val != _fireType)
			{
				triggersProxy.onTriggerPropertieChange(this, "fireType", val);
				_fireType = val;
			}
		}
		
		/**
		 *	Retourne l'identifiant du type de déclenchement du trigger
		 *	associé à cette instance
		 *	(voir fireTypeList)
		 */		
		public function get fireType():int
		{
			return _fireType;
		}

		/**
		 *	Retourne le type de déclenchement du trigger
		 *	associé à cette instance
		 *	(voir fireTypeList)
		 */				
		public function get fireEventType():String
		{
//			if (_fireType == -1) return "chained";
			return fireTypeList[_fireType];
		}
		
		
		
		public function setArgument (k:String, v:*) : void
		{
			if (k in this && k != "id") this[k] = v;
			else
				_arguments[k] = v;

//			trace(this, "setArgument", k, v);
		}
		
		public function set arguments(val:Dictionary):void
		{
			_arguments = val;
		}
		
		public function get arguments():Dictionary /* of String */
		{
			return _arguments;
		}
		
		/**
		 * Retourne true/false si cette instance est chainé
		 * à un autre trigger
		 */
		public function get isChained():Boolean
		{
			var li:Array = triggersProxy.allTriggersInMap;
			var n:int = li.length;
			var tr:Object;
			var isc:Boolean = false;
			while (--n > -1)
			{
				tr = li[n];
				if (tr.hasChainedTrigger)
				{
					if (tr.chainedTriggers.indexOf(this) > -1) {
						isc = true;
						break;
					}
				}
			}
			
			return isc;
		}
		
		public function get chainedTo () : Array
		{
			var li:Array = triggersProxy.allTriggersInMap;
			var n:int = li.length;
			var tr:Object;
			var ch:Array = [];
			while (--n > -1)
			{
				tr = li[n];
				if (tr.hasChainedTrigger)
				{
					if (tr.chainedTriggers.indexOf(this) > -1) {
						ch.push(tr.id);
					}
				}
			}
			
			return ch.length > 0 ? ch : null;
		}
		
		/**
		 * Retourne true / false si le trigger à un
		 * chaînage ou pas
		 * 
		 */
		public function get hasChainedTrigger () : Boolean
		{
			var a:Array = _arguments["onComplete"];
			if (!a) {
				return false;
			} else {
				return (a.length > 0);
			}
		}
		
		/**
		 *	Retourne la liste des triggers chaînés à cette instance
		 * 
		 *	@return Array
		 */
		public function get chainedTriggers () : Array
		{
			if (!hasChainedTrigger) return null;
			
			var al:Array = _arguments["onComplete"];
			var ret:Array = [];
			
			var n:int = al.length;
			for (var i:int = 0; i < n; i++)
				ret.push(list[al[i]]);
				
			return ret;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Ajoute une référence au chaînage de cette instance
		 * 
		 *	@param id int
		 *	@return Boolean
		 */
		public function addChainedTrigger(trProp:TriggerProperties, index:int = -1):void
		{
			// test si le tableau des triggers chaînés existe
			if (!hasChainedTrigger)
				_arguments["onComplete"] = [];
				
			// ajout de l'id ref au chainage
			var trid:int = trProp.id;
			var args:Array = _arguments["onComplete"];
			if (index > -1)
			{
				args.splice(index, 0, trid);
			} else {
				args.push(trid);
			}
		}
		
		public function removeChainedTrigger(trProp:TriggerProperties):void
		{
			if (hasChainedTrigger)
			{
				var tid:int = trProp.id;
				var args:Array = _arguments["onComplete"];
				var ind:int = args.indexOf(tid);
				if (ind > -1)
					args.splice(ind, 1);
			}
		}
		
		/**
		 * Parse l'objet data
		 * 
		 * @private
		 *	@param alist Object
		 */
		public function parseArguments (alist:Object) : void
		{

			var val:*;
			for (var prop:String in alist)
			{
				val = alist[prop];
				switch (prop)
				{
					// propriété de chainage à un autre trigger
					case "lid" :
						linkageId = val;
						break;
					// propriétés nbr de fois que le trigger pourra être executé
					case "fireCount" :
//						if (val > 0)
						_mFireCount = val;
						break;
					// propriétés lien symbolique à un autre trigger
					case "slid" :
						symbLinkId = val;
						break;
					default :
						_arguments[prop] = val;
						break;
				}
			}
		}
		
		public function parseArrayArguments(alist:Array /* of String */):void
		{
			var n:int = alist.length;
			while (--n > -1)
			{
				var args:String = alist[n];
				var ind:int = args.indexOf("=");
				var prop:String = args.substring(0,ind);
				var val:String = args.substring(ind + 1,args.length);
				switch (prop)
				{
					// propriété de chainage à un autre trigger
					case "lid":
						linkageId = int(val);
						break;
					// propriétés nbr de fois que le trigger pourra être executé
					case "fireCount" :
//						if (int(val) > 0)
						_mFireCount = int(val);
						break;
					// propriétés lien symbolique à un autre trigger
					case "slid" :
						symbLinkId = int(val);
						break;
					default :
						_arguments[prop] = val;
						break;
				}
				
			}
		}
		
		public function argumentsToArray():Array /* of String */
		{ 
			var a:Array /* of String */ = [];
			for (var p:String in _arguments)
			{
				a.push(p + "=" + _arguments[p]);
			}
			return a;
		}
		
		public function toString():String
		{
			return ("[TriggerProperties id:" + _id + "]");
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
