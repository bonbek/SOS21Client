package ddgame.triggers {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IEventDispatcher;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.events.TileEvent;

	import com.sos21.events.EventChannel;
	import com.sos21.facade.Facade;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;

	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.helper.HelperList;
	import ddgame.proxy.ProxyList;
		
	/**
	 *	Class description.
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AbstractExternalTrigger extends Sprite implements ITrigger {
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function AbstractExternalTrigger ()
		{
			super();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		public function get applicationStage () : DisplayObjectContainer
		{ return AbstractHelper.stage; }
		
		public function get builderProxy () : Object
		{ return facade.getProxy(ProxyList.OBJECTBUILDER_PROXY); }
		
		public function get isosceneHelper () : Object
		{ return facade.getObserver(HelperList.ISOSCENE_HELPER); }

		
		// ******************** Implémentation Notifier ***********************
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/*
		*	Return Facade instance associated to the EventChannel assigned
		*	to this Notifier instance
		*	@return	Facade
		*/
		public function get facade() : Facade
		{
			return Facade.getFacade(channel);
		}
		
		/*
		*	Notify Observers
		*	@param	e : Event
		*/
		final public function sendEvent(event:Event):void
		{
			facade.sendEvent(event);
		}
		
		/*
		*	Notify public Observers ( ApplicationChannel Observers )
		*	@param	e : Event
		*/
		final public function sendPublicEvent(event:Event):void
		{
			facade.sendPublicEvent(event);
		}
				
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		private var _c : EventChannel;
		
		/*
		*	Set the EventChannel this Notifier belong to
		*	Usualy set by a Facade instance during notifycation process (when a Command extends Notifier)
		*	or register Proxy process
		*	@param	ac : EventChannel
		*/
		public function set channel(ec:EventChannel):void
		{ 
			_c = ec;
		}
		
		/*
		*	@return	EventChannel
		*/
		public function get channel():EventChannel
		{ 
			return _c;
		}
		
		// ************ Implémentation ITrigger (Recopie AbstractTrigger) *************

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		protected var _id:int;
		protected var _properties:Object;
		protected var _starget:Object;
		protected var _differer:Object;
		protected var _canceled:Boolean = false;

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public function get classID () : int
		{
			return -1;
		}

		public function set sourceTarget (val:Object) : void
		{
			_starget = val;
		}

		public function get sourceTarget () : Object
		{
			return _starget;
		}

		public function set properties (val:Object) : void
		{ 
			_properties = val;
		}

		public function get properties () : Object 
		{ 
			return _properties;
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public function isPropertie (prop:String) : Boolean
		{ return _properties.arguments[prop] != null; }

		/**
		 *	Retourne une propriété
		 *	@return 
		 */
		public function getPropertie (prop:String) : *
		{ return _properties.arguments[prop]; }

		/**
		 * Définit une propriété
		 *	@param prop String
		 *	@param val *
		 */
		public function setPropertie (prop:String, val:*) : void
		{ _properties.arguments[prop] = val; }

		/**
		 *	@param event Event
		 */
		public function execute (event:Event = null) : void
		{ trace(".execute() should be implemented in your subClass@" + toString()); }

		/**
		 *	@private
		 */
		public function initialize () : void
		{
			// TODO, passer ça dans AbstractExternalTrigger
			var evtType:String = properties.fireType == -1 ? "chained" : properties.fireEventType;
			if (evtType != null)
			{
				var tevent:TriggerEvent = new TriggerEvent(evtType, this, true, true);
				sendEvent(tevent);
				if (tevent.isDefaultPrevented())
				{
					cancel();
					return;
				}
			}
			else
			{
				// TODO eventType est null ou non existant, on envoi une erreur / notifiation ?
				cancel();
			}

			if (!_differer)
			{
				// on regarde si il faut attendre que le joueur soit déplacé
				if (!waitPlayerMove()) _execute();
			} else {
				onDiffer();
			}
		}

		/**
		 *	Annule l'execution du trigger
		 */
		public function cancel () : void
		{
				// abonnement sur bob pour lancer réelement le trigger
			if (getPropertie("_mb"))
			{
				var bob:AbstractTile = AbstractTile.getTile("bob");
				bob.removeEventListener(TileEvent.MOVE_COMPLETE, onMoveBob);
				bob.removeEventListener(TileEvent.MOVE_CANCELED, onMoveBob);
				bob.stop();
				bob.gotoAndStop("stand");
			}

			if (getPropertie("_fs")) {
				sendEvent(new Event(EventList.UNFREEZE_SCENE));
			}

			_canceled = true;
			sendEvent(new TriggerEvent(TriggerEvent.CANCELED, this));
		}

		/**
		 * @private
		 * Nettoyage
		 */
		public function release () : void
		{
			_properties = null;
			_starget = null;
			_differer = null;
		}

		/**
		 * Retourne la référence du stage
		 */
		override public function get stage() : Stage
		{  return AbstractHelper.stage.stage; }

		/**
		 * TODO à supprimer ?
		 *	@param evtType String
		 */
		public function differ (evtType:String) : void
		{
	//		_differer = new TriggerDifferer(evtType, channel, this);
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/**
		 *	@param e Event
		 */
		protected function onMoveBob (e:Event) : void
		{
			// abonnement clique sur ecène annule, pour annuler le déplacement
			isosceneHelper.component.removeEventListener(MouseEvent.MOUSE_DOWN, onMoveBob);
			// abonnement sur bob pour lancer réelement le trigger
			// AbstractTile.getTile("bob").removeEventListener(TileEvent.MOVE_COMPLETE, onMoveBob);

			switch (e.type)
			{
				// joueur à cliqué dans la scène, on annule ce trigger
				case MouseEvent.MOUSE_DOWN :
					cancel();
					break;
				case TileEvent.MOVE_CANCELED :
					cancel();
					break;
				// fin du déplacement de bob
				case TileEvent.MOVE_COMPLETE :
					// abonnement sur bob pour lancer réelement le trigger
					AbstractTile.getTile("bob").removeEventListener(TileEvent.MOVE_COMPLETE, onMoveBob);
					_execute();
					break;
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------

		/**
		 * TODO implémnter tout ça dans AbstractExternalTrigger
		 *	@private
		 *	@return Boolean
		 */
		protected function waitPlayerMove () : Boolean
		{
			var mb:String = getPropertie("_mb");
			if (mb == null) return false;

			// format x/y/z/attendre fin du déplacement
			var tar:Array = mb.split("/");
			// check option attendre fin du déplacement ou pas
			var w:Boolean = tar[3] == 1;
			// le tile à bouger, bob
			var bob:AbstractTile = AbstractTile.getTile("bob");
			// target est une céllule
			var tpoint:UPoint = new UPoint(tar[0], tar[1], tar[2]);
			// on test savoir si le tile est déjà à cette place
			if (!bob.upos.isMatchPos(tpoint))
			{
	//			trace(this, tpoint.posToString(), bob.upos.posToString());
				if (w) {
					// abonnement clique sur scène annule, pour annuler le déplacement
					isosceneHelper.component.addEventListener (MouseEvent.MOUSE_DOWN, onMoveBob);
					// abonnement sur bob pour lancer réelement le trigger
					bob.addEventListener(TileEvent.MOVE_COMPLETE, onMoveBob);
					bob.addEventListener(TileEvent.MOVE_CANCELED, onMoveBob);
				}
				sendEvent(new BaseEvent(EventList.MOVE_TILE, {tile:bob, cellTarget:tpoint}));

			} else { w = false; }

			return w;
	//		sendEvent(new Event(EventList.FREEZE_SCENE));
		}

		/**
		 *	@param event Event
		 */
		protected function complete (event:Event = null) : void
		{
			if (getPropertie("_fs")) {
				sendEvent(new Event(EventList.UNFREEZE_SCENE));
			}

			// Experimental, écriture de variables comme option commune
			var tw:Array = getPropertie("_wv");
			if (tw)
			{
				for each (var o:Object in tw)
					sendEvent(new BaseEvent(EventList.WRITE_ENV, o));
			}

			// Experimental bonus intégrés en options commune
			var bonus:Object = getPropertie("completeBonus");
			if (bonus)
			{
				for (var p:String in bonus)
				{
					lastBonus.theme = bonusMap[p];
					lastBonus.bonus = bonus[p];
					sendEvent(new BaseEvent(EventList.ADD_BONUS, lastBonus));
				}
			}

			sendEvent(new TriggerEvent(TriggerEvent.COMPLETE, this));
		}

		protected static var lastBonus:Object = {theme:null, bonus:null};
		protected static var bonusMap:Object = {plev:0, ppir:1, psoc:2, peco:3, penv:4};

		protected function onDiffer () : void
		{
			trace(".onDiffer() should be implemented in your subClass@" + toString());
		}

		private function _execute () : void
		{
			if (_canceled) return;

			// on regarde si il faut freezer les interactions souris dans
			// la scène
			if (getPropertie("_fs")) {
				sendEvent(new Event(EventList.FREEZE_SCENE));
			}

			// on regarde si il faut stopper bob
			if (getPropertie("_sb"))
			{
				var bob:AbstractTile = AbstractTile.getTile("bob");
				bob.removeEventListener(TileEvent.MOVE_COMPLETE, onMoveBob);
				bob.stop(true);
			}

			sendEvent(new TriggerEvent(TriggerEvent.EXECUTE, this));
			execute();
		}
		
	}
	
}
