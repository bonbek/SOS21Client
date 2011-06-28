package ddgame.triggers {
	
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.events.TileEvent;
	import com.sos21.tileengine.structures.UPoint;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.triggers.AbstractExternalTrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;

	import m60.ItemArdoiseAchats;
	import ddgame.proxy.ProxyList;
	import com.sos21.observer.IObserver;
	import ddgame.helper.HelperList;

	/**
	 * Trigger map id 60 (commerce boucherie/cremerie)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m60 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m60():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m60.xml"));
		}
		
//		public static const CLASS_ID:int = 10;
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjBoucherie:Object;					// pnj vendeur primeur
		public var pnjCremerie:Object;					// pnj vendeur vetements
		public var boucherieStandBye:Boolean = false;
		public var playerHelper:Object;
		public var isoSceneHelper:Object;
//		protected var timerpnjLife:Timer = new Timer(0, 1);
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		protected var boucherieData:XML;	// data xml primeur
		protected var cremerieData:XML;		// data xml vêtements
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	Retourne true si le le joeur est dans le partie
		 *	commerce primeur
		 */		
		public function get playerInBoucherie():Boolean
		{
			return playerHelper.component.upos.xu < 17;
		}
		
		/**
		 *	Retourne true si le le joeur est dans le partie
		 *	commerce vêtements
		 */
		public function get playerInVeti():Boolean
		{
			return playerHelper.component.upos.yu > 17;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		/**
		 *	@inheritDoc
		 *	
		 */
		override public function execute(event:Event = null):void
		{
			// on test si les data sont arrviées et si l'init pas encore fait
			if (boucherieData && !stage.contains(this))
				_init();
		}
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Reception des events triggers (achats) partie primeur
		 */
		protected function boucherieTriggerHandler (event:TriggerEvent) : void
		{
			var trigger:ITrigger = event.trigger;
			
			// on test si le trigger est un context menu
			if (trigger.classID != 4) {
				// on test si on est sur le trigger sortie de map
				if (trigger.properties.id == 40)
				{
					// on check si joueur à validé ses achats					
					if (ardoiseAchats.getItemCount() > 0)
					{
						event.preventDefault();
						playerHelper.displayThink("je dois terminer mes achats avant de m'en aller", 5000, false, true);
					}
				}
				return;
			}
			
			// recup id du tile source
			var objId:String;
			try {
				objId = trigger.sourceTarget.ID;
			} catch (e:Error) {}
			
			// recup xml produit associé au tile
			var nodeProd:XMLList = boucherieData.products.product.(@id == objId).copy();
			
			// on test si un / des data produit sont associés au trigger / tile
			if (nodeProd.length() <= 0) return;
			
			switch (event.type)
			{
				case MouseEvent.CLICK : // click sur objet
				{
					// on injecte la liste des choix 
					trigger.setPropertie("title", "Acheter");
					var eList:XMLList = nodeProd.@title;
					var l:int = eList.length();
					var a:Array = [];
					for (var i:int = 0; i < l; i++)
						a.push(eList[i]);

					var p:String = a.join("#");
					trigger.setPropertie("tl", p);
					trigger.setPropertie("ll", p);
					break;
				}
				case TriggerEvent.COMPLETE : // click dans menu contextuel
				{
					// recup item selectionné dans context menu
					var entry:Object = Object(trigger).selectedEntry;
					
					// test si pas de selection (clique en dehors du menu contextuel)
					if (!entry) break;
					
					var sel:String = Object(trigger).selectedEntry.label;
					// recup noeud data produit
					var nod:XMLList = nodeProd.(@title == sel);
					var playerProxy:Object = facade.getProxy(ProxyList.PLAYER_PROXY);
					var peco:int = playerProxy.getBonus(3).gain + int(nod.@peco);
					var penv:int = playerProxy.getBonus(4).gain + int(nod.@penv);
					// test si le joueur à assez de points
					if (peco >= 0 && penv >= 0)
					{
						// le joueur à assez de points
						// envoie bonus / malus
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@peco), theme:3}));	// points éco
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@penv), theme:4}));	// points environnement
						// mise à jour de l'ardoise
						ardoiseAchats.addProduct(Number(nod.@quantity), nod);
						// on ferme la bulle du pnj
						pnjBoucherie.removeBallon();
					} else {
						pnjBoucherie.jumpInLife("needPoints");
					}
					break;
				}
			}
		}
				
		/**
		 *	@private
		 *	Réception des events triggers (achats) partie cremerie
		 */
		protected function cremerieTriggerHandler(event:TriggerEvent):void
		{
			var trigger:ITrigger = event.trigger;
			
			// on test si le trigger est un context menu
			if (trigger.classID != 4) {
				// on test si on est sur le trigger sortie de map
				if (trigger.properties.id == 41)
				{
					// on check si joueur à validé ses achats					
					if (ardoiseAchats.getItemCount() > 0)
					{
						event.preventDefault();
						playerHelper.displayThink("je dois terminer mes achats avant de m'en aller", 5000);
					}
				}
				return;
			}
			
			// recup id du tile source
			var objId:String;
			try {
				objId = trigger.sourceTarget.ID;
			} catch (e:Error) {}
			
			// recup xml produit associé au tile
			var nodeProd:XMLList = cremerieData.products.product.(@id == objId).copy();
			
			// on test si un / des data produit sont associés au trigger / tile
			if (nodeProd.length() <= 0) return;
			
			switch (event.type)
			{
				case MouseEvent.CLICK : // click sur objet
				{
					// on injecte la liste des choix 
					trigger.setPropertie("title", "Acheter");
					// on injecte la liste des choix achats
					var eList:XMLList = nodeProd.@title;
					var l:int = eList.length();
					var a:Array = [];
					for (var i:int = 0; i < l; i++)
						a.push(eList[i]);

					var p:String = a.join("#");
					trigger.setPropertie("tl", p);
					trigger.setPropertie("ll", p);
					break;
				}
				case TriggerEvent.COMPLETE : // click dans menu contextuel
				{
					// recup item selectionné dans context menu
					var entry:Object = Object(trigger).selectedEntry;
					
					// test si pas de selection (clique en dehors du menu contextuel)
					if (!entry) break;
					
					// recup item selectionné dans context menu
					var sel:String = Object(trigger).selectedEntry.label;
					// recup noeud data produit
					var nod:XMLList = nodeProd.(@title == sel);
					var playerProxy:Object = facade.getProxy(ProxyList.PLAYER_PROXY);
					var psoc:int = playerProxy.getBonus(2).gain + int(nod.@psoc);
					var peco:int = playerProxy.getBonus(3).gain + int(nod.@peco);
					var penv:int = playerProxy.getBonus(4).gain + int(nod.@penv);
					// test si le joueur à assez de points
					if (peco >= 0 && penv >= 0 && psoc >= 0)
					{
						// le joueur à assez de points
						// envoie bonus / malus
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@peco), theme:3}));	// points éco
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@penv), theme:4}));	// points environnement
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@psoc), theme:2}));	// points social
						// mise à jour de l'ardoise
						ardoiseAchats.addProduct(Number(nod.@quantity), nod);
						// on fait parler le pnj (noeuds info du produit)
						var infList:XMLList = nod.info;
						var len:int = infList.length();
						if (len > 1)
						{
							pnjCremerie.displayTalk(infList[int(Math.random() * len)], 0, true, true);
						} else if (len == 1) {
							pnjCremerie.displayTalk(infList, 0, true, true);
						}
					} else {
						pnjCremerie.jumpInLife("needPoints");
					}
					break;
				}
			}
		}

		/**
		 *	@private
		 *	Réception des events souris pour les pnjs
		 */
		protected function pnjMouseHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			// on recup le pnjHelper
			var targ:Object = event.target == pnjBoucherie.component ? pnjBoucherie : pnjCremerie;
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					/*targ.component.addEventListener(MouseEvent.MOUSE_OUT, pnjMouseHandler, false, 100, true);
					targ.component.addEventListener(MouseEvent.CLICK, pnjMouseHandler, false, 100, true);*/
					targ.removeBallon();
					targ.jumpInLife("help");
					/*targ.autoLife = false;*/
					break;
				}
				case MouseEvent.MOUSE_OUT :
				{
					/*if (!targ.ballon)
					{
						targ.autoLife = true;
					}
					targ.component.removeEventListener(MouseEvent.MOUSE_OUT, pnjMouseHandler, false);
					targ.component.removeEventListener(MouseEvent.CLICK, pnjMouseHandler, false);*/
					break;
				}
				case MouseEvent.CLICK :
				{
					/*targ.autoLife = true;
					targ.jumpInLife("info");*/
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception click sur bouton terminer mes achats sur
		 *	ardoise (partie primeur)
		 */
		protected function ardoiseAchatsHandler(event:MouseEvent = null):void
		{
			if (ardoiseAchats.getItemCount() > 0)
			{
				fireEndShopping();
			}				
		}
		
		/**
		 *	@private
		 *	Réception des events ballon du pnj primeur
		 */
		protected function ballonEventHandler (event:BaseEvent) : void
		{
			var te:Object = event.content; // data du BaseEvent
			// check type d'event
			if (te.kind != TextEvent.LINK) return;
			
			var targ:Object = te.target;
			var link:String = te.event.text;
			
			switch (link)
			{
				case "y1" : // le jouer n'a pas fini ses achats
				{
					targ.removeBallon();
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					break;
				}
				case "n1" : // le joueur à fini ses achats
				{
					var pdata:XML;
					var item:ItemArdoiseAchats;
					var imost:Object;
					var most:String;				// type de produit le plus acheté
					var peco:int = 0;
					var penv:int = 0;
					var psoc:int = 0;
					var eCost:Number = 0;
					var quantity:int = 0;
					var pList:Array = ardoiseAchats.getItemList();
					var l:int = pList.length;
					
					switch (targ)	// on switch sur le bon pnj
					{
						case pnjBoucherie :
						{
							while (--l > -1)
							{
								item = pList[l];
								peco+= item.ecoCost;
								penv+= item.envCost;
								psoc+= item.socCost;
								eCost+= item.eCost;
								quantity+= item.quantity;

								if (imost)
								{
									if (item.quantity > imost.quantity) imost = item;
								} else {
									imost = item;
								}
							}
							
							most = imost.data.@type;
							pdata = boucherieData;
							break;
						}
						case pnjCremerie :
						{
							imost = {};
							while (--l > -1)
							{
								item = pList[l];
								peco+= item.ecoCost;
								penv+= item.envCost;
								psoc+= item.socCost;
								eCost+= item.eCost;
								
								most = item.data.@type;	
								if (most in imost)
								{
									imost[most]+= item.getQuantity();
								} else {
									imost[most] = item.getQuantity();
								}
							}
							
							for (var s:String in imost)
							{
								if (imost[s] > imost[most])
									most = s;
							}
							
							pdata = cremerieData;
							break;
						}
					}
					
					var t:String = "";
					if (pdata.pnj.conclusionText.intro.length() > 0)
						t = pdata.pnj.conclusionText.intro[0];
						
					eCost = Math.round(eCost * 100) / 100;
					t+= pdata.pnj.conclusionText.info.(@type == most) + '\n';
					t = t.replace(/#eCost#/gi, String(eCost));
					t = t.replace(/#peco#/gi, String(peco));
					t = t.replace(/#penv#/gi, String(penv));
					t = t.replace(/#psoc#/gi, String(psoc));
					t+= '<p align="center"><u><a href="event:fermer">fermer</a></u></p>';
					
					// on affiche la conlusion (par le pnj)
					targ.displayTalk(t, 0, true, true);	
					// on efface l'ardoise
					ardoiseAchats.reset();	
					break;
				}
				case "fermer" :
				{
					targ.removeBallon();
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception des events avatar bob
		 */
		private function bobEventsHandler(event:Event):void
		{
			switch (event.type)
			{
				case TileEvent.ENTER_CELL :
				{
					var cell:UPoint = TileEvent(event).getCell();
					
					// test entrée dans cremerie
					var p:UPoint = new UPoint(18, 20, 0);
					if (p.isMatchPos(cell))
					{
						// test si joueur est déjà dans cremerie
						if (!boucherieStandBye)
						{
							// si le joueur à des achats en cours et qu'il n'à pas validé
							// la fin de ceux-ci
							if (ardoiseAchats.getItemCount() > 0)
							{													
								playerHelper.moveTo(14, 19, 0);
								playerHelper.displayThink("je dois terminer mes achats avant de m'en aller", 5000);
								return;
							} else {
								// sinon on le laisse entrer dans veti et on met le pnj primeur
								// au repos
								pnjBoucherie.jumpInLife("byebye");
								// patch pnj triggers non developpés
								boucherieStandBye = true;
								disableBoucherie();
															
								pnjCremerie.jumpInLife("hello");
								pnjCremerie.autoLife = true;
								enableCremerie();
								return;
							}
						}
					}
					// test entrée dans boucherie
					p.xu = 17;
					if (p.isMatchPos(cell))
					{
						if (boucherieStandBye)
						{
							// si le joueur à des achats en cours et qu'il n'à pas validé
							// la fin de ceux-ci
							if (ardoiseAchats.getItemCount() > 0)
							{													
								playerHelper.moveTo(21, 19, 0);
								playerHelper.displayThink("je dois terminer mes achats avant de m'en aller", 5000);
								return;
							} else {
								// on désactive la partie vêtements
								pnjCremerie.jumpInLife("byebye");
								disableCremerie();
								// on enclenche la partie primeur
								pnjBoucherie.autoLife = true;
								pnjBoucherie.jumpInLife("hello");
								boucherieStandBye = false;
								enableBoucherie();
								return;
							}
						}
					}
					
					// test passage derrière comptoire cremerie
					p.xu = 22;
					p.yu = 12;
					if (p.isMatchPos(cell))
					{
						playerHelper.moveTo(20, 13, 0);
						pnjCremerie.jumpInLife("warningComptoir");
						return;
					}
					p.xu = 20;
					p.yu = 11;
					if (p.isMatchPos(cell))
					{
						playerHelper.moveTo(20, 12, 0);
						pnjCremerie.jumpInLife("warningComptoir");
						return;
					}
					// test passage derrière vitrines boucherie
					p.xu = 8;
					p.yu = 18;
					if (p.isMatchPos(cell))
					{
						playerHelper.moveTo(10, 19, 0);
						pnjBoucherie.jumpInLife("warningComptoir");
						return;
					}
					p.xu = 12;
					p.yu = 10;
					if (p.isMatchPos(cell))
					{
						playerHelper.moveTo(13, 12, 0);
						pnjBoucherie.jumpInLife("warningComptoir");
						return;
					}				
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception chargement des data (m42.xml)
		 */
		private function dataLoaderHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, dataLoaderHandler, false);
			data = XML(event.target.data);
			data.ignoreComments = true;
			boucherieData = data.boucherie[0];
			cremerieData = data.cremerie[0];
			if (stage)
			{
				if (!stage.contains(this))
					_init();
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Lance scénarion fin des achats
		 */
		private function fireEndShopping():void
		{
			sendEvent(new Event(EventList.FREEZE_SCENE));
			// on fait parler pnj
			var t:String = 'Il vous faudra autre chose ?\n<u><a href="event:y1">oui</a></u> - <u><a href="event:n1">non</a></u>';
			if (playerInBoucherie)
				pnjBoucherie.displayTalk(t, 0, true);
			else
				pnjCremerie.displayTalk(t, 0, true);
		}
		
		/**
		 *	@private
		 *	Ajoute listener pour sortie entrée primeur / vêtements
		 */
		private function addBobInOutListeners():void
		{
			playerHelper.component.addEventListener(TileEvent.ENTER_CELL, bobEventsHandler, false, 0, true);
		}

		/**
		 *	@private
		 *	Ajoute listener pour sortie entrée primeur / vêtements
		 */
		private function removeBobInOutListeners():void
		{
			playerHelper.component.removeEventListener(TileEvent.ENTER_CELL, bobEventsHandler, false);
		}
		
		/**
		 *	@private
		 *	Mets en place la partie primeur
		 *	débloque interactions sur tiles + pnj
		 */
		private function enableBoucherie():void
		{
			// déblocage des events souris sur les tiles
			var tileList:XMLList = boucherieData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = true;
				
			// autres tile qui ne sont pas des "produits"
			var at:Array = [17, 20, 19, 54];
			l = at.length;
			while (--l > -1)
				isoSceneHelper.getTile(at[l]).mouseEnabled = true;
				
			// sur le pnj primeur
			pnjBoucherie.component.mouseEnabled = true;
			// écoute des events souris sur pnj boucherie
			pnjBoucherie.component.addEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false, 0, true);
			// écoute liens cliqués dans les ballons pnj
			channel.addEventListener(EventList.PNJ_BALLONEVENT, ballonEventHandler, false, 0, true);
			// ecoute bouton terminer achats sur ardoise
			ardoiseAchats.finishPrimShoppingButton.addEventListener(MouseEvent.CLICK, ardoiseAchatsHandler, false, 0, true);

			// écoute exécution des trigger
			channel.addEventListener(MouseEvent.CLICK, boucherieTriggerHandler, false, 50, true);
			channel.addEventListener(TriggerEvent.COMPLETE, boucherieTriggerHandler, false, 50, true);
			
			// mise à jour affichage de l'ardoise
			ardoiseAchats.title = "BOUCHERIE";
		}
		
		/**
		 *	@private
		 *	Empêche interactions partie boucherie
		 *	voir enableBoucherie()
		 */
		private function disableBoucherie():void
		{
			// blocage des interactions sur les produits
			var tileList:XMLList = boucherieData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = false;
				
			// autres tile qui ne sont pas des "produits"
			var at:Array = [17, 20, 19, 54];
			l = at.length;
			while (--l > -1)
				isoSceneHelper.getTile(at[l]).mouseEnabled = false;

			// sur le pnj boucherie
			pnjBoucherie.component.mouseEnabled = false;
			// events souris sur pnj boucherie
			pnjBoucherie.component.removeEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false);
			// écoute liens cliqués dans les ballons pnj
			channel.removeEventListener(EventList.PNJ_BALLONEVENT, ballonEventHandler, false);
			// bouton terminer achats sur ardoise
			ardoiseAchats.finishPrimShoppingButton.removeEventListener(MouseEvent.CLICK, ardoiseAchatsHandler, false);

			// écoute exécution des trigger
			channel.removeEventListener(MouseEvent.CLICK, boucherieTriggerHandler, false);
			channel.removeEventListener(TriggerEvent.COMPLETE, boucherieTriggerHandler, false);
		}
		
		/**
		 *	@private
		 *	Débloque les interactions partie cremerie
		 */
		private function enableCremerie():void
		{
			
			// déblocage des events souris sur les tiles
			var tileList:XMLList = cremerieData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = true;
			
			// autres tile qui ne sont pas des "produits"
			var at:Array = [52, 40, 45, 55];
			l = at.length;
			while (--l > -1)
				isoSceneHelper.getTile(at[l]).mouseEnabled = true;
			
			// sur le pnj cremerie
			pnjCremerie.component.mouseEnabled = true;
			// events souris sur pnj cremerie
			pnjCremerie.component.addEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false, 0, true);
			// écoute liens cliqués dans les ballons pnj
			channel.addEventListener(EventList.PNJ_BALLONEVENT, ballonEventHandler, false, 0, true);
			// bouton terminer achats sur ardoise
			ardoiseAchats.finishPrimShoppingButton.addEventListener(MouseEvent.CLICK, ardoiseAchatsHandler, false, 0, true);
			
			// écoute exécution des trigger
			channel.addEventListener(MouseEvent.CLICK, cremerieTriggerHandler, false, 50, true);
			channel.addEventListener(TriggerEvent.COMPLETE, cremerieTriggerHandler, false, 50, true);
			
			// mise à jour affichage de l'ardoise
			ardoiseAchats.title = "CREMERIE";
		}
		
		/**
		 *	@private
		 *	Débloque les interactions partie cremerie
		 */
		private function disableCremerie():void
		{
			var tileList:XMLList = cremerieData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = false;
			
			// autres tile qui ne sont pas des "produits"
			var at:Array = [52, 40, 45, 55];
			l = at.length;
			while (--l > -1)
				isoSceneHelper.getTile(at[l]).mouseEnabled = false;
			
			// sur le pnj cremerie
			pnjCremerie.component.mouseEnabled = false;
			// events souris sur pnj cremerie
			pnjCremerie.component.removeEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false);
			// écoute liens cliqués dans les ballons pnj
			channel.removeEventListener(EventList.PNJ_BALLONEVENT, ballonEventHandler, false);
			// bouton terminer achats sur ardoise
			ardoiseAchats.finishPrimShoppingButton.removeEventListener(MouseEvent.CLICK, ardoiseAchatsHandler, false);
			
			// écoute exécution des trigger
			channel.removeEventListener(MouseEvent.CLICK, cremerieTriggerHandler, false);
			channel.removeEventListener(TriggerEvent.COMPLETE, cremerieTriggerHandler, false);
		}
		
		/**
		 *	@private
		 */
		private function _init():void
		{
			applicationStage.addChild(this);

			// reference isoscene
			isoSceneHelper = facade.getObserver(HelperList.ISOSCENE_HELPER);

			// bob
			playerHelper = facade.getObserver(HelperList.PLAYER_HELPER);
			addBobInOutListeners();

			// -> PNJ's
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			// pnj primeur
			var tv:Object = objBuilder.createMCTileView(new TileViewBouchere());
			var at:Object = objBuilder.createAbstractTile("pnjBoucherie", 8, 15, 0, tv);
			pnjBoucherie = objBuilder.createPNJHelper("pnjBoucherieHelper", at);
			facade.registerObserver(pnjBoucherie.name, IObserver(pnjBoucherie));
			pnjBoucherie.iaData = data.boucherie.pnj.(@id == "boucherie")[0];
			
			// pnj cremerie
			tv = objBuilder.createMCTileView(new TileViewCremier());
			at = objBuilder.createAbstractTile("pnjCremerie", 24, 14, 0, tv);
			at.gotoAndStop("stand");
			at.rotation = 135;
			pnjCremerie = objBuilder.createPNJHelper("pnjCremerieHelper", at);
			facade.registerObserver(pnjCremerie.name, IObserver(pnjCremerie));
			pnjCremerie.iaData = data.cremerie.pnj.(@id == "cremerie")[0];
						
			// mise en route partie primeur ou vêtements selon endroit
			// du joueur
			if (playerInBoucherie)
			{
				disableCremerie();
				enableBoucherie();
				pnjBoucherie.autoLife = true;
			} else {
				disableBoucherie();
				enableCremerie();
				pnjCremerie.autoLife = true;
			}
			
			// ajout listaner sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);
						
			// debug
//			channel.addEventListener(EventList.PNJ_FIRETRIGGER, listenPnjCrem);
		}
		
		/*private function listenPnjCrem(event:BaseEvent):void
		{
			if (event.content.target == pnjCremerie)
				trace(event.content.data.toXMLString());
		}*/
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);

			disableBoucherie();
			disableCremerie();
			removeBobInOutListeners();
			applicationStage.removeChild(this);
			super.complete();
		}

	}

}