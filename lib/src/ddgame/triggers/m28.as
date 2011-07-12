package ddgame.triggers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import com.sos21.events.BaseEvent;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import com.sos21.observer.IObserver;

	/**
	 * Trigger map id 82 (port st Tropez)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m28 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m28():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m28.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		// pnjs
		public var pnjAccueil:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		/**
		 *	@inheritDoc
		 */
		override public function execute (event:Event = null) : void
		{
			// on test si les data sont arrviées et si l'init pas
			// encore fait
			if (data) _init();
		}
		
		/**
		 * Effectue l'injection du xml data pour un stand dans
		 * la map ciblée (par le noeud) et va au stand (changement de map)
		 * 
		 *	@param stand String	param pxml du noeud stand
		 */
		public function gotoStand (stand:String):void
		{
			var standNode:XML = data.stands.stand.(@dxml == stand)[0];
			if (standNode)
			{
				// on recup l'id de la map
				var mapId:int = standNode.@stype;
				// on remplace l'argument datafile et pload(préload) du trigger 1 dans la map stand
				triggerProxy.addSpecMapReplaceTriggerArgs(1, {datafile:stand, pload:[stand]}, mapId);
				// on va à la scène "stand"
				facade.sendEvent(new BaseEvent(EventList.GOTO_MAP, {mapId:mapId}));				
			}
			else
			{
				trace(this, "! erreur (ligne 96)");
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Réception des evenst souris sur les pnj's
 		 *	@private
		 */
		private function pnjEventHandler (e:Event):void
		{
			var targ:Object = e.target;
			switch (e.type)
			{
				// capture d'un clique "lien vers un stand" dans le ballon du pnj accueil
				case EventList.PNJ_BALLONEVENT :
				{
					var evtContent:Object = BaseEvent(e).content;
					if (evtContent.target == pnjAccueil)
					{
						var textEvent:Object = evtContent.event;
						gotoStand(textEvent.text);						
					}
					break;
				}
				
				case MouseEvent.MOUSE_OVER :
				{
					switch (true)
					{
						case targ == pnjAccueil.component :
						{
							pnjAccueil.jumpInLife("needHelp");
							pnjAccueil.autoLife = true;
							break;
						}
					}		
					break;
				}
			}
		}
		
		/**
		 * Réception chargement des data (m82.xml)
		 *	@private
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
			
			// -- injection liste des stands dans ballon pnj accueil --
			
			// > noeud ballon stand pnj
			var ballonNode:XMLList = data..action.(attribute("id") == "standList");			
			// > liste des stands
			var standList:XMLList = data.stands.stand;
			// > ajout
			var textAdd:String = "";
			for each (var nod:XML in standList)
			{
				textAdd+= '<a href="event:' + nod.@dxml + '">' + nod + '</a><br>';
			}
			ballonNode.text()[0] = ballonNode.text()[0] + textAdd;
			
			// mise en place pnjs
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);

			var tv:Object = objBuilder.createMCTileView(new PnjAccueil());
			var at:Object = objBuilder.createAbstractTile("pnjAccueil", 0, 0, 0, tv);
			pnjAccueil = objBuilder.createPNJHelper("pnjAccueil", at);
			facade.registerObserver(pnjAccueil.name, IObserver(pnjAccueil));
			pnjAccueil.iaData = data.pnj.(@id == "pnjAccueil")[0];
			pnjAccueil.autoLife = true;
			
			// ecoute event ballon sur pnj
			channel.addEventListener(EventList.PNJ_BALLONEVENT, pnjEventHandler, false, 0, true);
			// ecoute events souris sur pnjs
			pnjAccueil.component.addEventListener(MouseEvent.MOUSE_OVER, pnjEventHandler, false, 0, true);
			
			// ajout listener sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete (event:Event = null) : void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);
			channel.removeEventListener(EventList.PNJ_BALLONEVENT, pnjEventHandler, false);
			pnjAccueil.component.removeEventListener(MouseEvent.MOUSE_OVER, pnjEventHandler, false);
			super.complete();
		}
		
		/**
		 * @private
		 */
		private function get triggerProxy () : Object
		{
			return facade.getProxy(ProxyList.TRIGGERS_PROXY);
		}
		
	}

}