package ddgame.client.view {
	
	import flash.external.ExternalInterface;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.*
	import flash.events.TimerEvent;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import com.sos21.utils.XMLTrip;
	import com.sos21.utils.Delegate;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.TileView;
	import com.sos21.tileengine.display.MCTileView;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.events.TileEvent;
	
	import ddgame.client.events.EventList;
	import ddgame.client.view.IsosceneHelper;
	import ddgame.client.proxy.DatamapProxy;
	import ddgame.client.proxy.LibProxy;
	import ddgame.client.proxy.CollisionGridProxy;
	import gs.TweenLite;
	
	/**
	 *	Class d'aide pour les pnj
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class PNJHelper extends AbstractHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
//		public static const NAME:String = HelperList.PLAYER_HELPER;
		/*public var pnjTest:XML =
		<pnj>
			<triggers>
				<trigger id="1" exec="1">
						<evt type="click">
							<action type="talk"><![CDATA[Tenez, pour vous aider dans vos choix, je vous offre ce <u><a href="monPdf.pdf">calendrier des fruits et légumes de saison</a></u>]]></action>
						</evt>
						<evt type="mouseOver">
							<action type="talk"><![CDATA[Besoin d'un renseignement ?]]></action>
						</evt>
						<evt type="mouseOut">
							<action type="silent" />
							<evt pnjTrip="true" />
							<evt type="jumpInTrip" target="restart" />
						</evt>
				</trigger>
			</triggers>
			<trip>
				<group exec="1" delay="1000">
					<action type="play" label="stand" rotation="0" />
					<action type="talk" duration="8000" ><![CDATA[Bonjour ! La boutique est en libre service mais contactez-moi si besoin]]></action>
				</group>
				<group delay="9000">
					<action type="moveTo" x="20" y="13" z="0" />
					<action rotation="270" />
					<action type="think" delay="500"><![CDATA[ils sont beaux ces ananas, mais est-ce bien la saison ?]]></action>
					<action type="play" label="gratteTete" />
					<action type="silent" delay="7000" />
				</group>
				<group>
					<action type="moveTo" x="18" y="8" z="0" />
					<action rotation="270" />
					<action type="think" duration="6000" delay="500"><![CDATA[Les pommes de terre de ce producteur local sont délicieuses. Je vais en commander de nouveau.]]></action>
					<action type="play" label="writeNote" loop="1" delay="3000"/>
				</group>
				<group id="restart" delay="3000">
					<action type="moveTo" x="13" y="11" z="0" />
					<action rotation="0" />
					<rand>
						<action type="think" duration="6000"><![CDATA[tralali..]]></action>
						<action type="think" duration="6000"><![CDATA[pom pom pom pom, pom pom pom pom...]]></action>
						<action type="think" duration="6000"><![CDATA[y'avait des gros crocodiles et des orangs outan...]]></action>
					</rand>
				</group>
			</trip>
		</pnj>;*/

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function PNJHelper(sname:String, oComponent:Object = null, iaData:Object = null)
		{
			super(sname, oComponent);
			
			if (iaData)
				this.iaData = iaData;
			//_iaData = pnjTest;
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var ballon:MovieClip;				// instance du ballon paroles / pensées
		public var ballonStyleSheet:StyleSheet;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _skin:Object;
		protected var ballonTimer:Timer;			// timer durée affichage du ballon

		protected var tripTimer:Timer;			// 
		protected var triggerTimer:Timer;			// 
		protected var _tripNode:XML;				// noeud actuel du pnj trip
		protected var _tripIndex:int;				// index noeud enfant trip en cours
		protected var _triggerNode:XML;			// noeud actuel des triggers
		protected var _triggerIndex:int;			// index noeud trigger en cours
		protected var _currentTrigger:XML		// noeud trigger en cours (pour nettoyage listeners)
		protected var _pnjTrip:Boolean;			
		
		protected var _iaData:Object;				// data pour l'ia "parcours autonome" + triggers
		protected var _tripTimer:Timer;			// timer durées d'activitée d'un event (partie pnj trip)
		protected var _xmlTrip:XMLTrip;			// lecteur du xml partie pnj trip
		protected var _triggerXxmlTrip:XMLTrip // lecteur du xml partie triggers
		protected var _triggerTimer:Timer;		// timer durées d'activitée d'un event (partie triggers)
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var triggersLocked:Boolean	// activation désactivation des triggers
		public var tripLocked:Boolean			// activation désactivation du pnj trip
		public var isosceneHelper:IsosceneHelper
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne le composant casté
		 */
		public function get component () : AbstractTile
		{ 
			return AbstractTile(_component);
		}
		
		/**
		 *	Définit les data poir l'ia (parcours autonome & interactions)
		 */
		public function set iaData (data:Object) : void
		{
			// inetractions
			if (data.triggers.children().length() > 0)
			{
				_triggerTimer = new Timer(0, 1);
				_triggerXxmlTrip = new XMLTrip();
			}
			// pnj trip
			if (data.trip.children().length() > 0)
			{
				_tripTimer = new Timer(0, 1);
				_xmlTrip = new XMLTrip(data.trip[0]);
				_xmlTrip.addEventListener(XMLTrip.STEP, xmlTripHandler, false, 0, true);
			}
			
			// TODO, voir si on peut se passer du pointeur, vu
			// que l'on stock dans _xmlTrip & _triggerXxmlTrip
			_iaData = data;
		}
		
		/**
		 * Retourne l'instance "intelligence artificielle" de cette instance
		 */
		public function get ai () : Object
		{
			return _xmlTrip;
		}
		
		/**
		 *	Démarre / arrête l'ia du pnj
		 *	@param	val	 true pour démarrer / false pour arrêter
		 */
		public function set autoLife(val:Boolean):void
		{
			if (!_iaData) return;

			var isrunning:Boolean = _xmlTrip.running;
			if (val)
			{
				if (component.isPaused)
				{
					component.resume();
				} else if (!isrunning) {
					_xmlTrip.start();
				}				
			} else {
				// le pnj est en déplacement, _xmlTrip est stoppé 
				if (component.isMoving)
				{
					component.pause();
					component.gotoAndStop("stand");
				} else if (isrunning) {
					_xmlTrip.stop();
				}
			}
		}
		
		/**
		 *	Retourne le proxy datamap
		 */
		public function get dataMapProxy():DatamapProxy
		{
			return DatamapProxy(facade.getProxy( DatamapProxy.NAME));
		}
		
		/**
		 *	Retourne le proxy librairie
		 */
		public function get libProxy():LibProxy
		{
			return LibProxy(facade.getProxy(LibProxy.NAME));
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Déplace le pnj jusqu'au coordonnée
		 */
		public function moveTo(dx:int, dy:int, dz:int, callBack:Function = null) : Boolean
		{
			var cP:CollisionGridProxy = CollisionGridProxy(facade.getProxy(CollisionGridProxy.NAME));
			var cellTarget:UPoint = new UPoint(dx, dy, dz);
			var path:Array = cP.findPath(component.upos, cellTarget);
			if(path.length > 1)
			{
				component.pathTo(path);
				if (callBack) {
					component.addEventListener(TileEvent.MOVE_COMPLETE, callBack);
				}
				return true;
			}
			return false;
		}
		
		/**
		 *	Affiche un ballon de pensées.
		 *	le ballon suit le pnj si celui-ci se déplace
		 *	@param	text	 le texte à afficher dans la ballon
		 *	@param	duration	 durée d'affichage du ballon en millisecondes
		 */
		public function displayThink(	text:String, duration:int = 10000, stopAutoLife:Boolean = false,
												autoClose:Boolean = false, bwidth:int = 200	):MovieClip
		{
			// on supprime si un ballon déjà affiché
			removeBallon();
			// on crée le nouveau ballon
			createBallon("BallonThinkPopup", duration, stopAutoLife, autoClose, bwidth).text = text;	
			TweenLite.from(ballon, 1, {alpha:0});
			return ballon;
		}
		
		/**
		 *	Affiche un ballon de paroles
		 *	le ballon suit le pnj si celui-ci se déplace
		 *	@param	text	 le texte à afficher dans le ballon
		 *	@param	duration	 la durée d'affichage du ballon 0 = infini
		 */
		public function displayTalk(	text:String, duration:int = 0, stopAutoLife:Boolean = false,
												autoClose:Boolean = false, bwidth:int = 200	):MovieClip
		{
			// on supprime si un ballon déjà affiché
			removeBallon();
			// on crée le nouveau ballon
			createBallon("BallonPopup", duration, stopAutoLife, autoClose, bwidth).text = text;
			ballon.removeChild(ballon.closeButton);
			TweenLite.from(ballon, 1, {alpha:0});
			return ballon;
		}
		
		/**
		 *	Crée un ballon
		 *	@param	skin	 reference à la classe skin
		 *	@param	width	 largeur du ballon
		 *	@param	duration	 durée d'affichage du ballon
		 */
		public function createBallon(	skin:String, duration:int, stopAutoLife:Boolean, autoClose:Boolean, bwidth:int = 200 ):MovieClip
		{
			var classRef:Class = libProxy.getDefinitionFrom("lib/HtmlPopup.swf", skin);
			ballon = new classRef();
			stage.addChild(ballon);
			ballon.width = bwidth;			
			var spos:Object = component.stagePosition;
			var bd:Object = component.getBounds(stage);
			ballon.x = spos.x;
//			ballon.y = spos.y - (component.height / 2);
			ballon.y = bd.top + (component.height / 8);
			ballon.htmlContent.addEventListener(TextEvent.LINK, ballonEventHandler, false, 0, true);
			
			ballon.htmlContent.styleSheet = ballonStyleSheet;
			
			// suivit du pnj
			component.addEventListener(TileEvent.MOVE, componentHandler, false, 0, true);
			if (duration > 0)
			{
				ballonTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ballonEventHandler, false, 0, true);
				ballonTimer.delay = duration;
				ballonTimer.start();
			}
			
			ballon.data = { stopAutoLife:stopAutoLife, autoClose:autoClose };
			if (stopAutoLife)  autoLife = false;
			if (autoClose) isosceneHelper.component.addEventListener(MouseEvent.MOUSE_DOWN, ballonEventHandler, false, 0, true);

			return ballon;
		}
		public var ttest:int = 1;
		/**
		 *	Supprime le ballon
		 */
		public function removeBallon():void
		{			
			if (ballon)
			{
				ballonTimer.stop();
				ballonTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, ballonEventHandler, false);
				ballon.htmlContent.removeEventListener(TextEvent.LINK, ballonEventHandler, false);
				component.removeEventListener(TileEvent.MOVE, componentHandler, false);
				isosceneHelper.component.removeEventListener(MouseEvent.MOUSE_DOWN, ballonEventHandler, false);
				try {
					stage.removeChild(ballon);
				} catch (e:Error) { }
				
				var restartLife:Boolean = ballon.data.stopAutoLife;
				ballon = null;
				if (restartLife) autoLife = true;
			}
		}
		
		public function injectDataInLife (data:Object) : void
		{
			_xmlTrip.injectData(data);
		}
		
		public function jumpInLife (id:String) : Boolean
		{
			if (_xmlTrip.jumpToByAttribute(id))
			{
				if (component.isMoving)
				{
					component.stop();
					_xmlTrip.start();
				}
				return true;
			}
			return false;
		}
		
		public function nextInLife () : void
		{
			_xmlTrip.nextStep();
		}
		
		/**
		 *	Met en place un trigger (depuis la liste dans _iaData.triggers)
		 *	@param	id	 identifiant de trigger
		 */
		public function initTrigger(triggerId:String):void
		{
			// un trigger est déjà en place
			if (_currentTrigger)
				removeTriggersListener(_currentTrigger);
			
			// on retrouve le trigger
			var triggers:XMLList = _iaData.triggers.trigger.(@id == triggerId);
			var cnode:XML;
			if (triggers.length() > 0)
			{
				cnode = triggers[0];
				_currentTrigger = cnode;
				addTriggersListener(_currentTrigger);	
			}
		}
		
		/**
		 *	Relache le trigger en cours  (depuis la liste dans _iaData.triggers)
		 */
		public function releaseCurrentTrigger():void
		{
			if (_currentTrigger)
			{
				removeTriggersListener(_currentTrigger);
				_currentTrigger = null;
			}
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
				
		/**
		 *	@private
		 *	Réception des events du ballon
		 */
		protected function ballonEventHandler(event:Event):void
		{
			switch (true)
			{
				case event is MouseEvent :
				{
					if (ballon)
					{
						// on test si ballon est en fermeture auto
						if (ballon.data.autoClose)
						{
							// test si clique est hors du ballon
							if (!ballon.contains(DisplayObject(event.target)))
								removeBallon();
						}
					}
					break;
				}
				case event is TextEvent : // > clique sur lien dans le ballon
				{
					// hook pour empêcher execution du lien texte complet
					var evt:BaseEvent = new BaseEvent(EventList.PNJ_BALLONEVENT, {target:this, kind:event.type, event:event}, false, true);
					sendEvent(evt);
					
					if (!evt.isDefaultPrevented())
					{
						// format du lien > event:trigger:slid:23#autoClose
						var link:String = TextEvent(event).text
						// liste des options du lien
						var tList:Array = link.split("#");
						// liste des arguments pour chaque option
						var tArgs:Array;						
						// event dispatché pendant la phase de "parsing" juste avant d'effectuer chaque action
						var subEvt:BaseEvent;

						var l1:int = tList.length;
						if (l1 > 0)
						{
							for (var i:int = 0; i < l1; i++)
							{
								tArgs = tList[i].split(":");
								switch (tArgs[0])
								{
									case "trigger" : // > on est sur le lancement d'un trigger
									{
										if (tArgs[1] == "slid")
										{ // on est sur un lien symbolique vers un trigger											
											var triggerId:int = tArgs[2];
											// hook pour empêcher le lancement du trigger
											subEvt = new BaseEvent(EventList.PNJ_BALLONEVENT, {target:this, kind:EventList.LAUNCH_TRIGGER, triggerId:triggerId});
											sendEvent(subEvt);
											if (!subEvt.isDefaultPrevented())
												sendEvent(new BaseEvent(EventList.LAUNCH_TRIGGER, {id:triggerId}));
										}
										else
										{ // on à un encodage trigger
											// TODO
										}
										break;
									}
									case "autoClose" : // > on est sur option fermeture auto du ballon
									{
										// hook pour empêcher la fermeture du ballon
										subEvt = new BaseEvent(EventList.PNJ_BALLONEVENT, {target:this, kind:"closeBallon"});
										sendEvent(subEvt);
										if (!subEvt.isDefaultPrevented())
											removeBallon();
										break
									}
									case "jumpInTrip" : // > on est sur un saut dans le xmlTrip
									{
										var nodeId:String = tArgs[1];
										trace(this, "jumpInTrip", nodeId);
										subEvt = new BaseEvent(EventList.PNJ_BALLONEVENT, {target:this, kind:"jumpInTrip", nodeId:nodeId});
										sendEvent(subEvt);
										if (!subEvt.isDefaultPrevented())							
											jumpInLife(nodeId);
										break;
									}
								}
							}
						}
					}
					break;
				}
				case event is TimerEvent :
				{
					removeBallon();
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception des events du composant
		 *	suivit du ballon pendant déplacement
		 */
		protected function componentHandler(event:TileEvent):void
		{
			if (ballon)
			{
				var spos:Object = component.stagePosition;
				ballon.x = spos.x;
				ballon.y = spos.y - (component.height / 2);
			}
		}
		
		/**
		 *	@private
		 *	Réception des events du timer de contrôle des étapes
		 *	du pnj trip
		 */
		protected function tripHandler(event:Event):void
		{
			if (tripLocked) return;
	
			if (event is TimerEvent)
			{	
				// > on est sur un event timer
				
				// on test si on est sur un noeud evt qui arrive en fin
				// de son temps d'activation
				if (_tripNode.name() == "evt")
				{
					// on supprime le listener du tile qui devait déclencher
					var tId:String = _tripNode.@target; // identifiant du tile écouté ?
					var target:AbstractTile = tId.length ? AbstractTile.getTile(_tripNode.@target) : component;
					target.removeEventListener(_tripNode.@type, tripHandler, false);
					// on passe au noeud d'après l'evt
					_tripIndex = _tripNode.childIndex() + 1;
					_tripNode = _tripNode.parent();
					nextInTrip();
					
					return;
				}
			} else {
				// > on est sur un event provenant d'un tile (pnj inclus)
				
				var etype:String = event.type;
				if (etype == "enterCell" || etype == "leaveCell")
				{				
					var cell:Array = _tripNode.@cell.split("/");
					var p:UPoint = new UPoint(cell[0], cell[1], cell[2]);
					if (!p.isMatchPos(TileEvent(event).getCell()))
					{
						return;
					}
				}
				
				// on supprime le listener
				event.target.removeEventListener(event.type, tripHandler, false);
				
				if (event is TileEvent)
				{
					nextInTrip();
					return;
				}
			}
			
			// on récup l'action à éxécuter
			var actNode:XML = _tripNode.children()[_tripIndex];
			
			// on lance l'exec
			executeAction(actNode);

			// on incrémente pour l'action suivante
			++_tripIndex;

			// si l'action est un deplacement, on attend la fin de celui-ci pour mettre en
			// place l'action suivante
			if (actNode.@type == "moveTo")
			{
				component.addEventListener(TileEvent.MOVE_COMPLETE, tripHandler, false, 0, true);
			} else {
				nextInTrip();
			}
		}
		
		/**
		 *	@private
		 *	Réception des events depuis les triggers
		 */
		protected function triggersHandler(event:Event):void
		{			
			if (triggersLocked) return;
			
			if (event is TimerEvent)
			{
				// on récup l'action à éxécuter
				var actNode:XML = _triggerNode.children()[_triggerIndex];
				
				// on est sur un noeud evt
				if (actNode.name() == "evt")
				{
					// on test le deux possibilités pour ces noeuds (dans la partie triggers)
					// <evt type="complete" (pnjTrip="true/false") />
					var iscomp:Boolean = actNode.@type == "complete" ;

					var ispt:String = actNode.@pnjTrip;
					if (iscomp)
					{
						if (ispt.length > 0)
						{
							autoLife = Boolean(ispt);
						} else {
							// par defaut autolife revien à true quand pnjTrip n'est pas mentionné
							autoLife = true;
						}
						trace("trigger is complete");
						releaseCurrentTrigger();
						return;
					}

					// <evt pnjTrip="true/false" />
					if (ispt.length > 0)
					{
						// on passe à l'action suivante
						_triggerIndex++;
						nextInTriggers();
						trace("------------------------------------------");
						autoLife = Boolean(ispt);
						trace("evt node - autoLife " + Boolean(ispt));
						trace("------------------------------------------");
					}

					return;
				}
				
				// on lance l'exec
				executeAction(actNode);
				// on incrémente pour l'action suivante
				++_triggerIndex;
				
			} else {
				// on recup le trigger
				_triggerNode = _currentTrigger.children().(@type == event.type)[0];
				trace(_triggerNode.toXMLString());
				var trEvent:BaseEvent = new BaseEvent(EventList.PNJ_FIRETRIGGER, { target:this, data:_triggerNode });
				sendEvent(trEvent);
			
				if (trEvent.isDefaultPrevented())
				{
					return;
				}
				
				trace("----- triggersHandler -------");
				var al:String = _triggerNode.@pnjTrip;
				autoLife = al.length > 0 ? Boolean(al) : false;
				trace("autoLife " + (al.length > 0 ? Boolean(al) : false));
				trace("");				
				_triggerIndex = 0;				
			}
			
			nextInTriggers();
		}
		
		/**
		 * Default Event handler
		 */
		override public function handleEvent(event:Event):void
		{
			switch (event.type)
			{
				case EventList.CLEAR_MAP :
				{
					if (ballon)
					{
						ballon.data.stopAutoLife = false;
						removeBallon();
					}					
					autoLife = false;
					_xmlTrip.stop();
					_xmlTrip = null;
					_component = null;
					facade.unregisterObserver(this.name);
					break;
				}
				default : { break; }
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Reception des events du composant (Abstractile)
		 *	Gestion de l'ia
		 */
		protected function nextInTrip():void
		{
			var actions:XMLList = _tripNode.*;
			var cnode:XML;
			if (actions.length() - 1 >= _tripIndex)
			{
				// une action à la suite
				cnode = actions[_tripIndex];
				
				// test si le noeud est à supprimer
				var nexec:int = cnode.@exec;
				if (nexec > 0)
				{
					if (nexec == cnode.@count)
					{
//trace("delete: ", cnode.toXMLString());
						delete actions[_tripIndex];
						nextInTrip();
						return;
					}
				}
			} else {
				if (_tripNode.name() != "trip")
				{
					// il faut remonter d'un niveau
					_tripIndex = _tripNode.childIndex() + 1;
					_tripNode = _tripNode.parent();
					nextInTrip();
					return;
				} else {
					if (actions.length() > 0)
					{
						// on repart de 0 depuis le root
						_tripIndex = 0;
						nextInTrip();
						return;
					} else {
						// plus d'actions en root, on arrête autoLife
						autoLife = false;
						return;
					}
				}
			}

			// on incrémente le nombre d'éxecutions de l'action
			cnode.@count = int(cnode.@count) + 1;

			// on est sur un noeud group
			/*if (cnode.children().length() > 0)
			{

			}*/

			// on est sur un noeud evt ?
			if (cnode.name() == "evt")
			{
				if (cnode.@type == "trigger")
				{
					// on est sur un raccourci trigger
					initTrigger(cnode.@id);
					_tripIndex++;
					nextInTrip();
					return;
				}

				var targetId:String = cnode.@target; // identifiant du tile à écouter
				var dispatcher:AbstractTile = targetId.length ? AbstractTile.getTile(cnode.@target) : component;
				// écoute
				dispatcher.addEventListener(cnode.@type, tripHandler, false, 0, true);
				_tripNode = cnode;
				_tripIndex = 0;
				// le trigger à une durée d'activation ?
				var duration:int = cnode.@duration;
				if (duration > 10)
				{
					tripTimer.stop();
					tripTimer.delay = duration;
					tripTimer.start();
				}
			} else {
				var delay:int = cnode.@delay;
				tripTimer.stop();
				tripTimer.delay = delay > 0 ? delay : 1;
				tripTimer.start();
			}	
		}
		
		/**
		 *	@private
		 *	Passe à l'action suivante dans les evt triggers
		 */
		protected function nextInTriggers () : void
		{
			var actions:XMLList = _triggerNode.*;
			var cnode:XML;
			if (actions.length() - 1 >= _triggerIndex)
			{
				// une action à la suite
				cnode = actions[_triggerIndex];
//	trace("node: ", cnode.toXMLString());
				// test si le noeud est à supprimer
				var nexec:int = cnode.@exec;
				if (nexec > 0)
				{
					if (nexec == cnode.@count)
					{
//trace("delete: ", cnode.toXMLString());
						delete actions[_triggerIndex];
						nextInTriggers();
						return;
					}
				}
			} else {
				return;
			}

			// on incrémente le nombre d'éxecutions de l'action
			cnode.@count = int(cnode.@count) + 1;
			
			var delay:int = cnode.@delay;
			triggerTimer.stop();
			triggerTimer.delay = delay > 0 ? delay : 1;
			triggerTimer.start();

		}
		
		/**
		 *	@private
		 *	Met en place les écouteurs d'un noeud trigger
		 */
		protected function addTriggersListener(tnode:XML):void
		{
			var evtList:XMLList = tnode.children().(@type != "");
			var len:int = evtList.length();

			if (len == 0) return;

			var enode:XML;
			while(--len > -1)
			{
				enode = evtList[len];
				var targetId:String = enode.@target; // identifiant du tile à écouter
				var dispatcher:AbstractTile = targetId.length ? AbstractTile.getTile(enode.@target) : component;

				// écoute
				dispatcher.addEventListener(enode.@type, triggersHandler, false, 0, true);
			}
			// le trigger à une durée d'activitée ?
			var duration:int = tnode.@duration;
			if (duration > 10)
			{
				_triggerTimer.reset();
				_triggerTimer.delay = duration;
				_triggerTimer.addEventListener(TimerEvent.TIMER, triggersHandler, false, 0, true);
				_triggerTimer.start();
			}
			
//			triggerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, triggersHandler, false, 0, true);
		}
		
		/**
		 *	@private
		 *Supprime les écouteurs d'un noeud trigger
		 */
		protected function removeTriggersListener(tnode:XML):void
		{
			var evtList:XMLList = tnode.children().(@type != "");
			var len:int = evtList.length();
			
			if (len == 0) return;
			
			var enode:XML;
			while(--len > -1)
			{
				enode = evtList[len];
				var targetId:String = enode.@target; // identifiant du tile à écouter
				var dispatcher:AbstractTile = targetId.length ? AbstractTile.getTile(enode.@target) : component;

				dispatcher.removeEventListener(enode.@type, triggersHandler, false);
			}
			if (_triggerTimer.running)
			{
				
			}
			triggerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, triggersHandler, false);
		}
		
		protected function executeAction (cnode:XML) : void
		{				
			// test action sur target
			var actionTarget:AbstractTile = cnode.attribute("tileTarget").length() > 0 ? AbstractTile.getTile(cnode.@tileTarget) : component;
			
			// check rotation
			if (cnode.attribute("rotation").length() > 0)
				actionTarget.rotation = int(cnode.@rotation);
			
			var atype:String = cnode.@type;
			switch (atype)
			{
				case "think" :
				{
					var sal:Boolean = cnode.@stopPnjTrip == "true";
					var acl:Boolean = cnode.@autoClose == "true";
					displayTalk(cnode, cnode.@duration ? cnode.@duration : 10000, sal, acl, cnode.attribute("ballonw").length() > 0 ? int(cnode.@ballonw) : 200);
					break;
				}
				case "talk" :
				{
					sal = cnode.@stopPnjTrip == "true";
					acl = cnode.@autoClose == "true";
					displayTalk(cnode, cnode.@duration ? cnode.@duration : 0, sal, acl, cnode.attribute("ballonw").length() > 0 ? int(cnode.@ballonw) : 200);
					break;
				}
				case "play" :
				{
					var aloop:int = cnode.@loop;

					/*if (cnode.attribute("rotation"))
						actionTarget.rotation = int(cnode.@rotation);*/

					actionTarget.gotoAndPlay(cnode.@label, aloop > 0 ? aloop : -1);
					break;
				}
				case "draw" :
				{
					actionTarget.gotoAndStop(cnode.@label);
					if (cnode.@frame.length > 0)
						actionTarget.setFrame(int(cnode.@frame));
					
					/*if (cnode.attribute("rotation").length() > 0)
											actionTarget.rotation = int(cnode.@rotation);*/

					break;
				}
				case "teleport" :
				{
					actionTarget.umove(new UPoint(cnode.@x, cnode.@y, cnode.@z));
					break;
				}
				case "silent" :
				{
					removeBallon();
					break;
				}
				default :
				{
					/*if (cnode.attribute("rotation").length() > 0)
										actionTarget.rotation = int(cnode.@rotation);*/

					break;
				}
			}
		}
		
		protected function addComponentToScene ():void
		{
			// --> Patch pour scale du pnj
			var factor:Number = dataMapProxy.avatarFactor;
			var tview:MovieClip = MCTileView(component.getView()).asset;
			tview.scaleX = tview.scaleY = factor;
			tview.y = dataMapProxy.tileh / 2;
			
			// ajout du tile dans la scène
			IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).addAvatar(component);
			component.mouseEnabled = true;
			component.buttonMode = true;
		}
		
		protected function defaultInit ():void
		{
			// ref isoscene
			isosceneHelper = IsosceneHelper(facade.getObserver(IsosceneHelper.NAME));
			// ballon
			ballonTimer = new Timer(0, 1);
			// styleSheet du ballon
			ballonStyleSheet = new StyleSheet();

			var hover:Object = new Object();
			hover.fontWeight = "bold";
			hover.color = "#00FF00";

			var link:Object = new Object();
			link.fontWeight = "bold";
			link.textDecoration= "underline";
			link.color = "#555555";

			var active:Object = new Object();
			active.fontWeight = "bold";
			active.color = "#FF0000";

			var visited:Object = new Object();
			visited.fontWeight = "bold";
			visited.color = "#cc0099";
			visited.textDecoration= "underline";

			ballonStyleSheet.setStyle("a:link", link);
			ballonStyleSheet.setStyle("a:hover", hover);
			ballonStyleSheet.setStyle("a:active", active);
			ballonStyleSheet.setStyle(".visited", visited);
		}
		
		/**
		 *	@inheritDoc
		 * Initialise le pnj (Abstractile) et
		 *	l'ajoute à la scène
		 */
		override public function initialize():void
		{
			defaultInit();	
			addComponentToScene();
		}
		
		
		private function xmlTripHandler (event:Event) : void
		{
			if (event.target == _xmlTrip)
			{
// trace(this, event.target.currentStep.toXMLString(), "\n");
				// recup noeud en cours
				var nod:XML = event.target.currentStep;

				var trEvent:BaseEvent = new BaseEvent(EventList.PNJ_FIRETRIGGER, { target:this, data:nod });
				sendEvent(trEvent);
				if (trEvent.isDefaultPrevented())
					return;

				var nname:String = nod.name();
				var ntype:String = nod.@type;
				
				var tostride:Boolean = false;
				if (nname == "rand") // > on est sur un noeud aléatoire
				{
					var rand:int = Math.random() * nod.children().length();
					nod = nod.children()[rand];
					nname = nod.name();
					ntype = nod.@type;
					if (ntype != "jumpInTrip") tostride = true;
				}
	
				// on switch sur le nom du noeud
				switch (nname)
				{
					case "evt" : 	// -> on est sur un event enterCell / leaveCell, click, mouseOver... ou raccourci vers un trigger
					{
						if (ntype == "trigger")
						{
							// -> on est sur un raccourci trigger
							initTrigger(nod.@id);		
						} else if (ntype == "jumpInTrip") {
							if (nod.attribute("pnjTarget").length() > 0)
							{
								var tpnj:PNJHelper = facade.getObserver(nod.@pnjTarget) as PNJHelper;
								tpnj.jumpInLife(nod.@target);
							} else {
								_xmlTrip.jumpToByAttribute(nod.@target);
							}
						} else if (ntype == "stopTrip") {
							_xmlTrip.stop();
						} else {
							// on mets en place l'écouteur
							var targetId:String = nod.@target;	// identifiant du tile à écouter
							// si pas d'id target, on écoute sur le composanr pnj
							var dispatcher:AbstractTile = targetId.length > 1 ? AbstractTile.getTile(targetId) : component;
							dispatcher.addEventListener(ntype, targetsHandler, false, 50, true);
							// l'evt à un type d'anulation
							if (nod.attribute("cancelType").length() > 0)
							{
								dispatcher.addEventListener(nod.@cancelType, targetsHandler, false, 50, true);
							}
							
							// l'evt à une durée d'activation ?
							var duration:int = nod.@duration;
							// on est dans le pnj trip, les evt stopent la lecture du xml
							_xmlTrip.stop();
							if (duration > 10)
							{
								_tripTimer.reset();
								_tripTimer.delay = duration;
								_tripTimer.addEventListener(TimerEvent.TIMER, targetsHandler, false, 0, true);
								_tripTimer.start();
							}
						}
						break;
					}
					case "hidden" :
					{
						// noeud caché, on enjambe
						_xmlTrip.strideOver();
						break;
					}
					case "action" : 	// > on est sur un noeud action (play, talk, moveTo)
					{
						// on est sur un deplacement du pnj
						if (ntype == 'moveTo')
						{
							// test sur target différent
							var actionTarget:AbstractTile;
							var targ:String = nod.@tileTarget;
							if (targ.length > 1) {
								actionTarget = AbstractTile.getTile(nod.@tileTarget);
							} else {
								actionTarget = component;
							}
							
							var cP:CollisionGridProxy = CollisionGridProxy(facade.getProxy(CollisionGridProxy.NAME));
							var cellTarget:UPoint = new UPoint(nod.@x, nod.@y, nod.@z);
							var path:Array = cP.findPath(actionTarget.upos, cellTarget);
							if (path.length > 1)
							{
								// il faut attendre la fin pour lancer la lecture du prochain noeud
								if (nod.attribute("waitEnd").length() == 0) {
									_xmlTrip.stop();
									actionTarget.addEventListener(TileEvent.MOVE_COMPLETE, targetsHandler, false, 0, true);
								}
								actionTarget.pathTo(path);
							}		
						} else {
							// sinon on execute l'action sans arrêter la lecture du xml
							executeAction(nod);
						}
						break;
					}
					default :
					{
						// pas de moeud connu, on passe à la suite
//						_xmlTrip.nextStep();
						break;
					}
				}
				if (tostride) _xmlTrip.strideOver();
				return;
			}
			
			
		}
		
		protected function targetsHandler(event:Event):void
		{
			// patch empêchement déplacement player
			if (event.type == MouseEvent.CLICK)
			{
				// event.preventDefault(); marche pas :(
				// TODO pas glop, pas le choix...
				event.stopImmediatePropagation();
			}
				
			var dispatcher:Object = event.target;
			var nod:XML = _xmlTrip.currentStep;
			
			if (event is TimerEvent)	// > on arrive à la fin du délai d'activité d'un evt
			{
				// stop du timer
				_tripTimer.stop();
				_tripTimer.removeEventListener(TimerEvent.TIMER, targetsHandler, false);
				
				// on supprime l'écouteur en place
				
				var targetId:String = nod.@target;
				dispatcher = targetId.length ? AbstractTile.getTile(targetId) : component;
				dispatcher.removeEventListener(nod.@type, targetsHandler, false);
				// l'evt à un type d'anulation
				if (nod.attribute("cancelType").length() > 0)
				{
					dispatcher.removeEventListener(nod.@cancelType, targetsHandler, false);
				}				
				
				// on rédémarre la lecture
				_xmlTrip.strideOver();
				_xmlTrip.start();
				return;
			}
			else if (event is TileEvent)
			{
				// > on attendait l'entrée sortie d'une céllule
				if (event.type == TileEvent.ENTER_CELL || event.type == TileEvent.LEAVE_CELL)
				{
					// on test si c'est la bonne
					var cell:Array = _xmlTrip.currentStep.@cell.split("/");
					var p:UPoint = new UPoint(cell[0], cell[1], cell[2]);
					if (!p.isMatchPos(TileEvent(event).getCell()))
					{
						return;
					}
				}
			}
			
			// > par défaut
			// stop du timer si il y à une durée d'activité sur l'evt
			if (_tripTimer.running)
			{
				_tripTimer.stop();
				_tripTimer.removeEventListener(TimerEvent.TIMER, targetsHandler, false);
			}
			
			// on supprime l'écouteur (cas TileEvent.MOVE_COMPLETE, enterCell, leave, click...)

			// l'evt à un type d'anulation
			if (nod.attribute("cancelType").length() > 0)
			{
				dispatcher.removeEventListener(nod.@cancelType, targetsHandler, false);
				dispatcher.removeEventListener(nod.@type, targetsHandler, false);			
				if (event.type == nod.@cancelType) {
					_xmlTrip.strideOver();
				}
			} else {
				// on supprime l'écouteur (cas TileEvent.MOVE_COMPLETE, enterCell, leave, click...)
				dispatcher.removeEventListener(event.type, targetsHandler, false);
			}
			
			// on rédémarre la lecture
			_xmlTrip.start();
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function listInterest():Array /* of Constant */
		{
			return [ EventList.CLEAR_MAP ];
		}

	}
	
}