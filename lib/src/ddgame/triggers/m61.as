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
//	import com.sos21.tileengine.core.AbstractTile;
//	import com.sos21.tileengine.display.MCTileView;
	import com.sos21.tileengine.events.TileEvent;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
//	import ddgame.triggers.QuizTrigger;
	import ddgame.triggers.AbstractExternalTrigger;
//	import ddgame.client.view.IsosceneHelper;
//	import ddgame.client.proxy.LibProxy;
//	import ddgame.client.proxy.PlayerProxy;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
//	import ddgame.client.view.PNJHelper;
//	import ddgame.client.view.PlayerHelper;

	import m61.ItemArdoiseAchats;
	import ddgame.proxy.ProxyList;
	import ddgame.helper.HelperList;
	import com.sos21.observer.IObserver;

	/**
	 * Trigger map id 61 (commerce poissonnerie)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m61 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m61():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m61.xml"));
		}
		
//		public static const CLASS_ID:int = 10;
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjPoissonnerie:Object;					// pnj poissonnerie
		public var playerHelper:Object;
		public var isoSceneHelper:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		protected var poissonnerieData:XML;	// data xml primeur
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
				
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
			if (poissonnerieData && !stage.contains(this))
				_init();
		}
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Reception des events triggers (achats) partie primeur
		 */
		protected function poissonerieTriggerHandler(event:TriggerEvent):void
		{
			var trigger:ITrigger = event.trigger;
			
			// on test si on est sur le trigger sortie de map
			if (trigger.properties.id == 36)
			{
				// on check si joueur à validé ses achats					
				if (ardoiseAchats.getItemCount() > 0)
				{
					event.preventDefault();
					playerHelper.displayThink("je dois terminer mes achats avant de m'en aller", 0, false, true);
				}
				return;
			}
			
						
			// recup id du tile source
			var objId:String;
			try {
				objId = trigger.sourceTarget.ID;
			} catch (e:Error) {}
			
			// recup xml produit associé au tile
			var nodeProd:XMLList = poissonnerieData.products.product.(@id == objId).copy();
			
			// on test si un / des data produit sont associés au trigger / tile
			if (nodeProd.length() <= 0) return;

			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER : // roll over sur produit
				{
					// on injecte l'origine
					// pour éviter les l'affiche dupliqué de l'origine
					if (!trigger.isPropertie("otext"))
						trigger.setPropertie("otext", trigger.getPropertie("text"));
						
					trigger.setPropertie("text", trigger.getPropertie("otext") + "\n<i>origine : " + nodeProd.@origin[0] + "</i>");
					break;
				}
				case MouseEvent.CLICK : // click sur objet
				{
					if (trigger.classID == 4) // ouverture menu contextuel
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
					}
					break;
				}
				case TriggerEvent.COMPLETE :
				{
					if (trigger.classID == 4) // click dans menu contextuel
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
							// on fait parler le pnj (noeuds info du produit)
							var infList:XMLList = nod.info;
							var len:int = infList.length();
							if (len > 1)
							{
								pnjPoissonnerie.displayTalk(infList[int(Math.random() * len)], 0, true, true);
							} else if (len == 1) {
								pnjPoissonnerie.displayTalk(infList, 0, true, true);
							}
						} else {
							pnjPoissonnerie.jumpInLife("needPoints");
						}
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
			var targ:Object = pnjPoissonnerie;
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					targ.removeBallon();
					targ.jumpInLife("help");
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
						case pnjPoissonnerie :
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
							pdata = poissonnerieData;
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
					// test passage derrière frigo
					var cell:UPoint = TileEvent(event).getCell();
					var p:UPoint = new UPoint(19, 18, 0);
					if (p.isMatchPos(cell))
					{
						playerHelper.moveTo(20, 20, 0);
						pnjPoissonnerie.jumpInLife("warningComptoir");
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
			poissonnerieData = data.poissonnerie[0];
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
			pnjPoissonnerie.displayTalk(t, 0, true);
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
		private function enablePoissonerie():void
		{
			// déblocage des events souris sur les tiles
			var tileList:XMLList = poissonnerieData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = true;
				
			// autres tile qui ne sont pas des "produits"
			var at:Array = [];
			l = at.length;
			while (--l > -1)
				isoSceneHelper.getTile(at[l]).mouseEnabled = true;
				
			// sur le pnj primeur
			pnjPoissonnerie.component.mouseEnabled = true;
			// écoute des events souris sur pnj boucherie
			pnjPoissonnerie.component.addEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false, 0, true);
			// écoute liens cliqués dans les ballons pnj
			channel.addEventListener(EventList.PNJ_BALLONEVENT, ballonEventHandler, false, 0, true);
			// ecoute bouton terminer achats sur ardoise
			ardoiseAchats.finishShoppingButton.addEventListener(MouseEvent.CLICK, ardoiseAchatsHandler, false, 0, true);

			// écoute exécution des trigger
			channel.addEventListener(MouseEvent.MOUSE_OVER, poissonerieTriggerHandler, false, 50, true);
			channel.addEventListener(MouseEvent.CLICK, poissonerieTriggerHandler, false, 50, true);
			channel.addEventListener(TriggerEvent.COMPLETE, poissonerieTriggerHandler, false, 50, true);
			
			// mise à jour affichage de l'ardoise
			ardoiseAchats.title = "POISSONNERIE";
		}
		
		/**
		 *	@private
		 *	Empêche interactions partie boucherie
		 *	voir enablePoissonerie()
		 */
		private function disablePoissonnerie():void
		{
			// blocage des interactions sur les produits
			var tileList:XMLList = poissonnerieData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = false;
				
			// autres tile qui ne sont pas des "produits"
			var at:Array = [];
			l = at.length;
			while (--l > -1)
				isoSceneHelper.getTile(at[l]).mouseEnabled = false;

			// sur le pnj boucherie
			pnjPoissonnerie.component.mouseEnabled = false;
			// events souris sur pnj boucherie
			pnjPoissonnerie.component.removeEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false);
			// écoute liens cliqués dans les ballons pnj
			channel.removeEventListener(EventList.PNJ_BALLONEVENT, ballonEventHandler, false);
			// bouton terminer achats sur ardoise
			ardoiseAchats.finishShoppingButton.removeEventListener(MouseEvent.CLICK, ardoiseAchatsHandler, false);

			// écoute exécution des trigger
			channel.removeEventListener(MouseEvent.MOUSE_OVER, poissonerieTriggerHandler, false);
			channel.removeEventListener(MouseEvent.CLICK, poissonerieTriggerHandler, false);
			channel.removeEventListener(TriggerEvent.COMPLETE, poissonerieTriggerHandler, false);
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

			// -> PNJ
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			var tv:Object = objBuilder.createMCTileView(new TileViewPoissonniere());
			var at:Object = objBuilder.createAbstractTile("pnjPoissonnerie", 19, 15, 0, tv);
			at.rotation = 0;
			pnjPoissonnerie = objBuilder.createPNJHelper("pnjPoissonnerieHelper", at);
			facade.registerObserver(pnjPoissonnerie.name, IObserver(pnjPoissonnerie));
			pnjPoissonnerie.iaData = poissonnerieData.pnj.(@id == "poissonnerie")[0];
			
			enablePoissonerie();
			pnjPoissonnerie.autoLife = true;		
			
			// ajout listaner sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);

			disablePoissonnerie();
			removeBobInOutListeners();
			applicationStage.removeChild(this);
			super.complete();
		}

	}

}