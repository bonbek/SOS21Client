package ddgame.triggers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.sos21.events.BaseEvent;
//	import com.sos21.tileengine.core.AbstractTile;
//	import com.sos21.tileengine.display.MCTileView;
	import com.sos21.tileengine.structures.UPoint;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import com.sos21.observer.IObserver;

//	import ddgame.client.view.PNJHelper;

	/**
	 * Trigger map id 59 (librairie elka)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m59 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m59():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m59.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjElka:Object;					// pnj vendeur primeur
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		protected var visitedLink:Array;
		protected var pnjText:Array;
		
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
			// on test si les data sont arrviées et si l'init pas
			// encore fait
			if (data)
				_init();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Réception des evenst souris sur le pnj
		 */
		private function pnjHandler(event:Event):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					pnjElka.autoLife = false;
					pnjElka.component.addEventListener(MouseEvent.CLICK, pnjHandler, false, 0, true);
					pnjElka.component.addEventListener(MouseEvent.MOUSE_OUT, pnjHandler, false, 0, true);
					break;
				}
				case MouseEvent.MOUSE_OUT :
				{
					// on test si le pnj à été cliqué (son ballon est affiché)
					if (!pnjElka.ballon)
					{
						// on redemarre la life arrêtée par mouse over
						pnjElka.autoLife = true;
					}
					pnjElka.component.removeEventListener(MouseEvent.MOUSE_OUT, pnjHandler, false);
					break;
				}
				case MouseEvent.CLICK :
				{					
					pnjElka.component.removeEventListener(MouseEvent.CLICK, pnjHandler, false);
					pnjElka.component.removeEventListener(MouseEvent.MOUSE_OUT, pnjHandler, false);
					if (pnjText.length > 0)
					{
						event.stopImmediatePropagation();
						pnjElka.displayTalk(pnjText.shift() , 0, true, true);
					} else {
						pnjElka.component.removeEventListener(MouseEvent.MOUSE_OVER, pnjHandler, false);
						pnjElka.component.mouseEnabled = false;						
					}
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception des events text des popup html pour balancer les points
		 *	et ouvrir les liens
		 */
		private function htmlPopupHandler(event:TextEvent):void
		{
			var slink:String = event.text;
			// on test si c'est un lien
			if (slink.search(/http/gi) > -1)
			{				
				// on test l'extension
				var spl:Array = slink.split(".");			
				switch (spl[spl.length - 1])
				{
					case "pdf" :
					{
						// test si le lien à déjà été visité
						if (visitedLink.indexOf(slink) == -1)
						{
							sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:5, theme:2}));
							sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:5, theme:4}));
							visitedLink.push(slink);
						}
						flash.net.navigateToURL(new URLRequest(slink), "_blank");
						break;
					}
					default :
					{
						// test si le lien à déjà été visité
						if (visitedLink.indexOf(slink) == -1)						
						{
							sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:5, theme:2}));
							sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:5, theme:4}));
							visitedLink.push(slink);
						}
						flash.net.navigateToURL(new URLRequest(slink), "_blank");
						break;						
					}
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception des events triggers
		 *	On s'abonne aux events text si on est sur un trigger popup html
		 */
		private function triggersHandler(event:TriggerEvent):void
		{
			var trigger:ITrigger = event.trigger;
			if (trigger.classID == 9)
			{
				var htrig:Object = trigger as Object;
				htrig.textField.addEventListener(TextEvent.LINK, htmlPopupHandler, false, 0, true);
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
			_init();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 */
		private function _init():void
		{
			// pnj
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			// vendeur primeur
			var tv:Object = objBuilder.createMCTileView(new TileViewPnjElka());
			var at:Object = objBuilder.createAbstractTile("pnjPrimeur", 19, 19, 0, tv);
			pnjElka = objBuilder.createPNJHelper("pnjElka", at);
			facade.registerObserver(pnjElka.name, IObserver(pnjElka));
			pnjElka.iaData = data.pnj.(@id == "elka")[0];
			pnjElka.autoLife = true;
			
			// écoute des events triggers pour récup les liens cliqués dans popups html
			channel.addEventListener(TriggerEvent.EXECUTE, triggersHandler, false, 50);
			// ajout listener sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);
			// ecoute events souris sur pnj
			pnjElka.component.addEventListener(MouseEvent.MOUSE_OVER, pnjHandler, false, 0, true);
			// liens cliqués
			visitedLink = [];
			// textes du pnj
			pnjText = [];
			var nlist:XMLList = data.pnj.helptext.click;
			for (var i:int = 0; i < nlist.length(); i++)
				pnjText.push(nlist[i]);
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);
			super.complete();
		}
		
	}

}