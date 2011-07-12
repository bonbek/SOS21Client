package com.sos21.utils {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	/**
	 *	Lis un XML en se basant sur ses attributs de noeuds
	 *	attributs : 
	 *		- exec		nombre de fois que noeuds sera lus, au dela, il sera supprimé
	 *		- delay		délai avant lecture du noeud en millisecondes
	 *		- shortcut	?
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class XMLTrip extends EventDispatcher {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const STEP:String = "step";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function XMLTrip(xml:XML = null)
		{
			super();
			_t = new Timer(0, 1)
			
			if (xml)
				this.xml = xml;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _tripNode:XML;			// data
		protected var _tripIndex:int;			// index noeud en cours lecture
		protected var _cNode:XML;				// noeud parent en cours lecture
		protected var _stepNode:XML;			// dernier noeud lu / dispatché
		protected var _t:Timer;
		protected var _lastTime:int = -1;	// dernier temps de déclenchement du timer
		protected var _running:Boolean = false;	// état lecture
		protected var _stepEvent:Event;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set xml(data:XML):void
		{
			_tripNode = data;
			_tripIndex = -1;
			_cNode = _tripNode;
		}
		
		/**
		 *	Retourne le dernier noeud lu
		 */
		public function get currentStep():XML
		{
			return _stepNode;
		}
		
		/**
		 *	Retourne l'état de lecture en cours
		 */
		public function get running():Boolean
		{
			return _running;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Empêche l'entrée dans le noeud en cours (lecture des noeuds enfants)
		 *	Si l'instance est arrétée, appeler la méthode nextStep()
		 *	pour lancer la lecture du prochain noeud
		 */
		public function strideOver():void
		{
			_tripIndex = _cNode.childIndex();
			_cNode = _cNode.parent();
			if (!_running) _nextStep();
		}
		
		/**
		 *	Place la tête de lecture à un noeud du xml et le lis
		 *	Si l'instance est arrétée, appeler la méthode nextStep()
		 *	pour lancer la lecture du noeud
		 *	@param	val	 valeur de l'attribut
		 *	@param	atrib	 un nom d'attribut à utiliser pour retrouver le noeud
		 */
		public function jumpToByAttribute(val:String, attrib:String = "id"):Boolean
		{
			var nlist:XMLList = _tripNode.descendants().(attribute(attrib) == val);
			var n:int = nlist.length();
			if (n > 0)
			{
				// on test tous les noeuds pour en recup un de bon dans la liste
				var nod:XML;
				var tnod:XML;
				var exec:int;
				var count:int;
				for (var i:int = 0; i < n; i++)
				{
					tnod = nlist[i];

					exec = tnod.@exec;
					count = tnod.@count;
					if (exec > 0 && count >= exec) continue;

					nod = tnod;
					break;
				}
				if (!nod) return false;
//				var nod:XML = nlist[0];
				_tripIndex = nod.childIndex() - 1;
				_cNode = nod.parent();
				if (_running)
				{					
					_t.stop();
					// on empêche le passage en double l'étape suivante (voir onTickHandler)
					_stepEvent.preventDefault();
					_nextStep();
				}
				return true;
			}
			return false;
		}
		
		public function injectData(data:Object):void
		{
			var child1:XML = _stepNode;
//debug.trace("------------- inject data ------------------")
//debug.trace("stepNode > ", _stepNode.toXMLString());
//debug.trace("_cNode > ", _cNode.toXMLString());
			var pNode:XML = _stepNode == _cNode ? _stepNode.parent() : _cNode;
			pNode.insertChildAfter(child1, data);
//debug.trace("inject data > ", _tripNode.toXMLString());
		}
		
		/**
		 *	Passe au noeud suivant, ou noeud enfant si il y en à
		 */
		public function nextStep () : void
		{
//			debug.trace(" -- nextStep -- ");
			_nextStep();
		}
		
		/**
		 *	Démarre / redémarre la lecture "temporelle" du XML
		 */
		public function start():void
		{
//debug.trace("start XMLTrip");
			_t.addEventListener(TimerEvent.TIMER, onTickHandler, false, 0, true);
			_running = true;
			// on test si le dernier arrêt était en attente de lecture
			if (_lastTime > 10)
			{
//debug.trace("---- redémarage dernier noeud ------");
//debug.trace("> ", _lastTime);
				_t.reset();
				_t.delay = _lastTime;
				_lastTime = getTimer();
				_t.start();
			} else {
				nextStep();
			}
		}
		
		/**
		 *	stop la lecture "temporelle" du XML
		 */
		public function stop():void
		{
//debug.trace("stop XMLTrip");
			// on test si le prochain noeud est en attente afin de relancer
			// la lecture en fonction du temps restant pour l'atteindre
			if (_t.running)
			{
//debug.trace("---- recup de temps ---- ");	
				var tpass:int = getTimer() - _lastTime;
//debug.trace("> ecoulé: ",  tpass);
//debug.trace("> recup: ", _t.delay - tpass);
				_lastTime = _t.delay - tpass;
			} else {
				_lastTime = -1;
			}
			_t.removeEventListener(TimerEvent.TIMER, onTickHandler, false);
			_t.stop();
			_running = false;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Réception des events du timer
		 */
		protected function onTickHandler(event:Event = null):void
		{
//debug.trace("-> onTick " + currentStep.toXMLString());
//debug.trace("--------- " + _t.running + " : " + _t.delay);
//trace("exec > ", currentStep.toXMLString());
//debug.trace("-------------------------------------------");
			_stepEvent = new Event(STEP, false, true);
			dispatchEvent(_stepEvent);
			if (_running && !_stepEvent.isDefaultPrevented())
			{
				_nextStep();
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Recherche du prochain noeud
		 */
		protected function _nextStep():void
		{
//debug.trace("- nextStep -");
			++_tripIndex;

			var actions:XMLList = _cNode.*;
			var cnode:XML;

			if (actions.length() - 1 >= _tripIndex)
			{
				// une action à la suite
				cnode = actions[_tripIndex];

				if (!checkNode(cnode))
				{
					// on est sur un noeud invalide
//debug.trace("invalide node > ", cnode.toXMLString());
					_cNode = cnode;
					_nextStep();
					return;
				}

				// test si le noeud est à supprimer
				var nexec:int = cnode.@exec;
				if (nexec > 0)
				{
					if (nexec == cnode.@count)
					{
//debug.trace("delete > ", cnode.toXMLString());
						delete actions[_tripIndex];
						--_tripIndex;
						_nextStep();
						return;
					}
				}

			} else {
				if (_cNode != _tripNode)
				{
					// il faut remonter d'un niveau					
//debug.trace("up one level > ", _cNode.toXMLString());
					_tripIndex = _cNode.childIndex();
					_cNode = _cNode.parent();
					_nextStep();
					return;
				} else {
					if (actions.length() > 0)
					{
						// on repart de 0 depuis le root
//debug.trace("restart to root at 0");
						_tripIndex = -1;
						_nextStep();
						return;
					} else {
						// plus d'actions en root, on arrête autoLife
//debug.trace("plus de noeud en root");
						stop();
						return;
					}
				}
			}
			
//debug.trace("find > ", cnode.toXMLString());

			// on teste si on entre dans le noeud en cours
			// pour la prochaine fois
			var clist:XMLList = cnode.*;
			if (clist.length() > 0)
			{
				_cNode = cnode;
				_tripIndex = -1;
			}
//debug.trace("exec > ", cnode.toXMLString());

			// on incrémente le nombre d'éxecutions de l'action
			cnode.@count = int(cnode.@count) + 1;
			_stepNode = cnode;
			// on lance le timer
			var sdelay:int = cnode.@delay;

			_t.reset();
			
			if (sdelay > 10)
			{
				_t.delay = sdelay;
				_lastTime = getTimer();
				_t.start();
			} else {
				_lastTime = -1;
				onTickHandler();
			}
		}
		
		/**
		 *	@private
		 *	Test la validité d'un noeud
		 */
		protected function checkNode(nod:XML):Boolean
		{			
			return nod.nodeKind() == "element";
		}
		
	}

}

