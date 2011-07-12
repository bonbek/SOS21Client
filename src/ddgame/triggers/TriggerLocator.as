package ddgame.triggers {

	import flash.utils.*;
	import com.sos21.debug.log;
	import ddgame.triggers.ITrigger;
	
	/**
	 *	Localisateur de classes de trigger
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class TriggerLocator {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function TriggerLocator (acces:PrivateConstructor)
		{}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _oI:TriggerLocator;
		private var _triggerClassList:Array /* of Class */ = [];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get triggerList():Array /* of Class */
		{
			return _triggerClassList;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Retourne true si une classe de trigger est
		 *	enregistrer pour un identifiant donné
		 *	@param	id	 l'identifiant d'enregistrement à tester
		 */
		public function isRegisteredId(id:int):Boolean
		{
			return _triggerClassList[id] != null;
		}
		
		/**
		 *	Retourne une classe trigger depuis son
		 *	identifiant d'enregistrement
		 *	@param	id	 identifiant d'enregistrement
		 */
		public function findTriggerClass(id:int):Class
		{
			return _triggerClassList[id];
		}
		
		/**
		 *	Enregistre une classe de trigger
		 *	@param	id	 identifiant d'enregistrement
		 *	@param	classRef	 classe de trigger
		 */
		public function registerTriggerClass(id:int, classRef:Class):Boolean
		{
			// on test si la classe est déjà enregistrée
			if (_triggerClassList[id] is Class)
			{
				trace("-- can't register " + classRef + ", a triggerClass with id: " + id + " already registered @" + toString());
				return false;
			}
			
			// on test si c'est une classe de trigger
			var impl:String = "ddgame.triggers::ITrigger";
			if (describeType(classRef).factory.implementsInterface.(@type == impl).toXMLString() == "")
			{
				trace("-- can't register " + classRef + ", has no ITrigger implementation @" + toString());
				return false;
			}
			
			// on enregistre
			_triggerClassList[id] = classRef;
			return true;
		}
		
		/**
		 *	Déseregistre une classe de trigger
		 *	@param	id	 identifiant d'enregistrement du trigger
		 */
		public function unRegisterTriggerClass(id:int):void
		{
			_triggerClassList[id] = null
		}
		
		/**
		 *	Retourne la représentation string
		 *	de cette objet
		 */
		public function toString():String
		{
			return getQualifiedClassName(this);
		}
		
		/*
		*	Singelton
		*/
		public static function getInstance():TriggerLocator
		{
			if (_oI == null)
				_oI = new TriggerLocator(new PrivateConstructor());

			return _oI;
		}
				
	}
	
}

internal final class PrivateConstructor {}