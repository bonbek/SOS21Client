package com.sos21.utils {
	
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class XMLTrip extends Timer {
	
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
		public function XMLTrip(data:XML = null)
		{
			super(0, 1);
			
			if (data)
				this.data = data;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _tripNode:XML;
		protected var _tripIndex:int;
		protected var _cNode:XML;
		protected var _stepNode:XML;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set data(data:XML):void
		{
			_tripNode = data;
			_tripIndex = -1;
			_cNode = _tripNode;
		}
		
		public function get currentStep():XML
		{
			return _stepNode;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Empêche l'entrée dans le noeud en cours
		 */
		public function strideOver():void
		{
			_tripIndex = _cNode.childIndex();
			_cNode = _cNode.parent();
		}
		
		/**
		 *	Passe au noeud suivant, ou noeud enfant si il y en à du noeud
		 *	en cours.
		 */
		public function nextStep():void
		{
			if (running)
			{
				super.stop();
				super.reset();
			}
			
			_nextStep();
		}
		
		/**
		 *	@inheritDoc
		 *	Démarre / redémarre la lecture du XML
		 */
		override public function start():void
		{
			this.addEventListener(TimerEvent.TIMER, onTickHandler, false);
			nextStep();
		}
		
		/**
		 *	@inheritDoc
		 *	stop la lecture du XML
		 */
		override public function stop():void
		{
			super.stop();
			super.reset();
			this.removeEventListener(TimerEvent.TIMER, onTickHandler, false);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onTickHandler(event:Event):void
		{
			dispatchEvent(new Event(STEP));
//			nextStep();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 */
		protected function _nextStep():void
		{
//debug.trace("-------------------------------------");
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
					debug.trace("invalide node, test next");
					_cNode = cnode;
					nextStep();
					return;
				}

				// test si le noeud est à supprimer
				var nexec:int = cnode.@exec;
				if (nexec > 0)
				{
					if (nexec == cnode.@count)
					{
//debug.trace("delete: ", cnode.toXMLString());
						delete actions[_tripIndex];
						nextStep();
						return;
					}
				}

//debug.trace("node: ", cnode.toXMLString());
			} else {
				if (_cNode != _tripNode)
				{
					// il faut remonter d'un niveau
//debug.trace("up one level");
					_tripIndex = _cNode.childIndex();
					_cNode = _cNode.parent();
					nextStep();
					return;
				} else {
					if (actions.length() > 0)
					{
						// on repart de 0 depuis le root
						_tripIndex = -1;
						nextStep();
						return;
					} else {
						// plus d'actions en root, on arrête autoLife
debug.trace("plus de noeud en root");
						stop()
						return;
					}
				}
			}

			var clist:XMLList = cnode.*;
			if (clist.length() > 0)
			{
				_cNode = cnode;
				_tripIndex = -1;
			}

			// on incrémente le nombre d'éxecutions de l'action
			cnode.@count = int(cnode.@count) + 1;
			_stepNode = cnode;
			// on lance le timer
			var sdelay:int = cnode.@delay;
			delay = sdelay > 0 ? sdelay : 1;
			super.start();
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

