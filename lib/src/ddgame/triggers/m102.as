package ddgame.triggers {
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	
	import com.sos21.events.*;
	import com.sos21.tileengine.structures.UPoint;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
	import ddgame.helper.HelperList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import com.sos21.observer.IObserver;

	/**
	 * Trigger map id 102 (HSBC espace étudiants)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m102 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m102 () : void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m102.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjGuide:Object;					// pnj pione
		public var playerHelper:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		protected var guideNext:Boolean = false;
		
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
		
		private function handleMouseInTour (event:MouseEvent) : void
		{
			if (guideNext)
			{
				pnjGuide.nextInLife();
				guideNext = false;
			}
		}
		
		/**
		 * Réception events du pnj
		 *	@param event BaseEvent
		 */
		private function handlePnjEvent (event:BaseEvent) : void
		{
//			trace(event.content.data.toXMLString());
//			trace("-------------------------------");
			// recup id du noeud xmltrip
			var id:String = event.content.data.@id;
			switch (id)
			{
				// un point de continuation (clique dans la scène) est ateint
				case "tdest" :
				{
					guideNext = true;
					break;
				}
				// début de la visite guidée
				case "tour" :
				{
					sendEvent(new Event(EventList.FREEZE_SCENE));
					stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseInTour);					
					break;
				}
				// fin de la visite guidée
				case "endTour" :
				{
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseInTour);
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception chargement des data (102.xml)
		 */
		private function dataLoaderHandler (event:Event):void
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
			// refs utiles
			playerHelper = facade.getObserver(HelperList.PLAYER_HELPER);
			
			// pnj
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			var tv:Object = objBuilder.createMCTileView(new PnjGuideView());
			var at:Object = objBuilder.createAbstractTile("pnjGuide", 0, 0, 0, tv);
			pnjGuide = objBuilder.createPNJHelper("pnjGuide", at);
			facade.registerObserver(pnjGuide.name, IObserver(pnjGuide));
			
			// écoute xmltrip du pjn
			channel.addEventListener(EventList.PNJ_FIRETRIGGER, handlePnjEvent, false);
			
			pnjGuide.iaData = data.pnj.(@id == "guide")[0];
			pnjGuide.autoLife = true;
			
			// ajout listener sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);						
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.PNJ_FIRETRIGGER, handlePnjEvent, false);
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);
			super.complete();
		}
		
	}

}