package ddgame.client.triggers {
	
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.events.BaseEvent;
	import com.sos21.tileengine.events.TileEvent;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.proxy.*;
	import ddgame.client.view.*;
	import ddgame.client.events.EventList;
	import ddgame.sound.SoundTrack;
	import ddgame.sound.AudioHelper;	
	
	/**
	 *	Action d'un tile, bouger, animer, afficher / masquer...
	 * 
	 * 	act: 
    *     -
    *       a: 0 	> action : 	0 cacher
    * 								1 afficher
    * 								2 gotoFrame ?
    *       we: 1 > attendre fin
    *       t: 46 > ID tile cible
    *     -
    *        ...
    * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  30.11.2010
	 */
	public class TileActionTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 106;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var actionIndex:int = -1;
		private var actions:Array;
		private var timer:Timer;
		private var nexec:int = 0;
		
		// ref pour nettoyage
		private var currentTargetListener:Object;
		private var currentTypeListener:String;
		private var soundTrack:SoundTrack;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @private
		 * Refs
		 */
		private function get objectBuilder () : ObjectBuilderProxy
		{ return ObjectBuilderProxy(facade.getProxy(ObjectBuilderProxy.NAME)); }
		
		private function get playerHelper () : PlayerHelper
		{ return PlayerHelper(facade.getObserver(PlayerHelper.NAME)); }
		
		private function getPNJHelper (name:String) : PNJHelper
		{ return PNJHelper(facade.getObserver(name)); }
		
		private function get audioHelper () : AudioHelper
		{ return AudioHelper(facade.getObserver(AudioHelper.NAME)); }
		
		private function get libProxy () : LibProxy
		{ return LibProxy(facade.getProxy(LibProxy.NAME)); }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (e:Event = null) : void
		{
			if (!isPropertie("act"))
			{
				cancel();
				return;
			}
			
			actions = getPropertie("act");
			nextAction();
		}

		/**
		 * @inheritDoc
		 */
		override public function cancel () : void
		{
			removeWaitListener();
			if (timer) timer.stop();
			super.cancel();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Signal son pour action type son
		 *	@param signal String
		 */
		private function onSoundTrackSignal (signal:String) : void
		{
			// La lecture est terminée ou à été arrêtée
			if (signal == "complete" || signal == "stop")
			{
				// Suppression listener
				soundTrack.remove(onSoundTrackSignal);
				// Suppression ref de l'AudioHelper
				audioHelper.removeSoundTrack(soundTrack);
				soundTrack = null;
				nextAction();
			}
		}
		
		/**
		 * Réception timer spécifique au actions son, cas ou un son
		 * est lancé et on attend pas la fin lecture avant de passer à
		 * l'action suivante
		 *	@param event Event
		 */
		private function onSoundTrackTimer (event:Event) : void
		{
			event.target.removeEventListener("timerComplete", onSoundTrackTimer);
			onSoundTrackSignal("stop");
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Execute la prochaine action
		 *	@param event Event
		 */
		protected function nextAction (event:Event = null) : void
		{
			// on enleve le listener si on était sur une action avec
			// attente fin
			if (event) removeWaitListener();
			
			// Le trigger peut être déjà fini dans le cas ou il y ait plusieurs
			// actions définis avec des durées non bloquantes, ces actions n'étaient pas encore
			// finient alors que la pile d'actions à été lue entièrement et que le trigger s'est
			// terminé.
			if (!actions) return;
			
			// check si reste des actions
			actionIndex++;
			if (actionIndex == actions.length)
			{
				var lp:int = getPropertie("lp")
				// check si on à une boucle
				if (lp > 0)
				{
					if (++nexec == lp)
					{
						complete();
						return;						
					}
				}
				// on est en boucle, reset de l'index
				actionIndex = 0;
			}
			
			// prochaine action
			var act:Object = actions[actionIndex];
			
			// recup cible (pas forcé d'en avoir une, voir action 6: jouer un son)
			var target:AbstractTile = AbstractTile.getTile(act.t);
			
			// il faut attendre la fin ?
			if (doAction(target, act)) return;
			else
				nextAction();
		}
		
		/**
		 * Execution une action
		 *	@param target Object
		 *	@param act Object
		 *	@return Boolean
		 */
		private function doAction (target:Object, act:Object) : Boolean
		{
			// option attendre fin
			var wait:Boolean = act.we;

			// action!
			switch (int(act.a))
			{
				// > cacher tile
				case 0 :
					if (!target) return false;
					target.visible = false;
					if (act.d > 0 && !wait)
					{
						setTimer(act.d * 1000);
						wait = true;
					} else { wait = false; }
					break;
				// > afficher tile
				case 1 :
					if (!target) return false;
					target.visible = true;
					if (act.d > 0 && !wait)
					{
						setTimer(act.d * 1000);
						wait = true;
					} else { wait = false; }
					break;
				// téléporter
				case 2 :
					if (!target) return false;
					var pos:Array = act.p.p.split("/");
					if (pos)
					{
						var up:UPoint = objectBuilder.createUPoint(pos[0], pos[1], pos[2]);
						target.umove(up);
						if (act.d > 0 && !wait)
						{
							setTimer(act.d * 1000);
							wait = true;
						} else { wait = false; }
					}
					else
					{
						wait = false;
					}
					break;
				// déplacer
				case 3 :
					if (!target) return false;
					var pos:Array = act.p.p.split("/");
					var up:UPoint = objectBuilder.createUPoint(pos[0], pos[1], pos[2]);
					if (pos && !target.upos.isMatchPos(up))
					{
						// on déplace bob
						if (act.t == "bob")
						{
							sendEvent(new BaseEvent(EventList.MOVE_PLAYER, up));
						}
						// on déplace un pnj
						else if (target.data.pnj)
						{
							var pnj:PNJHelper = getPNJHelper(target.ID);
							if (pnj)
							{
								if (act.s) target.speed = act.s;
								pnj.moveTo(pos[0], pos[1], pos[2]);
							}
						}
						else {
							sendEvent(new BaseEvent(EventList.MOVE_TILE, {tile:target, cellTarget:up}));
						}

						// attente fin déplacement
						if (wait)
						{
							addWaitListener(TileEvent.MOVE_COMPLETE, target);
						}
						else
						{
							if (act.d > 0)
							{
								setTimer(act.d * 1000);
								wait = true;
							}
						}
					}
					else
					{
						wait = false;
					}
					break;
				// faire parler / penser
				case 4 :
					if (!target) return false;
					pnj = act.t == "bob" ? playerHelper : getPNJHelper(target.ID);
					if (pnj)
					{
						var d:int = act.d * 1000;
						var oc:Boolean = !d ? true : false;
						var txt:String = act.p.txt;
						var autoClose:Boolean = true;
						// liens
						if (act.p.l)
						{
							var ls:Array = act.p.l.split("|");
							var pls:Array = [];
							var la:int = ls.shift();
							while (ls.length)
								pls.push("<a href=\"event:trigger:" + ls.shift() + "#autoClose\">" + ls.shift() + "</a>");
							
							txt += "\n";
							txt += la ? pls.join(" ") : pls.join("\n");
							// on à des liens, check si on attend un clique obligatoire
							// sur un de ceux-ci avant de passer à la suite.
							if (getPropertie("_fs") && pls.length > 0) autoClose = false;
						}
						if (act.p.s) {
							pnj.displayThink(txt, d, autoClose, oc, act.p.bw ? act.p.bw : 200);
						}
						else {
							pnj.displayTalk(txt, d, autoClose, oc, act.p.bw ? act.p.bw : 200);
						}

						if (wait)
						{
							if (d > 0) {
								setTimer(d);
							} 
							else {
								// Ok, on est sur un trigger qui freeze la scène et on fait parler un pnj / avatar
								// pour lequel on va avoir un choix de réponses. Logiquement ça voudrait dire que :
								// on veut que le joueur soit obligé de passer par n clique dans un lien du ballon
								// pnj / avatar
								if (!autoClose) addWaitListener(EventList.PNJ_BALLONEVENT, channel);
								else // MOUSE_DOWN, car abonnement sur click est trop rapide est catch le MOUSE_UP
									addWaitListener(MouseEvent.MOUSE_DOWN, stage);
							}
						}
						
					}
					else
					{
						wait = false;
					}
					break;
				// animer
				case 5 :
				{
					if (!target) return false;
					var anims:Array = target.animations;
					if (anims)
					{
						var an:String = act.p.a;
						if (anims.indexOf(an) > -1)
						{
							// rotation du tile
							if (act.p.r) target.rotation = act.p.r;
							// on est sur une animation
							if (!act.p.f)
							{
								var loop:int = act.p.l;
								if (!loop) loop = -1;
								target.gotoAndPlay(an, loop);

								if (wait && loop > 0)
								{
									addWaitListener(TileEvent.PLAY_COMPLETE, target);
								}
								else {
									wait = false;
								}
							}
							// on est sur l'affichage d'une image
							else
							{
								target.gotoAndStop(an);
								target.setFrame(act.p.f);
								if (act.d > 0)
								{
									setTimer(act.d * 1000)
									wait = true;
								}
								else {
									wait = false;
								}
							}
						}
					}
					break;
				}
				// > Jouer un son
				case 6 :
				{
					var sndUrl:String = act.p.sf;

					if (!sndUrl) {
						wait = false;
					}
					else {
						// on test si le son existe dans la banque
						soundTrack = audioHelper.getSound(sndUrl);
						// le son n'est pas dans la banque
						if (!soundTrack)
						{
							// on regarde dans la lib...
							var sound:Sound = libProxy.lib.getContent(sndUrl) as Sound;
							if (sound) {
								soundTrack = audioHelper.addSound(sound, false);
							}
						}

						// On Recheck au cas ou rien n'ai été trouvé dans
						// la lib ou erreur de création du SoundTrack
						if (soundTrack)
						{
							// Lecture !!!
							var loops:int = act.p.lp;
							// Attente sur timer ?
							if (!wait) {
								if (act.d > 0)
								{
									var timer:Timer = new Timer(act.d * 1000, 1);
									timer.addEventListener("timerComplete", onSoundTrackTimer, false, 0, true);
									timer.start();
								}
							}
							// Attente fin de lecture
							else if (loops > 0) {
								soundTrack.add(onSoundTrackSignal);								
							}
							// On évite de bloquer la suite si lecture infini
							// et paramètre attendre fin sur true
							else {
								wait = false;
							}
							soundTrack.play(0, loops);
						}
						else {
							wait = false;
						}
					}
					break;
				}
			}
			
			return wait;
		}
				
		/**
		 * Définit un delai d'attente
		 *	@param delay int
		 */
		private function setTimer (delay:int) : void
		{
			if (!timer)
				timer = new Timer(0, 0);

			addWaitListener("timerComplete", timer);
			timer.delay = delay;
			timer.repeatCount = 1;
			timer.start();
		}
		
		/**
		 * Ajout listener
		 *	@param type String
		 *	@param target Object
		 */
		private function addWaitListener (type:String, target:Object) : void
		{
			currentTargetListener = target;
			currentTypeListener = type;
			target.addEventListener(type, nextAction);
		}

		/**
		 * Suppression listener cible courante
		 *	@private
		 */
		private function removeWaitListener () : void
		{
			if (currentTargetListener)
			{
				currentTargetListener.removeEventListener(currentTypeListener, nextAction);
				currentTargetListener = null;
				currentTypeListener = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function complete (event:Event = null) : void
		{
			actions = null;
			removeWaitListener();
			timer = null;
			super.complete();
		}
		
	}

}