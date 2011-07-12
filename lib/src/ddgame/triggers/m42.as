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
	import flash.net.navigateToURL;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.IObserver;
	import com.sos21.proxy.IProxy;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.events.TileEvent;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import ddgame.events.TriggerEvent;		
	import ddgame.triggers.ITrigger;
	import ddgame.events.EventList;
	import ddgame.helper.HelperList;
	import ddgame.proxy.ProxyList;
		
	import m42.ItemArdoisePrimeur;

	
	
//	import m42.VendeurPrimeur;

	/**
	 * Trigger map id 42 (commerce primeur/vêtements)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m42 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m42():void
		{
			super();

			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m42.xml"));
		}
		
//		public static const CLASS_ID:int = 10;
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjPrimeur:Object;					// pnj vendeur primeur
		public var pnjVeti:Object;						// pnj vendeur vetements
		public var primeurStandBye:Boolean = false;
		public var playerHelper:Object;
		public var isoSceneHelper:Object;
		protected var timerpnjLife:Timer = new Timer(0, 1);
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var season:int;			// saison
		protected var data:XML;
		protected var primeurData:XML;	// data xml primeur
		protected var vetiData:XML;		// data xml vêtements
		protected var _visitedLink:Array = [];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	Retourne true si le le joeur est dans le partie
		 *	commerce primeur
		 */		
		public function get playerInPrimeur():Boolean
		{
			return playerHelper.component.upos.yu < 19;
		}
		
		/**
		 *	Retourne true si le le joeur est dans le partie
		 *	commerce vêtements
		 */
		public function get playerInVeti():Boolean
		{
			return playerHelper.component.upos.yu > 18;
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
			trace("EXECUTE");
			// on test si les data sont arrviées et si l'init pas
			// encore fait
			if (primeurData && !stage.contains(this))
				_init();
		}
		
		/**
		 *	Retourne l'index de la saison
		 *	par rapport à la date passée en params
		 */
		public function getSeason(date:Date):int
		{
			var m:int = date.month;
			var d:int = date.date;
			var hiver:Array = [11,0,1,2];
			var printemps:Array = [2,3,4,5];
			var ete:Array = [5,6,7,8];
			var s:int;
			switch (true)
			{
				case hiver.indexOf(m) > -1 :
				{
					if (m == 11 && d < 21) 		// automne
						s = 2;
					else if (m == 2 && d > 20) // printemps
						s = 0;						
					else 								// hiver
						s = 3;
					break;
				}
				case printemps.indexOf(m) > -1 :
				{
					if (m == 2 && d < 21) 		// hiver
						s = 3;
					else if (m == 5 && d > 20) // été
						s = 1;
					else								// printemps
						s = 0;					
					break;
				}
				case ete.indexOf(m) > -1 :
				{
					if (m == 5 && d < 22) 		// printemps
						s = 0;
					else if (m == 8 && d > 22) // automne
						s = 2;
					else								// ete
						s = 1;
					break;
				}
				default :
				{
					if (m == 8 && d < 23) 		// ete
						s = 1;
					else if (m == 11 && d > 21) // hiver
						s = 3;
					else								// ete
						s = 2;
					break;
				}
			}
			return s;
		}
		
		/**
		 *	Retourne une copie du noeud XML d'un produit primeur
		 *	nettoyé des saison inutiles
		 *	@param	id	 identifiant du noeud product
		 */
		public function getCleanedPrimProductData(productId:String):XMLList
		{
			var productNode:XMLList = primeurData.products.product.(@id == productId).copy();
			var nodeList:XMLList = productNode.season.(@id != season);
			for(var i:int = nodeList.length() -1; i >= 0; i--)
				delete nodeList[i];
			
			// on repasse l'intitulé du type transport
			var ttype:String = productNode.season.@ttype;
			productNode.season.@ttype = primeurData.ttype.(@id == ttype).@title;
			
			return productNode;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Reception des events triggers (achats) partie primeur
		 */
		protected function primeurTriggerHandler(event:TriggerEvent):void
		{
			var trigger:ITrigger = event.trigger;
			
			// on recup les data cleanées pour l'objet (fruits / légs de la scène)
			var nodeProd:XMLList = getCleanedPrimProductData(trigger.getPropertie("objId"));
			// on switch sur l'id du trigger
			switch (trigger.properties.id)
			{
				// fleche sortie 
				case 62 :
				{
					// on check si joueur à validé ses achats
					if (ardoisePrimeur.getItemCount() > 0)
					{
						event.preventDefault();												
						playerHelper.moveTo(24, 13, 0);
						playerHelper.displayThink("je dois terminer mes achats avant de m'en aller", 5000);
					}
					break;
				}
				// roll over fruit / légumes
				case 3 :
				{
					// injection du texte du tooltip
					trigger.setPropertie("text", "<b>" + nodeProd.@plurTitle + "</b> <i>origine : " + nodeProd.season.@origin + "</i>");
					break;
				}
				// click achat oui
				case 2 :
				{
					var playerProxy:Object = facade.getProxy(ProxyList.PLAYER_PROXY);
					
					var peco:int = playerProxy.getBonus(3).gain + int(nodeProd.season.@peco);
					var penv:int = playerProxy.getBonus(4).gain + int(nodeProd.season.@penv);
					
					// on test si le joueur à assez de points éco en environnement
					if (peco >= 0 && penv >= 0)
					{
						// ajout du produit (fruit/leg) sur l'ardoise
						ardoisePrimeur.addProduct(1, nodeProd);
						// envoie bonus / malus
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nodeProd.season.@peco), theme:3}));	// points éco
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nodeProd.season.@penv), theme:4}));	// points environnement

						// distil d'une info relative au type de transport
						var ttypeNode:XMLList = primeurData.ttype.(@title == nodeProd.season.@ttype).info;
						var len:int = ttypeNode.length();
						if (len > 0)
						{
							var rand:int = Math.random() * len
							pnjPrimeur.displayThink(ttypeNode[rand]);
						}
					} else {
						// pas assez de points, on affiche une pensée sur joueur + pnj
						/*var think:String = "mince, il me faudrait plus de points ";
						var t2:String;
						if (peco <= 0)
						{ <div><object width="480" height="501"><param name="movie" value="http://www.dailymotion.com/swf/x34fa2_les-apprentis-zecolos-le-jean&related=1"></param><param name="allowFullScreen" value="true"></param><param name="allowScriptAccess" value="always"></param><embed src="http://www.dailymotion.com/swf/x34fa2_les-apprentis-zecolos-le-jean&related=1" type="application/x-shockwave-flash" width="480" height="501" allowFullScreen="true" allowScriptAccess="always"></embed></object><br /><b><a href="http://www.dailymotion.com/video/x34fa2_les-apprentis-zecolos-le-jean">Les Apprentis Z&#039;Ecolos : le jean</a></b><br /><i>envoy&eacute; par <a href="http://www.dailymotion.com/Terraeconomica">Terraeconomica</a>.</i></div>
							t2 = "économique";
							think+= t2;
						}
						if (penv <= 0)
						{
							if (t2) think+= " et ";
							think+= "social";
						}
						playerHelper.displayThink(think);*/
						var id:String = "inf" + String(getTimer());
						var snod:String = '<temp exec="1" id="' + id + '"><action type="play" label="stand" /><action type="talk" autoClose="true" stopPnjTrip="true"><![CDATA[Vous pouvez gagner des points Economie et Environnement en répondant à des quiz]]></action><evt type="jumpInTrip" target="restart" delay="8000"/></temp>';
						var nod:XML = new XML(snod);
						pnjPrimeur.injectDataInLife(nod);
						pnjPrimeur.jumpInLife(id);
					}
					break;
				}
			}
		}
		
		
		/**
		 *	@private
		 *	Réception des events triggers (achats) partie vêtements
		 */
		protected function vetiTriggerHandler(event:TriggerEvent):void
		{			
			// récupr du trigger
			var trigger:Object = event.trigger;
			// recup id tile
			var objId:String = trigger.getPropertie("objId");
			// recup xml produit associé au tile
			var nodeProd:XMLList = vetiData.products.product.(@id == objId).copy();
			
			switch (trigger.properties.id)
			{
				case 50 : // roll over
				{
					// injection du text dans le tooltip
					trigger.setPropertie("text", nodeProd.@title);
					break;
				}
				case 51 : // click (menu contextuel)
				{
					if (event.type == MouseEvent.CLICK)
					{
						// on injecte la liste des choix 
						trigger.setPropertie("title", nodeProd.@buyTitle); 
						var eList:XMLList = nodeProd.type.@title;
						var l:int = eList.length();
						var a:Array = [];
						for (var i:int = 0; i < l; i++) {
							a.push(eList[i]);
						}
						
						var en:String = a.join("#")
						trigger.setPropertie("tl", en);
						trigger.setPropertie("ll", en);
					} else {
						// le joueur à selectionné une entrée
						// on récup l'entrée selectionnée (voir ContextMenuTrigger)
						var sel:String = trigger.selectedEntry.label;
						trace(this, sel);
						var nod:XMLList = nodeProd.type.(@title == sel);
						// on test si le joueur à assez de points pour acheter
						var playerProxy:Object = facade.getProxy(ProxyList.PLAYER_PROXY);
						var peco:int = playerProxy.getBonus(3).gain + int(nod.@peco);
						var penv:int = playerProxy.getBonus(4).gain + int(nod.@penv);
						var psoc:int = playerProxy.getBonus(2).gain + int(nod.@psoc);
						if (peco >= 0 && penv >= 0 && psoc >= 0)
						{
							// le joueur à assez de points
							// > distil d'une info aléatoire concernant le produit acheté
							var infList:XMLList = nod.info;
							var len:int = infList.length();
							if (len > 0)
							{
								var rand:int = Math.random() * len;
								pnjVeti.displayTalk(infList[rand], 0, true, true);
							}
							// envoie bonus / malus
							sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@peco), theme:3}));	// points éco
							sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@penv), theme:4}));	// points environnement
							sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(nod.@psoc), theme:2}));	// points social
						} else {
							pnjVeti.jumpInLife("needPoints");
						}
					}
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception des events partie vêtements
		 */
		protected function vetiEventsHandler(event:Event):void
		{
			switch(event.type)
			{
				// > noeud ia pnjVeti
				case EventList.PNJ_FIRETRIGGER :
				{
					// on test si on est sur la bulle "proposition de thèmes" pour
					// ajout listener sur le ballon et récup les lien cliqués
					var id:String = BaseEvent(event).content.data.@id;
					if (id == "propalthemes" || id == "needPoints") {
						channel.addEventListener(EventList.PNJ_BALLONEVENT, vetiEventsHandler, false, 0, true);
					}
					break;
				}
				// > click sur lien dans ballon pnjVeti
				case EventList.PNJ_BALLONEVENT :
				{
					// on test si on est sur le noeud "propistion de themes"
					if (pnjVeti.ai.currentStep.@id == "propalthemes")
					{
						// on test si on est sur le lancement d'un des triggers quiz
						var evtKind:String = BaseEvent(event).content.kind;
						if (evtKind == EventList.LAUNCH_TRIGGER)
						{
							pnjVeti.autoLife = false;
							channel.removeEventListener(EventList.PNJ_BALLONEVENT, vetiEventsHandler, false);
							// on écoute la fermeture du quiz
							channel.addEventListener(TriggerEvent.COMPLETE, vetiEventsHandler, false, 0, true);
						}
					}
					break;
				}
				
				// > fin de trigger
				case TriggerEvent.COMPLETE :
				{
					// on test si on était sur les quiz
					var tevent:TriggerEvent = TriggerEvent(event);
					if (tevent.trigger.classID == 3)
					{
						// suppression écoute fermeture de quiz
						channel.removeEventListener(TriggerEvent.COMPLETE, vetiEventsHandler);
						// on passe à la conclusion
						pnjVeti.autoLife = true;
						pnjVeti.jumpInLife("conclusionQuiz" + tevent.trigger.properties.id);
					}
					break;
				}
				default : {break}
			}
		}
		
		/**
		 *	@private
		 *	Réception des events souris pour le pnj primeur
		 */
		protected function pnjPrimeurHandler(event:Event):void
		{
			var t:String;
			event.stopImmediatePropagation();
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					isoSceneHelper.component.addEventListener(MouseEvent.MOUSE_OUT, pnjPrimeurHandler, false, 100, true);
					isoSceneHelper.component.addEventListener(MouseEvent.CLICK, pnjPrimeurHandler, false, 100, true);
					t = primeurData.pnj.helptext.mouseOver[0];
					pnjPrimeur.displayTalk(t , 0, true);
					break;
				}
				case MouseEvent.MOUSE_OUT :
				{
					isoSceneHelper.component.removeEventListener(MouseEvent.MOUSE_OUT, pnjPrimeurHandler, false);
					isoSceneHelper.component.removeEventListener(MouseEvent.CLICK, pnjPrimeurHandler, false);
					pnjPrimeur.removeBallon();
					break;
				}
				case MouseEvent.CLICK :
				{
					isoSceneHelper.component.removeEventListener(MouseEvent.MOUSE_OUT, pnjPrimeurHandler, false);
					isoSceneHelper.component.removeEventListener(MouseEvent.CLICK, pnjPrimeurHandler, false);
					var tlist:XMLList = primeurData.pnj.helptext.txt.(@season == season);
					var rand:int = Math.random() * tlist.length();
					t = tlist[rand];
					t+= primeurData.pnj.helptext.click[0];
					// écoute liens sur ballon
					pnjPrimeur.displayTalk(t, 0, true, true).htmlContent.addEventListener(TextEvent.LINK, ballonEventHandler, false, 0, true);
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réceptiondes events souris pour le pnj vêtements
		 */
		protected function pnjVetiHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			switch (event.type)
			{
				case MouseEvent.CLICK :
				{
					pnjVeti.jumpInLife("propalthemes");
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception click sur bouton terminer mes achats sur
		 *	ardoise (partie primeur)
		 */
		protected function ardoisePrimeurHandler(event:MouseEvent = null):void
		{
			if (ardoisePrimeur.getItemCount() > 0)
			{
				fireEndPrimeurShopping();
			}				
		}
		
		/**
		 *	@private
		 *	Réception des events ballon du pnj primeur
		 */
		protected function ballonEventHandler(event:TextEvent):void
		{
			var resp:String = event.text;
			var t:String;
			switch (resp)
			{
				case "y1" :
				{
					pnjPrimeur.ballon.htmlContent.removeEventListener(TextEvent.LINK, ballonEventHandler, false);
					pnjPrimeur.removeBallon();
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					break;
				}
				case "n1" :
				{					
					// calcul produit saison hors saison
					var pList:Array = ardoisePrimeur.getItemList();	
					var item:ItemArdoisePrimeur;
					var peco:int = 0; 
					var penv:int = 0;
					var oilCost:Number = 0;
					// achats en saison
					var inSeason:int = 0;
					var quantity:int = 0;
					var l:int = pList.length;
					while (--l > -1)
					{
						item = pList[l];
						peco+= item.ecoCost;
						penv+= item.envCost;
						oilCost+= item.oilCost;
						quantity+= item.quantity;
						if (item.inSeason) inSeason+= quantity;
					}
					
//					debug.trace("nbr items: ", quantity);
//					debug.trace("peco: ", peco, " penv: ", penv);
//					debug.trace("en saison: ", inSeason);
//					debug.trace("hors saison: ", quantity - inSeason);
					
					// achats hors saison
					var outSeason:int = quantity - inSeason;
					
					if (inSeason > outSeason)
					{
						t = primeurData.pnj.conclusionText.good[0];
					} else if (inSeason < outSeason) {
						t = primeurData.pnj.conclusionText.bad[0];
					} else {
						t = primeurData.pnj.conclusionText.equal[0];
					}
					
					oilCost = Math.round(oilCost * 100) / 100;
					
					t = t.replace(/#oilCost#/gi, String(oilCost));
					t = t.replace(/#peco#/gi, String(Math.abs(peco)));
					t = t.replace(/#penv#/gi, String(penv));
					t+= '\n<p align="center"><u><a href="event:suite">suite</a></u></p>';
					
//					debug.trace(t);
										
					pnjPrimeur.displayTalk(t, 0, true).htmlContent.addEventListener(TextEvent.LINK, ballonEventHandler, false, 0, true);
//					pnjPrimeur.ballon.htmlContent.addEventListener(TextEvent.LINK, ballonEventHandler, false, 0, true);
										
					break;
				}
				case "suite" :
				{
					t = 'Vous avez besoin de sacs plastiques ?\n- <u><a href="event:y2">oui s’il vous plait</a></u>\n- <u><a href="event:n2">non merci</a></u>';
					pnjPrimeur.displayTalk(t, 0, true).htmlContent.addEventListener(TextEvent.LINK, ballonEventHandler, false, 0, true);
					// on reset l'ardoise
					ardoisePrimeur.reset();
					break;
				}
				case "y2" :
				{
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:-10, theme:4}));	// points environnement
					pnjPrimeur.ballon.htmlContent.removeEventListener(TextEvent.LINK, ballonEventHandler, false);					
					t = 'Vous pouvez récupérer des points en cliquant sur les sacs plastiques';
					pnjPrimeur.displayTalk(t, 0, true, true);
					break;
				}
				case "n2" :
				{
					pnjPrimeur.ballon.htmlContent.removeEventListener(TextEvent.LINK, ballonEventHandler, false);
					pnjPrimeur.removeBallon();
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					break;
				}
				default :
				{
					// clique sur lien téléchargement calendrier fruits / legs
					pnjPrimeur.ballon.htmlContent.removeEventListener(TextEvent.LINK, ballonEventHandler, false);
					if (_visitedLink.indexOf(resp) == -1)
					{
						_visitedLink.push(resp);
						sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:5, theme:2}));	// points social
					}
					flash.net.navigateToURL(new URLRequest(resp), "_blank");
					pnjPrimeur.removeBallon();
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
			primeurData = data.primeur[0];
			vetiData = data.veti[0];
			if (stage)
			{
				if (!stage.contains(this))
					_init();
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
					
					// test entrée dans vêti
					var p:UPoint = new UPoint(20, 19, 0);
					if (p.isMatchPos(cell))
					{
						// test si joueur est déjà dans veti
						if (!primeurStandBye)
						{
							// si le joueur à des achats en cours et qu'il n'à pas validé
							// la fin de ceux-ci
							if (ardoisePrimeur.getItemCount() > 0)
							{													
								playerHelper.moveTo(20, 14, 0);
								playerHelper.displayThink("je dois terminer mes achats avant de m'en aller", 5000);
								return;
							} else {
								// sinon on le laisse entrer dans veti et on met le pnj primeur
								// au repos
								pnjPrimeur.jumpInLife("byebye");
								// patch pnj triggers non developpés
								primeurStandBye = true;
								disablePrimeur();
															
								pnjVeti.jumpInLife("hello");
								pnjVeti.autoLife = true;
								enableVeti();
								return;
							}
						}
					}
					// test entrée dans primeur
					p.yu = 18;
					if (p.isMatchPos(cell))
					{
						if (primeurStandBye)
						{
							// on désactive la partie vêtements
							pnjVeti.jumpInLife("byebye");
							disableVeti();
							// on enclenche la partie primeur
							pnjPrimeur.autoLife = true;
							pnjPrimeur.jumpInLife("hello");
							primeurStandBye = false;
							enablePrimeur();
						}
					}
					break;
				}
			}
		}
				
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Lance scénarion fin des achats partie primeur
		 */
		private function fireEndPrimeurShopping():void
		{
			sendEvent(new Event(EventList.FREEZE_SCENE));
			// on fait parler pnj
			var t:String = 'Il vous faudra autre chose ?\n<u><a href="event:y1">oui</a></u> - <u><a href="event:n1">non</a></u>';
			pnjPrimeur.displayTalk(t, 0, true);
			pnjPrimeur.ballon.htmlContent.addEventListener(TextEvent.LINK, ballonEventHandler, false, 0, true);
		}
		
		/**
		 *	@private
		 *	Ajoute listener pour sortie entrée primeur / vêtements
		 */
		private function addBobInOutListeners():void
		{
			playerHelper.component.addEventListener(TileEvent.ENTER_CELL, bobEventsHandler, false, 0, true);
//			playerHelper.component.addEventListener(TileEvent.LEAVE_CELL, bobEventsHandler, false, 0, true);
		}

		/**
		 *	@private
		 *	Ajoute listener pour sortie entrée primeur / vêtements
		 */
		private function removeBobInOutListeners():void
		{
			playerHelper.component.removeEventListener(TileEvent.ENTER_CELL, bobEventsHandler, false);
//			playerHelper.component.addEventListener(TileEvent.LEAVE_CELL, bobEventsHandler, false, 0, true);
		}
		
		/**
		 *	@private
		 *	Mets en place la partie primeur
		 *	débloque interactions sur tiles + pnj
		 */
		private function enablePrimeur():void
		{
			// déblocage des events souris sur les tiles
			var tileList:XMLList = primeurData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = true;

			// autres tile qui ne sont pas des "produits"
			var tlist:Array = isoSceneHelper.getTileList();
			for each (var t:Object in tlist)
			{
				if (t.upos.yu <= 18) t.mouseEnabled = true;
			}

			// sur le pnj primeur
			pnjPrimeur.component.mouseEnabled = true;
			// écoute des events souris sur pnj primeur
			pnjPrimeur.component.addEventListener(MouseEvent.MOUSE_OVER, pnjPrimeurHandler, false, 0, true);
			// ecoute bouton terminer achats sur ardoise primeur
			ardoisePrimeur.finishPrimShoppingButton.addEventListener(MouseEvent.CLICK, ardoisePrimeurHandler, false, 0, true);
			// ecoute events triggers rollover et complete (achats fruits et légumes)
			channel.addEventListener(TriggerEvent.COMPLETE, primeurTriggerHandler, false, 50, true);
			channel.addEventListener(MouseEvent.MOUSE_OVER, primeurTriggerHandler, false, 0, true);
			// mise à jour affichage de l'ardoise
			ardoisePrimeur.title = "PRIMEUR";
		}
		
		/**
		 *	@private
		 *	Empêche interactions partie primeur
		 *	voir enablePrimeur()
		 */
		private function disablePrimeur():void
		{
			var tileList:XMLList = primeurData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = false;

			// autres tile qui ne sont pas des "produits"
			var tlist:Array = isoSceneHelper.getTileList();
			for each (var t:Object in tlist)
			{
				if (t.upos.yu <= 18) t.mouseEnabled = false;
			}
				
			pnjPrimeur.component.removeEventListener(MouseEvent.MOUSE_OVER, pnjPrimeurHandler, false);
			pnjPrimeur.component.mouseEnabled = false;			
			channel.removeEventListener(TriggerEvent.COMPLETE, primeurTriggerHandler, false);
			channel.removeEventListener(MouseEvent.MOUSE_OVER, primeurTriggerHandler, false);
		}
		
		/**
		 *	@private
		 *	Débloque les interactions partie vêtements
		 */
		private function enableVeti():void
		{
			// déblocage des events souris sur les tiles
			var tileList:XMLList = vetiData.products.product.@id;

			var l:int = tileList.length();
			var t:Object;
			while (--l > -1)
			{
				t = isoSceneHelper.getTile(tileList[l]);
				if (t) t.mouseEnabled = true;
			}
			
			// autres tile qui ne sont pas des "produits"
			var tlist:Array = isoSceneHelper.getTileList();
			for each (t in tlist)
			{
				if (t.upos.yu > 18) t.mouseEnabled = true;
			}

			// écoute des events souris sur pnj primeur
			pnjVeti.component.addEventListener(MouseEvent.CLICK, pnjVetiHandler, false, 0, true);
			pnjVeti.component.mouseEnabled = true;
			pnjVeti.component.buttonMode = true;
			// écoute des events xml trip du pnj vêtements
			channel.addEventListener(EventList.PNJ_FIRETRIGGER, vetiEventsHandler, false, 0, true);
			// ecoute events triggers rollover click et complete (achats vêtements)
			channel.addEventListener(MouseEvent.MOUSE_OVER, vetiTriggerHandler, false, 0, true);
			channel.addEventListener(MouseEvent.CLICK, vetiTriggerHandler, false, 0, true);
			channel.addEventListener(TriggerEvent.COMPLETE, vetiTriggerHandler, false, 0, true);
			// mise à jour affichage de l'ardoise
			ardoisePrimeur.title = "VETEMENTS";
		}
		
		/**
		 *	@private
		 *	Débloque les interactions partie vêtements
		 */
		private function disableVeti():void
		{
			// suppression des events souris sur les tiles
			var tileList:XMLList = vetiData.products.product.@id;
			var l:int = tileList.length();
			while (--l > -1)
				isoSceneHelper.getTile(tileList[l]).mouseEnabled = false;

			// autres tile qui ne sont pas des "produits"
			var tlist:Array = isoSceneHelper.getTileList();
			for each (var t:Object in tlist)
			{
				if (t.upos.yu > 18) t.mouseEnabled = false;
			}
				
			// suppression écoute des events souris sur pnj primeur
			pnjVeti.component.removeEventListener(MouseEvent.CLICK, pnjVetiHandler, false);
			pnjVeti.component.mouseEnabled = false;
			pnjVeti.component.buttonMode = false;
			// suppression écoute des events xml trip du pnj vêtements
			channel.removeEventListener(EventList.PNJ_FIRETRIGGER, vetiEventsHandler, false);
			// suppression écoute events triggers rollover click et complete (achats vêtements)
			channel.removeEventListener(MouseEvent.MOUSE_OVER, vetiTriggerHandler, false);
			channel.removeEventListener(MouseEvent.CLICK, vetiTriggerHandler, false);
			channel.removeEventListener(TriggerEvent.COMPLETE, vetiTriggerHandler, false);
		}
		
		/**
		 *	@private
		 */
		private function _init():void
		{
			applicationStage.addChild(this);
			season = getSeason(new Date());

			// reference isoscene
			isoSceneHelper = facade.getObserver(HelperList.ISOSCENE_HELPER);

			// bob
			playerHelper = facade.getObserver(HelperList.PLAYER_HELPER);
			addBobInOutListeners();

			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			// vendeur primeur
			var tv:Object = objBuilder.createMCTileView(new TileViewVendeurPrimeur());
			var at:Object = objBuilder.createAbstractTile("pnjPrimeur", 12, 12, 0, tv);
			pnjPrimeur = objBuilder.createPNJHelper("pnjPrimeurHelper", at);
			facade.registerObserver(pnjPrimeur.name, IObserver(pnjPrimeur));
			pnjPrimeur.iaData = data.primeur.pnj.(@id == "primeur")[0];
		
			// vendeur veti
			tv = objBuilder.createMCTileView(new TileViewVendeurVeti());
			at = objBuilder.createAbstractTile("pnjVeti", 14, 23, 0, tv);
			pnjVeti = objBuilder.createPNJHelper("pnjVetiHelper", at);			
			facade.registerObserver(pnjVeti.name, IObserver(pnjVeti));
			pnjVeti.iaData = data.veti.pnj.(@id == "veti")[0];

			/*// ajout point éco pour test
			sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:50, theme:3}));
			// ajout point environnement
			sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:50, theme:4}));
			// ajout point social
			sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:50, theme:2}));*/
			
			// mise en route partie primeur ou vêtements selon endroit
			// du joueur
			if (playerInPrimeur)
			{
				disableVeti();
				enablePrimeur();
				pnjPrimeur.autoLife = true;
			} else {
				disablePrimeur();
				enableVeti();
				pnjVeti.autoLife = true;
			}
			// ajout listaner sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);
			disablePrimeur();
			disableVeti();
			removeBobInOutListeners();
			applicationStage.removeChild(this);
			super.complete();
		}

	}

}